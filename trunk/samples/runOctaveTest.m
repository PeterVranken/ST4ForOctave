%   runOctaveTest - Test and demonstrate the StringTemplate V4 interface
%                   capabilities
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

% Force reloading of template files.
st4Render('clear', true);

% Select root template file
%   Hint: Loading the file basically has a powerful searching behind. However, this is
% Java-like controlled by a classpath and not so easy to control from Octave. The best way
% to begin is to use absolute paths.
tFile=[pwd '\testSTGroup.stg']

% An ordinary flat template
text = st4Render(tFile, false, '/hello', 'greeting', 'Hello', 'name', 'world')
size(text)
class(text)
disp(['Greeting: ' text])
disp([char(10) char(10)])

% The expansion of an array or list
text = st4Render(tFile, false, '/list', 'l', {'x' 'y' 'foo'}');
disp(['List of strings: ' text])
text = st4Render(tFile, false, '/list', 'l', [1:50]);
disp(['List of numerals: ' text])
disp([char(10)])

% Passing in an object with public fields
constPi = javaObject('Struct');
fieldnames(constPi)
setfield(constPi, 'name', 'Pi');
setfield(constPi, 'value', 3.1415);
setfield(constPi, 'asInt', 3);
text = st4Render(tFile, false, '/struct', 's', constPi);
disp(['Java struct: ' text])
disp([char(10)])

% Passing a MATLAB struct.
nativeStruct = struct('Pi', pi, 'e', exp(1), 'inf', inf, 'NaN', NaN, 'name', 'nativeStruct');
text = st4Render(tFile, false, '/nativeStruct', 's', nativeStruct);
disp(['MATLAB struct: ' text])
disp([char(10) char(10)])

% Passing in an array of objects with public fields
constE = javaObject('Struct');
setfield(constE, 'name', 'e');
setfield(constE, 'value', exp(1));
setfield(constE, 'asInt', floor(getfield(constE, 'value')));
constF = javaObject('Struct');
setfield(constF, 'name', 'f');
setfield(constF, 'value', 4.66920);
setfield(constF, 'asInt', floor(getfield(constF, 'value')));
structAry = javaArray('Struct', 3);
structAry(1) = constE;
structAry(2) = constPi;
structAry(3) = constF;
class(structAry)
text = st4Render(tFile, false, '/structList', 'l', structAry);
disp(['List of Struct objects: ' char(10) text])
disp([char(10) char(10)])

% TODO Test case with interger vs. float types. Investigate/document problem with
% (u)int32. What about (u)int64?

structAry = nativeStruct;
structAry(2) = nativeStruct;
structAry(2).name = 'PI as integer';
structAry(2).Pi = uint16(3);
structAry(3) = nativeStruct;
structAry(3).Pi = int16(-3.14);
structAry(3).e = int16(exp([1 2 3 4; 0.1 0.2 0.3 0.4; 0.2 0.4 0.6 0.8]));
structAry(3).name = 'PI negative';
text = st4Render(tFile, false, '/genericDataStructure', 'd', structAry);
disp(['Recursive data structure:' char(10) text])

% Render the empty object and an array with empty elements.
text = st4Render(tFile, false, '/genericDataStructure', 'd', []);
disp(['[]:' char(10) text])
text = st4Render(tFile, false, '/genericDataStructure', 'd', {1 [] 2 [] 3 {} 4});
disp(['[..]:' char(10) text])
text = st4Render(tFile, false, '/genericDataStructure', 'd', NaN);
disp(['NaN:' char(10) text])
text = st4Render(tFile, false, '/genericDataStructure', 'd', inf);
disp(['inf:' char(10) text])
text = st4Render(tFile, false, '/genericDataStructure', 'd', [1 inf 2 NaN 3]);
disp(['[NaN ... inf]:' char(10) text])

