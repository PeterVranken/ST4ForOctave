% Generate C code from a data dictionary
dd(1) = struct('name', 'signalA', 'type', 'uint8_t', 'gain', 2^-5, 'offset', 0);
dd(2) = struct('name', 'signalB', 'type', 'int16_t', 'gain', 2^1, 'offset', -10);
dd(3) = struct('name', 'signalC', 'type', 'int32_t', 'gain', 1, 'offset', 0);
cCode = st4Render('wikiSample.stg', 'cCode', 'dd', dd);
hCode = st4Render('wikiSample.stg', 'hCode', 'dd', dd);
fprintf(['C source file: ' char(10) cCode]);
fprintf(['C header file: ' char(10) hCode]);