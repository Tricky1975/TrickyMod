Rem
  StringMap.bmx
  2015
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
  String Map

  Copyright (C) 2015 Jeroen Petrus Broks

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



Version: 15.01.21

End Rem
Import brl.map
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - StringMap.bmx","15.09.02"
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
	
	End Type

