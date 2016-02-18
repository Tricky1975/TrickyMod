Rem
  Identify.bmx
  
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
  Identify.bmx
  
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
  Jeroen P. Broks

  Copyright (C) 2012, 2015 Identify

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



Version: 15.02.28

End Rem
' History
' 12.03.31 - Canibalized the original Identify, in order to make it compatible with JCR5
' 12.05.06 - Fixed forgetting to include a few needed modules
' 12.05.06 - LoadID can now handle as well TMaps as direct file calls
' 12.11.07 - Dirry now called from the module
' 12.11.08 - Converted into a module
' 13.06.11 - Put in some documentation for the 'Get' method inside 'TID'
' 13.06.11 - Placed in the MKL_Version tags
' 13.06.11 - Compatible with the mksync tool
' 15.02.03 - Adepted to JCR6
'          - Better variable usage!
' 15.02.24 - Added Keys() method
' 15.02.28 - Fixed the caps bug in finding identify files inside the JCR


Strict

Import brl.system
Import bah.volumes
'Import tricky.jcr5 ' "../JCR5/JCR_Read.bmx"
Import jcr6.jcr6main
Import tricky_units.Dirry
Import tricky_units.MKL_Version
Import tricky_units.StringMap

MKL_Version "Tricky's Units - Identify.bmx","15.09.02"
MKL_Lic     "Tricky's Units - Identify.bmx","ZLib License"


Rem
bbdoc: If set to true a dialog box will appear when the Identify files are not properly read
End Rem
Global IDNotify = False

Rem
bbdoc: Data type to contain all required data obtained from a JCR's Identify file
End Rem
Type TID
	Field Config:StringMap = New StringMap
	
	Rem
	bbdoc: Contains the data of a certain field inside the Identify file
	End Rem	
	Method Get$(Key$)
	Local ret$ = String(MapValueForKey(Config,Key))
	For Local Key$=EachIn MapKeys(config)
		ret = Replace(ret,"{"+key+"}",config.value(key))
		Next
	Return ret
	End Method
	
	Rem
	bbdoc: Get all the keys
	End Rem
	Method Keys:TMapEnumerator()
	Return MapKeys(config)
	End Method
	End Type

Rem
bbdoc: Loads the entry "Identify/Identify" from a JCR5 file or JCR Map.
about: I basically use this crappy routine solely to make multifunctional game engines able to read the data applicable for several game uses (in other words, when you want to use my engines to make your own game, this file can help you).	I hope you have good use for it. ;)
End Rem
Function LoadID:TID(JCRMain:Object,Entry$="IDENTIFY/IDENTIFY")
Local ak
Local JCRMap:TJCRDir = TJCRDir(JCRMain)
If Not JCRMap 
	JCRMap = JCR_Dir(String(JCRMain))
	DebugLog "Accessing: "+String(JCRMain)
	End If
Assert JCRMap Else "Could not properly access the JCR file (JDR)"
If Not JCRMap Return
If Not JCR_Exists(JCRMap,Entry)
	If IDNotify Notify("The JCR file called does not contain an Identify Entry")
	Return Null
	EndIf
Local BT:TStream 
Rem old
If MapContains(JCRMAP.entries,"IDENTIFY/IDENTIFY") 
	BT = JCR_ReadFile(JCRMAP,"IDENTIFY/IDENTIFY")
	Else
	BT = JCR_ReadFile(JCRMAP,"IDENTIFY/IDENTIFY.TXT")
	EndIf
End Rem
If MapContains(JCRMAP.entries,Entry) 
	BT = JCR_ReadFile(JCRMAP,Entry)
	Else
	BT = JCR_ReadFile(JCRMAP,Entry+".TXT")
	EndIf
Assert BT Else "Could not properly access the JCR file (JRF)"
If Not BT Return	
Local RL$,P,Key$,Key2$,Value$
Local Ret:TID = New TID
While Not(Eof(BT))
	RL = ReadLine(BT)
	P = RL.Find("=")
	Key=Trim(RL[..P])
	Value=Trim(RL[P+1..])
	'Print "~q"+Key+"~q makes ~q"+Value+"~q"
	MapInsert Ret.Config,Key,Value
	Wend
Rem	
For ak=1 To 2   ' the procedure is run twice to make sure all tags are replaced, as it might sometimes not happen in the first run due to the order in which the replacements happen.
	For key=EachIn MapKeys(Ret.Config)
		MapInsert Ret.Config,Key,Replace(Ret.Get(Key),"{UserDocumentsDir}",GetUserDocumentsDir())
		MapInsert Ret.Config,key,Replace(Ret.Get(Key),"{UserAppDir}",GetUserAppDir())
		For key2 = EachIn MapKeys(Ret.config)
			MapInsert ret.Config,Key,Replace(Ret.Get(Key),"{"+key2+"}",Ret.Get(key2))
			Next
		Print "Identify Result>   "+key+" = ~q"+Ret.Get(Key)+"~q"
		Next	
	Next	
EndRem	
CloseStream BT
Return Ret
End Function

