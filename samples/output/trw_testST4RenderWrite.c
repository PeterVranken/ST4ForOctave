/**
 * @file trw_testST4RenderWrite.c
 * 
 * This file demonstrates the use of both, the Ocatve-to-StringTemplate-interface
 * st4RenderWrite and the library template mod.stg.
 *
 * This file has been created with ST4ForOctave version 1.0.2.67,
 * see https://github.com/PeterVranken/ST4ForOctave.git
 *
 * Copyright (C) 2018-2020 Whoever
 *
 * No rights reserved. Reproduction in whole or in part is permitted
 * without the written consent of the copyright owner.
 */

/*
 * Include files
 */

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include "trw_testST4RenderWrite.h"


/*
 * Defines
 */

 

/*
 * Local type definitions
 */

 

/*
 * Local prototypes
 */

 

/*
 * Data definitions
 */

/** A lookup table for the powers of two. */
const unsigned int trw_tablePow2[32] = {
    [0] = 1u /** 2^0 */,
    [1] = 2u /** 2^1 */,
    [2] = 4u /** 2^2 */,
    [3] = 8u /** 2^3 */,
    [4] = 16u /** 2^4 */,
    [5] = 32u /** 2^5 */,
    [6] = 64u /** 2^6 */,
    [7] = 128u /** 2^7 */,
    [8] = 256u /** 2^8 */,
    [9] = 512u /** 2^9 */,
    [10] = 1024u /** 2^10 */,
    [11] = 2048u /** 2^11 */,
    [12] = 4096u /** 2^12 */,
    [13] = 8192u /** 2^13 */,
    [14] = 16384u /** 2^14 */,
    [15] = 32768u /** 2^15 */,
    [16] = 65536u /** 2^16 */,
    [17] = 131072u /** 2^17 */,
    [18] = 262144u /** 2^18 */,
    [19] = 524288u /** 2^19 */,
    [20] = 1048576u /** 2^20 */,
    [21] = 2097152u /** 2^21 */,
    [22] = 4194304u /** 2^22 */,
    [23] = 8388608u /** 2^23 */,
    [24] = 16777216u /** 2^24 */,
    [25] = 33554432u /** 2^25 */,
    [26] = 67108864u /** 2^26 */,
    [27] = 134217728u /** 2^27 */,
    [28] = 268435456u /** 2^28 */,
    [29] = 536870912u /** 2^29 */,
    [30] = 1073741824u /** 2^30 */,
    [31] = 2147483648u /** 2^31 */,

}; 

/*
 * Function implementation
 */

/**
 * Compute a power of two by simple table lookup.
 *   @return
 * Get the integer value \a 2^power.
 *   @param power
 * The power of two to compute as an integer in the range 0..31. Boundary check is
 * done by assertion.
 */
unsigned int trw_pow2(unsigned int power)
{
    assert(power < 32);
    return trw_tablePow2[power];

} /* End of trw_pow2 */
