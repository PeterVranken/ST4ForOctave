program = 'test'

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
disp('Java class path:')
javaclasspath

% Run the compiler to implement the program as Octave script.
targetFile = fullfile('output', [program '.m']);
[success msg] = compiler(targetFile, [program '.fcl']);
if ~success
    return
end

% Open the generated code.
%edit(targetFile)

% Run the compiler a second time to compile the program in pseudo assembler, wrapped in C.
targetFile = fullfile('output', [program '.c']);
[success msg p] = compiler(targetFile, [program '.fcl']);
if ~success
    return
end

% Open the generated code.
%edit(targetFile)

% Compile the code under the assumption that GCC is installed.
executable = fullfile('output', [program '.exe']);
listing = fullfile('output', [program '.lst']);
cmdLine = ['gcc -DDEBUG -o ' executable ' -mavx -Wa,-a=' listing ' -ggdb3 -O0 ' targetFile]
system(cmdLine);
ls output
