# README

# What is this

This is a quick and rough implementation of Jellonator's [Nandlang](https://github.com/Jellonator/Nandlang) as a racket #lang using the [racket-peg](https://github.com/rain-1/racket-peg) library!

It's done in 3 parts:

* The [parser](https://github.com/rain-1/nand-lang/blob/master/nand-parser.rkt) processes the nand language input files, producing a lispy abstract syntax tree.
* The [transformer](https://github.com/rain-1/nand-lang/blob/master/nand-transform.rkt) translates the abstract syntax tree into regular racket code, implementing the semantics of the language by embedding it in another language.
* The [runtime](https://github.com/rain-1/nand-lang/blob/master/nand-runtime.rkt) provides functions for the translated output to make use of during execution.

The same approach could be used to implement any other language.

# Installation

Make sure you have the latest version of racket-peg installed.

```
raco pkg remove nand-lang
raco pkg install -u -t dir nand-lang
```

# Example

![alt text](/nand%20lang.png?raw=true)
