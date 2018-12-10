function testST4RenderWrite

%   testST4RenderWrite() - Short demonstration and test of the user interface function
%                   st4RenderWrite. At the same time the first demonstration of the use of
%                   the service object info, which is provided to the ST4 templates since
%                   SVN revision 34.
%
%   Input argument(s):
%
%   Return argument(s):
%       returnValue The Octave function has no return value. The generated output can be
%                   found as files trw_testST4RenderWrite.c/h in the working directory.
%
%   Exceptions(s):
%                   All kinds of errors are reported by exception
%   Example(s):
%       testST4RenderWrite
%       edit output/trw_testST4RenderWrite.c
%       edit output/trw_testST4RenderWrite.h
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

    % To support the investigation of the sample (trying changes on the involved templates)
    % we clear the cache in every run of the test.
    st4ClearTemplateCache

    % Demonstrate a typical use case in C code generation: Enumerations. Automated C code
    % generation is typically involved if machine readable data sets are processed. The
    % data objects are either translated into initialized, constant data objects in C or
    % provided as enumerations.
    powersOfTwoAry = 2.^(0:31);
    enumColorAry = {'white', 'red', 'green', 'blue', 'purple', 'brown', 'grey', 'black'};

    % The library template mod.stg permitts overriding the default copyright notice:
    myCopyrightNotice = ...
      [' * Copyright (C) 2018 Whoever' char(10) ...
       ' *' char(10) ...
       ' * No rights reserved. Reproduction in whole or in part is permitted' char(10) ...
       ' * without the written consent of the copyright owner.' char(10) ...
      ];

    % Generate the C header file.
    st4RenderWrite( 'output/trw_testST4RenderWrite.h'   ... % fileName
                  , false                               ... % doAppend
                  , 'testST4RenderWrite.stg'            ... % templateGroupFileName
                  , 'testST4RenderWrite_h'              ... % templateName
                  , 4                                   ... % verbose, 4: INFO
                  , 'copyright', myCopyrightNotice ...
                  , 'powersOfTwo', powersOfTwoAry  ...
                  , 'enumColor', enumColorAry  ...
                  );
                  
    % Generate the C implementation file.
    st4RenderWrite( 'output/trw_testST4RenderWrite.c'   ... % fileName
                  , false                               ... % doAppend
                  , 'testST4RenderWrite.stg'            ... % templateGroupFileName
                  , 'testST4RenderWrite_c'              ... % templateName
                  , 4                                   ... % verbose, 4: INFO
                  , 'copyright', myCopyrightNotice ...
                  , 'powersOfTwo', powersOfTwoAry  ...
                  , 'enumColor', enumColorAry  ...
                  );
   
    disp(['Please find the generated files trw_testST4RenderWrite.c and' ...
          ' trw_testST4RenderWrite.h in directory output!'] ...
        );
end % of function testST4RenderWrite.


