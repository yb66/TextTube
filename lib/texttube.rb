# encoding: UTF-8

require_relative "./ext/blank.rb"
require_relative "./ext/to_constant.rb"

# The original. Maybe. I haven't checked.
module TextTube

  # Require all the filters.
  # The `map` is there to show the result of this and
  # show which libs were required (if so desired).
  # @return [Array<String,TrueClass>]
  def self.load_all_filters
    Dir.glob( File.join File.dirname(__FILE__), "/texttube/filters/*.rb" )
       .reject{|name| name.end_with? "version.rb" }
       .map{|filter| 
         tf = require filter
         [File.basename(filter, ".rb").gsub("_",""), tf]
       }
  end


end