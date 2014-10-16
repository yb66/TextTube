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
			subject { Base }
			it { should respond_to :options }
			its(:options) { should respond_to :empty? }
			its(:options) { should be_empty }
			it { should respond_to :reset! }
			it { should respond_to :filters }
			its(:filters) { should respond_to :empty? }
			its(:filters) { should be_empty }
			it { should respond_to :register }
			it { should respond_to :inherited }
		end
	end
end


end