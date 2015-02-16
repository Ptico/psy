module Psy
  class Configuration
    class Builder
      attr_reader :props, :logger_instance

      def environment(name, &block)
        @envs[name.to_sym] = self.class.new(&block)
      end

      def logger(instance)
        absent = LOGGER_METHODS.reject { |m| instance.respond_to?(m) }
        if absent.any?
          raise InvalidLoggerError, absent.first
        end

        set(:logger, instance)
      end
      alias :logger= :logger

      def params_hash(params_class)
        set(:params_hash, params_class)
      end
      alias :params_hash= :params_hash

      def set(key, value)
        @props[key.to_sym] = value
      end

      ##
      # Build configuration object
      #
      def build(env)
        env = env.to_sym

        # We use plain class with attr_reader because it's 3-4x faster
        # than method missing and unlike structs it doesn't defines setters
        built = Class.new(Psy::Configuration)

        all_props = merge_props(env)

        all_props[:logger] = Logger.new($stdout) unless all_props.has_key?(:logger)
        all_props[:params_hash] = Hash unless all_props.has_key?(:params_hash)

        all_props.keys.each do |k|
          built.send(:attr_reader, k)
        end

        inst = built.new(all_props)

        all_props.each_pair do |k, v|
          inst.instance_variable_set(:"@#{k}", v)
        end

        inst.freeze
      end

    private

      LOGGER_METHODS = %i(log debug info warn error fatal unknown).freeze

      def initialize(parent=nil, &block)
        @props  = {}
        @parent = parent
        @envs   = {}

        @logger = nil

        instance_eval(&block) if block_given?
      end

      def merge_props(env)
        parent = @parent ? @parent.props : {}

        env_props = @envs.has_key?(env) ? @envs[env].props : {}

        parent.merge(@props.merge(env_props))
      end
    end
  end
end
