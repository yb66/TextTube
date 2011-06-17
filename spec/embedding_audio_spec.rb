# encoding: utf-8

require 'rspec'
require 'logger'
require_relative "../lib/markdownfilters/embedding_audio.rb"


module MarkdownFilters
  describe MarkdownFilters do
    let(:logger){
      require 'logger'
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
      logger
    }

    describe EmbeddingAudio do
      context "Given some text" do
        let(:content) { "[audio[a24.m4a|A24]]" }
        let(:expected) {
%q[<div class='audio'><h3>A24</h3><audio preload='metadata' controls='controls'><source src='/streams/a24.m4a' type='audio/m4a' /><source src='/streams/a24.ogg' type='audio/ogg' />Your browser does not support HTML5, update your browser you fool!</audio></div>]
        }
        context "containing valid extended markdown for audio" do
          context "with no options" do
            subject { MarkdownFilters::EmbeddingAudio.run content }
            it { should_not be_nil }
            it { should be == expected }
          end
          context "with src_base given as an option" do
            subject { MarkdownFilters::EmbeddingAudio.run content, {src_base: "/files/" } }
            it { should_not be_nil }
            it { should_not == expected }
            it { should match(%r{^.+\ssrc\='/files/\S+?'\s.+$}) }
          end
        end
        context "containing invalid extended markdown for audio" do
          let(:content) { "audio[a24.m4a|A24]]" }
          subject { MarkdownFilters::EmbeddingAudio.run content }
          it { should_not be_nil }
          it { should_not be == expected }
          it { should == content }
        end
      end

    end # describe

  end # describe MarkdownFilters
end
