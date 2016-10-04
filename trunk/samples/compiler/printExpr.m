function [txt] = printExpr(expr)

%   printExpr() - Debug function: Display a parsed expression recursively.
%
%   Input argument(s):
%       expr        The parsed expression object.
%
%   Return argument(s):
%       txt         The expression as string.
%
%   Example(s):
%       txt = printExpr(expr)
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
    noOptPar = 0;

    error(nargchk(noPar, noPar+noOptPar, nargin));

    if ~isempty(expr.number)
        txt = num2str(expr.number);
    elseif ~isempty(expr.variable)
        txt = expr.variable;
    else
        txt = ['(' printExpr(expr.leftExpr) ' '];
        switch expr.operation
        case 'or'
            txt(end+1) = '|';
        case 'and'
            txt(end+1) = '&';
        case 'add'
            txt(end+1) = '+';
        case 'sub'
            txt(end+1) = '-';
        case 'mul'
            txt(end+1) = '*';
        case 'div'
            txt(end+1) = '/';
        case 'eq'
            txt(end+1) = '=';
        case 'neq'
            txt = [txt '<>'];
        case 'lt'
            txt(end+1) = '<';
        case 'leq'
            txt = [txt '<='];
        case 'gt'
            txt(end+1) = '>';
        case 'geq'
            txt = [txt '>='];
        case 'mod'
            txt(end+1) = '%';
        otherwise
            txt = [txt '???'];
        end
        if ~isempty(expr.depth)
            txt = [txt '[' num2str(expr.depth) ']'];
        end
        txt = [txt ' ' printExpr(expr.rightExpr) ')'];
    end
end % of function printExpr.


