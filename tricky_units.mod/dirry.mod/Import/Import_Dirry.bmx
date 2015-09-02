Rem
  Dirry.bmx
  
  version: 15.09.02
  Copyright (C) 2012, 2015 2012
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
  Dirry.bmx
  
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
  Dirry

  Copyright (C) 2012, 2015 Jeroen Broks

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

' 15.01.29 - Added "$LinuxDot$ which will place a "." in Linux and nothing at all in any other platform


Strict

Import brl.Map
Import bah.Volumes  ' In order to compile this unit you must have the "Volumes" module, made by Brucey installed.
Import brl.retro

Import tricky_units.MKL_Version
Global MDirry:TMap = New TMap

Rem
bbdoc: Adds a new tag to Dirry
End Rem
Function D_Add(K$,V$)  
' Too lazy to use MapInsert all the time :P
MapInsert Mdirry,K,v
'DebugLog "Dirry: "+K+" = "+V
End Function

Rem
bbdoc: Fills out the full directory with all tags filled out
about: Default Tags
<table><tr style='background-color:#ffaaaa;'><td>Tag</td><td>Value</td></tr>
<tr background-color:#bbbbff;'><td>$AppSupport$</td><td>App Support Dir</td></tr>
<tr background-color:#aaaaff;'><td>$MyDocs$</td><td>"My Documents" Dir</td></tr>
<tr background-color:#bbbbff;'><td>$AppDir$</td><td>Application Dir</td></tr>
<tr background-color:#bbbbff;'><td>$Home$</td><td>User Home Dir</td></tr>
<tr background-color:#bbbbff;'><td>$LinuxDot$</td><td>Places a "." in Linux and nothing at all in Windows and Mac. This is done due to the "/home/user/.mydir" setup most linux distros use. Mac and Windows however have a special appsupport dir providing no need for it.</td></tr>
</table>
New tags can be added with the D_Add function.
End Rem
Function Dirry$(S$,Map:TMap=Null)
Local Ret$=S$
Local UMap:TMap=Map
If Not UMap UMap = MDirry
For Local K$=EachIn MapKeys(UMap)
	Ret$ = Replace(Ret,K,String(MapValueForKey(UMap,K)))
	Next
Return Ret
End Function



'Default for Dirry
?Linux
D_Add("$LinuxDot$",".")
?Not Linux
D_Add("$LinuxDot$","")
?
D_Add("$AppSupport$", GetUserAppDir())
D_Add("$MyDocs$",GetUserDocumentsDir())
D_Add("$AppDir$",AppDir)
D_Add("$Home$",GetUserHomeDir())



MKL_Version "Tricky's Units - Dirry.bmx","15.09.02"
MKL_Lic     "Tricky's Units - Dirry.bmx","ZLib License"
