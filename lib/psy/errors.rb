module Psy
  class Configuration
    class InvalidLoggerError < StandardError
      def initialize(m)
        super("logger must respond to ##{m}")
      end
    end
  end
end
