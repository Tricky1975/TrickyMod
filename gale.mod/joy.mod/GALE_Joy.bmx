Rem
/* 
  GALE - Joy (DEPRECATED)

  Copyright (C) 2013, 2015 JPB from B

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/



Version: 15.04.02

End Rem

' 13.06.24 - Any button request higher than 15 will return 0
' 15.04.02 - Deprecated

Strict

Import pub.freejoy
Import gale.Main
Import tricky_units.MKL_Version


Type LuaJoy ' BLD: Object Joy\nHere are some routines for the joypad (it's not complete, more may be added over time). What is very important to note is that since my main system is a Mac, and nearly none of the controller manufacturers is willing to create drivers for Mac, I could not test thoroughly if this all works. If somebody knows a controller that DOES work on Mac, I'd be eternaly grateful.<p><span style='color:#ff0000'>NOTE! This entire object has been deprecated as of version 15.04.02</span>
 
	Method Count() ' BLD: Count Joysticks/pads
	Return JoyCount()
	End Method
	
	Method X(port=0) ' BLD: X
	Return JoyX(port)
	End Method

	Method Y(port=0) ' BLD: Y
	Return JoyY(port)
	End Method
	
	Method Hit(Button,Port=0) ' BLD: Contains 1 if button is pressed. 0 if not. (Note that Lua considers both values as 'true')
	If button>15 Or port>15 Return 0
	Return JoyHit(button,port)
	End Method
	
	Method Down(Button,Port=0) ' BLD: Contains 1 if a button is held down and 0 if not. (Note that Lua considers both values as 'true')
	If button>15 Or port>15 Return 0
	Return JoyDown(button,port)
	End Method
	
	End Type
	
GALE_Register New LuaJoy,"Joy"
   

MKL_Version "GALE - GALE_Joy.bmx","15.04.02"
MKL_Lic     "GALE - GALE_Joy.bmx","zLIB License"
