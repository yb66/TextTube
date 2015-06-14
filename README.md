## TextTube ##

Pass a string through filters to transform it.

### Build status ###

Master branch:
[![Build Status](https://travis-ci.org/yb66/TextTube.png?branch=master)](https://travis-ci.org/yb66/TextTube)

Develop branch:
[![Build Status](https://travis-ci.org/yb66/TextTube.png?branch=develop)](https://travis-ci.org/yb66/TextTube)

### Why? ###

I wanted to run a filter across articles I'd written for [my blog](http://iainbarnett.me.uk/), but also for the atom feed to the blog. Both needed some of the filters, but the atom feed needed less of them and slightly different options.


### What does it do? ###

You want to filter/transform a string. You also want to run several filters across it, usually in the same way but sometimes just some of them, sometimes in a slightly different order. Object orientated programming will come to our rescue!

* The string is the instance.
* Modules hold groups of reusable filters.
* A class defines which filters to use.
* The method for running the filters will also allow ordering.

In practice this means:

```ruby
require 'texttube/filterable'

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

require 'texttube/base'

class NeuS < TextTube::Base
  register BFil
  register AFilter
  register do # on the fly
    filter_with :dashes do |text|
      "---#{text}---"
    end
  end
end
```

Now there is a class `NeuS` which will run filters `:spacial`, `:double`, `:triple`, and `:dashes` in that order, on a given string. For example:

```ruby
n = NeuS.new "abc"
```

Running all of the filters:

```ruby
n.filter
# => "---a b ca b ca b ca b ca b ca b c---"
```

Or just some of the filters:

```
n.filter :spacial
# => "a b c"
n.filter :spacial, :dashes
# => "---a b c---"
```

Run them more than once:

```ruby
n.filter :double, :triple, :double
# => "abcabcabcabcabcabcabcabcabcabcabcabc"
```

### Creating a filter ###

Make something _filterable_:

```ruby
require 'texttube/filterable'

module AnotherFilter
  extend TextTube::Filterable

  filter_with :copyright do |text|
    text << " ©#{Time.now.year}. "
  end

  filter_with :number do |text,options|
    text * options[:times].to_i
  end
end
```

That's all there is to creating a filter.

### Creating a filter class ###

The class picks which filters to use, and can add filters on the fly, by using `register`:

```ruby
require 'texttube/base'

class MyString < TextTube::Base
  register AnotherFilter
  register do
    filter_with :my_name do |text|
      text.gsub "Iain Barnett", %q!<a href="iainbarnett.me.uk" title="My blog">Iain Barnett</a>!
    end
  end
end

s = MyString.new "Let me introduce Iain Barnett. He writes Ruby code."
# => "Let me introduce Iain Barnett. He writes Ruby code."

MyString.options.merge! :number => {times: 2}
# => {:number=>{:times=>2}}

s.filter
# => "Let me introduce <a href="iainbarnett.me.uk" title="My blog">Iain Barnett</a>. He writes Ruby code. ©2013. Let me introduce <a href="iainbarnett.me.uk" title="My blog">Iain Barnett</a>. He writes Ruby code. ©2013. "
```

### Options ###

There are 3 types of options available:

#### Class options ####

These options are available for all instances of that class. One was used in the previous example:

```ruby
MyString.options.merge! :number => {times: 2}
```

#### Instance options ####

Using this type of option will mean that option is used with this instance and no other. It will override class options:

```ruby
m = NeuS.new "abc", :order=>[:dashes, :double, :spacial]
m.filter # will use :dashes, :double, :spacial
```

#### Method options ####

These will affect only this call of the `filter` method:

```ruby
# this does :triple, :dashes, :spacial
m.filter :order=>[:triple, :dashes, :spacial]
# this does :dashes, :double, :spacial
m.filter
```

Of course, if you just want to effect the order in a one off call then `m.filter :triple, :dashes, :spacial` would work just as well.

If you have several filters and you want to pass some options then you need give the name of the filter along with the options. Here's an example:

```ruby
class FutureString < TextTube::Base
  register do
    filter_with :read_more do |text,options|
      text + " " + options.fetch(:teaser, "READ MORE")
    end
    filter_with :add_title do |text,options|
      title = "#{options.fetch(:title, 'My article')}\n\n"
      title + text
    end
  end
end

future = FutureString.new "It's looking bright!"
future.filter :read_more =>{teaser: "carry on reading…"}, :add_title =>{title: "Feeling optimistic"}
```

Which would output:

> Feeling optimistic
> 
> It's looking bright! carry on reading…

You can see from this example that you can register more than one filter on the fly within a register block.


#### Overrides ####

Keep in mind that class options are overriden by instance options, and instance options (and class options) are overriden by method options.

#### Note! ####

Options are only applied if you pass a block with the 2nd options argument available. For example, this will apply options:

```ruby
class Optional < TextTube::Base
  register do
    filter_with :something_with_options do |text,options|
      extras = options.fetch :extra, " "
      text + extras + "This should be ok."
    end
  end
end

This will not:

class Optional < TextTube::Base
  register do
    filter_with :something_without_options do |text|
      text + options + "This will throw an error."
    end
  end
end
```

If you don't plan to use the options then don't provide them as an argument, but don't refer to them in the block, e.g.

class NotBothered < TextTube::Base
  register do
    filter_with :something_without_options do |text|
      text + "We're just not giving you the option."
    end
  end
end


### All of these examples have been used as specs ###

Take a look and run them.


### Ready made filters ###

They used to come with this library, but sometimes they caused problems with installation (things like Nokogiri can be painful to install at times) so I spun them off into their own library - [TextTubeBaby](https://github.com/yb66/TextTubeBaby)!


### Contributors ###

Many thanks to Eleni Karinou and [Annette Smith](https://twitter.com/moosecatear) for brainsplatting a new name for the library, and after many unusable and clearly disturbing suggestions, to Annette for the final name (and its spin off, [TextTubeBaby](https://github.com/yb66/TextTubeBaby)).


### Licence ###

Copyright (c) 2013 Iain Barnett

MIT Licence

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


i.e. be good
