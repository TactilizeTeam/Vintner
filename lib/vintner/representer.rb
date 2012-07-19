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

      end
    end
  end
end
