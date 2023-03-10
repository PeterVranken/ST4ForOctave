function [p] = analyzer(p)

%   analyzer() - The StringTemplate V4 back-end can't do any data processing itself. It
%                   can't generate program code directly from the raw parse tree. Any kind
%                   of code structure decision, compile-time evaluation, etc. needs to be
%                   taken before going into the back-end. This module will do some
%                   transformations of the parse tree to a minimum extend so that
%                   generation of real program code becomes possible
%
%   Input argument(s):
%       p           The parsed program as got from the parser. Main content is the parse
%                   tree
%
%   Return argument(s):
%       p           The modified/extended program object
%
%   Example(s):
%       [p] = parser(sourcCode);
%       p = analyzer(p);
%
%   Copyright (C) 2016-2023 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU Lesser General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or any later
%   version.
%  
%   This program is distributed in the hope that it will be useful, but WITHOUT
%   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%   FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
%   for more details.
%  
%   You should have received a copy of the GNU Lesser General Public License
%   along with this program. If not, see <http://www.gnu.org/licenses/>.

    % Number of mandatory parameters.
    noPar = 1;

    % Number of optional parameters.
    noOptPar = 0;

    error(nargchk(noPar, noPar+noOptPar, nargin));

%    % Set the optional parameter values.
%    noPar = noPar + 1;
%    if nargin < noPar
%        optPar1 = ;
%    end

    % The most important tasks for code generation are:
    % - determine the depth of all branches of the expressions. This is required to decide
    %   on safe usage of temporary storage of intermediate results. A run-time stack would
    %   be an alternative concept
    % - The statement break is not directly by syntax linked to the loop it has to act on.
    %   The backend requires the direct link and we have to find and add it
    [p.parseTree mapOfVars nextLabel maxExprDepth] = analyseSequence( p.parseTree ...
                                                                    , struct ...
                                                                    , int32(1) ...
                                                                    , int32(0) ...
                                                                    , int32(-1) ...
                                                                    );
                                                                    
    % The map of variables is iterated. The parser output specifies two lists of variables
    % instead: The variables, which is assigned a value and those which are only read. The
    % two groups can be understood as program outputs and inputs, respectively.
    %   In principle, it would be possible to use the map (which is an Octave struct) as it
    % is in the interface to StringTemplate. However, inside the templates is not so easy
    % to safely filter the map for the one or other kind of variables. In a template, two
    % separate lists are much easier to handle. Data model should in general consider the
    % capabilities of the template expressions.
    for fieldName = fieldnames(mapOfVars).'
        fieldName = fieldName{1};
        if mapOfVars.(fieldName)
            p.listVariablesWr{end+1} = fieldName;
        else
            p.listVariablesRd{end+1} = fieldName;
        end
    end    
    
    % Provide the list of temporary storages required for expression evaluation. Here, we
    % can safely use an Octave array (not a cell array) since it is of numeric type.
    % Numeric arrays of any length, including 0 or 1, can be safely iterated in a
    % StringTemplate V4 template - opposed to arrays of struct objects.
    p.listOfRegisters = int32([0:maxExprDepth]);
    
end % of function analyzer.



function abort(msg)
% End of compilation by throwing an error.
    error([msg]);
end % abort




function [t mapOfVars nextLabel maxExprDepth] = analyseSequence( t ...
                                                               , mapOfVars ...
                                                               , nextLabel ...
                                                               , labelForBreak ...
                                                               , maxExprDepth ...
                                                               )

% This is the recursive entry: Nested code elements reappear like the complete program as a
% sequence of statements. Here we analyze each statement from the sequence and modify it in
% place.
%   Return value t:
% The modified parse tree is returned.
%   Return value mapOfVars:
% The same map of variables object is continuously updated, thus taken as argument and
% returned with contents as function result.
%   Return value nextLabel:
% The global label for loops and conditional clauses is is continuously updated, thus taken
% as argument and returned with modification as function result.
%   Return value maxExprDepth:
% The maximum expression depth used at function exit.
%   Parameter t:
% The parse tree got from the parser, which is the program sequence that is recursively
% analyzed.
%   Parameter mapOfVars:
% A map of variables. All variables mentioned somewhere in an expression are listed. The
% map is empty at entry into the recursion through the parse tree.
%   Parameter nextLabel:
% De-nesting loops and if-statements requires branch and jump operations, which build on a
% globally unique label. This parameter in combination with the return value of same name is
% nothing else as a infinitely incremented global counter.
%   Parameter labelForBreak:
% This is the label of the loop statement the next break statement will refer to, which is
% encountered in the further course of the recursion. The recursion starts with an invalid
% label in order to recognize a misplaced break.
%   Parameter maxExprDepth:
% The maximum expression depth used so far at function entry. This parameter in combination
% with the return value of same name is nothing else as a global maximum of expression
% depths.

    % The parse tree is modified in place.
    for idxStatement = 1:length(t)
        s = t{idxStatement};

        % The "expression" of a comment is the comment as a string. Here we are not going
        % to modify anything. All other statements and expressions may need handling.
        if s.isComment
            continue;
        end

        % If this statement make use of a (numeric) expression then this expression is now
        % handled.
        if ~isempty(s.expr)
            [t{idxStatement}.expr mapOfVars exprDepth] = analyseExpr( s.expr ...
                                                                    , int32(0) ...
                                                                    , mapOfVars ...
                                                                    );
            maxExprDepth = max(maxExprDepth, exprDepth);
        end
        
        if s.isAssignment
            % Keep track of having assigned a value to the given variable. Possible states:
            % - never mentioned - not in map.
            % - so far only used at right hand side - in map, value false
            % - a value has assigned - in map, value true
            mapOfVars.(s.variable) = true;

        elseif s.isLoop || s.isIf
            % Loop and if statements require a unique label for implementation. The label
            % is required to construct branch or jump destinations.
            t{idxStatement}.label = nextLabel;
            
            % If this statement is a loop then the break statement in further recursion
            % will refer to this loop. Remember for handling of sub-statements.
            if s.isLoop
                labelForBreak = nextLabel;
            end

            nextLabel = nextLabel+1;
        elseif s.isBreak
            % A break implicitly refers to the next outer loop. We need to have such a loop
            % and we need to store the reference explicitly for the code generation
            % back-end.
            if labelForBreak <= 0
                % Here, our simple demonstrative implementation reaches its limits; we
                % don't have a reasonable, helpful localization of the problem, no line
                % numbers in particular.
                abort('break used outside a loop');
            end
            t{idxStatement}.label = labelForBreak;
            
            % A break always ends the current sequence immediately. If there are remaining
            % statements left then we can consider this an error in the source code.
            if idxStatement < length(t)
                abort(['Unreachable code behind break. A break statement needs to be' ...
                       ' the last statement inside a conditional branch'] ...
                     );
            end
        end
        
        if ~isempty(s.seq)
            [t{idxStatement}.seq mapOfVars nextLabel maxExprDepth] = ...
                                                        analyseSequence( s.seq          ...
                                                                       , mapOfVars      ...
                                                                       , nextLabel      ...
                                                                       , labelForBreak  ...
                                                                       , maxExprDepth   ...
                                                                       );
        end
        if ~isempty(s.seqElse)
            [t{idxStatement}.seqElse mapOfVars nextLabel maxExprDepth] = ...
                                                        analyseSequence( s.seqElse     ...
                                                                       , mapOfVars     ...
                                                                       , nextLabel     ...
                                                                       , labelForBreak ...
                                                                       , maxExprDepth  ...
                                                                       );
        end
    end
end % of function analyseSequence.




function [e mapOfVars maxDepth] = analyseExpr(e, depth, mapOfVars)

% Analysis of an expression in order to find the depth of each node. This depth can be used
% by the backend to easily decide on (re-)usable storage for intermediate results.
%   The expression data structure is a fully recursive tree of nodes, where a node is a
% terminal or an operation on other nodes. The function implementation follows this
% recursice structure. The entry into the recursion, how you call this function, is done
% with the data object found in the statements of the parse tree.
%   Return value e:
% The modified expression. This includes all its sub-nodes.
%   Return value mapOfVars:
% The same map of variables object is continuously updated, thus taken as argument and
% returned with contents as function result.
%   Return value maxDepth:
% The maximum depth of the expression including the entered node and all its sub-nodes. The
% returned depth can be both, more or less than the proposed depth found in parameter
% 'depth'. The returned value is the depth of the complete expression when eventually
% returning from the recursion.
%   Parameter mapOfVars:
% A map of variables. All variables mentioned somewhere in an expression are listed.
%   Parameter depth:
% The depth proposed for the entered node in the expression. If the node is a terminal, not
% doing a computation then it may not consume the proposed depth and respond with a lower
% actual depth.

    % Keep track of use of variables.
    if ~isempty(e.variable)
        if ~isfield(mapOfVars, e.variable)
            % Here we can give feedback about first use prior to assignment. However, due
            % to loops and conditional code the order of code inspection we do here is not
            % necessarily the order of later code execution. Consequently, such an
            % evaluation must not be more than a warning and even better an optional
            % warning only.
            fprintf( 'Warning: Possible use of variable %s before first assignment\n' ...
                   , e.variable ...
                   );
            mapOfVars.(e.variable) = false;
        end
    end
    
    % Terminals don't need further handling.
    if isempty(e.operation)
        % Terminals don't consume any element from the computation/register stack.
        maxDepth = int32(-1);
        return
    end

    % The evaluation of the right associative tree is done like this: left operand first,
    % then right operand, then their combination. The combination can reuse the storage of
    % the left operand, so the left operand can use the same storage as this node, while
    % the right node requires a higher depth, i.e. a new storage location.
    assert(~isempty(e.leftExpr) && ~isempty(e.rightExpr))
    [e.leftExpr mapOfVars maxDepthLeft] = analyseExpr( e.leftExpr ...
                                                     , depth ...
                                                     , mapOfVars ...
                                                     );
    [e.rightExpr mapOfVars maxDepthRight] = analyseExpr( e.rightExpr ...
                                                       , depth+1 ...
                                                       , mapOfVars ...
                                                       );

    % A tiny optimization: operations on numericals can be evaluated immediately and the
    % operation is replaced by a terminal. This is in practice mainly relevant to remove
    % the negation operation and make it a negative literal.
    %   We take this step after the recursion of the sub-expressions in order to find more
    % compile-time known sub-expressions - even if this barely has relevance in practice.
    if ~isempty(e.leftExpr.number)  &&  ~isempty(e.rightExpr.number)
        % Numeric overruns don't matter in this demonstrative software. Actually, the
        % overrun behavior of these Octave operations at compile time differs from the
        % overrun behavior at run time of the generated C code. For a real compiler would
        % this be inacceptable: the same computation will yield a different result when
        % done once with literals and then with variables.
        switch e.operation
        case 'or'
            e.number = int64(e.leftExpr.number ~= 0  ||  e.rightExpr.number ~= 0);
        case 'and'
            e.number = int64(e.leftExpr.number ~= 0  &&  e.rightExpr.number ~= 0);
        case 'eq'
            e.number = int64(e.leftExpr.number == e.rightExpr.number);
        case 'neq'
            e.number = int64(e.leftExpr.number ~= e.rightExpr.number);
        case 'lt'
            e.number = int64(e.leftExpr.number < e.rightExpr.number);
        case 'leq'
            e.number = int64(e.leftExpr.number <= e.rightExpr.number);
        case 'gt'
            e.number = int64(e.leftExpr.number > e.rightExpr.number);
        case 'geq'
            e.number = int64(e.leftExpr.number >= e.rightExpr.number);
        case 'add'
            e.number = e.leftExpr.number + e.rightExpr.number;
        case 'sub'
            e.number = e.leftExpr.number - e.rightExpr.number;
        case 'mul'
            e.number = e.leftExpr.number * e.rightExpr.number;
        case 'div'
            % Octave's operation / is defined different to the intended integer division
            % operator, which rounds towards zero for all sign combinations. This behavior
            % is modeled by command idivide in elder versions of Octave and in MATLAB.
            % Newer version of Octave behave differently, which requires an equalizing
            % sub-function. Note, for large numbers, the calculation is still wrong due to
            % the different dealing with overflows in C and Octave.
            e.number = divIntLikeC(e.leftExpr.number, e.rightExpr.number);
        case 'mod'
            % Octave's operation mod(a,b) is defined different to the intended integer
            % modulus operator, which should behave as defined in language C. The operation
            % is done signless and the result gets the sign of the first operand.
            e.number = mod(abs(e.leftExpr.number), abs(e.rightExpr.number));
            if e.leftExpr.number < 0
                e.number = -e.number;
            end
        otherwise
            assert(false)
        end
        % Discart the meaning of this node so far.
        e.operation = [];
        e.leftExpr = [];
        e.rightExpr = [];
        assert(isempty(e.variable) && isempty(e.depth))
        
        % This node becomes a terminal and doesn't consume any element from the
        % computation/register stack - regardless of what we had computed above for the
        % left and right branches.
        assert(maxDepthLeft == -1  &&  maxDepthRight == -1)
        maxDepth = int32(-1);
    else
        % This node doesn't simplify to a numeral, so enter the found depth and keep track
        % of the maximum.
        e.depth = depth;
        maxDepth = max([depth; maxDepthRight; maxDepthLeft]);
        
        % The concept of the code generation depends on the fact that left operands are
        % either immediately available terminals (numbers, variables) or that they are
        % computed in the same register (the representation of what is here called depth)
        % as the operation in progress. Double-check this condition.
        assert(isempty(e.leftExpr.operation) || e.leftExpr.depth == depth);
    end
end % of function analyseExpr
