module Psy
  module Params
    def params
      @_params ||= config.params_hash.new(request.params)
    end
  end
end
