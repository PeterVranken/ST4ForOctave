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
%                   an exception when using java.util.TreeMap and fails to operate on keys
%                   with string length 1 when using HashMap. This has the ugly impact that
%                   structs, which have field names of length 1 are not processed correctly
%                   in the templates: These fields are obscured when trying the normal
%                   template expression; <struct.f> would be empty - although the fields
%                   are in the map: everything looks fine if doing the Map iteration
%                   <struct:{f|<f>=<struct.(f)>}>. Octave works fine.
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
%       varargin    Pair of strings with names and values of template arguments. Can either
%                   be a Java data structure or an Octave data object - with
%                   restrictions, see below.
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
%                   An error is thrown if the StringTemplate V4 library can't be located
%                   (Java CLASSPATH issue).
%
%                   Some template expansion errors are thrown, for example if the name of a
%                   template can't be resolved. This is mostly a consequential error; the
%                   internally used Java interface doesn't report a syntax error in the
%                   template file when reading the file (however the console output does
%                   do) but a later use of that template will likely be reported by a
%                   thrown error since the template doesn't exist in memory. This
%                   distinction barely makes a difference to the caller of this wrapper as
%                   it does both, template file reading and template expansion, one after
%                   another.
%
%                   Unsupported data types, which do not fit into the data model of the
%                   wrapper are reported by exception.
%
%                   Note, exception throwing is not affected by argument verbose. Setting
%                   verbose above error or fatal will not hinder any thrown error.
%
%   Return argument(s):
%       returnValue Expanded template text
%
%   Example(s):
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
    % value was introduced. The former Boolean true was mapped on the highest verbosity
    % level. The numeric scale is:
    verboseOff   = 0;
    verboseFATAL = 1;
    verboseERROR = 2;
    verboseWARN  = 3;
    verboseINFO  = 4; % default
    verboseDEBUG = 5; % or verbose=true
    if nargin >= 2
        if islogical(verbose)
            if verbose
                verbose = verboseDEBUG;
            else
                verbose = verboseINFO;
            end
        elseif isnumeric(verbose)
            assert( verbose >= 0  &&  verbose <= 5 ...
                  , 'verbose needs to be in the range 0 (off) till 5 (DEBUG)' ...
                  )
        else
            % verbose is not present and the right hand side needs a shift.
            if nargin >= 3
                varargin = [{templateName} varargin];
            end
            templateName = verbose;
            verbose = verboseINFO;
        end
    else
        % verbose is not present, use default.
        verbose = verboseINFO;
    end    

    % Support a real variable argument list or a single argument, which is a cell array of
    % attribute name/value pairs.
    if length(varargin) == 1  &&  iscell(varargin{1})
        varargin = varargin{1};
        % The name/value pairs can be a linear list or a table of two columns and as many
        % rows as there are attributes
        if size(varargin,2) == 2
            varargin = varargin.';
            varargin = varargin(:);
        end
    end
    
    assert(mod(length(varargin), 2) == 0, 'Require name/value pairs, a list of even length')
    assert(ischar(templateGroupFileName), 'First argument is of type string')

    % A cache of template group files - which should not be reloaded and parsed on every use.
    persistent mapOfTFilesByName
    if nargin <= 2  &&  strcmp(templateGroupFileName, 'clear')
        mapOfTFilesByName = [];
        if nargout >= 1
            text = '';
        end
        if nargin > 1  && verbose == verboseDEBUG
            fprintf('st4Render: All cached ST4 group files are cleared from memory\n');
        end
        return
    end

    assert(nargin >= 2)
    assert(ischar(templateName), 'Argument templateName is of type string')
    
    % Set verbosity level for template compilation and expansion messages and for template
    % emitted messages. It looks a bit crude to do this here as very first Java operations,
    % prior to have the related, message logging objects instantiated. The explanation is
    % the static character of the logger class. All objects use the one and only static
    % logger and by setting its level right here, we can be sure that it will be set even
    % for the very first actions of the ST4 library, when loading a group file.
    javaMethod('setLevel', 'info.SimpleLogger', verbose);
        
    if isempty(mapOfTFilesByName)
        mapOfTFilesByName = javaObject('java.util.HashMap');
    end
    key = canonicalizeFileName(templateGroupFileName);
    if mapOfTFilesByName.containsKey(key)
        stg = mapOfTFilesByName.get(key);
        assert(~isempty(stg) && isa(stg, 'org.stringtemplate.v4.STGroupFile'));
        
        % The error listener including the initial error counter are still element of the
        % cached group file object. We can reuse them (save their creation time, too) but
        % need to reset the counters in this case.
        errCnt = stg.getListener().getErrorCounter();
        errCnt.reset();

        if verbose == verboseDEBUG
            fprintf( 'st4Render: ST4 group file object is reused for file %s\n'     ...
                   , templateGroupFileName                                          ...
                   );
        end
    else
        try
            if verbose == verboseDEBUG
                fprintf( 'st4Render: ST4 group file object is created for file %s\n'    ...
                       , templateGroupFileName                                          ...
                       );
            end
            stg = javaObject('org.stringtemplate.v4.STGroupFile', templateGroupFileName);

            % Consider to be verbose with template loading process.
            %   Caution: true/false is not accepted although the Java type of the field is
            % boolean.
            if verbose == verboseDEBUG
                setfield(stg, 'verbose', 1);
            else
                setfield(stg, 'verbose', 0);
            end

            % We need an error reporting and an error counting object for the operation of
            % the ST4 library. Instantiation can fail, e.g. due to a bad Java CLASSPATH.
            % These kinds of errors are reported to the user as an exception.
            errCnt = javaObject('info.ErrorCounter');

            % Install an error listener so that the issues detected at template expansion
            % time are uniformly reported and counted in our error counter.
            st4ErrListener = javaObject('info.ST4ErrorListener', errCnt);
            stg.setListener(st4ErrListener);

            % TODO How to get a Java Class object of the abstract class Number? This would
            % save all the distinct assignments of the renderer.
            % TODO Why is java.lang.Byte not accepted? And indeed, Octave's int8/uint8
            % don't get supported by the renderer. As a work around we need to type cast
            % these numbers to at least 16 Bit (see below).
            numberRenderer = javaObject('org.stringtemplate.v4.NumberRenderer');
            for className = {'Double' 'Float' 'Integer' 'Long' 'Short'}
                className = className{1};
                stg.registerRenderer( javaMethod( 'getClass'                              ...
                                                , javaObject(['java.lang.' className], 0) ...
                                                )                                         ...
                                    , numberRenderer                                      ...
                                    );
            end
            stg.registerRenderer( javaMethod('getClass', javaObject('java.lang.String'))...
                                , javaObject('org.stringtemplate.v4.StringRenderer')    ...
                                );
            mapOfTFilesByName.put(key, stg);
        catch exc
            error(['Couldn''t open the StringTemplate V4 template group file ' ...
                   templateGroupFileName '. Either' ...
                   ' the file or the engine is not accessible. The most probable' ...
                   ' reason is the Java class path not being set appropriately. Please' ...
                   ' refer to' ...
                   ' https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html' ...
                   ' to find out how to set the class path. The ST4 library' ...
                   ' ST-4.0.8.jar is found in a sub-directory of this Octave script.' ...
                   ' Add this file and the directories containg your template files to' ...
                   ' the class path and restart Octave. Exception caught: ' char(10) ...
                   exc.message] ...
                 );
        end
    end

    % Pick the template to be applied from the group.
    if stg.isDefined(templateName)
        st = stg.getInstanceOf(templateName);
        assert(~isempty(st), 'Template not defined');
    else
        error(['Template ' templateName ' is not defined in template group file ' ...
               templateGroupFileName] ...
             );
    end

    % Add all pairs of template arguments in a loop.
    addInfoObject = true;
    wrapCol = 72;
    for i=1:2:length(varargin)
        name = varargin{i};
        value = varargin{i+1};

        % A template argument named info requires special handling: Normally, we add our
        % pre-defined Java info object as service function to a template. However, not all
        % templates will have such an attribute and we can only add it conditionally. Moreover,
        % 'info' is a quite common designation and if the user already uesed it, we must not
        % override his decision.
        if strcmpi(name, 'info')
            addInfoObject = false;
        end
        
        % A template argument named wrapColumn requires special handling: It's not
        % considered a template argument but an argument of the template rendering process.
        if strcmpi(name, 'wrapColumn')
            assert( isnumeric(value)  &&  value >= 1  &&  value == floor(value) ...
                  , 'wrapColumn is a positive integer' ...
                  );
            wrapCol = value;
        end
        
        % We bring the data element into a form, which can be handled by the Octave->Java
        % interface and which is compatible with the template engine. If the client code
        % has already done some Java wrapping of the template input data then the wrapper
        % function leaves this data unprocessed. Otherwise a transformation takes place
        % that yields either an Octave object, which we know to be handled properly by the
        % interface (like a normal floating point value) or a Java object created with
        % javaObject() (like a Java List or other collection object).
        st.add(name, octave2Java(value, verbose));
    end

    % We try adding our info object if the user didn't claim an attribute of this name.
    if addInfoObject
        % Create an info object. This is a Java implemented service class. Instantiation
        % can fail, e.g. due to a bad Java CLASSPATH. These kinds of errors are reported to
        % the user as an exception.
        try
            info = javaObject('info.Info', errCnt);
        catch exc
            error(['Java service object info.Info can''t be instantiated. Most probable' ...
                   ' cause is a badly defined Java CLASSPATH. Exception caught:' char(10) ...
                   exc.message] ...
                 );
        end

        % todo Consider publishing a version designation of st4Render rather than of info.Info? Or is it just the same?
        %info.setApplicationInfo( String appName
        %                       , int[] versionAry
        %                       , int verDataModel
        %                       )
        
        % Propagate file names and alike to the template expansion process.
        info.setTemplateInfo( templateGroupFileName ...
                            , templateName ...
                            , 'info' ... % tArgInfo
                            , wrapCol ...
                            );
                            
        % Propagate the file name of the generated output file to the template expansion
        % process (if any).
        %info.setOutputInfo(String fileName)
        
        % There's no obvious way to find out beforehand whether the template has an
        % attribute of name info. Try and error is the concept.
        try
            st.add('info', info);
            if verbose >= verboseDEBUG
                fprintf( 'st4Render: Service object ''info'' is passed to template %s\n' ...
                       , templateName ...
                       );
            end
        catch
            if verbose >= verboseINFO
                fprintf(['st4Render: Template %s doesn''t accept an' ...
                         ' attribute ''info''. No such service object is offered'] ...
                       , templateName
                       );
            end
        end
    end % if Do we need to create a service object info?
    
    %assignin('base', 'st', st);
    
    % Render the information using the template. Wrapping the lines of generated output
    % only relates to the rendering of multi-valued-arguments and can be switched off by
    % simply omitting this optional function argument.
    text = char(st.render(wrapCol));
    
    % The template expansion can produce errors, which are counted in our Java object.
    % Evaluate.
    if errCnt.getNoWarnings() > 0
        minReportingLvl = verboseWARN;
    elseif errCnt.getNoErrors() > 0
        minReportingLvl = verboseERROR;
    else
        minReportingLvl = verboseINFO;
    end
    if verbose >= minReportingLvl
        fprintf(['Template %s has been rendered with %d errors and %d warnings\n'] ...
               , templateName
               , errCnt.getNoErrors()
               , errCnt.getNoWarnings()
               );
    end
    
    % To be consistent with the rest of the user interface we need to throw an error if
    % there was one.
    if errCnt.getNoErrors() > 0
        error(['Rendering template ' templateName ' failed with ' ...
               num2str(errCnt.getNoErrors()) ' errors and ' num2str(errCnt.getNoWarnings()) ...
               ' warnings'] ...
             );
    end
end % of function st4Render.




%%
%% Return: true if the environment is Octave.
%% (This function has been downloaded from
%% https://www.gnu.org/software/octave/doc/v4.0.1/How-to-distinguish-between-Octave-and-Matlab_003f.html
%% on Sep 23, 2016.)
%%
function retval = isOctave
    persistent cacheval  % speeds up repeated calls

    if isempty(cacheval)
        cacheval = exist('OCTAVE_VERSION', 'builtin') > 0;
    end

    retval = cacheval;
end




function [canonicalizedfileName] = canonicalizeFileName(fileName)

% Return a unambiguous representation of a file designation.
%   Return value canonicalizedfileName:
% Get the unambiguous file name.
%   Parameter fileName:
% The file name to unambiguate.

    % No effective solution is known. fileparts with cd and pwd can be found as idea e.g.
    % at https://de.mathworks.com/matlabcentral/newsreader/view_thread/237707 (Sep 23,
    % 2016) but is expensive in in terms of run time and inappropriate. A solution is
    % however not essential, not having a canonicalized file name just means less cache
    % hits and higher likelihood of useless reparsing of ST4 files in the group file map.
    if isOctave
        % canonicalize_file_name will work only with existing files. It's not a string
        % operation just looking for and resolving patterns like . or .. The file names in
        % question are normally "non existing" in that they are not found via the Octave
        % search path but via the Java class path. Therefore the Octave function
        % canonicalize_file_name can't be applied.
        %canonicalizedfileName = canonicalize_file_name(fileName)
        canonicalizedfileName = fileName;
    else
        canonicalizedfileName = fileName;
    end
end % of function canonicalizeFileName.






function [st4Object] = octave2Java(value, verbose)

% Create a Java object, which is equivalent to a given Octave object and which only uses
% Java structural elements, which are compatible by the StringTemplate V4 engine.
%   Not all Octave data constructs can be transformed in a Java equivalent. The method
% throws an error on unsupported data types/structures.
%   Return value st4Object:
% The Java object, which can be passed as attribute value o the ST V4 trmplate engine.
%   Parameter value:
% The Octave object.
%   Parameter verbose:
% If equal to verboseDEBUG then the transformation is reported step by step. This can
% produce a lot of console output. Otherwise no output.

    verboseDEBUG = 5;

    % Data, which is already wrapped as Java object doesn't need further handling.
    if isjava(value)
        st4Object = value;
        return
    end 
    if isempty(value) && ~iscell(value) && ~isstruct(value)
        % We return the empty Octave object. This is not a Java null but will be translated
        % by the Octave->Java interface accordingly.
        st4Object = [];
        return
    end
    if length(size(value)) > 2
        % We only support two dimensional arrays. The appraoch could be made recursive to
        % support higher dimensions but no use case is visible.
        %   Remark: The restriction to two dimensions is arbitrary and only due to
        % usability. Only a few code location would require modification to recursively
        % support higher dimensions.
        error('Only scalar data elements or array of one or two dimensions are supported')
    end
    if isobject(value)
        % Although the old style objects (which are recognized by isobject) are quite
        % similar to structs in that they have fields, which can be processed by
        % introspection, is their handling not possible in a generic way. Fields might be
        % accessible only through dedicated methods, normal operation can be overloaded and
        % behave differently. All of this can easily lead to abnormal script termination
        % with barely understandable error messages. Better to abort immediately with a
        % simple and clear message.
        %   TODO How to recognize new style classes/objects to avoid the same kind of
        % problems with these?
        error(['Objects are not supported by the StringTemplate interface. Try to use an' ...
               ' ordinary struct instead'] ...
             );
    end
            
    % Octave's strings are formally arrays of characters. They must however not be
    % recognized as arrays by our algorithms since the Octave->Java interface handles
    % strings properly as integral entities - we definitly don't want to handle strings as
    % lists of single characters in the template expansion process.
    if ischar(value) &&  size(value,1) == 1
        st4Object = value;

    % The object to render can be a scalar object or a one or two dimensional array of
    % such. The latter requires a recursion with either a single element or a complete row
    % of such.
    %   ~iscell: A cell array of size 1x1 is retained as a list of one element in the ST4
    % representation. For most template operations this doesn't make any difference to a
    % scalar object but some subtle differences exist. For numerics and struct objects
    % Octave doesn't make a difference between scalar objects and vectors of length 1 so it
    % doesn't make any sense to try such a distinction in the ST4 representation.
    elseif ~iscell(value) && all(size(value) == [1 1])
        % Here the scalar objects are processed.

        % We support basic types and structs.
        if isstruct(value)
            % A struct has its natural representation in ST4 as a Java Map object.
            % Addressing to a map key, value pair uses the same syntax in an ST4 template
            % as addressing of a field in a true struct. (True structs are not available as
            % they require a pre-compiled Java class.) There are subtle differences between
            % Map and struct in ST4 but we have to accept that.
            %   TODO Here we see a subtle difference between Octave and its commercial
            % competitor MATLAB. MATLAB throws an error when using TreeMap as
            % implementation of the Java Map interface. HashMap works however well. The
            % error message indicates that this has to do with the handling of strings in
            % the Java interface. Strings of length one seem to be handled rather as Java
            % Character than as Java String. The TreeMap implementation fails in comparing
            % keys of differing type: A field name of length > 1 is a String, a fieldname
            % of length 1 is a Character and the order in the map can't be figured out.
            % However, it's not fully understood. If you use MATLAB you may change the data
            % type to HashMap. This is in almost all situations just the same, only when
            % iterating the fields of a struct in the ST4 template then you will yield
            % another order of appearance. Here the TreeMap has the advantage of a well
            % defined natural, lexical order.
            if isOctave
                st4Object = javaObject('java.util.TreeMap');
            else
                st4Object = javaObject('java.util.HashMap');
            end
            for fieldName = fieldnames(value).'
                fieldName = fieldName{1};
                % The MATLAB interface fails to put fields with names of length 1 properly
                % into the Map. The reason is unclear and Octave works fine. We issue a
                % warning. MATLAB users should avoid such short field names or only use the
                % Map iteration operator in the templates, which seems not affected.
                if ~isOctave &&  length(fieldName) == 1  &&  verbose >= verboseWARN
                    warning(['Fieldname ' fieldName ' found in a MATLAB struct, which is' ...
                             ' wrapped for StringTemplate V4. MATLAB has a problem with' ...
                             ' class Map in its Java interface. Field names of a' ...
                             ' single character aren''t correctly processed. They tend' ...
                             ' to be obscured when it comes to template expansion. You' ...
                             ' should either avoid field names of length one or solely' ...
                             ' use the Map iteration, which is not affected, in your' ...
                             ' templates'] ...
                           );
                end
                st4Object.put(fieldName, octave2Java(value.(fieldName), verbose));
            end
            if verbose == verboseDEBUG
                fprintf( 'st4Render: Java Map object looks like: %s\n'                  ...
                       , char(st4Object.toString())                                     ...
                       );
            end
        else
            % The data element is of a basic type. These are mostly supported as are by the
            % Octave->Java interface. We simply pass them to this interface.
            switch class(value)
            case {'int8' 'uint8'}
                % The eight Bit numbers are propagated as 16 to become java.lang.Short for
                % the template engine - otherwise the number renderer doesn't operate on
                % them.
                st4Object = int16(value);
            otherwise
                % As long as we don't see a problem we trust the Octave->Java interface to
                % handle the data type properly.
                st4Object = value;
            end
        end
    else
        % 1 or 2d arrays are represented as Java List objects of either single objects
        % or other Java List objects of such. This includes empty arrays with a size of zero
        % in at least one dimension. Those arrays are represented by an empty Java List
        % object. Octave knows sizes like 0x23, zero rows of 23 elements, but this can't be
        % represented in the ST4 template scope.
        st4Object = javaObject('java.util.ArrayList');

        % 2d arrays: We iterate along the rows and pack each row by recursion. To make the
        % recursion finite it is essential that any 1d array has one column with rows of
        % length 1. This means that we have to make a 1d array a column vector prior to the
        % iteration. It doesn't matter that we loose the orientation of the vector; once it
        % is packed as a Java List this quality is anyway no longer available. No ST4 list
        % operator makes a distinction about vertical or horizontal.
        if any(size(value) <= [1 1])
            value = value(:);
        end

        % Iterate along all rows of the array.
        %   For a 1d vector this means to iterate along the elements regardless whether it
        % is a horizontal or vertival vector.
        %   For a 0xn or nx0 array this means not to iterate any element. (value.' safely
        % has zero columns due to the preceding if clause.)
        for row = value.'
            if length(row) == 1
                if iscell(row)
                    % Here we get in case of 1d cell arrays. The ST4 representation should
                    % not be a List of Lists of length 1. This is confusing and useless. We
                    % eliminate the list character.
                    row = row{1};
                end
                % Here, row represents a scalar object.
            else
                % Here, row is a linear array. The recursion will return it as a single
                % ArrayList object.
                assert(length(row) > 1)
            end
            % This will properly add a Java null to the list if a cell array contains an
            % empty object.
            st4Object.add(octave2Java(row, verbose));
        end
        if verbose == verboseDEBUG
            fprintf( 'st4Render: Java ArrayList object looks like: %s\n'                ...
                   , char(st4Object.toString())                                         ...
                   );
        end
    end
    if verbose == verboseDEBUG
        if isOctave
            fprintf('st4Render: %s -> %s\n', disp(value), disp(st4Object));
        else
            % disp has not a return value in MATLAB.
            fprintf('st4Render: '); disp(value); fprintf(' -> '); disp(st4Object);
        end
    end
end % of function octave2Java.






