require 'spec_helper'
require_relative '../lib/markdownfilters/base.rb'
require_relative '../lib/markdownfilters/filterable.rb'

describe "MarkdownFilters" do
  before :all do
    module AFilter
      extend MarkdownFilters::Filterable
    
      filter_with :double do |text|
        text * 2
      end
    
      filter_with :triple do |text|
        text * 3
      end
    end
    
    module BFil
      extend MarkdownFilters::Filterable
    
      filter_with :spacial do |current,options|
        current.split(//).join " " 
      end
    end
    
    class NeuS < MarkdownFilters::Base
      register BFil
      register AFilter
      register do
        filter_with :dashes do |text|
          "---#{text}---"
        end
      end
    end
  end
  let(:n) { NeuS.new "abc" }
  subject { n }
  it { should == "abc" }
  its(:filters) { should =~ [:spacial, :dashes, :double, :triple] }
  its(:filter) { should == "---a b ca b ca b ca b ca b ca b c---" }
  context "ordering" do
    context "given one filter" do
      subject { n.filter :spacial }
      it { should == "a b c" }
    end
    context "given several filters but not all" do
      subject { n.filter :spacial, :dashes }
      it { should == "---a b c---" }
    end
    context "given several filters in a different order" do
      subject { n.filter :dashes, :double, :spacial, :triple }
      it { should == "- - - a b c - - - - - - a b c - - -- - - a b c - - - - - - a b c - - -- - - a b c - - - - - - a b c - - -" }
    end
  end
end