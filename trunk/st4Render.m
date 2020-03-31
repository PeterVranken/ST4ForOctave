function [text] = st4Render(templateGroupFileName, verbose, templateName, varargin)

%   st4Render() -   Render data under control of an StringTemplate V4 template group file.
%
%                   CAUTION: It is considered a typical use case to have a single template
%                   group file with a bunch of templates used by the caller. To support
%                   this use case a StringTemplate group file is read once and cached.
%                   Intermediate changes of the file with a text editor are not recognized
%                   unless the caller enforces a re-reading of the cached file. The client
%                   application of this wrapper should submit a "clear st4Render" before it
%                   terminates. Alternatively, the function can be called with the string
%                   'clear' as first argument.
%
%                   CAUTION: The implementation of this function is just a wrapper around
%                   the Java library StringTemplate V4 (http://www.stringtemplate.org). To
%                   successfully call the wrapper the StringTemplate jar file ST-4.0.8.jar
%                   needs to be on the Java class path. See
%                   https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html
%                   to find out how to control Octave's class path.
%
%   Limitations:    Arrays are supported only as one or two dimensional.
%
%                   Octave has no concept to say for a single struct object, whether it is
%                   meant a scalar or a list of such with a single element. In the
%                   StringTemplate representation we decide for a scalar object. However,
%                   template operators for scalar structs and lists of those differ in
%                   behavior. If the template assumes to get a list of structs and uses the
%                   according iterator like <listOfStructs:renderOneStruct()> then the
%                   template will fail in the special case of a list with one element; now
%                   the template engine will receive a scalar as "listOfStructs" and the
%                   operator ":" will iterate the field names rather than doing a single
%                   step with the struct as a whole.
%                     Since lists of length 1 are not an exceptional situation is the
%                   consequence that lists and arrays of structs must not be used unless
%                   there are use case given constraints on their size so that a size of
%                   one can be excluded.
%                     A work around that can be applied in most use cases is the cell
%                   array. Octave can safely make the distinction between a cell array of
%                   size 1x1 of struct objects and a scalar struct object. If a cell array
%                   is used the template engine will always receive an array, even an empty
%                   one if the size of any dimension should be zero.
%
%                   The StringTemplate V4 engine claims to handle the end-of-line
%                   characters always system dependent correct. It'll write different
%                   character sequences when running the same template with same data on a
%                   Windows and a Linux machine. This seems a reasonable decision but
%                   causes problems if the engine is embedded in an environment, which has
%                   already sorted out this issue. Octave - similar to the C libraries it
%                   builds on - leaves the system dependent EOL conversion to the low level
%                   file I/O routine but all the code will simply see and use a newline
%                   character. When mixing text fragments received from the StringTemplate
%                   V4 template engine with other Octave scripting sources then a mixture
%                   of different EOL conventions is highly probable at least on Windows
%                   machines. There's no proper solution; text produced by the template
%                   engine should be written binary to file (fopen with 'wb' instead of
%                   'wt' as usual). If other Octave code produces additional text output
%                   then this codes needs to become platform aware in order to produce the
%                   same EOL convention as the template engine does.
%
%                   The Java interface of MATLAB has some problems with Java Map. It throws
%                   an exception when using java.util.TreeMap and uses different Java data
%                   types char and String for key of lengths 1 and more than 1,
%                   respectively. This has the ugly impact that structs, which have field
%                   names of length 1 are not processed correctly in the templates: ST4
%                   expects keys to be generally Java String and so these fields are not
%                   found when trying the normal template expression; <struct.f> would be
%                   empty - although the fields are in the map: everything looks fine if
%                   doing the Map iteration <struct:{f|<f>=<struct.(f)>}>. Octave works
%                   fine.
%
%                   The new type string of recent MATLAB versions (first time seen in
%                   MATLAB 2019b) is not supported. It is not compatible with the
%                   double-quoted string of Octave. Rendered data objects need to continue
%                   using single quotes strings, i.e. vectors of chars. As important is not
%                   to use double-quoted MATLAB strings as arguments of the APIs, e.g. for
%                   the file name in st4RenderWrite. The unknown type leads to errors and
%                   not even the error message itself can be raised. It uses expressions to
%                   get the bad file name (or else) for feedback into the error message and
%                   the expressions are not compatible with the new type string.
%
%   Input argument(s):
%       templateGroupFileName
%                   Name of group file to be loaded.
%                     If this is a relative path designation then the file is looked for in
%                   the Java class path. But caution. Both, Octave and MATLAB, show an
%                   untransparent behavior with setting the class path for the loaded
%                   StringTemplate V4 library. If you encounter problems with loading the
%                   template file you may need to use absolute paths; consider using
%                   Octave's command which to get an absolute path.
%                     Normally, if reusing the same template file in consecutive calls of
%                   this function then it is not re-parsed every time. If this string
%                   argument is set to 'clear' and if there are no more than two function
%                   arguments then no template rendering is done but all cached template
%                   group files are cleared. Subsequent calls to the function will surely
%                   reload the template files. This feature supports the development of the
%                   template files
%       verbose     Verbosity of the script. A number from 0 (OFF), 1 (FATAL), 2 (ERROR), 3
%                   (WARNING), 4 (INFO), 5 (DEBUG).
%                     If DEBUG is chosen then the progress of template loading and data
%                   wrapping is reported in detail.
%                     All other levels relate only to the console output under control of
%                   the template itself.
%                     For compatibility with former revisions of this script, verbose may
%                   be a Boolean, too. true is mapped onto DEBUG and false is mapped onto
%                   INFO.
%                     DEBUG should be used with outermost care, can produce tons of output,
%                   even that much that Octave 4.0.3 failed.
%                     An numeric value in the range 0 to 5, optional. 4=INFO by default.
%       templateName
%                   The name of the template to expand. Needs to be defined somewhere down
%                   the group hierarchy. It's recommended to use full paths to identify the
%                   template, e.g. '/myTemplate' for a root template
%       varargin    Pairs of names and values of template arguments (also known as
%                   "attributes"). The name of an attribute is a simple string. The
%                   attribute itself can either be a Java data structure or an Octave data
%                   object - with restrictions, see below.
%                     The name/value pairs can either be a list of function arguments or a
%                   single function argument, which then is a cell array of name/value
%                   pairs. This cell array is either a linear list or a table of two
%                   columns; the first column holds attribute names, the second column
%                   holds the associated values.
%                     The name 'wrapColumn' is considered not a template argument but an
%                   argument of the template rendering process. Inside the template and for
%                   multi-element attributes, a template can demand line wrapping at this
%                   column; the value itself is however not available to the template but
%                   processed by the template engine. By default, if this name doesn't
%                   appear in the list, the wrap column is set to 72.
%                     A Java data structure would typically be a collection created with
%                   the Octave method javaObject(CLASSNAME). A Java data structure is any
%                   object Obj, which isjava(Obj) evaluates to true for. Java data
%                   structure are passed to the StringTemplate engine as attribute value as
%                   they are.
%                     A Octave data object is all the rest - with a number of unsupported
%                   exceptions. The interface to StringTemplate V4 can handle basic data
%                   tapes, like numerals and strings. Note, that the numeric data types
%                   double, uint8, uint16, int8, etc. are distinguished and matter, e.g.
%                   when it comes to formatted printing.
%                     The interface will try to model the more complex Octave data
%                   structures as equivalent Java data structures. It will represent
%                   Octave's arrays and cell arrays as Java ArrayLists of the elements.
%                   Note, only one or two dimensional (cell) arrays are supported.
%                     An Octave struct object is modeled by a Java Map object. Each field
%                   of the struct is a key into the map. In the Java map the struct field's
%                   value is associated with the key. A template can use the map access
%                   expression like <map.key> to access the value. This is syntactically
%                   identical with accessing a field of a real Java struct (which cannot be
%                   build dynamically at run-time). Most template constructs behave
%                   exactly as it would for real Java struct objects - with the important
%                   exception of an iteration. <obj:handleIt()> would pass the entire obj
%                   to the sub template handleIt if obj is a real Java struct but will
%                   iterate all keys of the map in case obj is a map; handleIt will be
%                   called repeatedly, once for each key. Since we use the map as a model
%                   of the Octave struct it means that the expression effectively is an
%                   iteration along all fields of the original Octave struct. This makes it
%                   difficult if not impossible to have templates operating on arrays of
%                   Octave structs. (While cell arrays of Octave structs are less
%                   critical.)
%                     Two dimensional arrays are modeled as an ArrayList of rows, where
%                   each row is an ArrayList in turn. Here, we encounter a problem if the
%                   data can have arbitrary size. If a particular 2-d data set has a size
%                   of 1xn or nx1 then the wrapper can't recognize any more that this is
%                   meant a two dimensional array and will wrap it as a 1-d vector. It
%                   depends on the kind of data if a template written for the 2-d data
%                   model will fail or not. It'll fail with struct objects (wrapped as Java
%                   Map) but will likely succeed with many other objects. This is exactly
%                   the same problem as discussed for 1-d arrays of struct objects but now
%                   cell arrays are affected, too. Work arounds:
%                     - Strictly avoid the sizes 1xn and nx1 for 2-d data
%                     - Use 1-d cell arrays of 1-d cell arrays rather than 2-d cell arrays
%                       already in your data model. This way you can safely model even
%                       matrices of higher dimensions
%                     - Wrap the data already in the client code of this function. Consider
%                       to use the Octave function javaArray to do so. Your Java data
%                       object would not be modified by this function. It doesn't matter if
%                       this Java object becomes a StringTemplate template attribute on its
%                       own or if it is located somewhere inside your larger Octave data
%                       object
%                     The elements of (cell) arrays and the fields of structs are processed
%                   recursively in the same way until the scalar elements are reached.
%                   These can be the basic data types or self-modeled Java objects.
%                     More structures of Octave data are not considered. Particularly, you
%                   must not try to pass Octave objects to this wrapper. Unsupported data
%                   will be reported by exception. You need to keep your data interface to
%                   the StringTemplate engine simple, restrict your data design to the
%                   described elements.
%   Exceptions(s):
%                   All kind of errors are reported by exception. In particular, an error
%                   is thrown if the StringTemplate V4 libraries can't be located (Java
%                   CLASSPATH issue), if a template file is not found or if the ST4 engine
%                   recognizes an error during template expansion.
%
%                   Unsupported data types, which do not fit into the data model of the
%                   wrapper are reported by exception (see above, Limitations).
%
%                   Note, exception throwing is not affected by argument verbose. Setting
%                   verbose above error or fatal will not hinder any thrown error.
%
%   Return argument(s):
%       returnValue Expanded template text
%
%   Example(s):
%       st4addpath
%       st4javaaddpath
%       text = st4Render('helloWorld.stg', 'myHelloWorldTemplate', 'greeting', 'Hello', 'name', 'World')
%       text = st4Render('helloWorld.stg', 'myHelloWorldLstTemplate', 'greeting', 'Hello', 'nameList', {'World', 'Anna', 'Tom', 'Terence Parr'})
%
%   Copyright (C) 2015-2018 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU Lesser General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or any later
%   version.
%  
%   This program is distributed in the hope that it will be useful, but WITHOUT
%   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%   FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
%   for more details.
%  
%   You should have received a copy of the GNU Lesser General Public License
%   along with this program. If not, see <http://www.gnu.org/licenses/>.

    assert(nargin >= 1, 'Too few input arguments')

    % Flag verbose is optional. We recognize its presence from the data type. If it isn't
    % then the the further arguments are shifted. Reorder them here to have more meaningful
    % program code down here.
    %   verbose used to be a Boolean flag, which enabled lots of output. Later a numeric
    % value was introduced and the former Boolean true was mapped on the highest verbosity
    % level. An extract from the numeric scale:
    verboseINFO  = 4; % default
    verboseDEBUG = 5; % or verbose=true
    if nargin >= 2
        if islogical(verbose)
            persistent warningVerboseDone
            if isempty(warningVerboseDone)
                warning(['st4Render: The Boolean type argument verbose is deprecated' ...
                         ' and may be dropped in a future release. Please consider' ...
                         ' using the numeric designation in the range 0 (OFF) till' ...
                         ' 5 (DEBUG)'] ...
                       )
                warningVerboseDone = true;
            end
            if verbose
                verbose = verboseDEBUG;
            else
                verbose = verboseINFO;
            end
        elseif ~isnumeric(verbose)
            % verbose is not present and the right hand side needs a shift.
            if nargin >= 3
                % TODO This should fail in case of a 2-column-table as input
                varargin = [{templateName} varargin];
            end
            templateName = verbose;
            verbose = verboseINFO;
        end
    else
        % verbose is not present, use default.
        verbose = verboseINFO;
    end    
    assert(ischar(templateGroupFileName), 'First argument is of type string')

    % Special call: Should we clear the cache of template group files and return?
    info.doClearCache = nargin <= 2  &&  strcmp(templateGroupFileName, 'clear');
    persistent warningClearCache
    if info.doClearCache && isempty(warningClearCache)
            warning(['st4Render: Deleting the contents of the cache for template group' ...
                     ' files with the call st4Render(''clear'') is deprecated and may be' ...
                     ' dropped in a future release. Please consider using the equivalent' ...
                     ' call of st4ClearTemplateCache.'] ...
                   )
        warningClearCache = true;
    end
    
    % Call the actual rendering function.
    info.outputFileName = [];
    templateDesc.verbose = verbose;
    if ~info.doClearCache
        templateDesc.templateGroupFileName = templateGroupFileName;
        templateDesc.templateName = templateName;
        text = render(info, templateDesc, varargin);
    else
        templateDesc.templateGroupFileName = '';
        templateDesc.templateName = '';
        if nargout >= 1
            text = render(info, templateDesc, varargin);
        end
    end
end % of function st4Render.
