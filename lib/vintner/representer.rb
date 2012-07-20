require 'active_support/concern'
require 'active_support/core_ext'

module Vintner
  module Representer
    extend ::ActiveSupport::Concern

    module ClassMethods
      mattr_reader :properties, :collections

      def property name, &block
        @@properties ||= {}

        @@properties[name] = Property.new(name, &block)
      end

      def collection name, representer
        @@collections ||= {}

        raise "TODO"
      end

      def representation &block
        return @representation unless block_given?

        @representation = Representation.new &block
      end

      def export model
        @representation.export(self, model).to_json
      end

      def import model, json
        @representation.import(self, model, ActiveSupport::JSON.decode(json))
      end
    end
  end
end
