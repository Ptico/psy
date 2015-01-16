require 'tipi'

require 'psy/environment'

module Psy
  @_envs  = Hash.new
  @_mutex = Mutex.new

  module_function def env(name=:default, &block)
    @_mutex.synchronize do
      @_envs[name.to_sym] = Environment.build(name, parent, &block)
    end
  end
end

require 'psy/rack'
require 'psy/response'
require 'psy/controller/base'
