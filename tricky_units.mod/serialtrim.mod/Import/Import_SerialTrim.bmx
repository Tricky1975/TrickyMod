Rem
  SerialTrim.bmx
  
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
  Serial Trim

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



Version: 15.05.26

End Rem
Strict
Import brl.linkedlist
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - SerialTrim.bmx","15.09.02"
MKL_Lic     "Tricky's Units - SerialTrim.bmx","ZLib License"

Rem
bbdoc: Trims all elements in an array string
about: This function actually modifies the given array itself. If you do not want that, use RTrimArray in stead
End Rem
Function TrimArray(A$[])
For Local ak=0 Until Len(a) a[ak]=Trim(a[ak]) Next
End Function

Rem
returns: A string array with all strings trimmed
End Rem
Function RTrimArray$[](A$[])
Local ret$[] = New String[Len(A)]
For Local ak=0 Until Len(a) ret[ak]=Trim(a[ak]) Next
Return ret
End Function

Rem 
bbdoc: Splits a string, and trims all created elements
End Rem
Function TrimSplit$[](str$,separator$)
Local ret$[] = str.split(separator)
trimarray ret
Return ret
End Function

Rem 
bbdoc: Returns a new TList of a string based TList. All objects not a string will just be copied unless you set the parameter ingoreother to True.
End Rem
Function RTrimList:TList(L:TList,ignoreother=False)
Local r:TList = New TList
For Local o:Object=EachIn L
	If String(o)
		ListAddLast r,Trim(String(o))
	ElseIf Not ignoreother
		ListAddLast r,o
		EndIf
	Next
Return r
End Function

Rem
bbdoc: Replaces a TList with a trimmed version
End Rem
Function TrimList(L:TList Var,ignoreother=False)
L = rtrimlist(L,ignoreother)
End Function
