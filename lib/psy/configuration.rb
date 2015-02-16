require 'psy/configuration/builder'

module Psy
  class Configuration
    attr_reader :props

    def [](key)
      props[key]
    end

    def inspect
      '#<Psy::Config>'
    end

    def method_missing(*)
      nil
    end

  private

    def initialize(props)
      @props = props
    end

  end
end
