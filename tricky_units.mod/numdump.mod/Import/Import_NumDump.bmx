Rem
/* 
  Number Dump

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



Version: 15.03.02

End Rem
' 15.03.02 - Initial version
Strict
Import tricky_units.MKL_Version
MKL_Version "Units - NumDump/NumDump.bmx","15.03.02"
MKL_Lic     "Units - NumDump/NumDump.bmx","zLIB License"

Private

Global dumpbank:TBank = CreateBank(10)



Public


Rem
bbdoc: Dumb bytes for int into string
End Rem
Function IntDump$(I)
Local ret$ = ""
PokeInt dumpbank,0,i
For Local ak=0 Until 4
	ret:+Chr(PeekByte(dumpbank,ak))
	Next
Return ret
End Function

Rem
bbdoc: Dumb bytes for long into string
End Rem
Function LongDump$(i:Long)
Local ret$ = ""
PokeLong dumpbank,0,i
For Local ak=0 Until 8
	ret:+Chr(PeekByte(dumpbank,ak))
	Next
Return ret
End Function

