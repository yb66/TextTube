# encoding: utf-8

require 'spec_helper'
require_relative "../lib/markdownfilters.rb"
require_relative "../lib/markdownfilters/filters/link_reffing.rb"

module MarkdownFilters
  describe LinkReffing do
    context "Given some text" do
      context "With a link to be reffed in it" do
        shared_examples "outputting links" do
          it { should_not be_nil }
          it { should == expected }
        end

        let(:content) { "The UtterFAIL website[[http://utterfail.info|UtterFAIL!]] is good. My blog[[http://iainbarnett.me.uk|My blog]] is also good." }

        context "and no options" do
          subject { MarkdownFilters::LinkReffing.run content }
          let(:expected) { s = <<HTML
The UtterFAIL website[&#8304;](#0 "Jump to reference") is good. My blog[&sup1;](#1 "Jump to reference") is also good.
<div markdown='1' id='reflinks'>
<a name="1"></a>&#91;1&#93; [http://utterfail.info](http://utterfail.info "http://utterfail.info") UtterFAIL!


<a name="2"></a>&#91;2&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog

</div>
HTML
            s.strip
          }
          include_examples "outputting links"
        end
        context "and an option not to ref the link" do
          subject { MarkdownFilters::LinkReffing.run content }
          pending
        end
        context "and an option to output a link 'normally'" do
          subject { MarkdownFilters::LinkReffing.run content }
          pending
        end
      end # context
      
      context "With no link to be reffed in it" do
        let(:content) { %Q$The [UtterFAIL website](http://utterfail.info/ "UtterFAIL!") is good.$ }
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