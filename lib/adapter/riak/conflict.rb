module Adapter
  module Riak
    class Conflict < StandardError
      attr_reader :robject

      def initialize(robject)
        @robject = robject
        super('Read conflict present')
      end
    end
  end
end