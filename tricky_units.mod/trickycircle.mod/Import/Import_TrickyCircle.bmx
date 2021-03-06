Rem
  TrickyCircle.bmx
  
  version: 16.06.12
  Copyright (C) 2014, 2015, 2016 Jeroen P. Broks
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
Strict

Import tricky_units.MKL_Version
Import brl.max2d
MKL_Version "Tricky's Units - TrickyCircle.bmx","16.06.12"
MKL_Lic     "Tricky's Units - TrickyCircle.bmx","ZLib License"

Rem
bbdoc:Draws a circle in the more classic stile.
about:This routine is not nescarily fast, but it should do the job.
End Rem
Function DrawOpenCircle(X:Double,Y:Double,Rad:Double)
Local ak
Local x1,x2,y2,y1
For ak=0 To 360
	x1 = x + Sin(ak-1)*rad
	y1 = y + Cos(ak-1)*rad
	x2 = x + Sin(ak  )*rad
	y2 = y + Cos(ak  )*rad
	DrawLine x1,y1,x2,y2
	Next
End Function

Rem
bbdoc: Draws a filled circle
End Rem
Function DrawFilledCircle(X:Double,Y:Double,Rad:Double)
Local SX:Double = X - Rad
Local SY:Double = Y - Rad
Local CW:Double = Rad*2
Local CH:Double = Rad*2
DrawOval Float(SX),Float(SY),Float(CW),Float(CH)
End Function
