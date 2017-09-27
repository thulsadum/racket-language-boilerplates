# racket - language boilerplates

In racket the top level abstractions are languages / domain specific languages.
This, is in the spirit of lisp.

Racket makes it reasonable simple to create your own languages with semantics, but I regulary mess
the setup / configuration of the module structure up. So, I decided to maintain these small
boilerplates to give myself a little aid.

## Examples

### simple

Shows the simple structure of a language (i.e. provides a `read-syntax` function and parses into a module form)

### simple-flavoured

Shows how to create a 'flavoured' language `#lang simple/ci`.


## Recommended Bibliography

  * [beau­ti­ful racket](https://beautifulracket.com/)
    by [matthew but­t­er­ick](https://beautifulracket.com/about-the-author.html)
  * [Fear of Macros](http://www.greghendershott.com/fear-of-macros/)
    by [Greg Hendershott](http://www.greghendershott.com/)
  * The sections about [Macros](http://docs.racket-lang.org/guide/macros.html) and
    [Languages](http://docs.racket-lang.org/guide/languages.html) of
    [the Racket Guide](http://docs.racket-lang.org/guide/index.html) by Matthew Flatt,
    Robert Bruce Findler and PLT


## Attributions

  * *LICENSE.md* taken from [@idleberg/Creative-Commons-Markdown](https://github.com/idleberg/Creative-Commons-Markdown)