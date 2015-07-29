Rem

	(c) 2014 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.04.02

End Rem

' History
' 11.11.16 - Initial Version
' 12.03.31 - Moved to GALE
' 13.06.24 - Any request to a mouse hit greater than 3 will always return 0
' 15.04.02 - Deprecated


Import BRL.PolledInput
Import Gale.Main
Import tricky_units.MKL_Version

MKL_Version "GALE - GALE_Mouse.bmx","15.04.02"
MKL_Lic     "GALE - GALE_Mouse.bmx","Mozilla Public License 2.0"

Private
Type LMouse  ' BLD: Object Mouse\nGets mouse functions.<br>These functions only work properly when the game uses a graphics mode\nWindowed or fullscreen doesn't really matter.<span style='color:#ff0000'>NOTE! This entire object has been deprecated as of version 15.04.02</span>
	
	Method X() ' BLD: Mouse X coordinate
	Return MouseX()
	End Method
	
	Method Y() ' BLD: Mouse Y coordinate
	Return MouseY()
	End Method

	Method Hit(B) ' BLD: Contains a value if button is hit, if not it returns 0
	If B>3 Return 0
	Return MouseHit(B)
	End Method

	Method Down(B) ' BLD: Contains a value if button is held, if not it returns 0
	If B>3 Return 0
	Return MouseDown(B)
	End Method

	End Type

G_LuaRegisterObject New LMouse,"Mouse"
