program = 'test'
[success msg p] = compiler([program '.c'], [program '.fcl']);
if ~success
    return
end
edit([program '.c'])
system(['gcc -DNDEBUG -o ' program '.exe ' program '.c -mavx -Wa,-a=' program '.lst -g -O2'])
dir([program '*'])
