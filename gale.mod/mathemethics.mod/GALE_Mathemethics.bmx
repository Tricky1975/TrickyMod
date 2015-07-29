Rem
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is (c) Jeroen P. Broks.
 *
 * The Initial Developer of the Original Code is
 * Jeroen P. Broks.
 * Portions created by the Initial Developer are Copyright (C) 2015
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 15.02.18

End Rem


' History
' 11.11.17 - Initial Version
' 12.03.31 - Moved to GALE
' 12.04.08 - Added distance calcuation, with very much thanks to Pythagoras :)
' 13.12.26 - Fixed a reference to the new GALE setup.
' 15.01.23 - Manually changed something caused by a bug that should prevent me to, which cannot exist, and yet it does.... ?????



Strict
Import brl.Random
Import Gale.Main
Import brl.math
Import brl.retro

'Import "../MKL_Version.bmx"
Import tricky_units.MKL_Version
Import tricky_units.pythagoras

MKL_Version "GALE - GALE_Mathemethics.bmx","15.02.18"
MKL_Lic     "GALE - GALE_Mathemethics.bmx","Mozilla Public License 2.0"

SeedRnd MilliSecs()

Type LUAMATH  ' BLD: Object Math\nSome mathematical functions<p>Please note that as of version 15.02.18 most of this object has been deprecated as Lua already provides those routines itself and somewhere in 2016 or in the years later they might be removed. The randomizer and the routines based on the pythagorean theorism have remained. The object itself is not deprecated and may even be expanded in the future when there are calculations I don't expect to see in the in the Lua default features ever.
	
	Method Rand(MinV,MaxV) ' BLD: Retuns a random number between MinV and MaxV<br><br>For the guys who know about seeding. This happens automatically when the game starts up.
	Return Brl.Random.Rand(MinV,MaxV)
	End Method
	
	Method New() ' Should not be documented in BLD. It will seed the randomizer as soon as this object is called in a project using GALE.
	SeedRnd MilliSecs()
	End Method
	
	Method Sin:Double(V:Double) ' BLD: Sine<p>This function is deprecated as of version 15.02.18, and may be removed somewhere in 2016 or a few years later. Use the Lua variant in stead.
	Return BRL.Math.Sin(V)
	End Method

	Method Cos:Double(V:Double) ' BLD: Cosine<p>This function is deprecated as of version 15.02.18, and may be removed somewhere in 2016 or a few years later. Use the Lua variant in stead.
	Return BRL.Math.Cos(V)
	End Method
	
	Field TanCrash = 0 	' BLD: When set to any other value than 0, the game will crash when an invalid tangent is asked for
	
	Method Tan:Double(V:Double) ' BLD: Tangent<p>This function is deprecated as of version 15.02.18, and may be removed somewhere in 2016 or a few years later. Use the Lua variant in stead.
	If Cos(V)=0
		Print "Tangent of "+V+" doesn't exist!"
		If TanCrash
			Throw "Invalid Tangend: "+V
			End
			EndIf
		EndIf	
	Return BRL.Math.Tan(V)
	End Method
	
	Method AlwaysPos:Double(V:Double)   ' BLD: Will turn a number into a positive number if it were a negative<p>This function is deprecated as of version 15.02.18, and may be removed somewhere in 2016 or a few years later. Use the Lua's math.abs in stead.
	'Print "AP: "+V   ' Debug line
	If V<0 Return V*-1 Else Return V
	End Method
	
	Method Dist2D:Double(x1:Double,y1:Double,x2:Double,y2:Double) ' BLD: Will calculate the distance between two points in a 2D image using the Pythagorean theorism
	Return Distance2D(x1,y1,x2,y2)
	End Method
	
	Method Dist3D:Double(x1:Double,y1:Double,z1:Double,x2:Double,y2:Double,z2:Double) ' BLD: Will calculate the distance between two points in a 3D image using the Pythagorean theorism
	Return Distance3D(x1,y1,z1,x2,y2,z2)
	End Method
	
	End Type

G_LuaRegisterObject New LuaMath,"Math"
