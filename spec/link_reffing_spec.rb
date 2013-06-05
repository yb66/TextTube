# encoding: utf-8

require 'spec_helper'
require_relative "../lib/markdownfilters.rb"
require_relative "../lib/markdownfilters/filters/link_reffing.rb"

module MarkdownFilters
  describe LinkReffing do
    context "Given some text" do
      context "With a link to be reffed in it" do

        let(:content) { "The UtterFAIL website[[http://utterfail.info|UtterFAIL!]] is good." }
        let(:expected) { %Q$The UtterFAIL website[&#8304;](#0 "Jump to reference") is good.\n<div markdown='1' id='reflinks'>\n<a name="0"></a>&#91;0&#93; [http://utterfail.info](http://utterfail.info "http://utterfail.info") UtterFAIL!\n\n</div>$ }

        subject { MarkdownFilters::LinkReffing.run content }
        it { should_not be_nil }
        it { should == expected }
      end # context
      
      context "With no link to be reffed in it" do
        let(:content) { %Q$The[UtterFAIL website](http://utterfail.info/ "UtterFAIL!") is good.$ }
        let(:expected) { content }
        subject { MarkdownFilters::LinkReffing.run content }
        it { should_not be_nil }
        it { should == expected }
      end # context
    end # context
    
    context "Given no text" do
      subject { MarkdownFilters::LinkReffing.run "" }
      it { should_not be_nil }
      it { should == "" }
    end # context
    
  end # describe LinkReffing
end # module 