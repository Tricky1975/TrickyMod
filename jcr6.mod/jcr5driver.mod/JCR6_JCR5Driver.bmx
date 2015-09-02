Rem
        JCR6_JCR5Driver.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.05.20

End Rem
Strict
Import jcr6.jcr6main
Import jcr6.zlibdriver 

Global StorageName$[] = ["Store","zlib"]


Type DRV_JCR5_FOR_JCR6 Extends DRV_JCRDIR
	Method recognize(fil$)
	Local BT:TStream = ReadFile(fil)
	If Not bt Return
	Local Header$ = ReadString(BT,5); 
	CloseFile bt
	Return Header="JCR5"+Chr(26) 
	End Method
	
	Method name$() Return "JCR5" End Method
	
	Method Dir:TJCRDir(fil$)
	Local Ret:TJCRDir = New TJCRDir
	Local BT:TStream = ReadStream(fil); 
	Local Header$
	Local FE:TJCREntry = New TJCREntry
	Local Tag,Length
	Local PackedBank:TBank,UnpackedBank:TBank
	Local PackedSize:Int,UnPackedSize:Int
	Local JCRD_DumpError$=""
	Local JCRFILE$ = fil
	If Not BT 
		JCR_JAMERR "JCR_Dir(~q"+JCRFIle+"~q): JCR file has not been found!",fil,"N/A","Dir"
		Return Null
		EndIf
	BT = LittleEndianStream(BT)
	If Not BT 
		JCR_JAMERR "JCR_Dir(~q"+JCRFIle+"~q): Forcing into LittleEndian failed!",fil,"N/A","Dir"
		Return Null
		EndIf
	Header = ReadString(BT,5); 
	If Header<>"JCR5"+Chr(26) 
		JCR_JAMERR "JCR_Dir(~q"+JCRFIle+"~q): File given appears not to be a JCR 5 file!",fil,"N/A","Dir"
	CloseStream BT
	Return Null
	EndIf
	Local FatOffSet = ReadLong(BT)
	If FatOffset>StreamSize(BT)
		JCR_JAMERR "JCR_Dir(~q"+JCRFIle+"~q): FAT offset beyond EOF ("+Fatoffset+">"+StreamSize(BT),fil,"N/A","Dir"
		CloseStream BT
		Return Null
		EndIf
	SeekStream BT,FatOffset; 
	Repeat
	tag = ReadByte(BT); 
	'DebugLog "JCR-TAG:"+Tag
	Select Tag
		Case $ff Exit
		Case   0 ReadLong(BT) 'JCRD_Print "JCR File ~q"+JCRFILE+"~q contains "+ReadLong(BT)+" entries~n~n"
		Case   1 FE = New TJCREntry; FE.MainFile=JCRFile;
		Case   2 	Length = ReadInt(BT); 
						'DebugLog "FLen = "+Length; 
						FE.FileName = ReadString(BT,Length); 
						MapInsert Ret.Entries,Upper(FE.FileName),FE; 
						'DebugLog "Found: "+FE.FIleName
		Case   3 FE.Size = ReadLong(BT)
		Case   4 FE.Offset = ReadLong(BT)
		Case   5 ReadInt(BT) ' FE.Time = ReadInt(BT) ' Not supported in JCR6 yet (strictly speaking it's easy to support it, but it's not needed in JCR6's purpose and therefore not supported by this driver)
		Case   6 ReadInt(BT) 'FE.Permissions = ReadInt(BT) ' Permissions not supported in JCR6 yet, and I doubt they ever will be.
		Case   7 FE.Storage = StorageName[ReadInt(BT)]
		Case   8 ReadInt(BT) ' FE.Encryption = ReadInt(BT) ' This was never worked out in JCR5, no need to consider any support for it in JCR6
		Case   9 FE.CompressedSize = ReadLong(BT)
		Case  10 Length = ReadInt(BT)
					 'DebugLog "ALen = "+Length; 
	    	     FE.Author = ReadString(BT,Length)
		Case  11 Length = ReadInt(BT)
		         FE.Notes = ReadString(BT,Length)	    	     
		Case  12 ReadByte(BT) 
		 		 'FE.Comment = ReadByte(BT)
	         	 'If FE.Comment And (Not LoadComments) MapRemove Ret,Upper(FE.FileName)
		Case 200 XTag BT,Ret,False,JCRFile$
		Case 254
			'JCRD_Print "This JCR file contains a compressed FAT"
			UnPackedSize = ReadLong(BT)
			PackedSize = ReadLong(BT)
			Unpackedbank = CreateBank(UnpackedSize)
			PackedBank = CreateBank(PackedSize)
			ReadBank PackedBank,BT,0,PackedSize
			uncompress BankBuf(UnPackedBank),UnpackedSize,BankBuf(PackedBank),PackedSize
			CloseFile BT		
			BT = CreateBankStream(UnPackedBank); BT=LittleEndianStream(BT)
		Default 
			JCR_JAMERR "JCR_Dir(~q"+JCRFIle+"~q): Unknown FAT Tag ("+Tag+")",fil,"N/A","Dir"
			CloseFile BT
			Return Null
		End Select
	Forever
	CloseFile BT
	Return Ret
	End Method

	End Type
	
Private
Rem 
The XTag function is need to add extra functionality to JCR Dir and is called by JCR_Dir if these extra functions are actually used.
End Rem
Function XTag(BT:TStream,JCR:TJCRDir,LoadComments,JCRFile$)
Local XTC$ ' Stands for 'XTag Command'. I'm not promoting any sorts of stuff here (in fact I recommend not to use that) :P
Local Length = ReadInt(BT); 
XTC = ReadString(BT,Length).toUpper()
Local F$
Local J:TJCRDir
Local D$ = Replace(ExtractDir(JCRFile),"\","/"); If D And Right(D,1)<>"/" D:+"/"
'JCRD_Print "XTag: "+XTC
Select XTC 
  Case "IMP","IMPORT"
 		Length = ReadInt(BT)
    F = Replace(ReadString(BT,Length),"\","/")
    If Left(F,1)<>"/" And Mid(F,2,1)<>":" And FileType(D+F)=1 Then F=D+F ' If the required file to import is found in the same directory than hit that file.
		J = JCR_Dir(F) ' ,LoadComments)
		If Not J
			'JCRD_Print "WARNING! Could not import "+F+"~n= Report: "+JCRD_DumpError
			Else
			'JCRD_Print "Importing: "+F
			'For Local K$=EachIn MapKeys(J)
			'	MapInsert JCR,K,MapValueForKey(J,K)
			'	Next
			JCR_AddPatch JCR,J
			EndIf
	Default
		JCR_JAMERR "WARNING! Unknown XTag in JCR file!","?","?","XTAG"
	End Select
End Function
Public
	


New drv_jcr5_for_jcr6
