require "get/formula"
require "get/ui"

module Get
  class Formulary
    def self.all
      @formulae ||= []
    end

    def self.register(**kwargs, &block)
      f = Formula.new(**kwargs, &block)
      all << f
      f
    end

    def info(name)
      f = self.class.all.find { |fm| fm.name == name }
      unless f
        UI.error "No formula for '#{name}'."
        return
      end
      UI.say "#{f.name} — #{f.desc}"
      UI.say "Homepage: #{f.homepage}" unless f.homepage.empty?
      UI.say "Default version: #{f.default_version}"
      UI.say "Available versions: #{f.versions.keys.join(", ")}"
      UI.say "Dependencies: #{f.dependencies.join(", ")}" unless f.dependencies.empty?
    end
  end
end
