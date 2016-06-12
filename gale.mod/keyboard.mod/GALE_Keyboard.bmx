Rem
        GALE_Keyboard.bmx
	(c) 2014, 2015 Jeroen Petrus Broks - (This file is deprecated).
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem'

	(c) 2014 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.04.02

End Rem

Rem
Updates
13.01.07 - Added Code() method to the TL_Keyboard type
14.03.25 - Updated the flush routine.
15.04.02 - Deprecated
16.06.11 - Blocked content for BlitzMax NG. This module is deprecated after all!
         - Removed dupe license block
End Rem

?Not bmxng

Import brl.PolledInput
Import pub.freejoy
Import GALE.MaxLua4GALE
Import Tricky_units.MKL_Version

Include  "Key_Name2Code.bmx"

Type TL_Keyboard ' BLD: Object Key\nKeyboard features<br><span style='color:#ff0000'>NOTE! This entire object has been deprecated as of version 15.04.02</span>

	Method Down(Code)   ' BLD: 1 if key is down, 0 if not. Please note that Lua doesn't count 0 as false!!!
	Return KeyDown(Code)
	End Method
	
	Method Hit(Code) ' BLD: 1 if key is hit, 0 if not. Please note that Lua doesn't count 0 as false!!!
	Return KeyHit(Code) 
	End Method

	Method Wait() 'BLD: Waits until a key is pressed and returns the key code.
	Return WaitKey() 
	End Method

	Method Read() ' BLD: If a key is pressed return the code, if no key is pressed return 0<br>Note, this routine can slow your project down a little. You have to decide for yourself if this is significant
	Local Ret = 0
	For Local ak=0 To 255
		If KeyHit(ak) Ret=Ak
		Next
	Return Ret
	End Method
	
	Method GetChar() ' BLD: Returns the character code of a pressed key (a queue is used for that in case multiple keys are hit)
	Return brl.polledinput.GetChar()
	End Method
	
	Method WaitChar() ' BLD: Waits until a key is pressed and retuns its character code
	Return brl.polledinput.WaitChar()
	End Method
	
	Method Flush(KEYONLY=0) ' BLD: Flushes the keyboard and mouse buffer.
	FlushKeys
	If Not KEYONLY
	   FlushMouse
	   FlushJoy
	   EndIf
	End Method
	
	Method Terminate() ' BLD: Returns 1 if the user made a request to terminate the program, returns 0 if such a request was not made
	Return AppTerminate()
	End Method
	
	Method Code(Name$) ' BLD: Returns a BlitzMax keycode name into a number that Key.Down() and Key.Hit() etc can understand. You can see the names in the BlitzMax documentation as the names are the same as the names of the constants listed in there.
	Return Key_Name2Code(Name)
	End Method
	
	End Type
	
G_LuaRegisterObject New TL_Keyboard,"Key"
	
	
MKL_Version "GALE - GALE_Keyboard.bmx","15.09.02"
MKL_Lic     "GALE - GALE_Keyboard.bmx","Mozilla Public License 2.0"

?
