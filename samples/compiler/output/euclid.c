/**
 * @file euclid.c
 *
 * C code generated from program euclid.fcl written in a fictive
 * computer language.
 *
 * This file has been created with help of st4Render.m, see
 * https://github.com/PeterVranken/ST4ForOctave.git
 *
 * Copyright (C) 2015-2023 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Include files
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


/*
 * Defines
 */

/* Definition of the pseudo assembler statements. */
#define jmp(target)         {goto target;}
#define breq(cond,target)   {if((cond)==0) goto target;}
#define load(R,val)         {(R) = (val);}
#define store(sym,val)      {(sym) = (val);}
#define eq(R,op)            {(R) = (R)==(op);}
#define neq(R,op)           {(R) = (R)!=(op);}
#define lt(R,op)            {(R) = (R)<(op);}
#define leq(R,op)           {(R) = (R)<=(op);}
#define gt(R,op)            {(R) = (R)>(op);}
#define geq(R,op)           {(R) = (R)>=(op);}
#define or(R,op)            {(R) = (R)||(op);}
#define and(R,op)           {(R) = (R)&&(op);}
#define add(R,op)           {(R) += (op);}
#define sub(R,op)           {(R) -= (op);}
#define mul(R,op)           {(R) *= (op);}
#define div(R,op)           {(R) /= (op);}
#define mod(R,op)           {(R) %= (op);}


/*
 * Local type definitions
 */


/*
 * Local prototypes
 */


/*
 * Data definitions
 */


/*
 * Function implementation
 */

/**
 * Application main entry point. The code from the fictive computer language can be run
 * with command line provided variable values. All variables, which do not get any value in
 * the computer program itself are considered external interfaces and are connected to the
 * command line. Each two consecutive command line arguments are a pair of variable name
 * and variable value. The value is a signed integer value and it is propagated to the
 * program variable of given name.
 *   @return
 * Always 0, no error conditions are implemented.
 *   @param noArgs
 * Number of command line arguments. Need to be even.
 *   @param argAry
 * Array of command line arguments.
 */
int main(int noArgs, const char * argAry[])
{
    /* Initialization of required variables. */
    int i=0, j=0, a=0, b=0, h=0;


    /* The following variables is not assigned any value in the source program
       euclid.fcl. We consider them system inputs and connect them to the
       application interface. */
    int _idxArg;
    for(_idxArg=1; _idxArg+1<noArgs; _idxArg+=2)
    {
       if(strcmp(argAry[_idxArg], "i") == 0)	i = atoi(argAry[_idxArg+1]);
       if(strcmp(argAry[_idxArg], "j") == 0)	j = atoi(argAry[_idxArg+1]);
    }


    /* Definition of temporary variables for expression evaluation. */
    int _R00;

    /* Find the greatest common divisor of two integer numbers. */
    /* An implementation of Euclid's algorithm. */
    /* See http://de.wikipedia.org/wiki/Euklidischer_Algorithmus and particularly */
    /* http://de.wikipedia.org/wiki/Euklidischer_Algorithmus#Beschreibung_durch_Pseudocode */
    /* (visited on Mar 6, 2014) for details on Euclid's algorithm. */
    /* Inputs are i and j. */
    store(a, i)
    store(b, j)
    _loop_1:
    load(_R00, b)
    eq(_R00, 0)
    breq(_R00, _else_2)
    jmp(_exit_loop_1)
    jmp(_end_if_2)
    _else_2:
    _end_if_2:
    /* h always has the sign of a. */
    load(_R00, a)
    mod(_R00, b)
    store(h, _R00)
    store(a, b)
    store(b, h)
    jmp(_loop_1)
    _exit_loop_1:
    /* a holds the result. */


    /* All variables are printed at the end as a kind of program output. */
    printf("a = %d\n", a);
    printf("b = %d\n", b);
    printf("h = %d\n", h);


    return 0;

} /* End of main */