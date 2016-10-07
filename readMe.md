# What is StringTemplate-for-Octave? #

StringTemplate-for-Octave is a SourceForge open source project, which
presents an interface between GNU Octave (<http://www.Octave.org>) and
StringTemplate V4 (<http://www.stringtemplate.org>). Although Octave is
basically an environment for data processing and development of
mathematical algorithms is it due to its convenient and very efficient
scripting language well suited for general scripting and text processing,
too. (Here, "very efficient" is meant in terms of development effort and
progress.) In this context, a template engine is a useful component.

StringTemplate V4 is a popular Java implementation of a powerful and
convenient template engine. Intended output text is defined widely literal
with intermingled template expressions. These expressions can refer to
data objects, which are passed in to the template engine as native Java
objects. Data object can be simple basic types or deeply nested data
structures build from collections and showing recursive structures. This
normally requires a compiled Java class, which a well-defined data object
can be instantiated from.

Using the Octave Java interface it is generally possible to build a Java
object at run-time and to pass it to a Java class like the StringTemplate
engine.

The interface presented automates this concept. It wraps widely arbitrary
Octave data objects with appropriate Java data types and collections.
While this is straight forward for linear lists (e.g. using a
java.util.ArrayList) does it need much more consideration when it comes to
Octave struct objects with run-time defined fields (i.e. no compiled Java
class is available by principle). All the processing is done recursively so
that deeply nested data objects can be passed to the template engine
just like that.

A major sample presents a compiler fragment, which passes its complete
parse tree as a single "attribute" -- the rendered data object in the
terminology of StringTemplate -- to the template engine for code
generation.

# How to run the StringTemplate V4 engine from GNU Octave? #

-   The interface is implemented by the single M script file `st4Render.m`.
    Copy this file anywhere in your Octave search path - or
    extend your search path to make it capture its location. See Octave
    command `addpath` for more
-   Open an Octave session. Ensure that the Java class path contains

    -   the StringTemplate V4 jar file, `ST-4.0.8.jar`
    -   all directories with template files (`*.stg`)
    
    The current Java class path can be double-checked with typing
    `javaclasspath` in the Octave command line window.
    
    Several ways exist to modify the Java class path of Octave. You may do
    this on the fly with Octave command `javaaddpath` or you rely on the
    startup file `javaclasspath.txt`. We provide you a template for this
    file but it needs customization before use and it'll work only if the
    Octave executable is started from this directory. Windows users can
    have a look at (and double-click) `Octave.cmd` to do so. Everybody
    should consult
    <https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html>
    to get the whole story on setting the Java class path
    
-   In Octave, `cd` to directory `samples` and run the different M scripts.
    They will easily throw an error if something is still wrong with the
    paths! Open the scripts in a text editor and find out what they want
    to demonstrate
-   If the basic samples are running well you can have a closer look at
    the major sample `compiler`
    
# Documentation #

-   In Octave, type `help st4Render` to get the online help about the
    StringTemplate interface for Octave
-   See folder `doc`. Some help on the StringTemplate engine has been added.
    You will need to study the documentation in order to learn about
    templates and template expressions
-   Study the well documented source code of the interface script and the
    samples

# Please note #

The data structures, which can be exchanged with the StringTemplate engine
are widely arbitrary, which means that you can feel free in modeling your
data. However, there are important limitations; we can't pass any
imaginable Octave object through the given Java interface. For example
class objects of Octave are not supported but struct objects are. Type
`help st4Render` to get a list of known limitations.

The limitations won't be very painful but it means that you must not
expect to reuse all of your existing data models without any kind of
re-work when passing the data to the template engine.

The interface can be used with MATLAB, too. Besides the documented
limitations of the StringTemplate V4 interface itself lack elder MATLAB
revisions the 64 Bit integer operations, which are required to run some of
the samples.
