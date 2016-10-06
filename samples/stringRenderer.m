%   stringRenderer - Test and demonstrate the StringTemplate V4 String renderer
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
st4Render('clear');

% Select the template that makes use of a String renderer.
tmplFile = [pwd '/testStringRenderer.stg']
tmpl = 'renderString'

% Render a simple string.
myString = 'hello World' 
text = st4Render(tmplFile, false, tmpl, 's', myString)

% Render a string with special characters, which are critical in XML/HTML.
myString = 'Rock & Roll' 
text = st4Render(tmplFile, false, tmpl, 's', myString)

% More special characters, which normally require storage as utf-8.
myString = 'Germans like Rock & Roll and Umlaute: �������' 
text = st4Render(tmplFile, false, tmpl, 's', myString)

% Generate HTML
myString = 'Germans like Rock & Roll and Umlaute: �������'
HTML = st4Render(tmplFile, false, 'html', 's', myString);
fid = fopen('stringRenderer.html', 'wt');
if fid >= 0
    fwrite(fid, HTML);
    fclose(fid);
    system('stringRenderer.html', false, 'async');
end


