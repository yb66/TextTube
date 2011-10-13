# encoding: UTF-8

module MarkdownFilters
  VERSION = "1.0.1"
end

require_relative "./markdownfilters/link_reffing.rb"
require_relative "./markdownfilters/embedding_video.rb"
require_relative "./markdownfilters/embedding_audio.rb"
require_relative "./markdownfilters/inside_block.rb"
require_relative "./markdownfilters/coderay.rb"