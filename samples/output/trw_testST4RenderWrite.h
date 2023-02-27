#ifndef TRW_TESTST4RENDERWRITE_DEFINED
#define TRW_TESTST4RENDERWRITE_DEFINED
/**
 * @file trw_testST4RenderWrite.h
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

#include <stdbool.h>
#include <stdint.h>


/*
 * Defines
 */

 

/*
 * Type definitions
 */

/** The colors, which are used in our program. */
typedef enum trw_color_t {
    trw_enumColor_white /** white = 0 */,
    trw_enumColor_red /** red = 1 */,
    trw_enumColor_green /** green = 2 */,
    trw_enumColor_blue /** blue = 3 */,
    trw_enumColor_purple /** purple = 4 */,
    trw_enumColor_brown /** brown = 5 */,
    trw_enumColor_grey /** grey = 6 */,
    trw_enumColor_black /** black = 7 */,

} trw_color_t; 

/*
 * Data declarations
 */

/** A lookup table for the powers of two. */
extern const unsigned int trw_tablePow2[32];
 

/*
 * Function declarations
 */

/** Compute a power of two by simple table lookup. */
unsigned int trw_pow2(unsigned int power);

#endif // !defined(TRW_TESTST4RENDERWRITE_DEFINED)