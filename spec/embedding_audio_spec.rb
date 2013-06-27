# encoding: utf-8

require 'spec_helper'
require_relative "../lib/texttube.rb"
require_relative "../lib/texttube/filters/embedding_audio.rb"


module TextTube
  describe TextTube do

    describe EmbeddingAudio do
      context "Given some text" do
        let(:content) { "[audio[a24.m4a|A24]]" }
        let(:expected) {
%q[<div class='audio'><h3>A24</h3><audio preload='metadata' controls='controls'><source src='/streams/a24.m4a' type='audio/m4a' /><source src='/streams/a24.ogg' type='audio/ogg' />Your browser does not support HTML5, update your browser you fool!</audio></div>]
        }
        context "containing valid extended markdown for audio" do
          context "with no options" do
            subject { TextTube::EmbeddingAudio.run content }
            it { should_not be_nil }
            it { should be == expected }
          end
          context "with src_base given as an option" do
            subject { TextTube::EmbeddingAudio.run content, {src_base: "/files/" } }
            it { should_not be_nil }
            it { should_not == expected }
            it { should match(%r{^.+\ssrc\='/files/\S+?'\s.+$}) }
          end
        end
        context "containing invalid extended markdown for audio" do
          let(:content) { "audio[a24.m4a|A24]]" }
          subject { TextTube::EmbeddingAudio.run content }
          it { should_not be_nil }
          it { should_not be == expected }
          it { should == content }
        end
      end

    end # describe

  end # describe TextTube
end
