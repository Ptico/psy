require 'psy/configuration/builder'

module Psy
  class Configuration
    attr_reader :props

    def inspect
      "#<Psy::Config>"
    end

  private

    def initialize(props)
      @props = props
    end

  end
end
