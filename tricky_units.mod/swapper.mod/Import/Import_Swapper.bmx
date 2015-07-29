Rem
/* 
  Swapper

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



Version: 15.02.28

End Rem
Strict
Import tricky_units.MKL_Version

Rem
bbdoc: Swaps two Int vers
End Rem
Function SwapInt(A:Int Var, B:Int Var)
Local C:Int = A
A=B
B=C
End Function

Rem
bbdoc: Swap two bytes
End Rem
Function Swapbyte(A:Byte Var, B:Byte Var)
Local C:Byte = A
A=B
B=C
End Function

Rem
bbdoc: Swap two doubles
End Rem
Function SwapDouble(A:Double Var, B:Double Var)
Local C:Double = A
A=B
B=C
End Function


Rem
bbdoc: Swap two floats
End Rem
Function SwapFloat(A:Float Var, B:Float Var)
Local C:Float = A
A=B
B=C
End Function

Rem
bbdoc: Swap two strings or any other object based type.
End Rem
Function Swap(A:Object Var, B:Object Var)
Local C:Object = A
A=B
B=C
End Function

MKL_Version "Units - Swapper/Swapper.bmx","15.02.28"
MKL_Lic     "Units - Swapper/Swapper.bmx","zLIB License"
