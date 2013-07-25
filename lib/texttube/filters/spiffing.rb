# encoding: UTF-8
require_relative "../filterable.rb"

module TextTube

  # Will transform the Queen's English into American English for use in CSS, as the current CSS standards prefer ugly words.
  # Inspired by visualidiot's SpiffingCSS (see http://spiffingcss.com/)
  module Spiffing
    extend TextTube::Filterable
  
    filter_with :spiffing do |text|
      TextTube::Spiffing.run text
    end


    # The dictionary.
    DICTIONARY = {
      # Queen's English	  # Primitive English from our stateside
                          # friends from across the pond.
      'colour'        => 'color',
      'grey'          => 'gray',
      '!please'       => '!important',
      'transparency'  => 'opacity',
      'centre'        => 'center',
      'plump'         => 'bold',
      'photograph'    => 'image',
      'capitalise'    => 'capitalize'
    }

    # @param [String] content
    # @param [Hash] options
    def self.run( content, options={})
      ugly_child = content.dup
#       warn ugly_child
      DICTIONARY.each do |english, ugly|
        ugly_child.sub! english, ugly
#         warn ugly_child
      end
      ugly_child
		end
  end
end