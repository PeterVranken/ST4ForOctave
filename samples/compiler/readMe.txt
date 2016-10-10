This sample presents a compiler fragment, which makes use of
StringTemplate V4 as target code generator. The entire parse tree is
passed as a single attribute to the StringTemplate V4 template. The
template iterates through this data object and produces the compiler
output.

Code is generated for two targets. Both are executable. The representation
of the generated code is modeled close to a real machine instruction set.
This holds particularly for the representation in C code, where macros and
the goto statement permit to let the generated code resemble real machine
code.

The sample proves that the template engine is well suited to render deeply
structured data. The parse tree itself is developed as a normal Octave
data structure. The sample code demonstrates that the StringTemplate V4
interface barely restrains the design of the Octave application. A quite
normal and usual data object can be passed to the StringTemplate V4 engine
just like that. The interface code does do the required wrapping in a
reliable way.

Furthermore, the sample demonstrates the major advantage of using a
template engine as output generator, the flexibility and configurability.
The Octave language itself is quite powerful in string or text operations.
It wouldn't be difficult to implement the compiler's back-end directly in
Octave without the need for the interface and StringTemplate. However, the
sample uses in total three structurally identical variants of the
templates to produce different output from the same data object; we get a
human readable log, which reports how the compiler understood the source
code and executable code for two different targets. Shaping output for
other targets, e.g. a real machine instruction set, would be quite easy --
without any change of the compiler's own source code. It would be hard to
achieve this degree of changeability of the application output with normal
programming techniques.

To run the compiler you need to consider the general notes on the
configuration of the interfaces stated in file readMe.md in the root
folder of this distribution. Then CD here and type e.g.

help runCompiler
runCompiler('test', true)