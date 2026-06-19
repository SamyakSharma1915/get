require "fileutils"
require "get/formulary"
require "get/ui"

module Get
  class Tap
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def self.all
      taps_dir = File.expand_path("~/.get/taps")
      return [] unless File.directory?(taps_dir)
      Dir.entries(taps_dir).reject { |e| e.start_with?(".") }.map do |name|
        new(name, File.join(taps_dir, name))
      end
    end

    def load
      Dir.glob(File.join(path, "**", "*.rb")).sort.each { |f| require f }
    end
  end
end
