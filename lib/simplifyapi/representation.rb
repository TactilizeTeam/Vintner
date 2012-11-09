require 'simplifyapi/dsl_methods'
require 'simplifyapi/builder'
require 'simplifyapi/importer'

module Simplifyapi
  class Representation
    def initialize &block
      @builder = Builder.new &block
      @importer = Importer.new &block
    end

    def export representer, model
      @builder.export representer, model
    end

    def import representer, model, hash
      @importer.import representer, model, hash

      model
    end
  end
end
