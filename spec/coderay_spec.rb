# encoding: utf-8

require 'spec_helper'
require_relative "../lib/texttube.rb"
require_relative "../lib/texttube/filters/coderay.rb"

module TextTube
  describe TextTube do
    
    let(:coderayed){ 
%Q!<h2>Hello</h2>\n\n<p>This is some code:</p>\n\n<pre><code class="CodeRay">[<span class="integer">1</span>,<span class="integer">2</span>,<span class="integer">3</span>].map{|x| + <span class="integer">1</span> }\n</code></pre>\n\n<p>And this is the result:\n  [2,3,4]</p>\n\n<p>Thankyou</p>\n!
    }
    
    let(:notrayed) {
"<h2>Hello</h2>\n\n<p>This is some code:</p>\n\n<pre><code>[1,2,3].map{|x| + 1 }\n</code></pre>\n\n<p>And this is the result:\n  [2,3,4]</p>\n\n<p>Thankyou</p>\n"
    }

    describe Coderay do
      context "Given some text" do
        context "With some code to be rayed in it" do
          context "That has a language hint" do
            let(:content) { <<CODE
<pre><code>::::ruby
{"one" => 1 }
</code></pre>
CODE
            }
            let(:expected) { <<HTML
<pre><code class="CodeRay">{<span class="string"><span class="delimiter">"</span><span class="content">one</span><span class="delimiter">"</span></span> =&gt; <span class="integer">1</span> }</code></pre>
HTML
            }
            let(:wrong) { <<CODE
<pre><code>::::json
{"one" => 1 }
</code></pre>
CODE
            }
  
            subject { TextTube::Coderay.run content }
            it { should_not be_nil }
            it { should == expected }
            it { should_not == TextTube::Coderay.run(wrong) }
          end
          context "That has no language hint" do
            let(:content) { notrayed }
            let(:expected) { coderayed }
  
            subject { TextTube::Coderay.run content }
            it { should_not be_nil }
            it { should == expected }
          end
          context "That has a 'skip' language hint" do
            let(:content) { <<CODE
<pre><code>::::skip
{"one" => 1 }
</code></pre>
CODE
            }          
            let(:expected) { <<CODE
<pre><code>{"one" =&gt; 1 }</code></pre>
CODE
            }
  
            subject { TextTube::Coderay.run content }
            it { should_not be_nil }
            it { should == expected }
          end
        end # context
        
        context "With no code to be rayed in it" do
          let(:content) { %Q$The[UtterFAIL website](http://utterfail.info/ "UtterFAIL!") is good.$ }
          let(:expected) { content }
          subject { TextTube::Coderay.run content }
          it { should_not be_nil }
          it { should == expected }
        end # context
      end # context
      
      context "Given no text" do
        subject { TextTube::Coderay.run "" }
        it { should_not be_nil }
        it { should == "" }
      end # context
      
    end # describe Coderay
  end # describe TextTube
end # module