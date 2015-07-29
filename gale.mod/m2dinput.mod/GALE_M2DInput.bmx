Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.04.29

End Rem
Strict

' 15.04.02 - Initial version
' 15.04.15 - Fixed bug that placed a NULL value in the Lua API register in stead of the actual API
' 15.04.28 - Yeah, stupid me. I had to make sure BMax can read stuff from the API. Well it can now.

Import brl.polledinput
Import brl.graphics
Import Pub.FreeJoy

Import gale.Main
Import tricky_units.MKL_Version

MKL_Version "GALE - GALE_M2DInput.bmx","15.04.29"
MKL_Lic     "GALE - GALE_M2DInput.bmx","Mozilla Public License 2.0"


Global KH[256],KD[256],MH[4],MD[4],JH[16],JD[16]

Type TGALEINPUT ' BLD: Object INP\nInput functions. (This only works on engines build on the M2D driver for GALE).
	
	Method Grab() ' BLD: Grabs all keyboard input, mouse buttons and joypad buttons. Please note that some engines based on GALE may do this automatically at certain events (like the start of a new cycle for example). 
	For Local ak=0 To 255
		KH[ak] = KeyHit(ak)
		KD[ak] = KeyDown(ak)
		If ak<Len(MH)
			MH[ak]=MouseHit(ak)
			MD[ak]=MouseDown(ak)
			EndIf
		If ak<Len(JH)
			JH[ak]=JoyHit(ak)
			JD[ak]=JoyDown(ak)
			EndIf
		Next
	End Method
	
	Method KeyD(a) ' BLD: Is the key held down on the moment of the last grab?
	Return KD[a]
	End Method
	
	Method KeyH(a) ' BLD: Was the key hit at the mometn of the last grab?
	Return KH[a]
	End Method
	
	Method MouseD(a) ' BLD: Was the mouse button held on the moment of the last grab?
	Return MD[a]
	End Method
	
	Method MouseH(a) ' BLD: Was the mouse button hit at the moment of the last grab?
	Return MH[a]
	End Method
	
	Method JoyD(a) ' BLD: was the joypad button held on the moment of the last grab?
	Return JD[a]
	End Method
	
	Method MouseX() ' BLD: Mouse X (does not require grab)
	Return brl.polledinput.MouseX()
	End Method
	
	Method MouseY() ' BLD: MouseY (does not require grab)
	Return brl.polledinput.MouseY()
	End Method	

	Method JoyX() ' BLD: Joystick X position (does not require grab)
	Return pub.freejoy.JoyX()
	End Method

	Method JoyY() ' BLD: Joystick Y position (does not require grab)
	Return pub.freejoy.JoyY()
	End Method
	
	Method MouseHide()
	HideMouse
	End Method
	
	Method MouseShow()
	ShowMouse
	End Method
	
	Method MoveMouse(X,Y) ' BLD: Moves the mouse to specific coordinates
	Return brl.system.MoveMouse(X,Y)
	End Method
	
	Method IncMouse(X,Y) ' BLD: Moves the mouse by x or Y pixels.<p>If the mouse is about to "leave" the screen, this function corrects that.
	Local tx = MouseX()
	Local ty = MouseY()
	tx:+x
	ty:+y
	If tx<0 tx=0
	If ty<0 ty=0
	If tx>=GraphicsWidth() tx=GraphicsWidth()-1
	If ty>=GraphicsHeight() ty=GraphicsHeight()-1
	MoveMouse tx,ty
	End Method

	Field Autograb = 1 ' BLD: Engines automatically calling for Grab should only do so if this value is set to any other value than 0 (by default it's set to 1). 
	
	End Type

Rem
bbdoc: Want to use the API in Blitz? Here you go.
End Rem
Global GALE_INP:TGaleinput = New TGaleInput


Function GrabInput() GALE_INP.Grab; End Function

GALE_Register GALE_INP,"INP"

