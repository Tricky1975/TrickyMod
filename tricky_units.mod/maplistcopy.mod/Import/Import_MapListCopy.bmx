Rem
  MapListCopy.bmx
  
  version: 16.09.24
  Copyright (C) 2016 Jeroen P. Broks
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
Import brl.maplist


Rem
bbdoc: Creates a new Tlist, but with the same elements as the original
End Rem
Function CopyList:TList(original:TList)
	Local ret:TList= New TList
	For Local O:Object=EachIn original
		ListAddLast ret
	Next
	Return ret
End Function

Rem
bbdoc: Creates a new TMap but with the same keys and values as the original
about: I do know there's a MapCopy() function in the Map itself, but the documentation is vague, and I cannot risk data to be overwritten. This routine at least works the way I intended to use it.
End Rem
Function CopyMapContent:TMap(Map:TMap)
	Local ret:TMap=New TMap
	For Local key:Object = EachIn MapKeys(map) MapInsert key,MapValueForKey(map,key) Next
	Return ret
End function
