require "get/formulary"
require "get/installer"
require "get/registry"
require "get/tap"
require "get/ui"
require "get/selfupdate"

repo_dir = File.expand_path("../../repo", __dir__)
Dir.glob(File.join(repo_dir, "**", "*.rb")).sort.each { |f| require f }

Get::Tap.all.each(&:load)

module Get
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      if @argv.empty?
        print_help
        return
      end

      case @argv.first
      when "install"   then handle_install
      when "uninstall" then handle_uninstall
      when "remove"    then handle_uninstall
      when "list"      then handle_list
      when "search"    then handle_search
      when "info"      then handle_info
      when "update"    then handle_update
      when "upgrade"   then handle_upgrade
      when "doctor"    then handle_doctor
      when "setup"     then handle_setup
      when "tap"       then handle_tap
      when "credit"    then handle_credit
      when "selfupdate" then handle_selfupdate
      when "--version", "-v" then puts "get #{VERSION}"
      when "--help", "-h"    then print_help
      else
        UI.error "Unknown command: #{@argv.first}"
        print_help
        exit 1
      end
    end

    private

    def handle_install
      name, version = parse_target(@argv[1])
      Installer.new(name, version: version).install
    end

    def handle_uninstall
      name = @argv[1]
      unless name
        $stderr.puts "Usage: get uninstall <app>"
        exit 1
      end
      Installer.new(name).uninstall
    end

    def handle_list
      Installer.new("").list_installed
    end

    def handle_search
      query = @argv[1]
      unless query
        $stderr.puts "Usage: get search <query>"
        exit 1
      end
      Registry.new.search(query)
    end

    def handle_info
      name = @argv[1]
      unless name
        $stderr.puts "Usage: get info <app>"
        exit 1
      end
      Formulary.new.info(name)
    end

    def handle_update
      UI.say "Updating formulae..."
      UI.say "(formulae update is a no-op in this build)"
    end

    def handle_upgrade
      Installer.new("").upgrade
    end

    def handle_doctor
      UI.say "All systems green (placeholder)."
    end

    def handle_setup
      shell = ENV["SHELL"] || "/bin/zsh"
      rc_file = shell.include?("zsh") ? "~/.zshrc" : "~/.bash_profile"
      line = 'export PATH="$HOME/.get/bin:$PATH"'
      UI.say "Add this to your #{rc_file}:"
      UI.say "  #{line}"
      UI.say ""
      UI.say "Then run: source #{rc_file}"
    end

    def handle_selfupdate
      SelfUpdate.run
    end

    def handle_credit
      puts <<~CREDIT

        ╔══════════════════════════════════════════════════════╗
        ║                    get — credits                     ║
        ╠══════════════════════════════════════════════════════╣
        ║                                                      ║
        ║   Creator:  Samyak Sharma                            ║
        ║   Language: Ruby                                     ║
        ║   License:  MIT                                      ║
        ║   Version:  #{Get::VERSION}                                    ║
        ║                                                      ║
        ║   "A package manager"                                ║
        ║                                                      ║
        ╚══════════════════════════════════════════════════════╝

      CREDIT
    end

    def handle_tap
      name = @argv[1]
      url = @argv[2]
      unless name && url
        $stderr.puts "Usage: get tap <name> <url>"
        exit 1
      end
      taps_dir = File.expand_path("~/.get/taps")
      FileUtils.mkdir_p(taps_dir)
      dest = File.join(taps_dir, name)
      if File.directory?(dest)
        UI.warn "Tap '#{name}' already exists."
      else
        system("git", "clone", url, dest)
      end
    end

    def parse_target(arg)
      unless arg
        $stderr.puts "Usage: get install <app> [ver=X.Y.Z]"
        exit 1
      end
      if arg.include?("ver=")
        name, ver = arg.split(/\s+ver=/)
        [name, ver]
      else
        [arg, nil]
      end
    end

    def print_help
      puts <<~HELP
        get — a package manager

        Install:
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/samyak/get/main/install.sh)"

        Usage:
          get install <app>            install the latest version of <app>
          get install <app> ver=X.Y.Z  install a specific version
          get uninstall <app>          remove <app>
          get list                     list installed packages
          get search <query>           search available packages
          get info <app>               show package details
          get update                   update package formulae
          get upgrade                  upgrade installed packages
          get doctor                   check your setup
          get setup                    show how to add get to PATH
          get tap <name> <url>         add a third-party tap
          get credit                   show credits
          get selfupdate               update get itself
          get --version                show version

        Examples:
          get install python
          get install python ver=3.14.4
          get install node
          get install ripgrep ver=14.1.0
      HELP
    end
  end
end
