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

	context "Instantiation" do
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
end

end # inconvenient