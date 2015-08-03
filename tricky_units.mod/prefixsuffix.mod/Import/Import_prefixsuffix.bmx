Rem
/* 
  Prefix Suffix

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



Version: 15.08.03

End Rem
Strict
' 15.08.03 - Initial version

Import brl.retro
Import tricky_units.MKL_Version

Private

Global checkers$(S$,l)[] = [Left,Right]

Function TrueCheck(FS$,SS$,CaseinSensitive,func)
Local S$=SS
Local F$=FS
If caseinsensitive 
	S=Upper(S)
	F=Upper(F)
	EndIf
Local ch$(S$,L)=Checkers[func]	
Return Ch(F,Len(S))=S
End Function

Public

Rem
bbdoc: Checks if a string is prefixed with the required text
returns: True is the required prefix is found and False if it isn't found.
End Rem
Function Prefixed(Fullstring$,Prefix$,caseinsensitive=False)
Return truecheck(Fullstring,Prefix,caseinsensitive,0)
End Function

Rem
bbdoc: Checks if a string is prefixed with the required text
returns: True is the required prefix is found and False if it isn't found.
End Rem
Function Suffixed(Fullstring$,Suffix$,caseinsensitive=False)
Return truecheck(Fullstring,suffix,caseinsensitive,0)
End Function

MKL_Version "Units - prefixsuffix/prefixsuffix.bmx","15.08.03"
MKL_Lic     "Units - prefixsuffix/prefixsuffix.bmx","zLIB License"
