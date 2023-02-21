/**
 * @file SimpleLogger.java
 * Simple substitute for the log4j logger, which is missing in this tiny project. We
 * redirect all output to the console.
 *
 * Copyright (C) 2018 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
/* Interface of class SimpleLogger
 *   SimpleLogger
 */

package info;

import java.util.*;

/**
 * Simple substitute for the log4j logger.
 *   We redirect all output to the Octave console.
 */

public class SimpleLogger
{
    /** The log level or verbosity. */
    enum Level
    {
        /* Definition of enumeration values with numeric value. */
          /** (0) No logging at all */                              OFF(0)
        , /** (1) Print only fatal error messages */                FATAL(1)  
        , /** (2) Print errors and the more severe messages */      ERROR(2)
        , /** (3) Print warnings and the more severe messages */    WARN(3) 
        , /** (4) Print informative and more severe messages */     INFO(4) 
        , /** (5) Print all messages, careful: tons of output */    DEBUG(5)
        ;
        
        /** Storage space for the numeric value of each enumeration value. */
        private final int numVal;

        /** Implicitly called constructor for each enumeration value.
              @param numVal The numeric representation of an enumerated value. */
        Level(int numVal)
            {this.numVal = numVal;}

        /** Getter for numeric representation of enumeration value.
              @return Get the numeric value as an integer. */
        public int value()
            {return numVal;}

    } /* End of sub-class Level. */
    
    /** The log level currently in use by the logger. */
    public static Level _level = Level.INFO;

//    /**
//     * A new instance of SimpleLogger is created.
//     *   @throws {@inheritDoc}
//     * The exception is thrown if 
//     *   @param i
//     * The ... or: {@inheritDoc}
//     *   @see SimpleLogger#
//     */
//    TODO: Fill in the method header.
//    public SimpleLogger()
//    {
//    } /* End of SimpleLogger.SimpleLogger. */


    /**
     * Adjust the logging level. By defaukt it is INFO but you can set any defined value.
     * See {@link SimpleLogger.Level}.
     *   @param level
     * The new logging level.
     */
    public static void setLevel(Level level)
        {_level = level;}

    /**
     * Adjust the logging level. By defaukt it is INFO but you can set any defined value.
     * Here by a numeric value rather than as enumeration value.
     * See {@link SimpleLogger.Level}.
     *   @param level
     * The new logging level as an interger in the range 0..5.
     */
    public static void setLevel(int level)
    {
        switch(level)
        {
        case 0: _level = Level.OFF; break;
        case 1: _level = Level.FATAL; break;
        case 2: _level = Level.ERROR; break;
        case 3: _level = Level.WARN; break;
        case 4: _level = Level.INFO; break;
        case 5: _level = Level.DEBUG; break;
        default: assert false: "Invalid logging level used. 0..5 are permitted";
        }
    }
    
    
    /**
     * Write a message of severity FATAL.
     *   @param msg
     * The message as a simple String.
     */
    public static void fatal(String msg)
    {
        if(_level.value() >= Level.FATAL.value())
            System.out.println("FATAL: " + msg);

    } /* End of fatal */

    /**
     * Write a message of severity ERROR.
     *   @param msg
     * The message as a simple String.
     */
    public static void error(String msg)
    {
        if(_level.value() >= Level.ERROR.value())
            System.out.println("ERROR: " + msg);

    } /* End of error */

    /**
     * Write a message of severity WARN.
     *   @param msg
     * The message as a simple String.
     */
    public static void warn(String msg)
    {
        if(_level.value() >= Level.WARN.value())
            System.out.println("WARN: " + msg);

    } /* End of warn */

    /**
     * Write a message of severity INFO.
     *   @param msg
     * The message as a simple String.
     */
    public static void info(String msg)
    {
        if(_level.value() >= Level.INFO.value())
            System.out.println(msg);

    } /* End of info */

    /**
     * Write a message of severity DEBUG.
     *   @param msg
     * The message as a simple String.
     */
    public static void debug(String msg)
    {
        if(_level.value() >= Level.DEBUG.value())
            System.out.println("DEBUG: " + msg);

    } /* End of debug */

    /**
     * Write a message of a given severity or verbositiy level.
     *   @param msg
     * The message as a simple String.
     *   @param level
     * The severity of the message.
     */
    public static void log(String msg, Level level)
    {
        if(level == SimpleLogger.Level.FATAL)
            fatal(msg);
        else if(level == SimpleLogger.Level.ERROR)
            error(msg);
        else if(level == SimpleLogger.Level.WARN)
            warn(msg);
        else if(level == SimpleLogger.Level.INFO)
            info(msg);
        else if(level == SimpleLogger.Level.DEBUG)
            debug(msg);
            
    } /* End of log. */


    /**
     * Write a message of a given severity or verbositiy level.
     *   @param msg
     * The message as a simple String.
     *   @param level
     * The severity of the message as an integer.
     */
    public static void log(String msg, int level)
    {
        if(level == SimpleLogger.Level.FATAL.value())
            fatal(msg);
        else if(level == SimpleLogger.Level.ERROR.value())
            error(msg);
        else if(level == SimpleLogger.Level.WARN.value())
            warn(msg);
        else if(level == SimpleLogger.Level.INFO.value())
            info(msg);
        else if(level == SimpleLogger.Level.DEBUG.value())
            debug(msg);
            
    } /* End of log. */


} /* End of class SimpleLogger definition. */





