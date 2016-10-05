program = 'test'

% Adjust Java class path. It doesn't matter if the paths were already configured.
[here] = fileparts(mfilename('fullpath'));
fullfile(here, '../../StringTemplate/ST-4.0.8.jar')
fullfile(here, 'templates')
% Find the StringTemplate template engine.
javaaddpath(fullfile(here, '../../StringTemplate/ST-4.0.8.jar'));
% Find the template group files.
javaaddpath(fullfile(here, 'templates'));
disp('Java class path:')
javaclasspath 

% Run the compiler.
targetFile = fullfile('output', [program '.c']);
executable = fullfile('output', [program '.exe']);
listing = fullfile('output', [program '.lst']);
[success msg p] = compiler(targetFile, [program '.fcl']);
if ~success
    return
end

% Open the generated code.
%edit(targetFile)

% Compile the code under the assumption that GCC is installed.
cmdLine = ['gcc -DDEBUG -o ' executable ' -mavx -Wa,-a=' listing ' -ggdb3 -O0 ' targetFile]
system(cmdLine)
ls output
