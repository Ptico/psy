module Psy
  class Response

    ##
    # Set response status
    #
    # Params:
    # - response_status {Fixnum} status code
    #
    def status=(response_status)
      @status = Tipi::Status[response_status.to_i]
      @body = [] unless body_allowed?
    end

    ##
    # Get or set response status
    #
    # Params:
    # - status {Fixnum} status code (optional)
    #
    # Returns: {Tipi::Status} status object
    #
    def status(response_status=nil)
      self.status = response_status if response_status
      @status
    end

    ##
    # Set response body
    #
    # Params:
    # - response_body {String|Array} plain response body or array of body parts
    #
    def body=(response_body)
      @body = Array(response_body) if body_allowed?
    end

    ##
    # Set response body
    #
    # Params:
    # - response_body {String|Array} plain response body or array of body parts (optional)
    #
    # Returns: {Array} array with body parts
    #
    def body(response_body=nil)
      self.body = response_body if response_body
      @body
    end

    ##
    # Add response header
    #
    # Params:
    # - key   {String} response header key
    # - value {String} response header value
    #
    def add_header(key, value)
      @headers[key.to_s] = value.to_s
    end

    attr_reader :headers

    ##
    # Build rack 3-element response tuple
    #
    # Returns: {Array} with status, headers and body
    #
    def to_rack_array
      normalize!

      [@status.to_i, @headers, @body]
    end

    ##
    # Returns: false if body not allowed by status or request method
    #
    def body_allowed?
      @status.allows_body? && @request_method.allows_body?
    end

    ##
    # Normalize response
    #
    # This method calculates content length and sets corresponding header.
    # Also, if body not allowed - it drops Content-Length, Content-Type headers
    # and body.
    #
    def normalize!
      if body_allowed?
        if calculate_content_length?
          @headers['Content-Length'] = body.inject(0) do |length, part|
            length + ::Rack::Utils.bytesize(part)
          end.to_s
        end
      else
        @headers.delete('Content-Type')
        @headers.delete('Content-Length')
        @body = []
      end
    end

  private

    ##
    # Constructor: Initialize response
    #
    def initialize(env)
      @request_method = Tipi::Method[env[Rack::REQUEST_METHOD]]

      self.status = 200

      @body = []
      @headers = {}
    end

    ##
    # Private: calculate content length only if Content-Type header was set
    #
    # Also we don't calculate if its already set
    #
    # Returns: false if content-length should not be calculated
    #
    def calculate_content_length?
      headers.has_key?('Content-Type') && !headers.has_key?('Content-Length')
    end
  end
end
