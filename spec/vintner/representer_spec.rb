require 'spec_helper'

module Vintner
  describe Representer do
    it "should allow to declare a simple property" do
      class Dummy
        include Vintner::Representer

        property :title
      end

      Dummy.properties.should include(:title)
    end

    it "should allow to declare a property with a getter" do
      class Dummy
        include Vintner::Representer

        property :title do
          get do |model|
            model.formatted_title
          end
        end
      end


      Dummy.properties[:title].getter_defined?.should be(true)
    end

    it "should allow to declare a property with a getter" do
      class Dummy
        include Vintner::Representer

        property :title do
          set do |model, value|
            model.formatted_title = value
          end
        end
      end

      Dummy.properties[:title].setter_defined?.should be(true)
    end
  end
end
