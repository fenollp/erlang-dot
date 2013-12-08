#erlang-dot • [GitHub](//github.com/fenollp/erlang-dot)

## Basis
* [DOT (graph description language)](http://en.wikipedia.org/wiki/DOT_(graph_description_language)#Syntax)
* [The DOT grammar](http://www.graphviz.org/doc/info/lang.html)

### Overview
This library reads & writes DOT files, having an AST (defined in `include/dot.hrl`) usable in Erlang.

I needed import/export and load digraphs into Erlang so made this library. Its goal is to be generic, abstracted away from my specific needs.
If you need some feature/part of the DOT language that is not available here please add it to the project, provided that it fits a generic project (as far as a library goes).
Just don't clutter it.

# Contact
Please [report issues](https://github.com/fenollp/erlang-dot/issues) and do a lot of [Pull Requests](https://github.com/fenollp/erlang-dot/pulls).
