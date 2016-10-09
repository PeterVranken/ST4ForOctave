% Adjust the general Octave search path for scripts and other files. It doesn't matter if
% the paths were already configured.
[here] = fileparts(mfilename('fullpath'));
addpath(fullfile(here, '..'));

% Adjust Java class path. It doesn't matter if the paths were already configured.
% Find the StringTemplate template engine.
javaaddpath(fullfile(here, '../StringTemplate/ST-4.0.8.jar'));
% Find the template group files.
javaaddpath(here);
disp('Java class path:')
javaclasspath
