function st4RenderWrite( fileName               ...
                       , doAppend               ...
                       , templateGroupFileName  ...
                       , templateName           ...
                       , verbose                ...
                       , varargin               ...
                       )

%   st4RenderWrite() - This is a wrapper convenience function around st4Render. It calls
%                   st4Render and writes the returned text, the expanded templates,
%                   directly into a file. Please consult the help of st4Render for most of
%                   the details related to the template expansion: Most of the arguments of
%                   this wrapper function are simply passed on to the other function and
%                   they are explained there.
%                   
%   Input argument(s):
%       fileName    The name of the file to write the text got from template expansion
%                   into. If doAppend is false then the file is created or overwritten
%                   without confirmation
%       doAppend    If true then the text got from template expansion is appended to the
%                   contents of the already existing file
%       templateGroupFileName
%                   Name of template group file to use. See st4Render for details
%       templateName
%                   The entry-point template in the template group file. See st4Render for
%                   details
%       verbose     The verbosity of the process as an integer in the range from 0 (OFF) to
%                   5 (DEBUG). See st4Render for details, but note, in contrast to
%                   st4Render this argument is  not optional here
%       varargin    The list of template attribute, value pairs. See st4Render for details
%
%   Return argument(s):
%                   (none, all problems are reported by exception)
%
%   Exceptions(s):
%                   The function uses thrown errors in all cases of problems. Wrong
%                   template arrguments, errors inside a template, errors intentionally
%                   emmitted by templates, file I/O errors, all of this is reported by
%                   exception.
%                     Note, regardless of a thrown error, the template expansion process
%                   uses the standard output (i.e. Octave console) for printing all
%                   progress information, including warnings and errors. This process is
%                   implemented as an external Java process and redirecting its output into
%                   the Octave interpreter context is not possible.
%
%   Example(s):
%       st4RenderWrite('helloWorld.txt', false, 'helloWorld.stg', 'myHelloWorldTemplate', 5, 'greeting', 'Hello', 'name', 'World')
%       edit helloWorld.txt
%       st4RenderWrite('helloWorld.txt', true, 'helloWorld.stg', 'myHelloWorldLstTemplate', 4, 'greeting', 'Hello', 'nameList', {'World', 'Anna', 'Tom', 'Terence Parr'})
%       edit helloWorld.txt
%
%   Copyright (C) 2018-2020 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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

    % TODO Allow having verbose as string, too

    % Prepare the call of the actual rendering function.
    info.outputFileName = fileName;
    info.doClearCache = false;
    templateDesc.verbose = verbose;
    templateDesc.templateGroupFileName = templateGroupFileName;
    templateDesc.templateName = templateName;

    % Run the template expanion, get the text to write into file.
    fileContents = render(info, templateDesc, varargin);

    % Try creating the directory to the generated file. For Octave, it doesn't matter if
    % this path should already exist but MATLAB complains with an undesired warning.
    targetDir = fileparts(fileName);
    if ~isempty(targetDir)  &&  exist(targetDir, 'dir') ~= 7
        mkdir(targetDir);
    end

    % Write file. Although we have a text file we need to open the file binary: The
    % StringTemplate V4 engine already does do the EOL conversion.
    if doAppend
        mode = 'ab';
    else
        mode = 'wb';
    end
    [fid msg] = fopen(fileName, mode);
    if fid == -1
        error(['Can''t open output file ' fileName ' for writing. ' msg]);
    end
    [count] = fwrite(fid, fileContents);
    if count ~= length(fileContents)
        error(['Error writing output file ' fileName '. File may be unusable']);
    end
    if fclose(fid) == -1
        error(['Can''t close output file ' fileName '. File may be unusable']);
    end
end % of function st4RenderWrite.
