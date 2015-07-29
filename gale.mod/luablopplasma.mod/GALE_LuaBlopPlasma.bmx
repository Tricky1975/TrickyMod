Rem
/* 
  

  Copyright (C) 2014 Jeroen P. Broks

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



Version: 15.02.14

End Rem
Strict

Rem

This is a GALE wrapper for the BlopPlasma routines.
The original routine was written by ImaginaryHuman as an demonstration to create an effect with as little lines as of code as possible. 
He decided to release it into the public domain.
I took on this routine, fixed some bugs and added some extra functionality to it, turned it into a BlitzMax Module and released under the terms of the zLib language.

When I needed this plasma routine for "The Abyss" dungeon in the 'Secrets of Dyrt' I decided to make this wrapper for GALE and this wrapper too has been released under the terms of the zLib language.

End Rem

Import GALE.Main
IMPORT TRICKY_UNITS.BLOPPLASMA


Type GALE_O_BlopPlasma  ' BLD: Object BlopPlasma\nThis object contains features to create a plasma

    Method InitBlopPlasma(Blops,Width,Height,Rad) ' BLD: Initizes BlopPlasma. The other functions cannot be used without doing this first. Please note, best is to only use it once at the startup of your entire program and not later. And best is to never use it twice or more. The results might get a little spooky.
	If Not Blops  Blops=24
	If Not Width  Width=640
	If Not height Height=480
	If Not Rad    Rad=500
	tricky_units.blopplasma.InitBlopPlasma(Blops,Width,Height,Rad)
	End Method
	
	Method NewBlopPlasma(Blops,Width,Hight) ' BLD: This function should set new values to a plasma. As you cannot use InitBlopPlasma again. Please note, the radius cannot be changed after being chosen with InitBlopPlasma
	tricky_units.blopplasma.NewBlopPlasma(Blops,Width,Hight) 
	End Method
	
	Method Draw(Blops) ' BLD: Simple drawplasma function. If Blops is not set it will use the default value set by InitBlopPlasma or NewBlopPlasma.
	DrawBlopPlasma Blops
	End Method
	
	Method DrawCol(R,G,B,Blops) ' BLD: This allows you to set the color of the plasma and draw it accordingly. Please note this routine works on percentage, so R,G and B must be values between 0 and 100 in stead of 0-255.
	DrawBlopPlasmaCol Double(R)/100,Double(G)/100,Double(B)/100,Blops
	End Method
		
	End Type

GALE_Register New GALE_O_BlopPlasma,"BlopPlasma"
