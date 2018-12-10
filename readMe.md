[TOC]

# What is StringTemplate-for-Octave? #

StringTemplate-for-Octave is a SourceForge open source project, which
presents an interface between GNU Octave (<http://www.Octave.org>) and
StringTemplate V4 (<http://www.stringtemplate.org>). Although Octave is
basically an environment for data analysis and development of mathematical
algorithms is it due to its convenient and very efficient scripting
language well suited for general scripting and text processing, too.
(Here, "very efficient" is meant in terms of development effort and
progress.) In this context, a template engine is a useful component.

StringTemplate V4 is a popular Java implementation of a powerful and
convenient template engine. Intended output text is defined widely literal
with intermingled template expressions. These expressions can refer to
data objects, which are passed in to the template engine as native Java
objects. Data object can be simple basic types or deeply nested data
structures build from collections and showing recursive structures. This
normally requires a compiled Java class, which a well-defined, statically
typed data object can be instantiated from.

Using the Octave Java interface it is generally possible to build a Java
object at run-time and to pass it to a Java class like the StringTemplate
engine.

The interface presented automates this concept. It wraps widely arbitrary
Octave data objects with appropriate Java data types and collections.
While this is straight forward for linear lists (e.g. using a
`java.util.ArrayList`) it does need much more consideration when it
comes to Octave struct objects with run-time defined fields (i.e. no
compiled Java class is available by principle). All the processing is done
recursively so that deeply nested data objects can be passed to the
template engine just like that.

A major sample presents a compiler fragment, which passes its complete
parse tree as a single "attribute" -- i.e. the data object to be rendered
in the terminology of StringTemplate -- to the template engine for code
generation.

# Current revision #

The current revision of the [downloadable files](https://sourceforge.net/projects/stringtemplate-for-octave/) is SVN r20. Please refer to
the SVN log for latest changes.

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
    
    Some of the samples use absolute paths for template group files and
    are not affected, but normally setting the class path is the most
    important setup step. 

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

## Problems with Java class path using StringTemplate V4 with Octave for Windows ##

In the SVN revisions prior to 39 we had documented a strange and
untransparent behavior of the StringTemplate V4 engine with respect to
locating template files via the Java class path. This was considered a
problem with setting the Java class path in Octave. Making now new
investigations it appeared to be another problem. Using the Octave command

    javaMethod ("getProperty", "java.lang.System", "java.class.path")
 
it could be proven that the class path was correctly set but the ST4
engine still didn't read the template files. From the error reports it
even appeared that it could locate the files in the class path but then it
failed because it tried loading the files always from the startup
directory of Octave. Either this was the right path or the template
expansion failed.

We could find an explanation and can't offer a fix. 

From SVN r39 on, we circumvent the problem by passing only absolute paths
to the ST4 engine. The user specified template files are located using the
Octave search path and if found the absolute path is send to the engine.
Consequently, the Java class path no longer needs to be configured for
template files. (It only requires two entries for the jar files that
implement the interface and the ST4 engine. This works straightforward.)

The import statement to load sub-template group files typically make use
of relative paths. These paths are understood as relative to the group
file, which contains the import statement. This behavior matches the
expectations but it is no longer possible to hold a general purpose
template library somewhere in the depth of the file system and just add
the root path of the library to the Java class path as it usually is with
the ST4 engine.

Using this avoidance strategy all samples and tests worked very well and
in full accordance with user expectations but the documented behavior of
the StringTemplate V4 engine is significantly changed by this decision!

# Documentation #

-   In Octave, type `help st4Render` and `help st4RenderWrite` to get the
    online help about the StringTemplate interface for Octave
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
