function st4addpath

%   st4addpath() - Extend the Octave search path of the current Octave session such that
%                   all scripts and samples belonging to the StringTemplate V4 interface
%                   are found. Note that this is not sufficient to successfully run scripts
%                   and samples, the Java CLASSPATH needs to be set, too. See
%                   st4javaaddpath for more.
%                   
%   Input argument(s): (none)
%
%   Return argument(s): (none)
%
%   Example(s):
%       path
%       st4addpath
%       path
%
%   Copyright (C) 2018-2023 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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

    installDirOfST4InterfaceForOctave = fileparts(mfilename('fullpath'));
    addpath( [installDirOfST4InterfaceForOctave ''] ...
           , [installDirOfST4InterfaceForOctave '\samples'] ...
           , [installDirOfST4InterfaceForOctave '\samples\templates'] ...
           , [installDirOfST4InterfaceForOctave '\samples\compiler'] ...
           , [installDirOfST4InterfaceForOctave '\samples\compiler\templates'] ...
           , [installDirOfST4InterfaceForOctave '\samples\compiler\output'] ...
           );

end % of function st4addpath.


