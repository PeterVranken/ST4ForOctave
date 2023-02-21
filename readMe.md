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

The current revision of the [downloadable files](https://sourceforge.net/projects/stringtemplate-for-octave/) is SVN r68 as of 21.02.2023.
  
The Java jar files require a Java runtime system of at least Java 8
(aka 1.8).

Please refer to the SVN log for latest changes.

# How to run the StringTemplate V4 engine from GNU Octave? #

-   The interface is implemented by a few Octave script files, mainly
    `st4Render.m` and `st4RenderWrite.m`. They are accompanied by some
    minor support scripts. Copy the contents of the archive to an
    appropriate location and update your Octave search path so that the
    scripts are found. Consider running the support script `st4addpath`
    from the root of the archive to do so once in a new Octave session. Or
    consider using the native Octave commands `addpath` and `savepath` to
    update the search path persistently
-   Support script `st4addpath` will set the search path not only for the
    executable Octave scripts but for the StringTemplate V4 template group
    files used by the different samples, too. Without running `st4addpath`
    some samples will fail to locate the required templates
-   Open an Octave session. Ensure that the Java class path contains

    -   the jar file with StringTemplate V4.3.4, `antlr-4.12.0-complete.jar`
    -   the interface jar file, `ST4ForOctave-1.0.jar`

    The current Java class path can be double-checked with typing
    `javaclasspath` in the Octave command line window.
    
    Several ways exist to modify the Java class path of Octave. You may do
    this on the fly with the support script `st4javaaddpath` from the root
    of the archive or you rely on the Octave startup file
    `javaclasspath.txt`. We provide you a template for this file but it
    needs customization before use and it'll work only if the Octave
    executable is started from this directory. Windows users can have a
    look at (and double-click) `runOctave.cmd` to do so. Everybody should
    consult
    <https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html>
    to get the whole story on setting the Java class path
-   Consider running the Octave command `st4SetLocaleUS`, which makes Java
    code assume standard US representation of character sets and number,
    date and time designations. If you don't do so, then your templates my
    produce different output depending on where the tool is run. See below
    for details
-   In Octave, `cd` to directory `samples` and run the different Octave
    scripts. They will easily throw an error if something is still wrong
    with the paths! Open the scripts in a text editor and find out what
    they want to demonstrate
-   If the basic samples are running well you can have a closer look at
    the major sample `compiler`

## Problems with Java class path using StringTemplate V4 with Octave for Windows ##

In the SVN revisions prior to 39 we had documented a strange and
untransparent behavior of the StringTemplate V4 engine with respect to
locating template files via the Java class path. This was considered a
problem with setting the Java class path in Octave. Making now new
investigations it appeared to be another problem. Using the Octave command
`javaMethod ("getProperty", "java.lang.System", "java.class.path")`
it could be proven that the class path was correctly set but the ST4
engine still didn't read the template files. From the error reports it
even appeared that it could locate the files in the class path but then it
failed because it tried loading the files always from the startup
directory of Octave. Either this was the right path or the template
expansion failed.

We couldn't find an explanation and can't offer a fix. 

From SVN r39 on, we circumvent the problem by passing only absolute paths
to the ST4 engine. The user specified template files are located using the
Octave search path and if found the absolute path is sent to the engine.
Consequently, the Java class path no longer needs to be configured for
template files. (It only requires two entries for the jar files that
implement the interface and the ST4 engine. This works straightforward.)

The import statement in a template group file to load sub-ordinated group
files typically makes use of relative paths. These paths are understood as
relative to the group file, which contains the import statement. This
behavior matches the expectations but it is no longer possible to hold a
general purpose template library somewhere in the depth of the file system
and just add the root path of the library to the Java class path as it
usually is possible with the ST4 engine.

Using this avoidance strategy all samples and tests worked very well and
in full accordance with user expectations but the documented behavior of
the StringTemplate V4 engine is significantly changed by this decision!

## Wrong Locale ##

Java's and thus StringTemplate's behavior are region dependent. The
representation of numbers and dates depends on where the software is
executed. This affects the generated output when using the renderers for
printf-like, formatted output. Mainly floating point numbers looking like
31,415e-1 are quite annoying. Region dependent software behavior will be
undesired in the majority of use cases. You can make your StringTemplate
V4 templates region independent by setting the default region US in the
Java virtual machine of the Octave session. Before using any of the
functions in this package put some code like this in your Octave script:

    % Call of static method getDefault of class Locale to see which country we
    % operate the software in.
    locale = javaMethod('getDefault', 'java.util.Locale');

    % It should be US to avoid problems with representation of numbers and
    % dates. Differences in locale will easily affect the output of
    % StringTemplate V4 in a way, which won't be desirable for most use
    % cases. We switch to the US standard if necessary.
    if ~strcmp(locale.getLanguage(), 'us')
        % Create a US Locale object...
        localeUSObj = javaObject('java.util.Locale', 'US');
        % ... and pass it to the static class method setDefault.
        javaMethod('setDefault', 'java.util.Locale', localeUSObj);
    end

    % Now, we should surely use the US representation of numbers and dates.
    locale = javaMethod('getDefault', 'java.util.Locale')

Consider running `testST4Render` to test your system's behavior. It proves
that floating point numbers use the dot as separator.

The commands to define the Java locale are made available to the library
users as command `st4SetLocaleUS`. Using this script, a typical startup
sequence for an application using ST4ForOctave could resemble this code
snippet:

    % Anchor of initialization: Make library scripts available to the
    % Octave interpreter.
    run <myInstallationPathOfST4ForOctave>\st4addpath.m
    st4javaaddpath
    st4SetLocaleUS
    % Down here, the StringTemplate V4 engine is usable. Let's try:
    testST4Render
    testST4RenderWrite

# Documentation #

-   In Octave, type `help st4Render` and `help st4RenderWrite` to get the
    online help about the StringTemplate interface for Octave
-   See folder `doc`. Some help on the StringTemplate engine has been added.
    You will need to study the documentation in order to learn about
    templates and template expressions
-   A service object of Java class `info.Info` is passed to the ST4
    templates as additional attribute `info`. The fields and services this
    object provides to the template are described in the Javadoc
    documentation at
    <https://svn.code.sf.net/p/stringtemplate-for-octave/code/trunk/doc/dataModel/index.html>.
    Consider this Javadoc as the manual of the info object
-   Study the well documented source code of the interface scripts and the
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
the samples. Moreover, MATLAB 2012 still comes with an incompatible old
Java version and can't be used. This revision of StringTemplate for Octave
has been successfully tested with MATLAB 2021b.
