# encoding: UTF-8

require 'spec_helper'
require_relative '../lib/texttube/base.rb'
require_relative '../lib/texttube/filterable.rb'

describe "TextTube" do
  let(:content) { <<MARKDOWN
## The Rainfall Problem ##

I read of a test given to students to see if they understand the concepts in the first part of a computer science course. It was in an interesting paper called *What Makes Code Hard to Understand?*[[http://arxiv.org/abs/1304.5257|What Makes Code Hard to Understand? Michael Hansen, Robert L. Goldstone, Andrew Lumsdaine]].

> To solve it, students must write a program that averages a list of numbers (rainfall amounts), where the list is terminated with a specific value – e.g., a negative number or 999999.

Of course, reading about the problem I immediately wanted to try it, but even though the idea of posing the problem was to test the understanding of loops, the problem lends itself naturally to a recursive solution, and that's much more interesting than a boring old loop! I realised it wouldn't run well in Ruby but decided to write it anyway:

    ::::ruby
    def rainfall(droplets,total=0,measures=1,limit=99_999)
      return total.to_f.div measures if droplets == limit
      unless droplets < 0
        total += droplets
        measures += 1
      end
      rainfall rand(limit + 1), total, measures
    end

Normally I'd start this off with a random number, but just to make it clear that it works I started with the termination number. Then, I reran it until it worked. It gives you an idea of how poor Ruby is at recursion.

    ::::shell
    rainfall 99_999
    # => 0
    rainfall 99_998
    SystemStackError: stack level too deep
      from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
    Maybe IRB bug!
    rainfall 99_998
    SystemStackError: stack level too deep
      from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
    Maybe IRB bug!
    rainfall 99_998
    SystemStackError: stack level too deep
      from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
    Maybe IRB bug!
    rainfall 99_998
    SystemStackError: stack level too deep
      from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
    Maybe IRB bug!
    rainfall 99_998
    # => 49693

Just to be clear, I ran this with Ruby 2.0.0-rc2 as well with the same results. It's a pity that Ruby fails at this kind of thing, because it is such an elegant and useful language that seems to have borrowed the best of many other niche languages. Recursion is often the most elegant *and* performant[[http://dictionary.cambridge.org/dictionary/british/pedant|If you're one of these then you won't like that I made a word up. Unfortunately for you, I'm British, which means that I understand that English is a living language, it is my tool not my master, and it has a long history of being changed to suit the speaker or writer. This is one such case.]] solution.
MARKDOWN
  }
  context "with simple examples" do
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
  context "Real examples" do
    require_relative "../lib/texttube.rb"
    require 'rdiscount'

    context "An article that needs all the filters" do
      before :all do
        TextTube.load_all_filters
        class MyFilter < TextTube::Base
          register TextTube::Coderay
          register TextTube::LinkReffing
          register TextTube::EmbeddingAudio
          register TextTube::EmbeddingVideo
          register TextTube::InsideBlock
          register do
            filter_with :rdiscount do |text|
              RDiscount.new(text).to_html
            end
          end
        end
      end
      let(:expected) { <<HTML
<h2>The Rainfall Problem</h2>

<p>I read of a test given to students to see if they understand the concepts in the first part of a computer science course. It was in an interesting paper called <em>What Makes Code Hard to Understand?</em><a href="#0" title="Jump to reference">⁰</a>.</p>

<blockquote><p>To solve it, students must write a program that averages a list of numbers (rainfall amounts), where the list is terminated with a specific value – e.g., a negative number or 999999.</p></blockquote>

<p>Of course, reading about the problem I immediately wanted to try it, but even though the idea of posing the problem was to test the understanding of loops, the problem lends itself naturally to a recursive solution, and that's much more interesting than a boring old loop! I realised it wouldn't run well in Ruby but decided to write it anyway:</p>

<pre><code class="CodeRay"><span class="keyword">def</span> <span class="function">rainfall</span>(droplets,total=<span class="integer">0</span>,measures=<span class="integer">1</span>,limit=<span class="integer">99_999</span>)
  <span class="keyword">return</span> total.to_f.div measures <span class="keyword">if</span> droplets == limit
  <span class="keyword">unless</span> droplets &lt; <span class="integer">0</span>
    total += droplets
    measures += <span class="integer">1</span>
  <span class="keyword">end</span>
  rainfall rand(limit + <span class="integer">1</span>), total, measures
<span class="keyword">end</span></code></pre>

<p>Normally I'd start this off with a random number, but just to make it clear that it works I started with the termination number. Then, I reran it until it worked. It gives you an idea of how poor Ruby is at recursion.</p>

<pre><code class="CodeRay">rainfall 99_999
# =&gt; 0
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
# =&gt; 49693</code></pre>

<p>Just to be clear, I ran this with Ruby 2.0.0-rc2 as well with the same results. It's a pity that Ruby fails at this kind of thing, because it is such an elegant and useful language that seems to have borrowed the best of many other niche languages. Recursion is often the most elegant <em>and</em> performant<a href="#1" title="Jump to reference">¹</a> solution.</p>

<div id="reflinks">
<p><a name="0"></a>[0] <a href="http://arxiv.org/abs/1304.5257" title="http://arxiv.org/abs/1304.5257">http://arxiv.org/abs/1304.5257</a> What Makes Code Hard to Understand? Michael Hansen, Robert L. Goldstone, Andrew Lumsdaine</p>

<p><a name="1"></a>[1] <a href="http://dictionary.cambridge.org/dictionary/british/pedant" title="http://dictionary.cambridge.org/dictionary/british/pedant">http://dictionary.cambridge.org/dictionary/br...</a> If you're one of these then you won't like that I made a word up. Unfortunately for you, I'm British, which means that I understand that English is a living language, it is my tool not my master, and it has a long history of being changed to suit the speaker or writer. This is one such case.</p>
</div>

HTML
      }
      let(:my_f) { MyFilter.new content }
      subject { my_f.filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount, :coderay, :insideblock }
      it { should == expected }
      
      describe "With options" do
        context "Passed to the class" do
          before :all do
            MyFilter.options.merge! :linkreffing => {kind: :none}
          end
          subject { MyFilter.new(content).filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount, :coderay, :insideblock }
          it { should_not == expected }

          context "and passed to filter" do
            subject { MyFilter.new(content).filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount, :coderay, :insideblock, :linkreffing => {kind: :reference} }
            it { should == expected }
          end
        end
      end
    end

    context "An atom feed that only needs some of the filters" do
      let(:expected) { <<EXPECTED
<h2>The Rainfall Problem</h2>

<p>I read of a test given to students to see if they understand the concepts in the first part of a computer science course. It was in an interesting paper called <em>What Makes Code Hard to Understand?</em>.</p>

<blockquote><p>To solve it, students must write a program that averages a list of numbers (rainfall amounts), where the list is terminated with a specific value – e.g., a negative number or 999999.</p></blockquote>

<p>Of course, reading about the problem I immediately wanted to try it, but even though the idea of posing the problem was to test the understanding of loops, the problem lends itself naturally to a recursive solution, and that's much more interesting than a boring old loop! I realised it wouldn't run well in Ruby but decided to write it anyway:</p>

<pre><code>::::ruby
def rainfall(droplets,total=0,measures=1,limit=99_999)
  return total.to_f.div measures if droplets == limit
  unless droplets &lt; 0
    total += droplets
    measures += 1
  end
  rainfall rand(limit + 1), total, measures
end
</code></pre>

<p>Normally I'd start this off with a random number, but just to make it clear that it works I started with the termination number. Then, I reran it until it worked. It gives you an idea of how poor Ruby is at recursion.</p>

<pre><code>::::shell
rainfall 99_999
# =&gt; 0
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
SystemStackError: stack level too deep
  from /Users/iainuser/.rvm/rubies/ruby-1.9.3-p385/lib/ruby/1.9.1/irb/workspace.rb:80
Maybe IRB bug!
rainfall 99_998
# =&gt; 49693
</code></pre>

<p>Just to be clear, I ran this with Ruby 2.0.0-rc2 as well with the same results. It's a pity that Ruby fails at this kind of thing, because it is such an elegant and useful language that seems to have borrowed the best of many other niche languages. Recursion is often the most elegant <em>and</em> performant solution.</p>
EXPECTED
      }
      before :all do
        TextTube.load_all_filters
        class MyFilter < TextTube::Base
          register TextTube::LinkReffing
          register TextTube::EmbeddingAudio
          register TextTube::EmbeddingVideo
          register do
            filter_with :rdiscount do |text|
              RDiscount.new(text).to_html
            end
          end
        end
      end
      describe "With options" do
        context "passed to filter" do
          subject { MyFilter.new(content).filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount, :linkreffing => {kind: :none} }
          it { should == expected }
        end
        context "set on the instance" do
          subject { MyFilter.new(content, :linkreffing => {kind: :none}).filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount }
          it { should == expected }
        end
        context "set on the class" do
          before :all do
            MyFilter.options.merge! :linkreffing => {kind: :none}
          end

          subject {
            MyFilter.new(content).filter :embeddingvideo, :embeddingaudio, :linkreffing, :rdiscount }
          it { should == expected }
        end
      end
    end
  end
end