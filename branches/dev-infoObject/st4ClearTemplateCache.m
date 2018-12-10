function st4ClearTemplateCache

%   st4ClearTemplateCache() - the functions st4Render and st4RenderWrite apply a cache for
%                   already loaded and used templates in order to not reload and re-parse
%                   them repeatedly in the common use case of iterative, programmatic use
%                   of the functions (particularly st4Render). During template development
%                   and maintenance this cache is most hindering since template changes are
%                   not considered by the rendering process. During this phase (or always
%                   if repeated use of a template is not the intention) the repeated call
%                   of the rendering functions can be preceded by a single call of this
%                   function in order to delete the cache contents. The next reference to
%                   any template group file will force loading and parsing the file.
%                     Note, the call of this function is equivalent to st4Render('clear')
%                   but the latter is deprecated and may not be supported by a future
%                   version of st4Render.
%                   
%   Input argument(s):
%
%   Return argument(s):
%
%   Exceptions(s):
%                   This function doesn't throw exceptions
%   Example(s):
%       st4ClearTemplateCache
%       text = st4Render('helloWorld.stg', 'myHelloWorldTemplate', 'greeting', 'Hello', 'name', 'World')
%
%   Copyright (C) 2018 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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

    info.doClearCache = true;
    info.outputFileName = [];
    templateDesc.verbose = 4;
    templateDesc.templateGroupFileName = '';
    templateDesc.templateName = '';
    render(info, templateDesc);

end % of function st4ClearTemplateCache.


