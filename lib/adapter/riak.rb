require 'adapter'
require 'adapter/riak/conflict'
require 'riak'
# present? that comes with riak-client is always
# returning true and thus always raising read conflicts
# need this until I can talk to maintainer or fix riak-client
require 'active_support/core_ext/object/blank'

module Adapter
  module Riak
    # Optimize key? to do head request in riak instead of full key read and nil check
    def key?(key)
      client.exists?(key_for(key))
    end

    def read(key)
      robject = client.get(key_for(key))
      raise Conflict.new(robject) if robject.conflict?
      robject.data
    rescue ::Riak::FailedRequest => e
      e.code.to_i == 404 ? nil : raise(e)
    end

    def write(key, value)
      key = key_for(key)
      obj = client.get_or_new(key)
      obj.content_type = 'application/json'
      obj.data = value
      obj.store
      value
    end

    def delete(key)
      read(key).tap { client.delete(key_for(key)) }
    end

    def clear
      client.keys do |keys|
        keys.each { |key| client.delete(key) }
      end
    end

    def encode(value)
      value
    end

    def decode(value)
      value
    end
  end
end

Adapter.define(:riak, Adapter::Riak)