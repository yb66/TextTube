require 'spec_helper'
require 'rspec/its'
require_relative "../lib/texttube/base.rb"

module TextTube # for convenience

describe Base do
	
	context "Checking the basics" do
		context "Instances" do
			subject { Base.new "anything" }
			it { should be_a_kind_of String }
			it { should respond_to :options }
			its(:options) { should respond_to :empty? }
			its(:options) { should be_empty }
		end
		context "Class methods and their defaults" do
		  shared_examples "any instance from a kind of Base" do
        it { should respond_to :reset! }
        it { should respond_to :filters }
        its(:filters) { should respond_to :empty? }
        its(:filters) { should be_empty }
        it { should respond_to :register }
        it { should respond_to :inherited }
      end
			subject { Base }
			it { should_not respond_to :options }
			it_should_behave_like "any instance from a kind of Base"
			context "when subclassed" do
			  before :all do
			    SubClassed = Class.new TextTube::Base
			  end
			  subject { SubClassed }
        it { should respond_to :options }
        its(:options) { should respond_to :empty? }
        its(:options) { should be_empty }
        it_should_behave_like "any instance from a kind of Base"
      end
		end
	end
end


end