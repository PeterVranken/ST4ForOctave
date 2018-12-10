function [a b h] = euclid(i, j)
% euclid:
%                   Find the greatest common divisor of two integer numbers.
%
%                   This Octave script implements the program written in the fictive
%                   computer language. The structure of the compiler output resembles
%                   machine code as much as possible for this compilation target:
%                   Expression evaluation can be implemented as sequence of basic
%                   instructions but the program flow can't be resolved; equivalents to the
%                   jump and branch instructions of a machine instruction set aren't
%                   available and we still need structural language elements like loops and
%                   conditional clauses.
%
%                   The program can be run with variable values provided as function
%                   arguments, see below. All values are signed integers.
%
%   Input argument(s):
%       i, j
%                   These are the input variables of the compiled program. Input variables
%                   are considered all those variables, which are not at all assigned in
%                   the program.
%
%                   Use these variables to control your program.
%
%   Return argument(s):
%       a b h
%                   All variables of the compiled program, which are assigned a value in
%                   the course of the program run, are considered outputs. All of these are
%                   returned by this Octave function that implements the compiled program.
%
%   Throws:
%                   No errors are thrown
%
%   Example(s):
%       [a b h] = euclid(i, j)
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

    % List of initialized variables.
    a = 0;
    b = 0;
    h = 0;

    % Find the greatest common divisor of two integer numbers.
    % An implementation of Euclid's algorithm.
    % See http://de.wikipedia.org/wiki/Euklidischer_Algorithmus and particularly
    % http://de.wikipedia.org/wiki/Euklidischer_Algorithmus#Beschreibung_durch_Pseudocode
    % (visited on Mar 6, 2014) for details on Euclid's algorithm.
    % Inputs are i and j.
    a = i;
    b = j;
    while true
      _R00 = b;
      _R00 = _R00 == 0;;
      if _R00
          break
      end
      % h always has the sign of a.
      _R00 = a;
      _R00 = cmod(_R00, b);
      h = _R00;
      a = b;
      b = h;

    end
    % a holds the result.

end % of function mod.




function [remainder] = cmod(a, b)
% This function computes the remainder of a quotient with same sign definition as known for
% the language C.
    remainder = mod(abs(a), abs(b));
    if a < 0
        remainder = -remainder;
    end
end % cmod