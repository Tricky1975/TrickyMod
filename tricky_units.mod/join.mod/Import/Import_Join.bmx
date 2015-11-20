Rem
  Join.bmx
  
  version: 15.11.20
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
Strict
Import brl.linkedlist
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - Join.bmx","15.11.20"
MKL_Lic     "Tricky's Units - Join.bmx","ZLib License"

' 15.11.20 - Initial version

Rem
bbdoc: Joins any string based list.
about: LA may either be an array or a Tlist, however only string values are processed, all other values will be ignored. If sub$ is set it will place that between all entries.
End Rem
Function Join$(LA:Object,sub$="")
Local A:Object[] 
If TList(LA) A=ListToArray(TList(LA)) Else A=Object[](LA)
If Not A 
	Print "Warning! Join received data it could not process"
	Return
	End
Local ret$=""
For Local s$=EachIn A
	If ret ret:+sub
	ret:+s
	Next
Return ret
End Function


