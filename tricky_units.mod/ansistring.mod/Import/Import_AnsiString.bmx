Rem
  AnsiString.bmx
  
  version: 17.10.31
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

Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - AnsiString.bmx","17.10.31"
MKL_Lic     "Tricky's Units - AnsiString.bmx","ZLib License"

Rem
bbdoc: When True ANSI String is used. When False, all ANSI functions Return a normal String
about: On Windows this is by default false, on Linux and Mac this is by default true.
End Rem
Global ANSI_Use 
?Not Win32
	ANSI_Use = True
?Win32
	ANSI_Use = False
?


Const A_Norm      = 0
Const A_Bright    = 1
Const A_Dark      = 2
Const A_Italic    = 3
Const A_Underline = 4
Const A_Blink     = 5

Const A_Black     = 0
Const A_Red       = 1
Const A_Green     = 2
Const A_Yellow    = 3
Const A_Blue      = 4
Const A_Magenta   = 5
Const A_Cyan      = 6
Const A_White     = 7


Rem
bbdoc: Basic 3 digit ANSI string
returns: The asked string
End Rem
Function ANSI_String$(d1,d2,d3,s$)
	If ANSI_Use
		Return Chr(27)+"["+d1+";"+d2+";"+d3+"m"+s+Chr(27)+"[0m"
	Else
		Return s
	EndIf
EndFunction

	
Rem
bbdoc: Basic color string
about: You can use A_Black, A_Red, A_Green, A_Yellow, A_Blue,A_Magenta,A_Cyan or A_White for color values and A_Norm, A_Bright, A_Dark, A_Underline, A_Blink for flags
returns: The worked out string
End Rem	
Function ANSI_Col$( S$, c1=7, c2=0, flags = A_Norm)
	Return ANSI_String(flags,c1+30,C2+40,s)
End Function

Rem
bbdoc: Print with only one color
returns: The worked out string
End Rem
Function ANSI_SCol$(S$,col,flags)
	If ansi_use
		Return Chr(27)+"["+flags+";"+Int(col+30)+"m"+s
	Else
		Return s
	EndIf
End Function
