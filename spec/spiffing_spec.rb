# encoding: UTF-8

require 'spec_helper'
require_relative '../lib/texttube/base.rb'
require 'texttube/filters/spiffing'

describe "TextTube" do
  let(:content) { <<CSS
body {
  background-colour: darkgrey;
  background-photograph: url(logo.gif);
  transparency: .7;

  font: 72px "Comic Sans", cursive !please;
  font-weight: plump;
  p { text-align: centre }
  fieldset input {
    text-transform: capitalise;
  }
}
CSS
  }

  let(:expected) { <<EXPECTED
body {
  background-color: darkgray;
  background-image: url(logo.gif);
  opacity: .7;

  font: 72px "Comic Sans", cursive !important;
  font-weight: bold;
  p { text-align: center }
  fieldset input {
    text-transform: capitalize;
  }
}
EXPECTED
  }
  class CssString < TextTube::Base
    register TextTube::Spiffing
  end

  subject { CssString.new(content).filter }
  it { should == expected }
end