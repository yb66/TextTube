require 'spec_helper'
require_relative "../lib/texttube.rb"
require_relative "../lib/texttube/filters/inside_block.rb"

describe "InsideBlock" do
  let(:content) { <<HTML
<div class='wrapper' id='sidebar' markdown='1'>
## This is a sidebar ##

* Written
* in
* markdown

Sometimes this is useful.
</div>
HTML
  }
  let(:expected) { <<HTML
<div class="wrapper" id="sidebar">
<h2>This is a sidebar</h2>

<ul>
<li>Written</li>
<li>in</li>
<li>markdown</li>
</ul>


<p>Sometimes this is useful.</p>
</div>
HTML
  }
  subject { TextTube::InsideBlock.run content }
  it { should == expected }
end