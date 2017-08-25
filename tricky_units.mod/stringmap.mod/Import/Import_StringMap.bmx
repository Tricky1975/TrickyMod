Rem
  StringMap.bmx
  2015
  version: 17.08.25
  Copyright (C) 2015, 2016, 2017 Jeroen P. Broks
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

' 15.01.21 Initial
' 16.06.11 Adepted for compatibility with BlitzMax NG

Strict
Import brl.map
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - StringMap.bmx","17.08.25"
MKL_Lic     "Tricky's Units - StringMap.bmx","ZLib License"

Rem
bbdoc: A map extended solely for string-string usage.
End Rem
Type StringMap Extends TMap
	
	Rem
	bbdoc: returns a string value in the map. Only works if both the key and the value are strings
	End Rem
	Method value$(key$)
		Return String(MapValueForKey(Self,key))
	End Method
	
	Rem
	bbdoc: Returns a string with all keys and values. This is only meant for debugging purposes
	End Rem
	Method dump$()
		Local ret$
		Local k$
		For k$=EachIn MapKeys(Self)
			If ret ret:+"~n"
			ret:+k+" = "+value(k)
		Next
		Return ret
	End Method
	
	Method AddText(key$,Text$)
		MapInsert Self,key,value(key)+Text
	End method	
	
End Type

