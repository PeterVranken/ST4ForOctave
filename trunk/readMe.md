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
    
    Some of the sample use absolute paths
    for template group files and are not affected, but
    
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
    
## **CAUTION**: Problems using Octave 4.0.3 for Windows? ##

Using Octave 4.0.3 under Windows 7 we saw a very strange
and untransparent dependency of the class path handling on the order
of submitted Octave commands. 

There seems to be an untransparent, malicious impact of using the command
`javaclasspath`. See what happened. Each command sequence shown down here
was submitted in a new Octave session, i.e. the Octave application was
reopened every time. The first two times, a properly configured file
`javaclasspath.txt` was in place:

~~~~~~~~~~~~~~~
addpath(pwd) % Make Octave find st4Render.m
cd samples % Go to the sample
testST4Render % Running the sample fails, java.lang.ClassNotFoundException
javaclasspath % Shows empty static and dynamic class path
addOctavePaths % Sets and displays correct dynamic CP, static CP is empty
testST4Render % Re-running the sample succeeds
~~~~~~~~~~~~~~~

Although the static class path should be set because of the file
`javaclassptha.txt` the Java virtual machine didn't find the
StringTemplate V4 jar file and class. Healing by setting the dynamic class path was
possible. It's however striking that after setting the dynamic class path
the static class path is empty. Where has it gone? In the second test --
Octave re-opened -- we begin with double-checking the (static) class path,
which should be configured by `javaclasspath.txt`:

~~~~~~~~~~~~~~~
javaclasspath % Displays correct static CP and empty dynamic CP
addpath(pwd) % Make Octave find st4Render.m
cd samples % Go to the sample
testST4Render % Running the sample fails, java.io.FileNotFoundException
javaclasspath % Shows unchanged static and dynamic class paths
addOctavePaths % Sets and shows correct dynamic CP, static CP is unchanged
testST4Render % Re-running the sample still fails, group file not found
~~~~~~~~~~~~~~~

Only by displaying the class paths at the beginning the behavior changes.
Now the Java virtual machine finds the StringTemplate V4 engine and runs
it but StringTemplate V4 doesn't find the group file (which is however in
the displayed static class path). Healing by setting the dynamic class
path is impossible, the behavior is unchanged.

The situation is similar without a `javaclasspath.txt` in the Octave start
directory. See the next two command sequences. The sample works well in
the third sequence:

~~~~~~~~~~~~~~~
addpath(pwd) % Make Octave find st4Render.m
cd samples % Go to the sample
addOctavePaths % Sets and shows correct dynamic CP, static CP is empty
testST4Render % Sample succeeds
~~~~~~~~~~~~~~~

Only by issuing a 'javaclasspath' as very first command the behavior
changes. The command `addOctavePaths` displays the wanted class path and
the class path is alright to let the Java virtual machine find the
StringTemplate V4 jar file and class but the Java class StringTemplate
can't locate the group file. Healing by repetition of addOctavePaths isn't
possible in this situation.

~~~~~~~~~~~~~~~
javaclasspath % Shows empty static and dynamic class paths
addpath(pwd) % Make Octave find st4Render.m
cd samples % Go to the sample
addOctavePaths % Sets and shows correct dynamic CP, static CP is empty
testST4Render % Running the sample fails, java.io.FileNotFoundException
~~~~~~~~~~~~~~~

From the observations is looks as if the initial submission of command
`javaclasspath` would freeze the static class path somehow, while an
earlier use of `javaaddpath` (as part of our `addOctavePaths`) seems to
discard it. First setting the dynamic class path and then issuing
`javaclasspath` shows an empty static class path. Furthermore, the Java
class StringTemplate seems to find template files only through the dynamic
class path and only if the static class path has not been "frozen" before.

As a conclusion and if your environment shows the same behavior, a
recipe could be:

-   Don't use a static class path for StringTemplate V4
-   Define the dynamic class path. It points to the ST4 jar file and
    contains all folders with your template files
-   Don't issue `javaclasspath` prior to defining the dynamic class path
-   Run st4Render only after setting the dynamic class path

An explanation cannot be given.


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
