function [p] = parser(c)

%   parser() -      A parser for a fictive programming language with numeric expressions,
%                   assignments, conditional statements and a simple loop.
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
%       c           A string with the program code to be parsed.
%
%   Return argument(s):
%       p           The parsed program. p is a data structure, which contains the parse
%                   tree t plus some accompanying information, e.g. a map of referenced
%                   variables. t is the representation of "sequence" from the language
%                   definition.
%
%   Example(s):
%       [p] = parser('x=4 loop if x=0 break end y=y+x x=x-1 end ')
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
    
    % Adding an artificial termination character avoids permanent check for end of string
    % when trying a single character look ahead. The combination of EOL and the real
    % termination character is required to avoid that a final comment consumes the termination
    % character.
    c = [strtrim(c) char(10) ';'];
    
    p = new('program');
    [p.parseTree c] = sequence(c);
    
    % The termination character needs to be still present.
    assert(strcmp(c(end), ';'), 'internal implementation error')
    c = c(1:end-1);
    
    % All input needs to be consumend by the parser.
    if ~isempty(c)
        abort('Found unconsumed input after parsing program', c)
    end

%    % Test
%    if length(p.parseTree) >= 1  &&  p.parseTree(1).isAssignment
%        disp(printExpr(p.parseTree(1).expr));
%    end
end % of function parser.



function s = new(dataType)
% Create and return an object of given type.

    switch dataType
    case 'sequence'
        % We must not model a sequence, which can have a length of one as an array of
        % struct (which would be natural here otherwise) - this is a limitation of the
        % interface with StringTemplate V4, which is going to receive the whole data
        % structure. See documentation of st4Render for details. We use a cell array
        % instead.
        s = cell(1, 0);
    case 'statement'
        s = struct( 'isComment', false                                                  ...
                  , 'isLoop', false                                                     ...
                  , 'isBreak', false                                                    ...
                  , 'isIf', false                                                       ...
                  , 'isAssignment', false                                               ...
                  , 'variable', []                                                      ...
                  , 'expr', []                                                          ...
                  , 'seq', []                                                           ...
                  , 'seqElse', []                                                       ...
                  ... % The following fields are not filled by the parser but required  ...
                  ... % for later processing. The parse tree analysis will fill them.   ...
                  , 'label', []                                                         ...
                  );
    case 'expression'
        s = struct( 'number', []                                                        ...
                  , 'variable', []                                                      ...
                  , 'operation', []                                                     ...
                  , 'leftExpr', []                                                      ...
                  , 'rightExpr', []                                                     ...
                  ... % The following fields are not filled by the parser but required  ...
                  ... % for later processing. The parse tree analysis will fill them.   ...
                  , 'depth', []                                                         ...
                  );
    case 'program'
        s = struct( 'parseTree', []                                                     ...
                  ... % The following fields are not filled by the parser but required  ...
                  ... % for later processing. The parse tree analysis will fill them.   ...
                  , 'listVariablesRd', []                                               ...
                  , 'listVariablesWr', []                                               ...
                  , 'listOfRegisters', []                                               ...
                  );
        % A cell array can not easily be the argument of a call of struct().
        s.parseTree = new('sequence');
        s.listVariablesRd = {};
        s.listVariablesWr = {};
    otherwise
        error(['Internal error, undefined type ' dataType ' demanded'])
        
    end % switch dataType
end % new




function abort(msg, c)
% End parsing by throwing an error.
    if length(c) > 200
        c = c(1:200);
    else
        % Remove the only internally known termination character.
        c = c(1:end-1);
    end
    error([msg '. Unparsable input is: ' c]);
end % abort




function [c] = consumeEnd(c)
% Parse the keyword 'end' and return the unconsumed input.
    if ~strncmp(c, 'end', 3)
        abort('Expect keyword ''end''', c);
    end
    c = strtrim(c(4:end));
end % consumeEnd



function [isElse c] = consumeElseOrEnd(c)
% Parse one of the keywords 'else' or 'end' and return which was found and
% the unconsumed input.
    if strncmp(c, 'end', 3)
        isElse = false;
        c = strtrim(c(4:end));
    elseif strncmp(c, 'else', 4)
        isElse = true;
        c = strtrim(c(5:end));
    else
        abort('Expect keyword ''end''', c);
    end
end % consumeElseOrEnd



function [t c] = sequence(c)
% Parse 'sequence' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    t = new('sequence');
    % len > 1: Because of termination character added at the beginning.
    while length(c) > 1
        [s c] = statement(c);
        if isempty(s)
            c = strtrim(c);
            break
        else
            t{end+1} = s;
        end
    end
end % sequence



function [t c] = statement(c)
% Parse 'statement' and return the parse tree of the next statement and the unconsumed input.
%   Throws an error if any syntax error appears.

    if c(1) == '#'
        % Comments are parsed as a kind of statement. This way they are well defined part
        % of the data flow of the parse tree, which permits to use them at logically
        % correct positions in the generated compiler output. The disadvantage is that they
        % can not be put at arbitrary locations of the source code, e.g. in the midle of
        % an expression to comment just on a sub-term. While this is common in most real
        % languages we can't support it easily as we don't implement a symbol scanner.
        c = strtrim(c(2:end));
        comment = '';
        i = 1;
        while c(i) ~= char(10)
            comment(end+1) = c(i);
            i = i+1;
        end
        
        t = new('statement');
        t.isComment = true;
        t.expr = comment;
        
        % The EOL is not included in the comment but removed by the anyway required strtrim.
        c = strtrim(c(i:end));
    else
        % Any statement, which is not a comment, begins with an identifier, a variable name or
        % a key word.
        ident = '';
        i = 1;
        while isstrprop(c(i), 'alpha')
            ident(end+1) = c(i);
            i = i+1;
        end
        if isempty(ident)
            abort('Expect either identifier or keyword', c);
        end

        % The keywords 'else' or 'end' are the end of a statement sequence and must not be
        % consumed here. We return an empty statement, which the caller can append to his
        % sequence so far.
        if any(strcmp(ident, {'end' 'else'}))
            t = [];
            return
        end

        t = new('statement');
        c = strtrim(c(i:end));
        switch ident
        case 'loop'
            t.isLoop = true;
            [t.seq c] = sequence(c);
            c = consumeEnd(c);
        case 'if'
            t.isIf = true;
            [t.expr c] = expression(c);
            [t.seq c] = sequence(c);
            [isElse c] = consumeElseOrEnd(c);
            if isElse
                [t.seqElse c] = sequence(c);
                c = consumeEnd(c);
            end
        case 'break'
            t.isBreak = true;
        otherwise
            if ~strcmp(c(1), '=')
                abort('Expect assignment operator ''=''', c);
            end
            c = strtrim(c(2:end));
            t.isAssignment = true;
            t.variable = ident;
            [t.expr c] = expression(c);
        end
    end % if comment or real statement?
end % statement




function [t c] = expression(c, leftOp)
% Parse 'expression' and return the parse tree and the unconsumed input. The first input is
% the still unconsumed source code. The second input is required to make the recursion
% build a left associative tree.
%   Throws an error if any syntax error appears.

    [t c] = andExpr(c);
    if nargin >= 2
        leftOp.rightExpr = t;
        t = leftOp;
    end
    
    if c(1) == '|'
        % The more straight forward recursion here, when found the next operation |, would
        % be creating a new operation node "or", assign the already parsed operand as left
        % operand and then assign the result of the recursive call of this same method to
        % the right operand of the new node. Then it would return the new operation node.
        % This pattern recurses down till the last two operands are consumed and combine
        % these two in the right most operation node. The further return from the recursion
        % levels will build a right-associative tree - which is counter intuitive and
        % unwanted.
        %   To overcome this effect we introduced the second function argument, which is
        % empty on initial entry in this method. The argument is used to reorder the parsed
        % operands so that we always end with a left associative tree. As long as there are
        % still further operands to the right, we create the new node but leave the
        % assignment of the right operand to the next recursion level, which will parse the
        % next operand. If this level has parsed the operand it has the possibility to add
        % it as right operand of the previous node and to take that entire, now completed
        % node as its own left operand - if there would be a further operation "or".
        %   This pattern is used on all levels of the syntax definition of an expression.
        % We build the left associative tree even where it wouldn't be essential for a
        % correct computation result as it is for add/subtract and multiplication/division
        % level.
        c = strtrim(c(2:end));
        tNew = new('expression');
        tNew.operation = 'or';
        tNew.leftExpr = t;
        [t c] = expression(c, tNew);
    end
end % expression



function [t c] = andExpr(c, leftOp)
% Parse 'andExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    [t c] = boolExpr(c);
    if nargin >= 2
        leftOp.rightExpr = t;
        t = leftOp;
    end
    
    if c(1) == '&'
        c = strtrim(c(2:end));
        tNew = new('expression');
        tNew.operation = 'and';
        tNew.leftExpr = t;
        [t c] = andExpr(c, tNew);
    end
end % andExpr




function [t c] = boolExpr(c, leftOp)
% Parse 'boolExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    [t c] = sumExpr(c);
    if nargin >= 2
        leftOp.rightExpr = t;
        t = leftOp;
    end
    
    switch c(1)
    case '='
        operation = 'eq';
        c = c(2:end);
    case '<'
        switch c(2)
        case '>'
            operation = 'neq';
            c = c(3:end);
        case '='
            operation = 'leq';
            c = c(3:end);
        otherwise
            operation = 'lt';
            c = c(2:end);
        end
    case '>'
        switch c(2)
        case '='
            operation = 'geq';
            c = c(3:end);
        otherwise
            operation = 'gt';
            c = c(2:end);
        end
    otherwise
        operation = [];
    end
    if ~isempty(operation)
        c = strtrim(c);
        tNew = new('expression');
        tNew.operation = operation;
        tNew.leftExpr = t;
        [t c] = boolExpr(c, tNew);
    end
end % boolExpr



function [t c] = sumExpr(c, leftOp)
% Parse 'sumExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    [t c] = mulExpr(c);
    if nargin >= 2
        leftOp.rightExpr = t;
        t = leftOp;
    end
    
    switch c(1)
    case '+'
        operation = 'add';
    case '-'
        operation = 'sub';
    otherwise
        operation = [];
    end
    if ~isempty(operation)
        c = strtrim(c(2:end));
        tNew = new('expression');
        tNew.operation = operation;
        tNew.leftExpr = t;
        [t c] = sumExpr(c, tNew);
    end
end % sumExpr



function [t c] = mulExpr(c, leftOp)
% Parse 'mulExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    [t c] = signExpr(c);
    if nargin >= 2
        leftOp.rightExpr = t;
        t = leftOp;
    end
    
    switch c(1)
    case '*'
        operation = 'mul';
    case '/'
        operation = 'div';
    case '%'
        operation = 'mod';
    otherwise
        operation = [];
    end
    if ~isempty(operation)
        c = strtrim(c(2:end));
        tNew = new('expression');
        tNew.operation = operation;
        tNew.leftExpr = t;
        [t c] = mulExpr(c, tNew);
    end
end % mulExpr




function [t c] = signExpr(c)
% Parse 'signExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    % Sign can be a numeric or a Boolean sign but not both at a time.
    isSign = strcmp(c(1), {'-' '!'});
    if any(isSign)
        c = strtrim(c(2:end));
    end
    [t c] = terminalExpr(c);
    if any(isSign)
        tNew = new('expression');
        tConstant = new('expression');

        if isSign(1)
            % Numeric negation: times -1
            tConstant.number = int64(-1);
            tNew.operation = 'mul';
        else
            % Boolean negation: != 0
            tConstant.number = int64(0);
            tNew.operation = 'eq';
        end
        
        tNew.leftExpr = t;        
        tNew.rightExpr = tConstant;

        t = tNew;
    end
end % signExpr



function [t c] = terminalExpr(c)
% Parse 'terminalExpr' and return the parse tree and the unconsumed input.
%   Throws an error if any syntax error appears.

    if isstrprop(c(1), 'digit')
        t = new('expression');
        number = '';
        i = 1;
        while isstrprop(c(i), 'digit')
            number(end+1) = c(i);
            i = i+1;
        end
        c = strtrim(c(i:end));
        t.number = int64(str2num(number));
    elseif isstrprop(c(1), 'alpha')
        t = new('expression');
        ident = '';
        i = 1;
        while isstrprop(c(i), 'alpha')
            ident(end+1) = c(i);
            i = i+1;
        end
        c = strtrim(c(i:end));
        % For sake of simplicity only, we do not filter keywords here (in a true compiler
        % would this already have been done by the tokenizer). Keywords can thus be used in
        % expressions. They can't be LHS values but can appear as system inputs.
        t.variable = ident;
    elseif c(1) == '('
        c = strtrim(c(2:end));
        [t c] = expression(c);
        if c(1) ~= ')'
            abort('Closing parenthesis missing', c)
        end
        c = strtrim(c(2:end));
    else
        abort('Expect variabale or integer number', c)
    end
end % terminalExpr


