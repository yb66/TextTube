require 'spec_helper'
require 'rspec/its'
require_relative "../lib/texttube/base.rb"
require_relative "../lib/texttube/filterable.rb"

module TextTube # for convenience

describe "Example usage" do
	before :all do
		module AFilter
			extend TextTube::Filterable

			filter_with :double do |text|
				text * 2
			end

			filter_with :triple do |text|
				text * 3
			end
		end

		module BFil
			extend TextTube::Filterable

			filter_with :spacial do |current,options|
				current.split(//).join " " 
			end
		end

		class NeuS < TextTube::Base
			register BFil
			register AFilter
			register do
				filter_with :dashes do |text|
					"---#{text}---"
				end
			end
		end
	end # before

	context "Simple" do
		let(:n) { NeuS.new "abc" }
		subject { n }
		it { should == "abc" }

		context "filtering" do
			context "With no arguments" do
				subject { n.filter }
				it { should == "---a b ca b ca b ca b ca b ca b c---" }
			end
			context "Given a specific filter" do
				subject { n.filter :spacial }
				it { should == "a b c" }
			end
			context "Given several specific filters" do
				subject { n.filter :spacial, :dashes, :spacial }
				it { should == "- - - a   b   c - - -" }
			end
		end
	end
	context "with global options" do
	  context "To set the order" do
	    before :all do
	      NeuS.options.merge! :order=>[:spacial, :dashes, :spacial]
	    end
      let(:n) { NeuS.new "abc" }
      subject { n }
      it { should == "abc" }
      context "filtered" do
        subject { n.filter }
        it { should == "- - - a   b   c - - -" }
      end
      context "and given instance options" do
        subject { n.filter :order=>[:dashes, :double, :spacial] }
        it { should == "- - - a b c - - - - - - a b c - - -" }
      end
      context "with a different instance" do
        let(:m) { NeuS.new "def" }
        subject { m }
        it { should == "def" }
        context "filtered" do
          subject { m.filter }
          it { should == "- - - d   e   f - - -" }
        end        
      end
    end
	end
	context "with options passed to the instance" do
	  context "To set the order" do
      let(:n) { NeuS.new "abc", :order=>[:spacial, :dashes, :spacial] }
      subject { n }
      it { should == "abc" }
      context "filtered" do
        subject { n.filter }
        it { should == "- - - a   b   c - - -" }
      end
    end
	end
end

end # inconvenient