module Psy
  module Controller
    class Base

      class << self
        attr_accessor :config

        def configure(&block)
          @config = Configuration::Builder.new(@config, &block).build(ENV['RACK_ENV'])
        end

        def call(env)
          request  = ::Rack::Request.new(env)
          response = Response.new(env)

          instance = new(request, response)
          instance.call
          instance.to_rack_array
        end

        def inherited(subclass)
          subclass.instance_variable_set(:"@config", self.config)
        end
      end

      ##
      # Request environment
      #
      def env; @_env; end

      ##
      # Request object
      #
      def request; @_request; end

      ##
      # Response builder
      #
      def response; @_response; end

      ##
      # Abstract: Method for main processing logic
      # should be overrided in descendants
      def call; end

      def to_rack_array
        response.to_rack_array
      end

    private

      def initialize(request, response)
        @_env      = request.env
        @_request  = request
        @_response = response
        @_config   = self.class.config
      end

    end
  end
end
