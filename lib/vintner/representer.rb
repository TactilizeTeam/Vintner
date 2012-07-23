require 'active_support/concern'
require 'active_support/core_ext'

module Vintner
  module Representer
    extend ::ActiveSupport::Concern

    def initialize model
      @model = model
    end

    def to_json
      self.class.export(@model).to_json
    end

    def from_json json
      self.class.import @model, ActiveSupport::JSON.decode(json)
    end

    module ClassMethods
      mattr_reader :properties, :collections

      def property name, &block
        @@properties ||= {}

        @@properties[name] = Property.new(name, &block)
      end

      def collection name, representer
        @@collections ||= {}

        @@collections[name] = Collection.new(name, representer)
      end

      def representation &block
        return @representation unless block_given?

        @representation = Representation.new &block
      end

      def export model
        @representation.export(self, model)
      end

      def import model, hash
        @representation.import(self, model, hash)
      end

    end
  end
end
