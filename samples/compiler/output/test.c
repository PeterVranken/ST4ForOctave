/**
 * @file test.c
 *
 * C code generated from program test.fcl written in a fictive
 * computer language.
 *
 * This file has been created with help of st4Render.m, see
 * https://sourceforge.net/projects/stringtemplate-for-octave/
 *
 * Copyright (C) 2018 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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
    int z=0, u=0, y=0, x=0, show=0, cntLoops=0, testOkay=0, a=0, b=0;


    /* The following variables is not assigned any value in the source program
       test.fcl. We consider them system inputs and connect them to the
       application interface. */
    int _idxArg;
    for(_idxArg=1; _idxArg+1<noArgs; _idxArg+=2)
    {
       if(strcmp(argAry[_idxArg], "z") == 0)	z = atoi(argAry[_idxArg+1]);
       if(strcmp(argAry[_idxArg], "u") == 0)	u = atoi(argAry[_idxArg+1]);
    }


    /* Definition of temporary variables for expression evaluation. */
    int _R00, _R01, _R02, _R03;

    /* A simple test program for the compiler for our fictive computer language. */
    load(_R02, y)
    mul(_R02, -1)
    load(_R01, 23)
    sub(_R01, _R02)
    eq(_R01, 0)
    load(_R03, z)
    mul(_R03, -1)
    load(_R02, -7)
    add(_R02, _R03)
    mul(_R01, _R02)
    load(_R00, 6)
    add(_R00, _R01)
    add(_R00, 0)
    load(_R01, x)
    mod(_R01, 23)
    add(_R00, _R01)
    load(_R01, z)
    mul(_R01, u)
    add(_R00, _R01)
    add(_R00, z)
    add(_R00, u)
    store(x, _R00)
    store(show, x)
    store(cntLoops, 0)
    load(_R00, x)
    lt(_R00, 0)
    breq(_R00, _else_1)
    load(_R00, x)
    mul(_R00, -1)
    store(x, _R00)
    jmp(_end_if_1)
    _else_1:
    _end_if_1:
    load(_R00, x)
    gt(_R00, 0)
    load(_R01, x)
    eq(_R01, 0)
    or(_R00, _R01)
    store(testOkay, _R00)
    breq(testOkay, _else_2)
    store(x, 99)
    jmp(_end_if_2)
    _else_2:
    _end_if_2:
    _loop_3:
    /* Since the loop itself doesn't have a condition will we always find */
    /* an if clause with break statement somewhere inside the loop */
    load(_R00, x)
    eq(_R00, 0)
    breq(_R00, _else_4)
    store(y, u)
    jmp(_exit_loop_3)
    jmp(_end_if_4)
    _else_4:
    load(_R01, x)
    gt(_R01, 0)
    load(_R00, x)
    sub(_R00, _R01)
    store(x, _R00)
    load(_R00, x)
    leq(_R00, 0)
    breq(_R00, _else_5)
    jmp(_exit_loop_3)
    jmp(_end_if_5)
    _else_5:
    _end_if_5:
    _end_if_4:
    load(_R00, cntLoops)
    add(_R00, 1)
    store(cntLoops, _R00)
    load(_R00, y)
    add(_R00, x)
    store(y, _R00)
    /* An empty if or else branch should be possible */
    breq(testOkay, _else_6)
    jmp(_end_if_6)
    _else_6:
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    load(_R00, testOkay)
    eq(_R00, 0)
    store(testOkay, _R00)
    _end_if_6:
    load(_R00, testOkay)
    eq(_R00, 0)
    breq(_R00, _else_7)
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    load(_R00, testOkay)
    eq(_R00, 0)
    store(testOkay, _R00)
    jmp(_end_if_7)
    _else_7:
    _end_if_7:
    load(_R00, x)
    leq(_R00, 0)
    breq(_R00, _else_8)
    load(_R00, x)
    sub(_R00, 1)
    store(x, _R00)
    store(testOkay, 0)
    jmp(_end_if_8)
    _else_8:
    _end_if_8:
    /* Test all the operations. Operations on literals are evaluated at */
    /* compile time, operations with one variable at least are evaluated at */
    /* run time. We need to test both situations. */
    store(a, 100)
    /* Surely greater than x */
    store(b, 0)
    /* Surely less than x */
    /* Test of run time expressions */
    load(_R01, a)
    or(_R01, x)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, x)
    eq(_R02, 0)
    load(_R01, a)
    or(_R01, _R02)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    eq(_R01, 0)
    load(_R02, x)
    eq(_R02, 0)
    or(_R01, _R02)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    eq(_R01, 0)
    or(_R01, x)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    and(_R01, b)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, b)
    eq(_R02, 0)
    load(_R01, a)
    and(_R01, _R02)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    eq(_R01, 0)
    and(_R01, b)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    eq(_R01, 0)
    load(_R02, b)
    eq(_R02, 0)
    and(_R01, _R02)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    add(_R01, b)
    add(_R01, 1)
    eq(_R01, 101)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    sub(_R01, a)
    eq(_R01, -100)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    sub(_R01, b)
    load(_R02, b)
    sub(_R02, a)
    mul(_R02, -1)
    eq(_R01, _R02)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    mul(_R01, b)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, b)
    add(_R02, 12)
    load(_R01, a)
    mul(_R01, _R02)
    eq(_R01, 1200)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, 12)
    div(_R01, a)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, 1300)
    div(_R01, a)
    eq(_R01, 13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, -1300)
    div(_R01, a)
    eq(_R01, -13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    mul(_R02, -1)
    load(_R01, -1300)
    div(_R01, _R02)
    eq(_R01, 13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    mul(_R02, -1)
    load(_R01, 1300)
    div(_R01, _R02)
    eq(_R01, -13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    div(_R01, 1300)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, 1313)
    mod(_R01, a)
    eq(_R01, 13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    /* Sign of modulo is defined to be sign of first operand */
    load(_R01, -1313)
    mod(_R01, a)
    eq(_R01, -13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    mul(_R02, -1)
    load(_R01, -1313)
    mod(_R01, _R02)
    eq(_R01, -13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    mul(_R02, -1)
    load(_R01, 1313)
    mod(_R01, _R02)
    eq(_R01, 13)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, 1300)
    mod(_R01, a)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    mod(_R01, 1300)
    eq(_R01, a)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    mod(_R01, 17)
    load(_R03, a)
    div(_R03, 17)
    load(_R02, 17)
    mul(_R02, _R03)
    add(_R01, _R02)
    eq(_R01, a)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    lt(_R01, a)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    gt(_R01, a)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    eq(_R01, a)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    sub(_R02, 100)
    load(_R01, b)
    eq(_R01, _R02)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    neq(_R01, a)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    sub(_R02, 100)
    load(_R01, b)
    neq(_R01, _R02)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, b)
    leq(_R01, b)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, b)
    add(_R02, 1)
    load(_R01, b)
    leq(_R01, _R02)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, b)
    sub(_R02, 1)
    load(_R01, b)
    leq(_R01, _R02)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R01, a)
    geq(_R01, a)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    add(_R02, 1)
    load(_R01, a)
    geq(_R01, _R02)
    eq(_R01, 0)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    load(_R02, a)
    sub(_R02, 1)
    load(_R01, a)
    geq(_R01, _R02)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    /* Test of compile time expressions. This is a single (assignment) */
    /* statement and you must not add a comment somewhere in the middle. In */
    /* our language definition a comment always is a separate statement. */
    load(_R01, 100)
    or(_R01, x)
    eq(_R01, 1)
    load(_R00, testOkay)
    and(_R00, _R01)
    load(_R02, x)
    eq(_R02, 0)
    load(_R01, 100)
    or(_R01, _R02)
    eq(_R01, 1)
    and(_R00, _R01)
    load(_R02, x)
    eq(_R02, 0)
    load(_R01, 0)
    or(_R01, _R02)
    eq(_R01, 0)
    and(_R00, _R01)
    load(_R01, 0)
    or(_R01, x)
    eq(_R01, 1)
    and(_R00, _R01)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    and(_R00, 1)
    store(testOkay, _R00)
    jmp(_loop_3)
    _exit_loop_3:
    load(_R01, cntLoops)
    eq(_R01, 98)
    load(_R00, testOkay)
    and(_R00, _R01)
    store(testOkay, _R00)
    /* A final comment */


    /* All variables are printed at the end as a kind of program output. */
    printf("y = %d\n", y);
    printf("x = %d\n", x);
    printf("show = %d\n", show);
    printf("cntLoops = %d\n", cntLoops);
    printf("testOkay = %d\n", testOkay);
    printf("a = %d\n", a);
    printf("b = %d\n", b);


    return 0;

} /* End of main */