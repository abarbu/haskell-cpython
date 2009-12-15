-- Copyright (C) 2009 John Millikin <jmillikin@gmail.com>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
{-# LANGUAGE ForeignFunctionInterface #-}
module CPython.Float
	( Float
	, floatType
	, check
	, checkExact
	, toDouble
	, fromDouble
	) where
import Prelude hiding (Float)
import CPython.Internal

#include <Python.h>
#include <hscpython-shim.h>

newtype Float = Float (ForeignPtr Float)
instance ObjectClass Float where
	toObject (Float x) = Object x
	fromForeignPtr = Float

{# fun hscpython_PyFloat_Type as floatType
	{} -> `Type' peekStaticObject* #}

{# fun hscpython_PyFloat_Check as check
	`ObjectClass self ' =>
	{ withObject* `self'
	} -> `Bool' #}

{# fun hscpython_PyFloat_CheckExact as checkExact
	`ObjectClass self ' =>
	{ withObject* `self'
	} -> `Bool' #}

{# fun PyFloat_AsDouble as toDouble
	{ withObject* `Float'
	} -> `Double' realToFrac #}

{# fun PyFloat_FromDouble as fromDouble
	{ realToFrac `Double'
	} -> `Float' stealObject* #}
