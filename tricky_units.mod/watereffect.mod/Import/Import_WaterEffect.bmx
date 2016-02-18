Rem
  WaterEffect.bmx
  
  version: 15.09.02
  Copyright (C) 2015 Jeroen P. Broks
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
End Rem
Rem
/* 
  Water Effect

  Copyright (C) 2015 Jeroen P. Broks

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



Version: 15.02.24

End Rem
Strict

Import brl.max2d
Import tricky_units.MKL_Version

Rem
bbdoc:WaterEffect
End Rem
Function WaterEffect(Img:TImage,x,y,horizontaal=1,spd=100,plus=1,rng:Double=.25)
Assert Img Else "Hey man!~nI cannot perform a water effect on a non-existent image!"
Assert Abs(spd) Else "Spd may NEVER be 0!"
Local MS = MilliSecs()/spd
Local f = Len(Img.Pixmaps)
Local ak,wsin:Double,wscale:Double
Local ax,ay
For ak=0 Until f
	wsin = Sin(MS+ak)
	wscale = (wsin*rng)+plus
	ax=x
	ay=y
	If horizontaal 
		ay:+ak 
		SetScale wscale,1
	Else 
		ax:+ak
		SetScale 1,wscale
		EndIf
	DrawImage Img,ax,ay,ak
	SetScale 1,1
	Next		
End Function

MKL_Version "Tricky's Units - WaterEffect.bmx","15.09.02"
MKL_Lic     "Tricky's Units - WaterEffect.bmx","ZLib License"
