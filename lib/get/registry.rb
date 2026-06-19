require "get/formula"
require "get/ui"

module Get
  class Registry
    def initialize
      @formulae = Formulary.all
    end

    def search(query)
      results = @formulae.select { |f| f.name.include?(query) || f.desc.downcase.include?(query.downcase) }
      if results.empty?
        UI.say "No packages matching '#{query}'."
      else
        UI.say "Available packages:"
        results.each { |f| UI.say "  #{f.name} — #{f.desc}" }
      end
    end
  end
end
