module Psy
  class Environment

    class Result
      def inspect
        "#<Psy::Environment[#{@_name}]>"
      end

    private

      def initialize(name)
        @_name = name
      end
    end

    def set(key, value)
      @props[key] = value
    end

    def build
      # We use plain class with attr_reader because it's 3-4x faster
      # than method missing and unlike structs it doesn't defines setters
      built = Class.new(Result)

      @props.keys.each do |k|
        built.send(:attr_reader, k)
      end

      inst = built.new(@name)

      @props.each_pair do |k, v|
        inst.instance_variable_set(:"@#{k}", v)
      end

      inst.freeze
    end

    def initialize(name, parent, &block)
      @props  = {}

      @name   = name
      @parent = parent

      instance_eval(&block)
    end
  end
end
