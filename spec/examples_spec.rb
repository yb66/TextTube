require 'spec_helper'
require 'rspec/its'
require_relative "../lib/texttube/base.rb"
require_relative "../lib/texttube/filterable.rb"

module TextTube # for convenience

TimeNow = "2060" # According to Sir Isaac Newton's research of the Bible, the world will end in this year!

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

    module AnotherFilter
      extend TextTube::Filterable

      filter_with :copyright do |text|
        text << " ©#{TimeNow}. "
      end

      filter_with :number do |text,options|
        text * options[:times].to_i
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

    class NewerS < TextTube::Base
			register BFil
			register AFilter
			register do
				filter_with :dashes do |text|
					"---#{text}---"
				end
			end
		end

    class FutureString < TextTube::Base
      register AnotherFilter
      register do
        filter_with :read_more do |text,options|
          text + options[:teaser]
        end
      end
    end

    class Optional < TextTube::Base
      register do
        filter_with :something_with_options do |text,options|
          extras = options.fetch :extra, " "
          text + extras + "This should be ok."
        end
      end
      register do
        filter_with :something_without_options do |text|
          text + options + "This will throw an error."
        end
      end
    end
	end # before

	context "Simple" do
		let(:n) { NeuS.new "abc" }
    let(:the_no_options_filtered_result){ "---a b ca b ca b ca b ca b ca b c---" }
		subject { n }
		it { should == "abc" }

		context "filtering" do
			context "With no arguments" do
				subject { n.filter }
				it { should == the_no_options_filtered_result }
			end
			context "Given a specific filter" do
				subject { n.filter :spacial }
				it { should == "a b c" }
        it { should_not == the_no_options_filtered_result }
			end
			context "Given several specific filters" do
				subject { n.filter :spacial, :dashes, :spacial }
				it { should == "- - - a   b   c - - -" }
        it { should_not == the_no_options_filtered_result }
			end
		end
	end
	context "with options passed to the instance" do
	  context "To set the order" do
      let(:n) { NeuS.new "abc", :order=>[:spacial, :dashes, :spacial] }
      let(:the_no_options_filtered_result){ "- - - a   b   c - - -" }
      subject { n }
      it { should == "abc" }
      context "filtered" do
        subject { n.filter }
        it { should == the_no_options_filtered_result }
        context "and then given method options" do
          subject { n.filter :order=>[:triple, :dashes, :spacial] }
          it { should == "- - - a b c a b c a b c - - -" }
          it { should_not == the_no_options_filtered_result }
        end
      end
      context "with a different instance" do
        let(:m) { NeuS.new "def" }
        subject { m }
        it { should == "def" }
        context "filtered" do
          subject { m.filter }
          it { should_not == "- - - d   e   f - - -" }
          it { should_not == the_no_options_filtered_result }
        end
        context "and given instance options" do
          let(:k) { NeuS.new "abc", :order=>[:dashes, :double, :spacial] }
          subject { k }
          it { should == "abc" }
          context "filtered" do
            subject { k.filter }
            it { should == "- - - a b c - - - - - - a b c - - -" }
            it { should_not == the_no_options_filtered_result }
          
            context "and then given method options" do
              subject { k.filter :order=>[:triple, :dashes, :spacial] }
              it { should == "- - - a b c a b c a b c - - -" }
              it { should_not == the_no_options_filtered_result }
            end
          end
        end
      end
      context "with a different class" do
        let(:n) { NewerS.new "abc" }
        subject { n }
        it { should == "abc" }
        context "filtered" do
          subject { n.filter }
          it { should == "---a b ca b ca b ca b ca b ca b c---" }
          it { should_not == the_no_options_filtered_result }
        end        
      end
    end
	end
	context "with class options" do
	  context "To set the order" do
	    before :all do
	      NeuS.options.merge! :order=>[:spacial, :dashes, :spacial]
	    end
      let(:n) { NeuS.new "abc" }
      let(:the_no_options_filtered_result){ "- - - a   b   c - - -" }
      subject { n }
      it { should == "abc" }
      context "filtered" do
        subject { n.filter }
        it { should == the_no_options_filtered_result }
      end
      context "and given method options" do
        subject { n.filter :order=>[:dashes, :double, :spacial] }
        it { should == "- - - a b c - - - - - - a b c - - -" }
        it { should_not == the_no_options_filtered_result }
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
      context "with a different class" do
        let(:n) { NewerS.new "abc" }
        subject { n }
        it { should == "abc" }
        context "filtered" do
          subject { n.filter }
          it { should == "---a b ca b ca b ca b ca b ca b c---" }
          it { should_not == the_no_options_filtered_result }
        end        
      end
      context "and given instance options" do
        let(:m) { NeuS.new "abc", :order=>[:dashes, :double, :spacial] }
        subject { m }
        it { should == "abc" }
        context "filtered" do
          subject { m.filter }
          it { should == "- - - a b c - - - - - - a b c - - -" }
          it { should_not == the_no_options_filtered_result }
          
          context "and then given method options" do
            subject { m.filter :order=>[:triple, :dashes, :spacial] }
            it { should == "- - - a b c a b c a b c - - -" }
            it { should_not == the_no_options_filtered_result }
          end
        end
      end
    end
	end

	describe "Block option arguments" do
    let(:optional){ Optional.new "Does this block have an options argument?" }
	  context "Given a block" do
	    context "with an options argument *and* that uses the options" do
        context "with method options" do
          subject { optional.filter :something_with_options, :something_with_options => {extra: " Yes, I told you so. " } }
          it { should == "Does this block have an options argument? Yes, I told you so. This should be ok." }
        end
        context "without method options" do
          subject { optional.filter :something_with_options }
          it { should == "Does this block have an options argument? This should be ok." }
        end
      end
      context "without an options argument *and* a block that uses the options" do
        context "with method options" do
          it "should raise an error" do
            expect{
              optional.filter :something_without_options, :something_without_options => {extra: " Yes, I told you so. " }
            }.to raise_error(NameError)
          end
        end
        context "without method options" do
          it "should raise an error" do
            expect{
              optional.filter :something_without_options
            }.to raise_error(NameError)
          end
        end
      end
    end
	  
	end
end

end # inconvenient