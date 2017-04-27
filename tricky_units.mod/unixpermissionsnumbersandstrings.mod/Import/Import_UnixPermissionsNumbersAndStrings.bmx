Rem
  UnixPermissionsNumbersAndStrings.bmx
  
  version: 17.04.27
  Copyright (C) 2017 Jeroen P. Broks
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

' This is just for my own version system. If you don't want to use it, just make the "Import MKL_VERSION" line plus all lines prefixed with MKL_ into comments, and you can use this as a stand-alone module.
Import tricky_units.MKL_Version
MKL_Version "Tricky's Units - UnixPermissionsNumbersAndStrings.bmx","17.04.27"
MKL_Lic     "Tricky's Units - UnixPermissionsNumbersAndStrings.bmx","ZLib License"

Rem
bbdoc: Sets unix permission number into a string
about: This function was copied from the BlitzMax documentation.
return: A readable string of the unix permissions in this number.
End Rem
Function Permissions$(mode)
	Local	testbit,pos,res$
	Local	p$="rwxrwxrwx"
	testbit=%100000000
	pos=1
	While (testbit)
		If mode & testbit res$:+Mid$(p$,pos,1) Else res$:+"-"
		testbit=testbit Shr 1
		pos:+1	
	Wend
	Return res
End Function


Rem
bbdoc: Sets readable unix permission string into a number.
returns: An integer with the number coming out. 
End Rem
Function PermissionsToNum(mode$)
	Local p$="rwxrwxrwx"
	Local b$=""
	For Local i=Len(p$) To 1
		If Lower(Mid(mode,i,1))=Lower(Mid(p,i,1)) b="1"+b Else b="0"+b
	Next
	b="%"+b
	Local ret = b.toint()
	Return ret
End Function


Rem -- Debug lines

Global d=123
Global e$=permissions(d); Print d+" >> "+e
Global f=Permissionstonum(e); Print e+" >> "+d



End Rem

