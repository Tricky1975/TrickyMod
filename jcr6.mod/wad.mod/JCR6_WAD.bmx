Rem
        JCR6_WAD.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.23
End Rem
Strict
Import jcr6.jcr6main

MKL_Version "JCR6 - JCR6_WAD.bmx","15.09.23"
MKL_Lic     "JCR6 - JCR6_WAD.bmx","Mozilla Public License 2.0"

Private
Function JCR_FetchWAD:TJCRDir(WAD$,SupportLevel=1)
Local Returner:TJCRDir = New TJCRDir
Local Ret:TMap = New TMap; returner.entries = ret
Local E:TJCREntry
Local BT:TStream = ReadFile(WAD$)
Local Level$
Local LevelFiles$[] = ["THINGS","LINEDEFS","SIDEDEFS","VERTEXES","SEGS","SSECTORS","NODES","SECTORS","REJECT","BLOCKMAP","BEHAVIOR"] ' All files used in a DOOM/HERETIC/HEXEN level, in which I must note that "BEHAVIOR" is only used in HEXEN.
If Not BT 
	'JCRD_DumpError = "JCR_FetchWAD(~q"+WAD+"~q): WAD file could not be read"
	JCR_JAMERR("WAD file could not be read!",WAD,"N/A","JCR6 WAD Driver - JCR_FetchWAD")
	Return Null
	EndIf
BT = LittleEndianStream(BT) ' WADs were all written for the MS-DOS platform, which used LittleEndian, so we must make sure that (even if the routine is used on PowerPC Macs) that LittleEndian is used
'WAD files start with a header that can either be 'IWAD' for main wad files or 'PWAD' for patch WAD files. For JCR this makes no difference it all (it didn't even to WAD for that matter), but this is our only way to check if the WAD loaded is actually a WAD file.
Local Header$ = ReadString(BT,4)  
Select HEader 
	Case "IWAD"	
		MapInsert returner.comments,"Important notice","The WAD file you are viewing is an IWAD,~nmeaning it belongs to a copyrighted project.~n~nAll content within it is very likely protected by copyright~neither by iD software or Apogee's Developers of Incredible Power or Raven Software.~n~nNothing can stop you from analysing this file and viewing its contents,~nbut don't extract and distribute any contents of this file~nwithout proper permission from the original copyright holder"
	Case "PWAD"
		MapInsert returner.comments,"Notice","This WAD file is a PWAD or Patch-WAD. It's not part of any official file of the games using the WAD system. Please respect the original copyright holders copyrights though!"
	Default
		JCR_JAMERR "JCR_FetchWAD(~q"+WAD+"~q): Requested file is not a WAD file",WAD,"N/A","JCR_FetchWAD"
		Return Null
	End Select	
returner.config.def("&__CaseSensitive",1)	
'Next in the WAD files are 2 32bit int values telling how many files the WAD file contains and where in the WAD file the File Table is stored
Local FileCount = ReadInt(BT)
Local DirOffset = ReadInt(BT)
DebugLog "This WAD contains "+FileCount+" entries starting at "+DirOffset
SeekStream BT,DirOffset
'And let's now read all the crap
For Local Ak=1 To FileCount
	'DebugLog "Reading entry #"+Ak
	E = New TJCREntry
	E.PVars = New StringMap ' Just has to be present to prevent crashes in viewer based software.
	E.MaiNFile = WAD
	E.Offset = ReadInt(BT)
	E.Size = ReadInt(BT)
	E.FileName = Replace(Trim(ReadString(BT,8)),Chr(0),"")
	E.CompressedSize = E.Size
	E.Storage = "Store"     ' WAD does not support compression, so always deal this as "Stored"
	'E.Encryption = 0  ' WAD does not support encryption, so always value 0
	If SupportLevel ' If set the system will turn DOOM levels into a folder for better usage. When unset the system will just dump everything together with not the best results, but hey, who cares :)
		'Print "File = "+E.FileName+" >> Level = ~q"+Level+"~q >> Len="+Len(E.FileName)+" >> 1 = "+Left(E.FileName,1)+" >> 3 = "+Mid(E.FileName,3,1)
		'If Level="" 
		If (Left(E.FileName,3)="MAP") 
			Level="MAP_"+E.FileName+"/"
		ElseIf ((Len(E.FileName)=4 And Left(E.FileName,1)="E" And Mid(E.FileName,3,1)="M")) 
			Level="MAP_"+E.FileName+"/"
		ElseIf Level<>""
			Local Ok=False
			For Local S$=EachIn LevelFiles
				If E.FileName=S Ok=True
				'Print "Comparing "+E.FileName+" with "+S+"   >>>> "+Ok
				Next
			If Ok E.FileName = Level+E.FileName Else level=""
			EndIf
		EndIf
	Print "Adding: "+E.FileName	
	MapInsert Ret,Upper(E.FileName),E
	Next
CloseFile BT
'Return Ret
Return returner
End Function
Public


Type DRV_WAD Extends DRV_JCRDIR
	Method Name$()
	Return "Where's All the Data? (WAD)"
	End Method

	Method Recognize(fil$)
	If FileType(fil)<>1 Return False
	Local bt:TStream = ReadFile(fil)
	If Not bt Return False
	Local head$ = ReadString(bt,4)
	CloseFile bt
	Return head="IWAD" Or head="PWAD"
	End Method
	
	Method Dir:TJCRDir(fil$)
	Return JCR_FetchWAD(fil$)
	End Method

    End Type

New DRV_WAD
