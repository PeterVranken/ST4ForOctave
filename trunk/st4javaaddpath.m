function st4javaaddpath

%   st4javaaddpath() - Extend the Java classpath of the current Octave session such that
%                   the StringTemplate V4 interface and its samples are running well.
%                     If you didn't set your Java CLASSPATH statically (see
%                   https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html
%                   for details) then you should call this function once after starting your
%                   Octave session but prior to using any of the ST4 functions.
%                     Note, you will first have to add the installation directory of the
%                   ST4 interface to your normal Octave search path. In Octave, type: "help
%                   addpath" to get more information.
%                   
%   Input argument(s): (none)
%
%   Return argument(s): (none)
%
%   Example(s):
%       javaclasspath
%       st4javaaddpath
%       javaclasspath
%
%   Copyright (C) 2018 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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
    javaaddpath([installDirOfST4InterfaceForOctave '\StringTemplate\ST-4.0.8.jar']);
    javaaddpath([installDirOfST4InterfaceForOctave '\StringTemplate\ST4ForOctave-1.0.jar']);

end % of function st4javaaddpath.


