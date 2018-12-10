%   numberRenderer - Test and demonstrate the StringTemplate V4 Number renderer
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

% Force reloading of template files. This is useful for a program under development, when
% you still modify the templates frequently.
st4ClearTemplateCache

% Select the template that makes use of a Number renderer.
tmplFile = 'testNumberRenderer.stg';

% Render a floating point number.
disp('Now rending the floating point number pi using floating point formatting (%f):')
text = st4Render(tmplFile, 'renderFPN', 'x', pi)

disp('Now using the same template to render the number 31415:')
text = st4Render(tmplFile, 'renderFPN', 'x', 31415)

disp('Now using integer number formatting (%d) to render the integer number 31415927:')
text = st4Render(tmplFile, 'renderInt', 'd', uint32(31415927))

disp('Now using integer number formatting (%d) to render the integer number -31415927:')
text = st4Render(tmplFile, 'renderInt', 'd', int32(-31415927))

% The ST renders look at the data type of the rendered object. This depends on the script
% code here and how the data is passed on through to the StringTemplate engine. This
% requires dedicated tests for all numeric types:
n8 = exp(1)*10;
n16 = n8*100;
n32 = n16*10000;
n64 = n32*1000000000;
text = ['int8: '   st4Render(tmplFile, 'testIntRendering', 'd', int8(n8)) ...
        'uint8: '  st4Render(tmplFile, 'testIntRendering', 'd', uint8(n8)) ...
        'int16: '  st4Render(tmplFile, 'testIntRendering', 'd', int16(n16)) ...
        'uint16: ' st4Render(tmplFile, 'testIntRendering', 'd', uint16(n16)) ...
        'int32: '  st4Render(tmplFile, 'testIntRendering', 'd', int32(n32)) ...
        'uint32: ' st4Render(tmplFile, 'testIntRendering', 'd', uint32(n32)) ...
        'int64: '  st4Render(tmplFile, 'testIntRendering', 'd', int64(n64)) ...
        'uint64: ' st4Render(tmplFile, 'testIntRendering', 'd', uint64(n64)) ...
       ]

% If we consider Booleans as a kind of numbers then we can put some related tests here. We
% expect the interface to propagate Boolean information such that the logical template
% expression can operate on them.
n = 12;
isPos = true;
isLarge = n > 10000;
isHuge = logical(0);
text = st4Render( tmplFile ...
                , 'testBoolean' ...
                , 'bPos', isPos ...
                , 'bLarge', isLarge ...
                , 'bHuge', isHuge ...
                , 'n', n ...
                )
n = 12000;
isPos = logical(1);
isLarge = n > 10000;
isHuge = false;
text = st4Render( tmplFile ...
                , 'testBoolean' ...
                , 'bPos', isPos ...
                , 'bLarge', isLarge ...
                , 'bHuge', isHuge ...
                , 'n', n ...
                )
n = -12000;
isPos = n >= 0;
isLarge = abs(n) > 10000;
isHuge = n < -1e6;
text = st4Render( tmplFile ...
                , 'testBoolean' ...
                , 'bPos', isPos ...
                , 'bLarge', isLarge ...
                , 'bHuge', isHuge ...
                , 'n', n ...
                )
n = -12000e3;
isPos = n >= 0;
isLarge = abs(n) > 10000;
isHuge = n < -1e6;
text = st4Render( tmplFile ...
                , 'testBoolean' ...
                , 'bPos', isPos ...
                , 'bLarge', isLarge ...
                , 'bHuge', isHuge ...
                , 'n', n ...
                )
n = 12000e3;
isPos = n >= 0;
isLarge = abs(n) > 10000;
isHuge = abs(n) > -1e6;
text = st4Render( tmplFile ...
                , 'testBoolean' ...
                , 'bPos', isPos ...
                , 'bLarge', isLarge ...
                , 'bHuge', isHuge ...
                , 'n', n ...
                )
