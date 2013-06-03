# encoding: utf-8

require 'spec_helper'
require 'logger'
require_relative "../lib/markdownfilters/coderay.rb"

module MarkdownFilters
  describe MarkdownFilters do
    let(:logger){
      require 'logger'
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
      logger
    }
    
    let(:coderayed){ 
%Q!<h2>Hello</h2>\n\n<p>This is some code:</p>\n\n<pre><code class="CodeRay">[<span class="integer">1</span>,<span class="integer">2</span>,<span class="integer">3</span>].map{|x| + <span class="integer">1</span> }\n</code></pre>\n\n<p>And this is the result:\n  [2,3,4]</p>\n\n<p>Thankyou</p>\n!
    }
    
    let(:notrayed) {
"<h2>Hello</h2>\n\n<p>This is some code:</p>\n\n<pre><code>[1,2,3].map{|x| + 1 }\n</code></pre>\n\n<p>And this is the result:\n  [2,3,4]</p>\n\n<p>Thankyou</p>\n"
    }

    describe Coderay do
      context "Given some text" do
        context "With some code to be rayed in it" do

          let(:content) { notrayed }
          let(:expected) { coderayed }

          subject { MarkdownFilters::Coderay.run content }
          it { should_not be_nil }
          it { should == expected }
        end # context
        
        context "With no code to be rayed in it" do
          let(:content) { %Q$The[UtterFAIL website](http://utterfail.info/ "UtterFAIL!") is good.$ }
          let(:expected) { content }
          subject { MarkdownFilters::Coderay.run content }
          it { should_not be_nil }
          it { should == expected }
        end # context
      end # context
      
      context "Given no text" do
        subject { MarkdownFilters::Coderay.run "" }
        it { should_not be_nil }
        it { should == "" }
      end # context
      
    end # describe Coderay
  end # describe MarkdownFilters
end # module