require 'spec_helper'

module Vintner
  describe Representer do
    it "should declare a simple property" do
      class Dummy
        include Vintner::Representer

        property :title
      end

      Dummy.properties.should include(:title)
    end

    it "should declare a property with a getter" do
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

    it "should declare a property with a setter" do
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

    describe "Representation" do
      before :each do
        class Dummy
          include Vintner::Representer

          property :title do
            get do |model|
              model.formatted_title
            end

            set do |model, value|
              model.formatted_title = value
            end
          end

          representation do |json|
            json.meta do |meta|
              meta.property :title
            end
          end
        end
      end

      it "should declare a representation" do
        Dummy.representation.should_not be_nil
      end

      it "should export json" do
        hash = {meta:{title:"some title"}}

        model = Struct.new(:formatted_title).new("some title")
        Dummy.export(model).should ==(hash.to_json)
      end

      it "should import json" do
        hash = {meta:{title:"some title"}}
        model = Struct.new(:formatted_title).new

        Dummy.import(model, hash.to_json).formatted_title.should ==("some title")
      end
    end
  end
end
