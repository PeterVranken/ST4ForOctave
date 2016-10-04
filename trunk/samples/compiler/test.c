/**
 * @file test.c
 * C code generated from program test.fcl written in a fictive
 * computer language.
 *
 * Copyright (C) 2016 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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
/* Module interface
 * Local functions
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
#define brneq(cond,target)  {if(cond) goto target;}
#define load(R,val)         {R = val;}
#define store(sym,val)      {sym = val;}
#define eq(R,op)            {R = R==op;}
#define neq(R,op)           {R = R!=op;}
#define lt(R,op)            {R = R<op;}
#define leq(R,op)           {R = R<=op;}
#define gt(R,op)            {R = R>op;}
#define geq(R,op)           {R = R>=op;}
#define or(R,op)            {R ||= op;}
#define and(R,op)           {R &&= op;}
#define add(R,op)           {R += op;}
#define sub(R,op)           {R -= op;}
#define mul(R,op)           {R *= op;}
#define div(R,op)           {R /= op;}
#define mod(R,op)           {R %= op;}


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
 * command line. Each two consequetive command line arguments are a pair of variable name
 * and variable value. The value is a signed integer value and it is propgated to the
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
    /* Map of variables. */
    int cntLoops=0, show=0, x=0, y=0, z=0;

    /* The following variables is not assigned any value in the source program
       test.fcl. We consider them system inputs and connect them
       to the application interface. */
    int _idxArg;
    for(_idxArg=1; _idxArg+1<noArgs; _idxArg+=2)
    {
        if(strcmp(argAry[_idxArg], "z") == 0)	z = atoi(argAry[_idxArg+1]);
    }

    /* Definition of temporary variables for expression evaluation. */
    int _R00, _R01, _R02, _R03, _R04, _R05, _R06, _R07;

    /* A simple test program */
    load(_R02, -1)
    mul(_R02, y)
    load(_R01, 23)
    sub(_R01, _R02)
    load(_R03, -1)
    mul(_R03, z)
    load(_R02, -7)
    add(_R02, _R03)
    mul(_R01, _R02)
    load(_R00, 38)
    add(_R00, _R01)
    add(_R00, 1)
    load(_R01, x)
    mod(_R01, 23)
    add(_R00, _R01)
    store(x, _R00)
    store(show, x)
    store(cntLoops, 0)
    load(_R00, x)
    lt(_R00, 0)
    brneq(_R00, _if_1)
    jmp(_end_if_1)
    _if_1:
    load(_R00, -1)
    mul(_R00, x)
    store(x, _R00)
    _end_if_1:
    _loop_2:
    load(_R00, cntLoops)
    add(_R00, 1)
    store(cntLoops, _R00)
    /* Since the loop itself doesn't have a condition will we always find */
    /* an if clause with break statement somewhere inside the loop */
    load(_R00, x)
    leq(_R00, 0)
    brneq(_R00, _if_3)
    jmp(_end_if_3)
    _if_3:
    store(y, 9)
    jmp(_exit_loop_2)
    _end_if_3:
    load(_R00, y)
    add(_R00, x)
    store(y, _R00)
    /* An empty if or else branch should be possible */
    load(_R00, x)
    eq(_R00, 1)
    brneq(_R00, _if_4)
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    jmp(_end_if_4)
    _if_4:
    _end_if_4:
    load(_R00, x)
    eq(_R00, 2)
    brneq(_R00, _if_5)
    jmp(_end_if_5)
    _if_5:
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    _end_if_5:
    load(_R00, x)
    gt(_R00, 0)
    brneq(_R00, _if_6)
    jmp(_end_if_6)
    _if_6:
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    _end_if_6:
    jmp(_loop_2)
    _exit_loop_2:
    /* A final comment */


    /* All variables are printed at the end as a kind of program output. */
    printf("cntLoops = %d\n", cntLoops);
    printf("show = %d\n", show);
    printf("x = %d\n", x);
    printf("y = %d\n", y);

    return 0;
}