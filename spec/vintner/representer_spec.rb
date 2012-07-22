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

    describe "Complex representation" do
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

          property :position do
            get do |model|
              {:x => model.position_x, :y => model.position_y}
            end

            set do |model, value|
              model.position_x = value['x']
              model.position_y = value['y']
            end
          end

          representation do |json|
            json.meta do |meta|
              meta.property :title
            end

            json.property :position
          end
        end
      end

      it "should export json" do
        hash = {:meta=>{:title => "test"}, :position => {:x => 4, :y => 5}}

        model = Struct.new(:formatted_title, :position_x, :position_y).new("test", 4,5)

        Dummy.export(model).should ==(hash.to_json)
      end

      it "should import json" do
        hash = {:meta=>{:title => "test"}, :position => {:x => 4, :y => 5}}

        model = Struct.new(:formatted_title, :position_x, :position_y).new

        Dummy.import(model, hash.to_json).formatted_title.should ==("test")

        Dummy.import(model, hash.to_json).position_x.should ==(4)
        Dummy.import(model, hash.to_json).position_y.should ==(5)
      end
    end

    describe "Immediate values" do
      before :each do
        @hash = {:meta=>{:version => 4, :title => "test"}}
        @model = Struct.new(:formatted_title).new("test")

        class Dummy
          include Vintner::Representer

          property :title do
            get do |model|
              model.formatted_title
            end

            set do |model, title|
              model.formatted_title = title
            end
          end

          representation do |json|
            json.meta do |meta|
              meta.version 4
              meta.property :title
            end
          end
        end
      end

      it "should export immediate values " do
        Dummy.export(@model).should ==(@hash.to_json)
      end

      it "should ignore it when importing" do
        Dummy.import(@model, @hash.to_json).formatted_title.should ==('test')
      end
    end
  end
end
