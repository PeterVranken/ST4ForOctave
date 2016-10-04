function [success msg p] = compiler(programFile, sourceFile)

%   compiler() - This sample implements the compiler for a most simple demonstrative
%                   computer language. A handwritten parser is connected to a
%                   StringTemplate V4 backend. The use of a template engine permits easy
%                   configuration of different outpt formats; in our sample the compiler
%                   does a translation in a sequence of either simple C statements or
%                   simple M script statements. This pemits immediate try out. However, the
%                   structure of the generated code is such simple that it would be
%                   compatible with many native machine instruction sets. The compiler
%                   could be configured for assembler code generation by rewriting the
%                   templates.
%                   
%   Input argument(s):
%       programFile The generated compiler output. The file name extension decides, which
%                   template set is used for the backend: it may be either '.c' or '.m'.
%       sourceFile  The source code, written in fcl, our 'fictive computer language'.
%
%   Return argument(s):
%       success     Boolean success message
%       msg         Error message or warning. The compiler is kept as simple as possible
%                   and abort with the frst problem. We don't get an error listing
%       p           The parsed program. Main content of the structure is the pasre tree
%
%   Example(s):
%       [success msg] = compiler('myProgramFile.c', 'mySourceFile.fcl')
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
    noPar = 2;

    % Number of optional parameters.
    noOptPar = 0;

    error(nargchk(noPar, noPar+noOptPar, nargin));

%    % Set the optional parameter values.
%    noPar = noPar + 1;
%    if nargin < noPar
%        optPar1 = ;
%    end

    p = [];
    try
        s = file(sourceFile);
        p = parser(s);
        p = analyzer(p);
        st4Render clear
        log = st4Render( 'C:\user\vranken\projects\StringTemplateForOctave\samples\compiler\templates\displayProg.stg' ...
                       , 'displayProg' ...
                       , 'p', p ...
                       )
        [path rawSrcFileName] = fileparts(sourceFile);
        [path rawOutputFileName ext] = fileparts(programFile);
        today = date;
        year = today(8:end);
        fileInfo = struct( 'source', sourceFile ...
                         , 'rawSrcFileName', rawSrcFileName ...
                         , 'output', programFile ...
                         , 'rawOutputFileName', rawOutputFileName ...
                         , 'isC', strcmpi(ext, 'c') ...
                         , 'isOctave', strcmpi(ext, 'm') ...
                         , 'date', today ...
                         , 'year', year ...
                         );
        code = st4Render( 'C:\user\vranken\projects\StringTemplateForOctave\samples\compiler\templates\generateCode.c.stg' ...
                        , 'main' ...
                        , 'file', fileInfo ...
                        , 'p', p ...
                        );
        % Temporary test only
        if length(p.t) >= 1  &&  p.t{1}.isAssignment
            expr = printExpr(p.t{1}.expr);
        else
            expr = '(not yet implemented)';
        end
        file(programFile, [code]);
        msg = '';
        success = true;
    catch exc
        success = false;
        msg = exc.message;
        fprintf( 'Compilation of %s into %s failed. %s\n'
               , sourceFile
               , programFile
               , msg
               );
    end
end % of function compiler.


