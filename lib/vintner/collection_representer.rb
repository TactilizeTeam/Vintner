require 'active_support/concern'
require 'active_support/core_ext'

module Vintner
  module CollectionRepresenter
    extend ::ActiveSupport::Concern

    def initialize collection
      @collection = collection
    end

    def to_json
      self.class.export(@collection).to_json
    end


    module ClassMethods
      mattr_reader :collection

      def representer representer_klass
        @@collection = Collection.new(name, representer_klass)
      end

      def representation &block
        return @representation unless block_given?

        @representation = Representation.new &block
      end

      def export collection
        @representation.export(self, collection)
      end

      def represents_model?
        false
      end

      def represents_collection?
        true
      end
    end
  end
end
