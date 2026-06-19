module Get
  module System
    def self.platform
      @platform ||= begin
        host = RbConfig::CONFIG["host_os"]
        case host
        when /darwin/ then :macos
        when /linux/ then :linux
        when /mingw|mswin/ then :windows
        else :unknown
        end
      end
    end

    def self.arch
      @arch ||= case RbConfig::CONFIG["host_cpu"]
      when /arm64|aarch64/ then :arm64
      when /x86_64|x64/ then :x86_64
      when /i[3-8]68/ then :i686
      else :unknown
      end
    end

    def self.macos?
      platform == :macos
    end

    def self.linux?
      platform == :linux
    end

    def self.windows?
      platform == :windows
    end

    def self.arch_str
      case arch
      when :arm64 then "arm64"
      when :x86_64 then "x86_64"
      when :i686 then "i686"
      else "unknown"
      end
    end

    def self.os_str
      case platform
      when :macos then "macos"
      when :linux then "linux"
      when :windows then "windows"
      else "unknown"
      end
    end

    def self.to_s
      "#{os_str}/#{arch_str}"
    end
  end
end
