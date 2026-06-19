require "fileutils"
require "open-uri"
require "tmpdir"
require "get/formulary"
require "get/formula"
require "get/system"
require "get/ui"

module Get
  class Installer
    GET_ROOT = File.expand_path("~/.get")
    APPS_DIR = File.join(GET_ROOT, "apps")
    CACHE_DIR = File.join(GET_ROOT, "cache")

    def initialize(name, version: nil)
      @name = name
      @version = version
    end

    def install
      formula = Formulary.all.find { |f| f.name == @name }
      unless formula
        UI.error "No formula for '#{@name}'. Try: get search #{@name}"
        exit 1
      end

      version = @version || formula.default_version
      unless formula.versions.key?(version)
        UI.error "Version '#{version}' not available for #{@name}."
        UI.say "Available: #{formula.versions.keys.join(", ")}"
        exit 1
      end

      os = detect_os(formula)
      UI.say "==> Detected: #{Get::System.os_str}/#{Get::System.arch_str} (#{os})"

      prefix = File.join(APPS_DIR, @name)
      FileUtils.mkdir_p(prefix)
      FileUtils.mkdir_p(CACHE_DIR)

      UI.say "==> Installing #{@name} #{version} (#{os})"

      formula.dependencies.each do |dep|
        UI.say "==> Installing dependency: #{dep}"
        self.class.new(dep).install
      end

      if formula.run_install(version, prefix, os)
        UI.success "#{@name} #{version} installed to #{prefix}"
        write_manifest(formula, version, prefix, os)
        link_bin(prefix, @name)
      else
        url = formula.url_for(version, os)
        if url && url != "builtin"
          install_from_url(url, version, prefix, os)
        else
          UI.error "No install method available for #{@name} on #{Get::System}."
          exit 1
        end
      end
    end

    def uninstall
      prefix = File.join(APPS_DIR, @name)
      if File.directory?(prefix)
        FileUtils.rm_rf(prefix)
      end
      app_dir = File.expand_path("~/Applications")
      Dir.glob(File.join(app_dir, "#{@name}.app")).each { |a| FileUtils.rm_rf(a) }
      bin_link = File.join(GET_ROOT, "bin", @name)
      FileUtils.rm_f(bin_link) if File.exist?(bin_link)
      UI.success "#{@name} uninstalled."
    end

    def list_installed
      entries = Dir.entries(APPS_DIR) - [".", "..", ".DS_Store"]
      if entries.empty?
        UI.say "No packages installed."
      else
        UI.say "Installed packages:"
        entries.each do |entry|
          manifest = File.join(APPS_DIR, entry, ".get-manifest")
          if File.exist?(manifest)
            version = File.read(manifest).strip
            UI.say "  #{entry} (#{version})"
          else
            UI.say "  #{entry}"
          end
        end
      end
    end

    def upgrade
      entries = Dir.entries(APPS_DIR) - [".", "..", ".DS_Store"]
      if entries.empty?
        UI.say "Nothing to upgrade."
        return
      end
      entries.each do |entry|
        manifest = File.join(APPS_DIR, entry, ".get-manifest")
        next unless File.exist?(manifest)
        current = File.read(manifest).strip
        formula = Formulary.all.find { |f| f.name == entry }
        next unless formula
        latest = formula.default_version
        if latest != current
          UI.say "Upgrading #{entry}: #{current} -> #{latest}"
          self.class.new(entry, version: latest).install
        else
          UI.say "#{entry} is already at latest (#{current})"
        end
      end
    end

    private

    def detect_os(formula)
      if formula.linux_only? && !Get::System.linux?
        UI.warn "#{@name} is Linux-only. You're on #{Get::System.os_str}."
      end
      if formula.macos_only? && !Get::System.macos?
        UI.warn "#{@name} is macOS-only. You're on #{Get::System.os_str}."
      end
      if Get::System.macos?
        arch = Get::System.arch == :arm64 ? "arm64" : "x86_64"
        :macos
      elsif Get::System.linux?
        :linux
      elsif Get::System.windows?
        :windows
      else
        :unknown
      end
    end

    def install_from_url(url, version, prefix, os)
      cache_file = File.join(CACHE_DIR, "#{@name}-#{version}-#{os}-#{File.basename(url)}")
      unless File.exist?(cache_file)
        UI.say "Downloading #{url}"
        URI.open(url) { |r| File.binwrite(cache_file, r.read) }
      end

      case cache_file
      when /\.tar\.gz$/, /\.tgz$/
        system("tar", "-xzf", cache_file, "-C", prefix, "--strip-components=1")
      when /\.zip$/
        system("unzip", "-q", cache_file, "-d", prefix)
      when /\.dmg$/
        install_dmg(cache_file, prefix)
      when /\.deb$/
        system("dpkg", "-i", cache_file)
      when /\.rpm$/
        system("rpm", "-i", cache_file)
      else
        FileUtils.cp(cache_file, File.join(prefix, File.basename(cache_file)))
      end

      UI.success "#{@name} #{version} installed to #{prefix}"
      write_manifest(Formulary.all.find { |f| f.name == @name }, version, prefix, os)
      link_bin(prefix, @name)
    end

    def install_dmg(dmg, prefix)
      mount_point = "/tmp/get-#{@name}-#{$$}"
      FileUtils.mkdir_p(mount_point)
      system("hdiutil", "attach", dmg, "-mountpoint", mount_point, "-nobrowse", "-quiet")
      begin
        entries = Dir.entries(mount_point).reject { |e| e.start_with?(".") }
        app_entries = entries.select { |e| e.end_with?(".app") }
        if app_entries.any?
          dest_dir = File.expand_path("~/Applications")
          FileUtils.mkdir_p(dest_dir)
          app_entries.each do |entry|
            src = File.join(mount_point, entry)
            dest = File.join(dest_dir, entry)
            FileUtils.rm_rf(dest) if File.exist?(dest)
            FileUtils.cp_r(src, dest)
            UI.say "Installed #{entry} to #{dest_dir}"
          end
        else
          entries.each do |entry|
            src = File.join(mount_point, entry)
            dest = File.join(prefix, entry)
            if File.directory?(src)
              FileUtils.cp_r(src, dest)
            else
              FileUtils.cp(src, dest)
            end
          end
        end
      ensure
        system("hdiutil", "detach", mount_point, "-quiet")
      end
    end

    def write_manifest(formula, version, prefix, os)
      File.write(File.join(prefix, ".get-manifest"), "#{version}\n#{os}\n#{Get::System}")
    end

    def link_bin(prefix, name)
      bin_dir = File.join(GET_ROOT, "bin")
      FileUtils.mkdir_p(bin_dir)
      candidates = [
        File.join(prefix, "bin", name),
        File.join(prefix, name),
        File.join(prefix, "Contents", "MacOS", name),
        File.expand_path("~/Applications/#{name}.app/Contents/MacOS/#{name}"),
      ]
      candidates.each do |candidate|
        next unless File.exist?(candidate)
        target = File.join(bin_dir, name)
        FileUtils.ln_sf(candidate, target)
        return
      end
    end
  end
end
