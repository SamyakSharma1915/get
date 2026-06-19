module Get
  class Formula
    attr_reader :name, :desc, :homepage, :versions, :default_version,
                :install_block, :dependencies, :linux_only, :macos_only

    def initialize(name:, desc:, homepage: "", versions: {}, default_version: nil,
                   dependencies: [], install_block: nil, linux_only: false,
                   macos_only: false, &block)
      @name = name
      @desc = desc
      @homepage = homepage
      @versions = versions
      @default_version = default_version || versions.keys.max
      @dependencies = dependencies
      @install_block = install_block || block
      @linux_only = linux_only
      @macos_only = macos_only
    end

    def linux_only?
      @linux_only
    end

    def macos_only?
      @macos_only
    end

    def url_for(version, os = nil)
      return nil unless versions[version]
      v = versions[version]
      case v
      when String
        v
      when Hash
        os_key = os || "default"
        v[os_key] || v["default"] || v.values.first
      end
    end

    def run_install(version, prefix, os = nil)
      return false unless install_block
      install_block.call(version, prefix, os)
    end
  end
end
