Rem
  GameVars.bmx
  
  version: 15.09.02
  Copyright (C) 2012, 2015 Jeroen P. Broks
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
  GameVars.bmx
  
  version: 15.09.02
  Copyright (C) 2012, 2015 Jeroen P. Broks
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
  GameVars

  Copyright (C) 2012, 2015 Jeroen Petrus Broks

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



Version: 15.06.27

End Rem


Strict
Import brl.System
Import BRL.Map
Import BRL.StandardIO
Import BRL.Retro
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - GameVars.bmx","15.09.02"
MKL_Lic     "Tricky's Units - GameVars.bmx","ZLib License"



Private
Global GM_REF:TMap    ' This variable should have the same referrence as the var you use in the game. Just create a map and register it with VarReg

Public


Rem
bbdoc: Register a TMAP for the usage of the vars. If you don't need to do anything crazy just "New TMap" for a parameter suffices. This command needs to be executed before you can use this module at all!
end rem
Function VarReg(V:TMap)
If Not V 
	Notify "Cannot register a Null-value"
	Return
	EndIf
GM_Ref=V
Return 1
End Function

Rem
bbdoc: Defines var
end rem
Function VarDef(K$,V$)
If Not GM_Ref Return Notify("VarDef(~q"+k+"~q,~q"+V+"~q): Cannot define with Null For referrence")
MapInsert GM_REF,K,V
End Function

Rem
bbdoc: Shows value in var
end rem
Function VarCall$(K$,Debug=0)
If Not GM_Ref Return Notify("VarCall(~q"+K+"~q): Cannot call with Null For referrence")
Local Ret$ = String(MapValueForKey(GM_REF,K))
If Debug
	Print "VARCALL(~q"+K+"~q) = ~q"+Ret+"~q"
	If Not MapContains(GM_REF,K) Print "Please note that the key does not exist!"
	EndIf
Return Ret
End Function

Rem
bbdoc: Converts a string by substituting all found vars into their respective values
end rem
Function VarStr$(Str$)
Local Ret$ = Str$
For Local K$=EachIn(MapKeys(GM_Ref))
	Ret = Replace(Ret,k,VarCall(K))
	Next
Return ret
End Function

Rem
bbdoc: Clears everything
end rem
Function VarClearAll()
ClearMap GM_Ref
End Function

Rem
bbdoc: Removes var 
end rem
Function VarClear(K$)
MapRemove GM_Ref,K
End Function

Rem
bbdoc: List of all vars for use with EachIn
End Rem
Function Vars:TMapEnumerator()
Return MapKeys(GM_Ref)
End Function

Rem
Returns: Returns the registered var map in case you need it
End Rem
Function VarMap:TMap()
Return GM_Ref
End Function

Rem
bbdoc: Counts all variables we got now
returns: The exact number of variables
End Rem
Function VarCount()
Local ret
For Local k$=EachIn MapKeys(GM_Ref) 
	ret:+1
	Next
Return ret
End Function

Rem
returns: The varkey on a specific index. 
about: In the release mode you'll just get an empty string if the index is out of bounds. The debug mode will throw an error.
End Rem
Function VarKey$(i)
Local ret$
Local c=0
Assert c>=0 And c<=VarCount() Else "VarKey("+i+"): Index out of bounds"
For Local K$=EachIn MapKeys(GM_Ref)
	If c=i Return K
	c:+1
	Next
End Function	
	



	

