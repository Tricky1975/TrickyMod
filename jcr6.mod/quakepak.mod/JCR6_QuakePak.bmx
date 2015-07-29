Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.05.20

End Rem
' 15.03.03 - Initial version built upon the old WAD driver. Some crazy behavior is seen and due to that some files are added to the dir, but the system tries to catch too much and I'm not quite sure what causes that.

Strict
Import jcr6.jcr6main

Private
Function JCR_FetchQuakePak:TJCRDir(QuakePAK$,SupportLevel=1)
Local Returner:TJCRDir = New TJCRDir
Local Ret:TMap = New TMap; returner.entries = ret
Local E:TJCREntry
Local BT:TStream = ReadFile(QuakePAK$)
Local Level$
Local LevelFiles$[] = ["THINGS","LINEDEFS","SIDEDEFS","VERTEXES","SEGS","SSECTORS","NODES","SECTORS","REJECT","BLOCKMAP","BEHAVIOR"] ' All files used in a DOOM/HERETIC/HEXEN level, in which I must note that "BEHAVIOR" is only used in HEXEN.
If Not BT 
	'JCRD_DumpError = "JCR_FetchQuakePAK(~q"+QuakePAK+"~q): QuakePAK file could not be read"
	JCR_JAMERR("QuakePAK file could not be read!",QuakePAK,"N/A","JCR6 QuakePAK Driver - JCR_FetchQuakePAK")
	Return Null
	EndIf
BT = LittleEndianStream(BT) ' QuakePAKs were all written for the MS-DOS platform, which used LittleEndian, so we must make sure that (even if the routine is used on PowerPC Macs) that LittleEndian is used
'QuakePAK files start with a header that can either be 'IQuakePAK' for main QuakePAK files or 'PQuakePAK' for patch QuakePAK files. For JCR this makes no difference it all (it didn't even to QuakePAK for that matter), but this is our only way to check if the QuakePAK loaded is actually a QuakePAK file.
Local Header$ = ReadString(BT,4)  
Select HEader 
	Case "PACK"
		Print "Quake Pack?"
	Default
		JCR_JAMERR "JCR_Fetch(~q"+QuakePAK+"~q): Requested file is not a QuakePAK file",QuakePAK,"N/A","JCR_FetchQuakePAK"
		Return Null
	End Select	
returner.config.def("&__CaseSensitive",0)	
'Next in the QuakePAK files are 2 32bit int values telling how many files the QuakePAK file contains and where in the QuakePAK file the File Table is stored
Local DirOffset = ReadInt(BT)
Local FileCount = ReadInt(BT)
Local FN$,FNS$[]
DebugLog "This QuakePAK contains "+(FileCount/64)+" entries starting at "+DirOffset
SeekStream BT,DirOffset
'And let's now read all the crap
For Local Ak=1 To FileCount Step 64
	'DebugLog "Reading entry #"+Ak
	If Eof(BT) Exit
	E = New TJCREntry
	E.PVars = New StringMap ' Just has to be present to prevent crashes in viewer based software.
	E.MaiNFile = QuakePAK
	FN = ReadString(BT,56)
	E.Offset = ReadInt(BT)
	E.Size = ReadInt(BT)
	FNS = FN.Split(Chr(0))
	E.FileName = FNS[0]'Replace(Trim(ReadString(BT,8)),Chr(0),"")
	E.CompressedSize = E.Size
	E.Storage = "Store"     ' QuakePAK does not support compression, so always deal this as "Stored"
	'E.Encryption = 0  ' QuakePAK does not support encryption, so always value 0
	'If SupportLevel ' If set the system will turn DOOM levels into a folder for better usage. When unset the system will just dump everything together with not the best results, but hey, who cares :)
		'Print "File = "+E.FileName+" >> Level = ~q"+Level+"~q >> Len="+Len(E.FileName)+" >> 1 = "+Left(E.FileName,1)+" >> 3 = "+Mid(E.FileName,3,1)
		'If Level="" 
		Rem
		If (Left(E.FileName,3)="MAP") 
			Level="MAP_"+E.FileName+"/"
		ElseIf ((Len(E.FileName)=4 And Left(E.FileName,1)="E" And Mid(E.FileName,3,1)="M")) 
			Level="MAP_"+E.FileName+"/"
		ElseIf Level<>""
		End Rem
			Local Ok=False
			For Local S$=EachIn LevelFiles
				If E.FileName=S Ok=True
				'Print "Comparing "+E.FileName+" with "+S+"   >>>> "+Ok
				Next
			'If Ok E.FileName = Level+E.FileName Else level=""
			'EndIf
	'EndIf
	Print "Adding: "+E.FileName	
	MapInsert Ret,Upper(E.FileName),E
	Next
CloseFile BT
'Return Ret
Return returner
End Function
Public


Type DRV_QuakePAK Extends DRV_JCRDIR
	Method Name$()
	Return "QuakePAK"
	End Method

	Method Recognize(fil$)
	If FileType(fil)<>1 Return False
	Local bt:TStream = ReadFile(fil)
	If Not bt Return False
	Local head$ = ReadString(bt,4)
	CloseFile bt
	Return head="PACK"
	End Method
	
	Method Dir:TJCRDir(fil$)
	Return JCR_FetchQuakePAK(fil$)
	End Method

    End Type

New DRV_QuakePAK
