function testST4Render

%   testST4Render - Some test calls of the interface Octave with StringTemplate V4
%
%   Input argument(s):
%
%   Return argument(s):
%
%   Example(s):
%       testST4Render
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

    disp('This test uses assertions. No error output means test succeeded')
    
    st4Render clear

    % StringTemplate V4 returns the native EOL character of the hosting system. We need to
    % anticipate this character (sequence) to write the test cases down here system
    % independent. We retrieve it from the engine (and trust it). At the same time a test
    % of template expansion without any input.
    EOL = st4Render('testST4Render.stg', 'EOL');
    disp(uint8(EOL));

    % The basic types.
    n = pi;
    i8  = int8(-pi*10);
    i16 = int16(-pi*1000);
    i32 = int32(-pi*1000);
    i64 = int64(-pi*1000000);
    u8  = uint8(pi*10);
    u16 = uint16(pi*1000);
    u32 = uint32(pi*1000);
    u64 = uint64(pi*1000000);
    s = 'hello world';
    txt = st4Render( 'testST4Render.stg', 'basicTypes' ...
                   , 'n',   n   ...
                   , 'i8',  i8  ...
                   , 'i16', i16 ...
                   , 'i32', i32 ...
                   , 'i64', i64 ...
                   , 'u8',  u8  ...
                   , 'u16', u16 ...
                   , 'u32', u32 ...
                   , 'u64', u64 ...
                   , 's',   s   ...
                   );
    expectation = ['n   = 3.1416' EOL ...
                   'i8  = -31' EOL ...
                   'i16 = -3142' EOL ...
                   'i32 = -3142' EOL ...
                   'i64 = -3141593' EOL ...
                   'u8  = 31' EOL ...
                   'u16 = 3142' EOL ...
                   'u32 = 3142' EOL ...
                   'u64 = 3141593' EOL ...
                   's   = hello world' EOL ...
                  ];
    assert(strcmp(txt, expectation), 'Test case failed: basic types')

    % The basic types bundled in a struct.
    attrib = struct;
    attrib.n = pi;
    attrib.i8  = int8(-pi*10);
    attrib.i16 = int16(-pi*1000);
    attrib.i32 = int32(-pi*1000);
    attrib.i64 = int64(-pi*1000000);
    attrib.u8  = uint8(pi*10);
    attrib.u16 = uint16(pi*1000);
    attrib.u32 = uint32(pi*1000);
    attrib.u64 = uint64(pi*1000000);
    attrib.s = 'hello world';
    txt = st4Render('testST4Render.stg', 'basicTypesAsStruct', 'attrib', attrib);
    assert(strcmp(txt, expectation), 'Test case failed: basic types in a struct')

    % An array of structs. Here we avoid the critical length 1.
    structAry = attrib;
    structAry(end+1).i64 = int64(1);
    structAry(end+1).i64 = int64(2);
    structAry(end+1).i64 = int64(3);
    txt = st4Render('testST4Render.stg', 'structAry', 'ary', structAry);
    expectation = "-3141593-1-2-3";
    assert(strcmp(txt, expectation), 'Test case failed: structAry')

    % A 2-d array of structs.
    structAry = repmat(attrib, 9, 13);
    for r=1:9
        for c=1:13
            structAry(r,c).u8 = uint8(r);
            structAry(r,c).i8 = uint8(c);
        end
    end
    expectation = [ ...
'(1,1) (1,2) (1,3) (1,4) (1,5) (1,6) (1,7) (1,8) (1,9) (1,10) (1,11) (1,12) (1,13)' EOL ...
'(2,1) (2,2) (2,3) (2,4) (2,5) (2,6) (2,7) (2,8) (2,9) (2,10) (2,11) (2,12) (2,13)' EOL ...
'(3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (3,10) (3,11) (3,12) (3,13)' EOL ...
'(4,1) (4,2) (4,3) (4,4) (4,5) (4,6) (4,7) (4,8) (4,9) (4,10) (4,11) (4,12) (4,13)' EOL ...
'(5,1) (5,2) (5,3) (5,4) (5,5) (5,6) (5,7) (5,8) (5,9) (5,10) (5,11) (5,12) (5,13)' EOL ...
'(6,1) (6,2) (6,3) (6,4) (6,5) (6,6) (6,7) (6,8) (6,9) (6,10) (6,11) (6,12) (6,13)' EOL ...
'(7,1) (7,2) (7,3) (7,4) (7,5) (7,6) (7,7) (7,8) (7,9) (7,10) (7,11) (7,12) (7,13)' EOL ...
'(8,1) (8,2) (8,3) (8,4) (8,5) (8,6) (8,7) (8,8) (8,9) (8,10) (8,11) (8,12) (8,13)' EOL ...
'(9,1) (9,2) (9,3) (9,4) (9,5) (9,6) (9,7) (9,8) (9,9) (9,10) (9,11) (9,12) (9,13)' EOL ...
];
    txt = st4Render('testST4Render.stg', 'structAryAry', 'M', structAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d struct array')

    % Same array as cell array.
    cellAry = cell(9, 13);
    for r=1:9
        for c=1:13
            cellAry{r,c} = structAry(r,c);
            assert(cellAry{r,c}.u8 == uint8(r)  &&  cellAry{r,c}.i8 == uint8(c));
        end
    end
    txt = st4Render('testST4Render.stg', 'structAryAry', 'M', cellAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d cell array')
    
    % Linear (cell) arrays of struct, including critical lengths 0 and 1 for cells.
    % We take a vertical array. The wrapper doesn't have any idea of horizontal or vertical
    % for 1-d arrays. We will see it transposed.
    vcAry = cellAry(:,2);
    expectation = ['(1,2) (2,2) (3,2) (4,2) (5,2) (6,2) (7,2) (8,2) (9,2)' EOL];
    txt = st4Render('testST4Render.stg', 'row', 'r', vcAry);
    assert(strcmp(txt, expectation), 'Test case failed: 1-d vertical cell array')
    txt = st4Render('testST4Render.stg', 'row', 'r', structAry(:,2));
    assert(strcmp(txt, expectation), 'Test case failed: 1-d vertical struct array')
    % A horizontal extract.
    hcAry = cellAry(3,:);
    expectation = ['(3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (3,10) (3,11)' ...
                   ' (3,12) (3,13)' EOL];
    txt = st4Render('testST4Render.stg', 'row', 'r', hcAry);
    assert(strcmp(txt, expectation), 'Test case failed: 1-d horizontal cell array')
    txt = st4Render('testST4Render.stg', 'row', 'r', structAry(3,:));
    assert(strcmp(txt, expectation), 'Test case failed: 1-d horizontal struct array')
    % Length 2, cell
    hcAry = hcAry([3 7]);
    expectation = ['(3,3) (3,7)' EOL];
    txt = st4Render('testST4Render.stg', 'row', 'r', hcAry);
    assert(strcmp(txt, expectation), 'Test case failed: 1-d horizontal cell array, len=2')
    % Length 1, cell
    hcAry = hcAry([1]);
    expectation = ['(3,3)' EOL];
    txt = st4Render('testST4Render.stg', 'row', 'r', hcAry);
    assert(strcmp(txt, expectation), 'Test case failed: 1-d horizontal cell array, len=1')
    % Length 0, cell
    hcAry = {};
    expectation = ['' EOL];
    txt = st4Render('testST4Render.stg', 'row', 'r', hcAry);
    assert(strcmp(txt, expectation), 'Test case failed: 1-d horizontal cell array, len=0')
    
    % A 2-d cell array with size nx1: The template won't return a reasonable result as it
    % doesn't get nested ArayList Objects as rows. Trying the iteration of the instaed
    % received scalar Map objects yields empty template expressions - as many times as
    % there are fields.
    vcAry = cellAry(:,2);
    expectation = [repmat('(,) ', 1, length(fieldnames(attrib))-1) '(,)' EOL];
    expectation = repmat(expectation, 1, size(vcAry,1));
    txt = st4Render('testST4Render.stg', 'structAryAry', 'M', vcAry);
    assert(strcmp(txt, expectation), 'Test case failed:  nx1 cell array')
    
    % The not-regonized 2-d array in case of special sizes 1xn and nx1 can be avoided by
    % using cell arrays of row cell arrays. Let's begin with a mxn with n,m ~= 1.
    cAryAry = cell(0,1);
    for rowIdx = [2 3 5 9]
        cAryAry{end+1,1} = cellAry(rowIdx,:);
    end
    expectation = [ ...
'(2,1) (2,2) (2,3) (2,4) (2,5) (2,6) (2,7) (2,8) (2,9) (2,10) (2,11) (2,12) (2,13)' EOL ...
'(3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (3,10) (3,11) (3,12) (3,13)' EOL ...
'(5,1) (5,2) (5,3) (5,4) (5,5) (5,6) (5,7) (5,8) (5,9) (5,10) (5,11) (5,12) (5,13)' EOL ...
'(9,1) (9,2) (9,3) (9,4) (9,5) (9,6) (9,7) (9,8) (9,9) (9,10) (9,11) (9,12) (9,13)' EOL ...
];
    txt = st4Render('testST4Render.stg', 'structAryAry', 'M', cAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d cell array of cell array')
    % The same with a single row.
    cAryAry = cAryAry(2,:);
    expectation = [ ...
'(3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (3,10) (3,11) (3,12) (3,13)' EOL ...
];
    txt = st4Render('testST4Render.stg', 'structAryAry', 'M', cAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d cell array of cell array')

    % Use Java objects. st4Render should only pass these on. 'Struct' is a simple class
    % defined in this directory by compiled Java source code.
    javaAryAry = javaArray('Struct', 7, 5);
    for r=1:7
        for c=1:5
            javaAryAry(r,c) = javaObject('Struct');
            setfield(javaAryAry(r,c), 'name',  ['r' num2str(r) 'c' num2str(c)]);
            setfield(javaAryAry(r,c), 'value', (c-1)+(r-1)*5+1);
            setfield(javaAryAry(r,c), 'asInt', int32(getfield(javaAryAry(r,c), 'value')));
        end
    end
    expectation = [ ...
        'r1c1:1.00=1 r1c2:2.00=2 r1c3:3.00=3 r1c4:4.00=4 r1c5:5.00=5' EOL ...
        'r2c1:6.00=6 r2c2:7.00=7 r2c3:8.00=8 r2c4:9.00=9 r2c5:10.00=10' EOL ...
        'r3c1:11.00=11 r3c2:12.00=12 r3c3:13.00=13 r3c4:14.00=14 r3c5:15.00=15' EOL ...
        'r4c1:16.00=16 r4c2:17.00=17 r4c3:18.00=18 r4c4:19.00=19 r4c5:20.00=20' EOL ...
        'r5c1:21.00=21 r5c2:22.00=22 r5c3:23.00=23 r5c4:24.00=24 r5c5:25.00=25' EOL ...
        'r6c1:26.00=26 r6c2:27.00=27 r6c3:28.00=28 r6c4:29.00=29 r6c5:30.00=30' EOL ...
        'r7c1:31.00=31 r7c2:32.00=32 r7c3:33.00=33 r7c4:34.00=34 r7c5:35.00=35' EOL ...
        ];
    txt = st4Render('testST4Render.stg', 'javaAryAry', 'M', javaAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d Java array')
    
    % This technique should work for 1xn and nx1, too. The template always receives a
    % linear row array in the inner itertion, even with one element if there's only a
    % single column.
    javaAryAry = javaArray('Struct', 1, 5);
    for r=1
        for c=1:5
            javaAryAry(r,c) = javaObject('Struct');
            setfield(javaAryAry(r,c), 'name',  ['r' num2str(r) 'c' num2str(c)]);
            setfield(javaAryAry(r,c), 'value', (c-1)+(r-1)*5+1);
            setfield(javaAryAry(r,c), 'asInt', int32(getfield(javaAryAry(r,c), 'value')));
        end
    end
    expectation = ['r1c1:1.00=1 r1c2:2.00=2 r1c3:3.00=3 r1c4:4.00=4 r1c5:5.00=5' EOL];
    txt = st4Render('testST4Render.stg', 'javaAryAry', 'M', javaAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d Java array')
    % A vertical Java array.
    javaAryAry = javaArray('Struct', 7, 1);
    for r=1:7
        for c=1
            javaAryAry(r,c) = javaObject('Struct');
            setfield(javaAryAry(r,c), 'name',  ['r' num2str(r) 'c' num2str(c)]);
            setfield(javaAryAry(r,c), 'value', (c-1)+(r-1)*1+1);
            setfield(javaAryAry(r,c), 'asInt', int32(getfield(javaAryAry(r,c), 'value')));
        end
    end
    expectation = ['r1c1:1.00=1' EOL ...
                   'r2c1:2.00=2' EOL ...
                   'r3c1:3.00=3' EOL ...
                   'r4c1:4.00=4' EOL ...
                   'r5c1:5.00=5' EOL ...
                   'r6c1:6.00=6' EOL ...
                   'r7c1:7.00=7' EOL ...
                  ];
    txt = st4Render('testST4Render.stg', 'javaAryAry', 'M', javaAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d Java array')

    % The use of an array of Java Map objects proves that a 2-d array with a single column
    % is still decomposed in an array of row arrays: the inner iteration recives an array
    % of a single map object and the iteration of this array yields map objects, which can
    % be used syntactically like structs would. If the row would be represented as a single
    % object (not an array with a single object) then the inner iteration would do a map
    % iteration, yielding the field names of the map rather than the map object as a whole.
    javaAryAry = javaArray('java.util.HashMap', 7, 1);
    for r=1:7
        for c=1
            map = javaObject('java.util.HashMap');
            map.put('name',  ['r' num2str(r) 'c' num2str(c)]);          
            map.put('value', (c-1)+(r-1)*1+1);
            map.put('asInt', int32(map.get('value')));
            javaAryAry(r,c) = map;
        end
    end
    expectation = ['r1c1:1.00=1' EOL ...
                   'r2c1:2.00=2' EOL ...
                   'r3c1:3.00=3' EOL ...
                   'r4c1:4.00=4' EOL ...
                   'r5c1:5.00=5' EOL ...
                   'r6c1:6.00=6' EOL ...
                   'r7c1:7.00=7' EOL ...
                  ];
    txt = st4Render('testST4Render.stg', 'javaAryAry', 'M', javaAryAry);
    assert(strcmp(txt, expectation), 'Test case failed: 2-d with 1 col Java array of Map')

    % Mixture of Octave and Java data objects.
    s = struct( 'name', 'Octave Struct with Java Map'
              , 'id', 12345
              , 'map', javaAryAry
              , 'size', uint8(4)
              );
    expectation = ['Name: ' s.name ' (ID: ' sprintf('%.1f', s.id) ')' EOL ...
                   expectation ...
                   'Size: ' sprintf('%d', s.size) ...
                  ]
    txt = st4Render('testST4Render.stg', 'structWithJavaAryAry', 's', s)
    assert(strcmp(txt, expectation), 'Test case failed: Octave struct with Java object');
    
end % of function testST4Render.


