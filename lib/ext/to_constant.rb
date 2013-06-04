module MarkdownFilters

  # Core lib extensions reside here.
  module CoreExtensions
    # to_constant tries to find a declared constant with the name specified
    # in the string. It raises a NameError when the name is not in CamelCase
    # or is not initialized.
    #
    # Examples
    #   "Module".to_constant #=> Module
    #   "Class".to_constant #=> Class
    def to_constant
      unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ self
        fail NameError, "#{self.inspect} is not a valid constant name!"
      end
  
      Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end
  end
end


# Standard lib String class gets some extras.
class String
  include MarkdownFilters::CoreExtensions
end