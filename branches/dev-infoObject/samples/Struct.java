/**
 * @file Struct.java
 * Test of Octave interface to StringTemplate: A simple struct to demonstrate access to
 * fields from the template. An object of this struct can be instantiated from the Octave
 * command line and passed in to StringTemplate via the Octave Java interface. See
 * runOctaveTest.m and testSTGroup.stg for more.
 *
 * Copyright (C) 2015 Peter Vranken (mailto:Peter_Vranken@Yahoo.de)
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
/* Interface of class Struct
 *   Struct
 */

//package ;

import java.util.*;

public class Struct
{
    public String name = "<name not set>";
    public int asInt = 0;
    public double value = 0.0;
}
