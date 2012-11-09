module Simplifyapi
  class Collection
    def initialize name, representer, &block
      @name = name
      @representer = representer

      instance_eval &block if block_given?
    end

    def import
      raise "TODO"
    end

    # Depending on how you use a collection, it can
    # be invoked with an array or with a model
    # if you're defining nested collections
    # like a has_many relationship
    def export model_or_collection
      if getter_defined?
        result = @getter.call model_or_collection
      else
        if model_or_collection.is_a? Array
          result = model_or_collection
        else
          result = model_or_collection.send(@name)
        end
      end

      wrap_representers result
    end

    def wrap_representers collection
      collection.map do |item|
        @representer.export(item)
      end
    end

    def getter_defined?
      !!@getter
    end

    def setter_defined?
      !!@setter
    end

    private
    def get &block
      @getter = block
    end

    def set &block
      @setter = block
    end
  end
end

