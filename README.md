## TextTube ##

Pass a string through filters to transform it.

### Why? ###

I wanted to run a filter across articles I'd written for [my blog](iainbarnett.me.uk/), but also for the atom feed to the blog. Both needed some of the filters, but the atom feed needed less of them and slightly different options.


### What does it do? ###

You want to filter/transform a string. You also want to run several filters across it, usually in the same way but sometimes just some of them, sometimes in a slightly different order. Object orientated programming will come to our rescue!

* The string is the instance.
* Modules hold groups of reusable filters.
* A class defines which filters to use.
* The method for running the filters will also allow ordering.

In practice this means:


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

Now there is a class `NeuS` which will run filters `:double`, `:triple` and `spacial` in that order, on a given string. For example:

    n = NeuS.new "abc"

Running all of the filters:

    n.filter
    # => "---a b ca b ca b ca b ca b ca b c---"

Or just some of the filters:

    n.filter :spacial
    # => "a b c"
    n.filter :spacial, :dashes
    # => "---a b c---"

Run them more than once:
    
    n.filter :double, :triple, :double
    # => "abcabcabcabcabcabcabcabcabcabcabcabc"

### Creating a filter ###

Make something _filterable_:

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

That's all there is to creating a filter.

### Creating a filter class ###

The class picks which filters to use, and can add filters on the fly, by using `register`:

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


## The Filters ##

Here are some ready built filters to use.

### LinkReffing ###

If you'd don't want your links inline and would prefer to have them at the bottom of the document, then you can use this:

    require 'texttube/base'
    require 'texttube/filters/link_reffing'
    
    class TextWithLinks < TextTube::Base
      register TextTube::LinkReffing
    end
    
    s = TextWithLinks.new %q!Iain's blog[[http://iainbarnett.me.uk|My blog]] is good. Erik Hollensbe's blog[[http://erik.hollensbe.org/|Holistic Engineering]] is also good, as is James Coglan's blog[[http://blog.jcoglan.com/|The If Works]]!

    s.filter

and it will produce this:

    # => "Iain's blog[&#8304;](#0 "Jump to reference") is good. Erik Hollensbe's blog[&sup1;](#1 "Jump to reference") is also good, as is James Coglan's blog[&sup2;](#2 "Jump to reference")\n<div markdown='1' id='reflinks'>\n<a name="0"></a>&#91;0&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog\n\n\n<a name="1"></a>&#91;1&#93; [http://erik.hollensbe.org/](http://erik.hollensbe.org/ "http://erik.hollensbe.org/") Holistic Engineering\n\n\n<a name="2"></a>&#91;2&#93; [http://blog.jcoglan.com/](http://blog.jcoglan.com/ "http://blog.jcoglan.com/") The If Works\n\n</div>"

Run that through a markdown parser and you get:

    <p>Iain's blog<a href="#0" title="Jump to reference">&#8304;</a> is good. Erik Hollensbe's blog<a href="#1" title="Jump to reference">&sup1;</a> is also good, as is James Coglan's blog<a href="#2" title="Jump to reference">&sup2;</a></p>
    
    <div markdown='1' id='reflinks'>
    <a name="0"></a>&#91;0&#93; [http://iainbarnett.me.uk](http://iainbarnett.me.uk "http://iainbarnett.me.uk") My blog
    
    
    <a name="1"></a>&#91;1&#93; [http://erik.hollensbe.org/](http://erik.hollensbe.org/ "http://erik.hollensbe.org/") Holistic Engineering
    
    
    <a name="2"></a>&#91;2&#93; [http://blog.jcoglan.com/](http://blog.jcoglan.com/ "http://blog.jcoglan.com/") The If Works
    
    </div>

Using this will probably end up with also using InsideBlock, to transform the markdown inside the div.

### InsideBlock ###

Sometimes it'd be useful to wrap some markdown with HTML, for example:

    <div id="notes">
    
    * first
    * second
    * third
    
    </div>

If you put this through a markdown parser the markdown won't get parsed:

    require 'rdiscount'
    s = "<div id="notes">\n\n* first\n* second\n* third\n\n</div>\n"
    puts RDiscount.new(s).to_html

This is the output:

    <div id="notes">
    
    * first
    * second
    * third
    
    </div>

My brilliant idea to get around this is to add an HTML attribute of `markdown='1'` to HTML tags that you want the markdown parser to look inside:

    <div id="notes" markdown='1'>
    
    * first
    * second
    * third
    
    </div>

Trying this with `InsideBlock` gives:

    puts TextTube::InsideBlock.run s

    <div id="notes">
    <ul>
    <li>first</li>
    <li>second</li>
    <li>third</li>
    </ul>
    
    </div>

To use it as a filter:

    require 'texttube/base'
    
    class MyFilter < TextTube::Base
      register TextTube::InsideBlock
    end
    
    myf = MyFilter.new(s)
    # => "<div id="notes" markdown='1'>\n\n* first\n* second\n* third\n\n</div>\n"
    
    puts myf.filter

Gives:

    <div id="notes">
    <ul>
    <li>first</li>
    <li>second</li>
    <li>third</li>
    </ul>
    
    </div>

### Coderay ###

Filters an HTML code block and marks it up with [coderay](http://coderay.rubychan.de/):



    require 'texttube/base'
    require 'texttube/filters/coderay'
    require 'rdiscount' # a markdown parser
    
    class TextWithCode < TextTube::Base
      register do
        filter_with :rdiscount do |text|
          RDiscount.new(text).to_html
        end
      end
      register TextTube::Coderay
    end

    s = TextWithCode.new <<'STR'
    # FizzBuzz #
    
        ::::ruby
        (1..100).each do |n| 
          out = "#{n}: "
          out << "Fizz" if n % 3 == 0
          out << "Buzz" if n % 5 == 0
          puts out
        end
    
    That's all folks!
    STR
    # => "# FizzBuzz #\n\n    ::::ruby\n    (1..100).each do |n| \n      out = "\#{n}: "\n      out << "Fizz" if n % 3 == 0\n      out << "Buzz" if n % 5 == 0\n      puts out\n    end\n\nThat's all folks!\n"


    puts s.filter

Produces:

    <h1>FizzBuzz</h1>
    
    <pre><code class="CodeRay">(<span class="integer">1</span>..<span class="integer">100</span>).each <span class="keyword">do</span> |n| 
      out = <span class="string"><span class="delimiter">"</span><span class="inline"><span class="inline-delimiter">#{</span>n<span class="inline-delimiter">}</span></span><span class="content">: </span><span class="delimiter">"</span></span>
      out &lt;&lt; <span class="string"><span class="delimiter">"</span><span class="content">Fizz</span><span class="delimiter">"</span></span> <span class="keyword">if</span> n % <span class="integer">3</span> == <span class="integer">0</span>
      out &lt;&lt; <span class="string"><span class="delimiter">"</span><span class="content">Buzz</span><span class="delimiter">"</span></span> <span class="keyword">if</span> n % <span class="integer">5</span> == <span class="integer">0</span>
      puts out
    <span class="keyword">end</span></code></pre>
    
    <p>That's all folks!</p>

The language was specified with a leading `::::ruby`. It didn't have to be as the default is to use Ruby, but if you want to use any other of the [coderay supported languages](http://coderay.rubychan.de/doc/CodeRay/Scanners.html), that's how to do it.

### Contributors ###

Many thanks to Eleni Karinou and [Annette Smith](https://twitter.com/moosecatear) for brainsplatting a new name for the library, and after many unusable and clearly disturbing suggestions, to Annette for the final name (and its future spin off, which will remain secret for now).

### Licence ###

Copyright (c) 2013 Iain Barnett

MIT Licence

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


i.e. be good
