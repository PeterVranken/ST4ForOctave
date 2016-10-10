function runCompiler(program, openCode)

%   runCompiler() - Run the compiler sample; the source code is compiled for all supported
%                   targets, the generated code can be presented in Octave's text editor
%                   and -- for the representation of the compiled program in language C --
%                   the generated code can be compiled to an executable.
%                     Compilation into an executable requires the availability of GCC and
%                   has been tested only with GCC 4.9.3 on a Windows 7 system.
%                     All produced files are placed in folder ./output.
%                     This is just a simple wrapper of some underlaying Octave commands. It
%                   has no elaborated error handling and will simply abort in case of
%                   errors.
%
%   Input argument(s):
%       program     The name of the program to compile. Note, this is not the file name:
%                   the source file is expected in this directory and its file name is
%                   composed as ['./' program '.fcl']
%       openCode    Boolean option to present the generated, compiled code in Octave's
%                   editor. Optional, default is false
%
%   Return argument(s):
%
%   Example(s):
%       runCompiler('test', true)
%       runCompiler('euclid', true)
%
%   Copyright (C) 2016 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%
%   This program is distributed in the hope that it will be useful, but
%   WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
%   General Public License for more details.
%
%   You should have received a copy of the GNU General Public License along
%   with this program. If not, see <http://www.gnu.org/licenses/>.

    % Number of mandatory parameters.
    noPar = 1;

    % Number of optional parameters.
    noOptPar = 1;

    error(nargchk(noPar, noPar+noOptPar, nargin));

    % Set the optional parameter values.
    noPar = noPar + 1;
    if nargin < noPar
        openCode = false;
    end

    % Adjust the general Octave search path for scripts and other files. It doesn't matter if
    % the paths were already configured.
    [here] = fileparts(mfilename('fullpath'));
    addpath(fullfile(here, '../..'));
    addpath(fullfile(here, 'output'));

    % Adjust Java class path. It doesn't matter if the paths were already configured.
    % Find the StringTemplate template engine.
    javaaddpath(fullfile(here, '../../StringTemplate/ST-4.0.8.jar'));
    % Find the template group files.
    javaaddpath(fullfile(here, 'templates'));
    %disp('Java class path:')
    %javaclasspath

    % Run the compiler to implement the program as Octave script.
    targetFile = fullfile('output', [program '.m']);
    [success msg] = compiler(targetFile, [program '.fcl']);
    if ~success
        return
    end

    % Open the generated code?
    if openCode
        edit(targetFile)
    end

    % Run the compiler a second time to compile the program in pseudo assembler, wrapped in C.
    targetFile = fullfile('output', [program '.c']);
    [success msg p] = compiler(targetFile, [program '.fcl']);
    if ~success
        return
    end

    % Open the generated code?
    if openCode
        edit(targetFile)
    end

    % Compile the code under the assumption that GCC is installed.
    executable = fullfile('output', [program '.exe']);
    listing = fullfile('output', [program '.lst']);
    cmdLine = ['gcc -DDEBUG -o ' executable ' -mavx -Wa,-a=' listing ' -ggdb3 -O0 ' targetFile]
    system(cmdLine);
    ls output

end % of function runCompiler.
