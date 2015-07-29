Rem
/* 
  Pythagoras

  Copyright (C) 2012, 2015 Jeroen P. Broks

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



Version: 15.02.03

End Rem






Strict

Rem

This file will help calculating distances with help of the Pythagorean theorem.
Of course all credit to Pythagoras for this theorem (he didn't invent it, the theorem is older than he is, but he is the one who proved the formula to be correct).
For the rest this is all done by me, myself and I :)


History
12.04.08 - First quick version
12.09.26 - Turned into a module
15.01.22 - Moved to the new module setup

End Rem

Import Tricky_units.MKL_Version

MKL_Version "Units - Pythagoras/Pythagoras.bmx","15.02.03"
MKL_Lic     "Units - Pythagoras/Pythagoras.bmx","zLIB License"



' Calculate the hypothenusa powered by 2
Function Hypothenusa2:Double(x1:Double,y1:Double,x2:Double,y2:Double)
Return (Abs(x1-x2)^2)+(Abs(y1-y2)^2)
End Function

' Use the theorem to calculate a distance in a 2D environment
Rem
bbdoc: Calculates the distance between two points in a 2D environment by using the Pythagorean Theorem
end rem
Function Distance2D:Double(x1:Double,y1:Double,x2:Double,y2:Double)
Return Sqr(Hypothenusa2(x1,y1,x2,y2))
End Function


' Use the theorem twice to calculate a distance in a 3D environment
Rem
bbdoc: Calculates the distance between two points in a 3D environment by using the Pythagorian Theorem
end rem
Function Distance3D:Double(x1:Double,y1:Double,z1:Double,x2:Double,y2:Double,z2:Double)
Local h:Double = Hypothenusa2(x1,y1,x2,y2)
Local v:Double = h + (Abs(z1-z2)^2)
Return Sqr(v+h)
End Function

