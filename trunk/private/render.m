function [text] = render(info, templateDesc, varargin)

%   st4Render() -   Render data under control of a StringTemplate V4 template group file.
%                     This is a private function of st4Render. It implements the actual
%                   behavior, while st4Render is the well documented interface function.
%                   Never call this functions directly, only call st4Render!
%                     For a description of behavior, limitations, function arguments and
%                   return value, please refer to st4Render.
%
%   Input argument(s):
%       info        A struct containing information about the rendering process, which is
%                   passed to the rendering process, i.e. to make it available to the
%                   template expressions.
%       templateDesc
%                   A struct, which contains the information about the template to use. It
%                   collects mainly the function arguments templateGroupFileName,
%                   templateName and verbose of st4Render
%       varargin    Pairs of names and values of template arguments (also known as
%                   "attributes"). The name of an attribute is a simple string. The
%                   attribute itself can either be a Java data structure or an Octave data
%                   object - with restrictions, see st4Render.
%                     The name/value pairs can either be a list of function arguments or a
%                   single function argument, which then is a cell array of name/value
%                   pairs. This cell array is either a linear list or a table of two
%                   columns; the first column holds attribute names, the second column
%                   holds the associated values.
%   Exceptions(s):
%                   All kind of errors are reported by exception. In particular, an error
%                   is thrown if the StringTemplate V4 libraries can't be located (Java
%                   CLASSPATH issue), if a template file is not found or if the ST4 engine
%                   recognizes an error during template expansion.
%
%   Return argument(s):
%       returnValue Expanded template text
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
    
    assert(nargin >= 2, 'Too few input arguments')
    
    % The numeric scale of argument verbose.
    %   Caution: These constants are used in sub-functions, too. There, they are locally
    % redefined (oops), so never make a change here.
    verboseOff   = 0;
    verboseFATAL = 1;
    verboseERROR = 2;
    verboseWARN  = 3;
    verboseINFO  = 4;
    verboseDEBUG = 5;
    assert( templateDesc.verbose >= 0  &&  templateDesc.verbose <= 5 ...
          , 'templateDesc.verbose needs to be in the range 0 (off) till 5 (DEBUG)' ...
          )

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

    % A cache of template group files - which should not be reloaded and parsed on every use.
    persistent mapOfTFilesByName
    if info.doClearCache
        mapOfTFilesByName = [];
        if nargout >= 1
            text = '';
        end
        if nargin > 1  && templateDesc.verbose == verboseDEBUG
            fprintf('st4Render: All cached ST4 group files are cleared from memory\n');
        end
        return
    end

    % Set verbosity level for template compilation and expansion messages and for template
    % emitted messages. It looks a bit crude to do this here as very first Java operations,
    % prior to have the related, message logging objects instantiated. The explanation is
    % the static character of the logger class. All objects use the one and only static
    % logger and by setting its level right here, we can be sure that it will be set even
    % for the very first actions of the ST4 library, when loading a group file.
    javaMethod('setLevel', 'info.SimpleLogger', templateDesc.verbose);
        
    if isempty(mapOfTFilesByName)
        mapOfTFilesByName = javaObject('java.util.HashMap');
    end
    key = canonicalizeFileName(templateDesc.templateGroupFileName);
    if mapOfTFilesByName.containsKey(key)
        stg = mapOfTFilesByName.get(key);
        assert(~isempty(stg) && isa(stg, 'org.stringtemplate.v4.STGroupFile'));
        
        % The error listener including the initial error counter are still element of the
        % cached group file object. We can reuse them (save their creation time, too) but
        % need to reset the counters in this case.
        errCnt = stg.getListener().getErrorCounter();
        errCnt.reset();

        % Adjust verbosity of the existing group file object for this run of the function.
        %   Caution: true/false is not accepted although the Java type of the field is
        % boolean.
        if templateDesc.verbose == verboseDEBUG
            setfield(stg, 'verbose', 1);
        else
            setfield(stg, 'verbose', 0);
        end

        if templateDesc.verbose == verboseDEBUG
            fprintf( 'st4Render: ST4 group file object is reused for file %s\n'     ...
                   , templateDesc.templateGroupFileName                             ...
                   );
        end
    else
        try
            if templateDesc.verbose == verboseDEBUG
                fprintf( 'st4Render: ST4 group file object is created for file %s\n'    ...
                       , templateDesc.templateGroupFileName                             ...
                       );
            end
            
            % Here we have severe problem. ST4 promises to search for group file throughout
            % the Java CLASSPATH. This has however always been a pain in this Octave
            % interface and recent experiments seem to prove that it is simply not working
            % in this environment. ST4 seems to find a file with relative path but then it
            % tries loading the file with prepended path p, where p is not the matching
            % path from the CLASSPATH but the startup path of the Octave application (and
            % not the current working directory if CDs have been issued meanwhile). Since
            % we don't want to debug and change the ST4 library we use the Octave search
            % path a kind of work around. This is ugly as it means a significant change of
            % behavior for the ST4 library, which needs to be clearly documented.
            %stg = javaObject( 'org.stringtemplate.v4.STGroupFile' ...
            %                , templateDesc.templateGroupFileName ...
            %                );
            stg = javaObject( 'org.stringtemplate.v4.STGroupFile' ...
                            , findFile(templateDesc.templateGroupFileName) ...
                            );
            
            % Consider to be verbose with template loading process.
            %   Caution: true/false is not accepted although the Java type of the field is
            % boolean.
            if templateDesc.verbose == verboseDEBUG
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
                   findFile(templateDesc.templateGroupFileName) '. Either' ...
                   ' the file or one of the template files it imports or the' ...
                   ' StringTemplate V4 Java library is not accessible. The most probable' ...
                   ' reason is either the Octave path or the Java CLASSPATH not' ...
                   ' being set appropriately.' char(10) ...
                   '   Type ''help addpath'' and ''help savepath'' to see how to' ...
                   ' modify the Octave search path. Add all directories containing' ...
                   ' your ST4 template files to the Octave search path.' char(10) ...
                   '   Please refer to' ...
                   ' https://octave.org/doc/v5.2.0/Making-Java-Classes-Available.html#' ...
                   'Making-Java-Classes-Available' ...
                   ' to find out how to set the Java CLASSPATH. The ST4 libraries' ...
                   ' antlr-4.8-complete.jar (containing StringTemplate V4.3) and' ...
                   ' ST4ForOctave-1.0.jar are found in a sub-directory' ...
                   ' of this Octave script. Add these files to the Java CLASSPATH.' char(10)...
                   '   Restart Octave. Exception caught: ' char(10) ...
                   exc.message] ...
                 );
        end
    end

    % Pick the template to be applied from the group.
    if stg.isDefined(templateDesc.templateName)
        st = stg.getInstanceOf(templateDesc.templateName);
        assert(~isempty(st), 'Template not defined');
    else
        error(['Template ' templateDesc.templateName ...
               ' is not defined in template group file ' ...
               templateDesc.templateGroupFileName] ...
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
        % templates will have such an attribute and we can only add it conditionally.
        % Moreover, 'info' is a quite common designation and if the user already uesed it,
        % we must not override his decision.
        if strcmpi(name, 'info')
            addInfoObject = false;
        end
        
        % A template argument named wrapColumn requires special handling: It's not
        % considered a template argument but an argument of the template rendering process.
        %   TODO This should rather be an element of the info struct but how to get the
        % input from the user? Is it worth an explicit function argument?
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
        attributeObj = octave2Java(value, templateDesc.verbose);
        try
            st.add(name, attributeObj);
        catch exc
            msg = ['Failed to add attribute ' name ' to template ' ...
                  templateDesc.templateName ' of template group file ' ...
                  templateDesc.templateGroupFileName '. Most likely, the template' ...
                  ' doesn''t name such an attribute in its argument list. Caught' ... 
                  ' exception:' char(10) ...
                  exc.message];
            error(msg);
        end
    end

    % We try adding our info object if the user didn't claim an attribute of this name.
    if addInfoObject
        % Create an info object. This is a Java implemented service class. Instantiation
        % can fail, e.g. due to a bad Java CLASSPATH. These kinds of errors are reported to
        % the user as an exception.
        try
            infoObj = javaObject('info.Info', errCnt);
        catch exc
            error(['Java service object info.Info can''t be instantiated. Most probable' ...
                   ' cause is a badly defined Java CLASSPATH. Exception caught:' char(10) ...
                   exc.message] ...
                 );
        end

        % Propagate file names and alike to the template expansion process.
        infoObj.setTemplateInfo( templateDesc.templateGroupFileName ...
                               , templateDesc.templateName ...
                               , 'info' ... % templateArgInfo
                               , wrapCol ...
                               );
                            
        % Propagate the file name of the generated output file to the template expansion
        % process (if any).
        if ~isempty(info.outputFileName)
            infoObj.setOutputInfo(info.outputFileName);
        end

        % There's no obvious way to find out beforehand whether the template has an
        % attribute of name info. Try and error is the concept.
        try
            st.add('info', infoObj);
            if templateDesc.verbose >= verboseDEBUG
                fprintf( 'st4Render: Service object ''info'' is passed to template %s\n' ...
                       , templateDesc.templateName ...
                       );
            end
        catch
            if templateDesc.verbose >= verboseDEBUG
                fprintf(['st4Render: Template %s doesn''t accept an' ...
                         ' attribute ''info''. No such service object is offered\n'] ...
                       , templateDesc.templateName ...
                       );
            end
        end
    end % if Do we need to create a service object infoObj?
    
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
        minReportingLvl = verboseDEBUG;
    end
    if templateDesc.verbose >= minReportingLvl
        fprintf(['Template %s has been rendered with %d errors and %d warnings\n'] ...
               , templateDesc.templateName ...
               , errCnt.getNoErrors() ...
               , errCnt.getNoWarnings() ...
               );
    end
    
    % To be consistent with the rest of the user interface we need to throw an error if
    % there was one.
    if errCnt.getNoErrors() > 0
        error(['Rendering template ' templateDesc.templateName ' failed with ' ...
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



function absFileName = findFile(fileName)
% Apply the Octave search path to localize a file.
%   Return value absFileName:
% If a file fileName is found via the search path then this is the file designation with
% full, absolute path. Otherwise the value of fileName is returned, which is now considered
% still the best guess.
%   Parameter fileName:
% The file to look for. Can be any kind of relative or absolute file designation.

    % Look for the file. Octave returns a string, which is empty if no such file is found.
    absFileName = which(fileName);
    
    % TODO MATLAB would return a cell array in case of several matches (TBC: only with -all?)
    if iscell(absFileName) && length(absFileName) >= 1
        absFileName = absFileName{1};
    end
    
    % The function mainly aims at locating ST4 group files. If Octave can't find a group
    % file then we better proceed with the original file designation: ST4 will fail, too,
    % but will emit the more meaningful error message.
    if isempty(absFileName)
        absFileName = fileName;
    end
end % of function findFile



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

    verboseWARN  = 3;
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
            %   TODO Things have changed in more recent MATLAB revisions. It now supports
            % the new class "string". If we pass the key as string then it no longer
            % matters, whether it is of length 1 or more. And we can prove the elder
            % statements: If we put a key 'c' into the map, it can't be retrieved with "c".
            % (But another pair can be put into the map using "c" as key.) If we put key
            % 'cc' into the map it can be retrieved with "cc". So, when using the old
            % string representation [char] then MATLAB decides for the Java class of the
            % key by length. We could now support the TreeMap (and remove the warning
            % below) if we unconditionally cast the key to MATLAB's new string type.
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






