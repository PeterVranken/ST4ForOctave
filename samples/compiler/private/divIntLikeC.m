function [c] = divIntLikeC(a, b)

%   divIntLikeC() - Integer division, which behaves as C and which behaves identical in
%                   Octave and MATLAB. Unfortunately, the Octave command idivide is not
%                   identical in behavior with MATLAB, and both behave different to C. We
%                   need some conditionals to make them all behave identical.
%                     For Octave, it depends on the version; elder versions didn't show the
%                   difference between Octave and MATLAB.
%                     All four combinations of signs need to be considered. C rounds
%                   towards zero in all cases.
%                     Example: idivide(int64(-9), int64(-4), 'fix')
%                     MATLAB 2021b: 2
%                     Octave 7.1.0: 3
%                     C: 2
%                     Using rounding 'floor' will differ with another combination of signs.
%                   
%   Input argument(s):
%       a           First operand of type int64
%       b           Second operand of type int64
%
%   Return argument(s):
%       c           Inter division result for a/b as it would be yielded in langauge C,
%                   rounded towards zero.
%                     Caution, the returned result is not perfectly identical to language
%                   C. Octave and MATLAB deal very differently with overflows and this is
%                   not equalized by this function. For large numbers, the function return
%                   value will differ from C.
%
%   Exceptions(s):
%                   This function doesn't throw exceptions
%   Example(s):
%       assert(divIntLikeC(9,4) == 2);
%       assert(divIntLikeC(-9,4) == -2);
%       assert(divIntLikeC(-9,-4) == 2);
%       assert(divIntLikeC(9,-4) == -2);
%
%   Copyright (C) 2023 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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
    noPar = 2;

    % Number of optional parameters.
    noOptPar = 0;

    error(nargchk(noPar, noPar+noOptPar, nargin));

%    % Set the optional parameter values.
%    noPar = noPar + 1;
%    if nargin < noPar
%        optPar1 = ;
%    end

    if a*b >= 0
        c = idivide(a, b, 'floor');
    else
        c = idivide(a, b, 'ceil');
    end
end % of function divIntLikeC.
