Rem
  InitFile.bmx
  Init File - Deprecated
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
  InitFile.bmx
  Init File - Deprecated
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
  InitFile

  Copyright (C) 2012, 2015 Jeroen P. broks

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



Version: 15.02.24

End Rem

' 12.xx.xx - Original
' 15.02.03 - Adepted to new units set
' 15.02.23 - Made a quick LoadIni function
' 15.08.31 - Deprecated






Strict
Import brl.Map
Import brl.linkedlist
?WIn32
Import BRL.D3D9Max2D ' DirectX Drivers. Only compatible with Windows
?
Import BRL.GLMax2D
'Import "Dirry.bmx"
'Import "MKL_Version.bmx"
Import tricky_Units.Dirry
Import tricky_units.MKL_Version
Import Tricky_units.SafeString

MKL_Version "Tricky's Units - InitFile.bmx","15.09.02"
MKL_Lic     "Tricky's Units - InitFile.bmx","ZLib License"

SafeChars = Replace(SafeChars,"=","") ' = must be filtered out for security reasons.
SafeChars = Replace(SafeChars,":","") ' : must be filtered out for security reasons.

Type TP
	Field Command$
	Field Param$
	End Type
	
Function GetP:TP(Str$,Sep$)
Local Ret:TP = New TP
Local P = str.find(Sep)
Ret.command=str[..p]
ret.param=str[P+1..]
Rem      ' set on REM as of 12.04.19 as this data was only getting annoying! ;)
DebugLog "Param string: "+Str
DebugLog "Command:    "+Ret.Command
DebugLog "Parameter:  "+Ret.Param
End Rem
Return ret
End Function

Rem
bbdoc: Contains the initialization data
about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
End Rem
Type TIni
	Field Values:TMap = New TMap
	Field Lists:TMap = New TMap
	Field NoCrash = True 'False
	
	Rem
	bbdoc: Define an initiation variable
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	EndRem
	Method D(K$,V$)
	MapInsert Values,K,V
	End Method
	
	Rem 
	bbdoc: Adds a value to a initiation list
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	End Rem
	Method Add(K$,V$)
	If Not MapContains(Lists,K) MapInsert Lists,K,New TList
	ListAddLast TList(MapValueForKey(Lists,K)),V
	'MapInsert Values,K,"** LIST **" ' Putting "** LIST **" was deemed unneeded and is therefore deprecated as of version 11.11.19, and may be removed in a later version.      ' Deprecated first... time for removal.
	End Method
	
	Rem
	bbdoc: Returns all items stored in an initiation list into a TList
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	End Rem	
	Method List:TList(K$)
	If Not MapContains(Lists,K) Return Null
	Return TList(MapValueForKey(Lists,K))
	End Method
	
	Rem
	bbdoc: Retuns the value of an initation variable
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	EndRem
	Method C$(K$)
	Return String(MapValueForKey(Values,K))
	End Method
	
	Rem
	bbdoc: Saves all initiation data into a file
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	End Rem
	Method Save(File$)
	CreateDir ExtractDir(Dirry(File)),1
	Local BT:TStream = WriteFile(Dirry(File))
	If Not BT
		Throw "Initvar.Save(~q"+File+"~q): Could Not write: "+Dirry(File)
		Return
		EndIf
	WriteLine BT,"-- Init/Config file"
	WriteLine BT,"-- Written by: "+StripDir(AppFile)+" ("+AppTitle+")"
	WriteLine BT,"-- "+CurrentDate()+";  "+CurrentTime()
	WriteLine BT,"~n~n"
	For Local K$ = EachIn(MapKeys(Values))
		WriteLine BT,"Var:"+SafeString(K$)+"="+SafeString(String(MapValueForKey(Values,K)))
		Next
	WriteLine BT,""
	For Local KL$ = EachIn(MapKeys(Lists)) 
		WriteLine BT,""
		For Local LL$=EachIn TList(MapValueForKey(Lists,KL$))
			WriteLine BT,"Add:"+SafeString(KL)+","+SafeString(LL)
			Next
		Next
	CloseFile BT
	End Method
		
	Rem
	bbdoc: Loads all initiation data from a file
	about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
	End Rem	
	Method Load(File$,ClearAll=0,DoNotCrash=0)
	Local P:TP
	Local SP:TP
	Local LineCount
	If ClearAll 
		ClearMap Values
		ClearMap Lists
		EndIf
	If Not FileType(Dirry(File)) Return	
	Local BT:TStream = ReadFile(Dirry(File))
	Local Line$
	If Not BT
		If Not NoCrash Throw "Initvar.Load(~q"+File+"~q): Could not read: "+Dirry(File)
		Return
		EndIf
	While Not(Eof(BT))		
		LineCount:+1
		Line = Trim(ReadLine(BT))
		If Len(Line)>1 And (Left(Line,2)<>"--")
			P = GetP(Line,":")
			Select P.Command
				Case "Var"
					SP = GetP(P.Param,"=")
					D(UnSafeString(SP.Command),UnSafeString(SP.Param))
				Case "Add"
					SP = GetP(P.Param,",")
					Add(UnSafeString(SP.Command),UnSafeString(SP.Param))
				Case "Dll"  ' Duplicate List-Link
				  Rem
					This function can be loaded, and then all data will be the same and even updating one list will update the other.
     			However the system is (yet) unable to save this contraption. Covering this up is planned for a future version. This will mean that when you save now the data is simply stored twice to two separate lists.
					end rem
					SP = GetP(P.Param,",")
					Print "Duplicating the link to list "+UnSafeString(SP.Command)+" to "+UnSafeString(SP.Param)
					If Not List(UnSafeString(SP.Command)) Print "List "+SP.COmmand+" appears to be NULL"
					MapInsert Lists,UnSafeString(SP.Param),List(UnSafeString(SP.Command)	)
				Default
					If DoNotCrash Or NoCrash
						Print "- Error loading: "+File
						Print "  = Unknown command: "+P.Command
						Print "  = Line: "+LineCount
						Print "  = Request ignored"
						Else
						Print "- Error loading: "+File
						Print "  = Unknown command: "+P.Command+"~n  = Line: "+LineCount
						Print "  = NoCrash value ("+NoCrash+") set to false so crashout!~n"
						End
						EndIf
				End Select
			EndIf
		Wend
	CloseFile BT	
	Return True
	End Method
	
	Rem
	bbdoc: Init Graphics mode based on the initiation data in this object
	about: Variable 'Driver' can contain 'OpenGL' or 'DirectX' in order to tell Windows what to use. Any platform that is not Windows will ignore this variable and use OpenGL.<br>GfxW will contain the width, GfxH the height and GfxD the depth. If Blnd is set it will determine the blend setting to start out with.
	end rem
	Method InitGFX()
	?Win32
	Select C("Driver")
		Case "OpenGL"
			SetGraphicsDriver  GLMax2DDriver()
		Case "DirectX"
			SetGraphicsDriver D3D9Max2DDriver()
		End Select
	?Not Win32
	SetGraphicsDriver  GLMax2DDriver()
	?
	Graphics C("GfxW").toint(), C("GfxH").toint(), C("GfxD").ToInt()
	If C("Blnd").ToInt()>0 SetBlend C("Blnd").ToInt()
	End Method

	End Type
	
Rem
bbdoc: A quick way to load an ini-file.
about: This object and this entire module is deprecated as of Aug 31st, 2015. It still exist because too many programs still use it, however it is planned to be removed, eventually. Use IniFile2 in stead
End Rem	
Function LoadIni:TIni(InitFile$)	
Local ret:TIni = New TIni
If ret.Load(InitFile) Return ret
End Function

