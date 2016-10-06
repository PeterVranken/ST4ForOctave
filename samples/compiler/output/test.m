function [y x show cntLoops testOkay a b] = test(z, u)
% test:
%                   A simple test program for the compiler for our fictive computer language.
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
%       z, u
%                   These are the input variables of the compiled program. Input variables
%                   are considered all those variables, which are not at all assigned in
%                   the program.
%
%                   Use these variables to control your program.
%
%   Return argument(s):
%       y x show cntLoops testOkay a b
%                   All variables of the compiled program, which are assigned a value in
%                   the course of the program run, are considered outputs. All of these are
%                   returned by this Octave function that implements the compiled program.
%
%   Throws:
%                   No errors are thrown
%
%   Example(s):
%       [y x show cntLoops testOkay a b] = test(z, u)
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
    y = 0;
    x = 0;
    show = 0;
    cntLoops = 0;
    testOkay = 0;
    a = 0;
    b = 0;

    % A simple test program for the compiler for our fictive computer language.
    _R02 = y;
    _R02 = _R02 * -1;;
    _R01 = 23;
    _R01 = _R01 - _R02;;
    _R01 = _R01 == 0;;
    _R03 = z;
    _R03 = _R03 * -1;;
    _R02 = -7;
    _R02 = _R02 + _R03;;
    _R01 = _R01 * _R02;;
    _R00 = 6;
    _R00 = _R00 + _R01;;
    _R00 = _R00 + 0;;
    _R01 = x;
    _R01 = cmod(_R01, 23);
    _R00 = _R00 + _R01;;
    x = _R00;
    show = x;
    cntLoops = 0;
    _R00 = x;
    _R00 = _R00 < 0;;
    if _R00
        _R00 = x;
        _R00 = _R00 * -1;;
        x = _R00;
    end
    _R00 = x;
    _R00 = _R00 > 0;;
    _R01 = x;
    _R01 = _R01 == 0;;
    _R00 = _R00 || _R01;;
    testOkay = _R00;
    if testOkay
        x = 99;
    end
    while true
      % Since the loop itself doesn't have a condition will we always find
      % an if clause with break statement somewhere inside the loop
      _R00 = x;
      _R00 = _R00 == 0;;
      if _R00
          y = u;
          break
      else
          _R01 = x;
          _R01 = _R01 > 0;;
          _R00 = x;
          _R00 = _R00 - _R01;;
          x = _R00;
          _R00 = x;
          _R00 = _R00 <= 0;;
          if _R00
              break
          end
      end
      _R00 = cntLoops;
      _R00 = _R00 + 1;;
      cntLoops = _R00;
      _R00 = y;
      _R00 = _R00 + x;;
      y = _R00;
      % An empty if or else branch should be possible
      if testOkay
      else
          _R00 = x;
          _R00 = _R00 - 1;;
          x = _R00;
          _R00 = testOkay;
          _R00 = _R00 == 0;;
          testOkay = _R00;
      end
      _R00 = testOkay;
      _R00 = _R00 == 0;;
      if _R00
          _R00 = x;
          _R00 = _R00 - 1;;
          x = _R00;
          _R00 = testOkay;
          _R00 = _R00 == 0;;
          testOkay = _R00;
      end
      _R00 = x;
      _R00 = _R00 <= 0;;
      if _R00
          _R00 = x;
          _R00 = _R00 - 1;;
          x = _R00;
          testOkay = 0;
      end
      % Test all the operations. Operations on literals are evaluated at
      % compile time, operations with one variable at least are evaluated at
      % run time. We need to test both situations.
      a = 100;
      % Surely greater than x
      b = 0;
      % Surely less than x
      % Test of run time expressions
      _R01 = a;
      _R01 = _R01 || x;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = x;
      _R02 = _R02 == 0;;
      _R01 = a;
      _R01 = _R01 || _R02;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 == 0;;
      _R02 = x;
      _R02 = _R02 == 0;;
      _R01 = _R01 || _R02;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 == 0;;
      _R01 = _R01 || x;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 && b;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = b;
      _R02 = _R02 == 0;;
      _R01 = a;
      _R01 = _R01 && _R02;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 == 0;;
      _R01 = _R01 && b;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 == 0;;
      _R02 = b;
      _R02 = _R02 == 0;;
      _R01 = _R01 && _R02;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 + b;;
      _R01 = _R01 + 1;;
      _R01 = _R01 == 101;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 - a;;
      _R01 = _R01 == -100;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 - b;;
      _R02 = b;
      _R02 = _R02 - a;;
      _R02 = _R02 * -1;;
      _R01 = _R01 == _R02;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 * b;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = b;
      _R02 = _R02 + 12;;
      _R01 = a;
      _R01 = _R01 * _R02;;
      _R01 = _R01 == 1200;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = 12;
      _R01 = idivide(_R01, a);
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = 1300;
      _R01 = idivide(_R01, a);
      _R01 = _R01 == 13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = -1300;
      _R01 = idivide(_R01, a);
      _R01 = _R01 == -13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 * -1;;
      _R01 = -1300;
      _R01 = idivide(_R01, _R02);
      _R01 = _R01 == 13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 * -1;;
      _R01 = 1300;
      _R01 = idivide(_R01, _R02);
      _R01 = _R01 == -13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = idivide(_R01, 1300);
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = 1313;
      _R01 = cmod(_R01, a);
      _R01 = _R01 == 13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      % Sign of modulo is defined to be sign of first operand
      _R01 = -1313;
      _R01 = cmod(_R01, a);
      _R01 = _R01 == -13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 * -1;;
      _R01 = -1313;
      _R01 = cmod(_R01, _R02);
      _R01 = _R01 == -13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 * -1;;
      _R01 = 1313;
      _R01 = cmod(_R01, _R02);
      _R01 = _R01 == 13;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = 1300;
      _R01 = cmod(_R01, a);
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = cmod(_R01, 1300);
      _R01 = _R01 == a;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = cmod(_R01, 17);
      _R03 = a;
      _R03 = idivide(_R03, 17);
      _R02 = 17;
      _R02 = _R02 * _R03;;
      _R01 = _R01 + _R02;;
      _R01 = _R01 == a;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 < a;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 > a;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 == a;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 - 100;;
      _R01 = b;
      _R01 = _R01 == _R02;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 ~= a;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 - 100;;
      _R01 = b;
      _R01 = _R01 ~= _R02;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = b;
      _R01 = _R01 <= b;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = b;
      _R02 = _R02 + 1;;
      _R01 = b;
      _R01 = _R01 <= _R02;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = b;
      _R02 = _R02 - 1;;
      _R01 = b;
      _R01 = _R01 <= _R02;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R01 = a;
      _R01 = _R01 >= a;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 + 1;;
      _R01 = a;
      _R01 = _R01 >= _R02;;
      _R01 = _R01 == 0;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      _R02 = a;
      _R02 = _R02 - 1;;
      _R01 = a;
      _R01 = _R01 >= _R02;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      testOkay = _R00;
      % Test of compile time expressions. This is a single (assignment)
      % statement and you must not add a comment somewhere in the middle. In
      % our language definition a comment always is a separate statement.
      _R01 = 100;
      _R01 = _R01 || x;;
      _R01 = _R01 == 1;;
      _R00 = testOkay;
      _R00 = _R00 && _R01;;
      _R02 = x;
      _R02 = _R02 == 0;;
      _R01 = 100;
      _R01 = _R01 || _R02;;
      _R01 = _R01 == 1;;
      _R00 = _R00 && _R01;;
      _R02 = x;
      _R02 = _R02 == 0;;
      _R01 = 0;
      _R01 = _R01 || _R02;;
      _R01 = _R01 == 0;;
      _R00 = _R00 && _R01;;
      _R01 = 0;
      _R01 = _R01 || x;;
      _R01 = _R01 == 1;;
      _R00 = _R00 && _R01;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      _R00 = _R00 && 1;;
      testOkay = _R00;

    end
    _R01 = cntLoops;
    _R01 = _R01 == 98;;
    _R00 = testOkay;
    _R00 = _R00 && _R01;;
    testOkay = _R00;
    % A final comment

end % of function mod.




function [remainder] = cmod(a, b)
% This function computes the remainder of a quotient with same sign definition as known for
% the language C.
    remainder = mod(abs(a), abs(b));
    if a < 0
        remainder = -remainder;
    end
end % cmod