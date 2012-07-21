require 'vintner/dsl_methods'
require 'vintner/builder'
require 'vintner/importer'

module Vintner
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
