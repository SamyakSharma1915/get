require "fileutils"
require "open-uri"
require "get/ui"
require "get/version"

module Get
  module SelfUpdate
    REPO_URL = "https://github.com/SamyakSharma1915/get"
    RAW_BASE  = "https://raw.githubusercontent.com/SamyakSharma1915/get/main"

    def self.run
      UI.say "==> Checking for updates..."
      latest = latest_version
      if latest && latest != VERSION
        UI.say "==> New version available: #{latest} (current: #{VERSION})"
        update_to(latest)
      else
        UI.say "get is up to date (#{VERSION})."
      end
    end

    def self.latest_version
      url = "#{RAW_BASE}/lib/get/version.rb"
      content = URI.open(url, &:read)
      if content =~ /VERSION\s*=\s*"([^"]+)"/
        $1
      end
    rescue
      nil
    end

    def self.update_to(version)
      UI.say "==> Updating get to #{version}..."
      install_dir = File.expand_path("~/.get")
      tmp_dir = "/tmp/get-update-#{$$}"
      FileUtils.mkdir_p(tmp_dir)
      UI.say "Downloading from #{REPO_URL}"
      system("git", "clone", "--depth", "1", REPO_URL, tmp_dir, out: File::NULL, err: File::NULL)
      if $?.success?
        FileUtils.cp_r(File.join(tmp_dir, "bin", "."), File.join(install_dir, "bin"))
        FileUtils.cp_r(File.join(tmp_dir, "lib", "."), File.join(install_dir, "lib"))
        FileUtils.cp_r(File.join(tmp_dir, "repo", "."), File.join(install_dir, "repo"))
        FileUtils.cp_r(File.join(tmp_dir, "share", "."), File.join(install_dir, "share"))
        UI.success "get updated to #{version}."
      else
        UI.error "Update failed. Try: git pull #{REPO_URL}"
      end
    ensure
      FileUtils.rm_rf(tmp_dir) if tmp_dir && File.exist?(tmp_dir)
    end

    def self.install_script
      <<~BASH
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/samyak/get/main/install.sh)"
      BASH
    end
  end
end
