module Get
  module UI
    def self.say(msg)
      $stdout.puts msg
    end

    def self.error(msg)
      $stderr.puts "Error: #{msg}"
    end

    def self.success(msg)
      $stdout.puts "✓ #{msg}"
    end

    def self.warn(msg)
      $stdout.puts "⚠ #{msg}"
    end
  end
end
