function [success msg p] = compiler(programFile, sourceFile)

%   compiler() -    This sample implements the compiler for a most simple demonstrative
%                   computer language. A handwritten parser is connected to a
%                   StringTemplate V4 back-end. The use of a template engine permits easy
%                   configuration of different output formats; in our sample the compiler
%                   does a translation in a sequence of either simple C statements or
%                   simple M script statements. This permits immediate try out. However,
%                   the structure of the generated code is such simple that it would be
%                   compatible with many native machine instruction sets. The compiler
%                   could be configured for assembler code generation by rewriting the
%                   templates.
%
%                   The syntax of the computer language is defined as such:
%                     sequence ::= {statement}
%                     statement ::= assignment | loop | 'break' | if | comment
%                     comment ::= '#' {character} '\n'
%                     assignment ::= variable '=' expression
%                     variable ::= letter {letter}
%                     expression ::= andExpr ['|' expression]
%                     andExpr ::= boolExpr ['&' andExpr]
%                     boolExpr ::= sumExpr [('=' | '<>' | '<' | '>' | '<=' | '>=') boolExpr]
%                     sumExpr ::= mulExpr [('+' | '-') sumExpr]
%                     mulExpr ::= signExpr [('*' | '/' | '%') mulExpr]
%                     signExpr ::= ['-' | '!'] terminalExpr
%                     terminalExpr ::= '(' expression ')' | variable | number
%                     number ::= digit {digit}
%                     loop ::= 'loop' sequence 'end'
%                     if ::= 'if' expression sequence ['else' sequence] 'end'
%
%   Input argument(s):
%       programFile The generated compiler output. The file name extension decides, which
%                   template set is used for the back-end: it may be either '.c' or '.m'
%       sourceFile  The source code, written in our fictive computer language
%
%   Return argument(s):
%       success     Boolean success message
%       msg         Error message or warning. The compiler is kept as simple as possible
%                   and abort with the first problem. We don't get an error listing
%       p           The parsed program. Main content of the structure is the parse tree.
%                   This is the data object, which is given to the StringTemplate V4
%                   template engine for target code generation
%
%   Example(s):
%       [success msg p] = compiler('euclid.c', 'euclid.fcl');
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

    p = [];
    try
        % Read the entire source file into a string.
        s = file(sourceFile);

        % Create the parse tree from the input.
        p = parser(s);

        % Enhance the parse tree with additional information required for target code
        % generation. The parse tree is modified in place.
        p = analyzer(p);

        % To support the development of the compiler's ST4 templates we enforce re-loading
        % of these in every run of the compiler. Once the development is done this
        % statement should be commented out.
        %st4Render clear

        [path rawSrcFileName] = fileparts(sourceFile);
        [path rawOutputFileName ext] = fileparts(programFile);
        logFile = fullfile(path, [rawSrcFileName '.log']);

        % Which target language to generate?
        switch upper(ext)
        case '.C'
            isC = true;
            isOctave = false;
            tmplGrpFile = 'generateCode.c.stg';
        case '.M'
            isC = false;
            isOctave = true;
            tmplGrpFile = 'generateCode.m.stg';
        otherwise
            error(['Target code generation for a file of extension ''' ext ''' is not' ...
                   ' supported'] ...
                 );
        end

        % Pass some information about time, date and files to the template engine for use
        % in the generated text.
        today = date;
        year = today(8:end);
        fileInfo = struct( 'sourceFileName', sourceFile ...
                         , 'rawSourceFileName', rawSrcFileName ...
                         , 'outputFileName', programFile ...
                         , 'rawOutputFileName', rawOutputFileName ...
                         , 'logFileName', logFile ...
                         , 'isC', isC ...
                         , 'isOctave', isOctave ...
                         , 'date', today ...
                         , 'year', year ...
                         );
        log = st4Render( 'displayProg.stg' ...
                       , 'displayProg' ...
                       , 'info', fileInfo ...
                       , 'p', p ...
                       );
        code = st4Render( tmplGrpFile ...
                        , 'main' ...
                        , 'info', fileInfo ...
                        , 'p', p ...
                        );

        % Write generated code into files.
        file(logFile, log);
        file(programFile, code);
        msg = '';
        success = true;
    catch exc
        success = false;
        msg = exc.message;
        fprintf( 'Compilation of %s into %s failed. %s\n' ...
               , sourceFile                               ...
               , programFile                              ...
               , msg                                      ...
               );
    end
end % of function compiler.


