Rem
  Bye.bmx
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
  Bye.bmx
  
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
  Bye

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



Version: 15.04.19

End Rem
Strict
Import brl.linkedlist
Import tricky_units.MKL_Version


MKL_Version "Tricky's Units - Bye.bmx","15.09.02"
MKL_Lic     "Tricky's Units - Bye.bmx","ZLib License"

Rem
bbdoc: Ends a program and if any functions are assigned to this module they will all be executed in the same order as they were added.
End Rem
Function Bye(IgnoreFunctions=False)
Local bf:TByeFunction
If Not ignorefunctions
	For bf=EachIn byelist
		bf.f()
		Next
	EndIf
End
End Function



Private
Global ByeList:TList = New tlist

Type TByeFunction
	Field f()
	End Type
Public

Rem
bbdoc: Adds a function to the list of functions to be executed when a program is ended using "Bye"
End Rem
Function AddByeFunction(f())
Local bf:TByeFunction = New TByeFunction
bf.f = f
ListAddLast byelist,bf
End Function


Rem
bbdoc: Removes a function from the list of functions to be executed when a program is ended using "Bye"
about: It *is* possible to add the same function twice or more. In that all of them are removed.
End Rem
Function RemoveByeFunction(f())
For Local BF:TByefunction = EachIn ByeList
	If bf.f=f ListRemove byelist,bf
	Next
End Function


Rem
bbdoc: Clear all functions listed to be executed when a program is ended using "bye"
End Rem
Function ClearBye()
ClearList byelist
End Function

