Rem
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is (c) Jeroen P. Broks.
 *
 * The Initial Developer of the Original Code is
 * Jeroen P. Broks.
 * Portions created by the Initial Developer are Copyright (C) 2013
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 14.03.17

End Rem

' 13.xx.xx - Initial version
' 15.02.03 - Turned into a module just like the rest, enabling people to make their own editors more easily. ;)
'          - Converted to JCR6
Strict

' Save routine for Teddybear. Should only be used in editors.



'Import tricky.jcr5
'Import "TeddyBear_Core.bmx"

'Import jcr6.jcr6main 
Import tricky_teddybear.teddycore
Import tricky_units.TrickyReadString


'Version
MKL_Version "TeddyBear - TeddyBear_Save.bmx","14.03.17"
MKL_Lic     "TeddyBear - TeddyBear_Save.bmx","Mozilla Public License 2.0"



' Returns "OK" when saved succesfully, or else it returns the error message.
' When Pack = 0, the level won't be packed. This is done in case of porting to languages in which a link to zLib is not yet possible.
Function SaveTeddyBear$(Map:TeddyBear,MapFile$,Pack$="zlib")
Local MP$ = Replace(MapFile,"\","/")
Local BT:TJCRCreate
Local bte:TJCRCreateStream
Local K$
Local Ak,X,Y
Local Obj:TeddyObject
'If Right(MP,1)<>"/" MP:+"/"
'If Not CreateDir(MP,1) Return "Required path could not be created!"
BT = JCR_Create(MapFile)
If Not BT Return "Save file could not be created!"
' DEFS
bte = BT.createEntry("Defs",pack) 'BT = WriteFile(MP+"Defs")
'If Not BT Return MP+"Defs could not be written"
'BT = LittleEndianStream(BT)
WriteByte bte.stream, 0; WriteInt bte.stream, Map.GridX; WriteInt bte.stream, Map.GridY
WriteByte bte.stream, 1; WriteByte bte.stream, Map.TexResize
WriteByte bte.stream, 2; WriteInt bte.stream, Map.SizeX; WriteInt bte.stream, Map.SizeY
For Ak=0 To 255
    If Map.Texture[Ak] 
			WriteByte bte.stream, 3; WriteByte bte.stream, Ak; TrickyWriteString bte.stream, Map.Texture[AK] 'WriteInt BT,Len(Map.Texture[ak]); WriteString(BT,Map.Texture[Ak])
		Else
			'DebugLog "No texture present at ID"+Ak
		EndIf	
Next
For K$=EachIn MapKeys(Map.Layers)
	WriteByte bte.stream, 4; TrickyWriteString bte.stream, K 'WriteInt BT,Len(K); WriteString BT,K
	If Left(K,5)="Zone_"
		For Ak=0 To 255 ' Zone Names (if the specific layer is a zone)
			WriteByte bte.stream, 5
			WriteByte bte.stream, Ak
			'WriteInt BT,Len(Map.ZName(K).Name[Ak])
			TrickyWriteString bte.stream, Map.ZName(K).Name[Ak]
			Next 
		EndIf 
	Next
bte.close 'CloseFile BT
' Layers
For K=EachIn MapKeys(Map.Layers)
	Local Prefix$ = "Layer_"
	If Left(K,5)="Zone_" Prefix=""
	bte = Bt.createentry( Prefix+k , Pack )'BT = WriteFile(MP+Prefix+K)
	'If Not BT Return MP+Prefix+K+" could not be written"
	'BT = LittleEndianStream(BT)
	WriteByte bte.stream, 0; WriteByte bte.stream, Map.Layer(K).T
	WriteByte bte.stream, 1; WriteInt bte.stream, Map.Layer(K).W; WriteInt bte.stream, Map.Layer(K).H
	WriteByte bte.stream, 2; WriteString bte.stream, Left(Map.Layer(K).Hot+"  ",2)
	' Saving the map itself. No compression is used in saving the data, as TeddyBear has been designed to be used in combination with JCR6 which already compresses everything by itself.
	' Also note, the map itself tagged with $ff will cause the loader to end loading as soon as the map itself is read. In other words it must always come last in the file.
	' This is simply a security measure as some tags above can cause the loaded level to be unloaded immediatly, when this comes last, this simply can't happen.
	' A level without a $ff tagged map will also result into an error when loading.
	' $fe is also reserved in case 32 bit maps may be added in the future, which is in the current state of things, not likely to happen, but just in case :)
	' and for that reason $fd is reserved in case of the very small chance 64bit is used.
	' Must I really reserve $fc for 128bit (which is not even supported by BlitzMax yet)? Nah.... :-P
	WriteByte bte.stream, $ff
	For Local X=0 To Map.Layer(K).W
		For Local Y=0 To Map.Layer(K).H
			WriteByte bte.stream, Map.Layer(K).F[X,Y]
		Next
	Next
	'CloseFile BT
	bte.close
Next
' Objects
' BT = WriteFile(MP+"Objects")
' BT = LittleEndianStream(BT)
bte = bt.createentry( "Objects" , Pack)
WriteInt bte.stream, Map.OW
WriteInt bte.stream, Map.OH
For X=0 To Map.OW
	For Y=0 To Map.OH
		For Obj=EachIn Map.ObjectList(X,Y)
			WriteByte bte.stream,   0 ' New Object on the next coordinates
			WriteInt bte.stream,    X
			WriteInt bte.stream,    Y
			WriteByte bte.stream,   2
			'WriteInt    BT,Len(Obj.ObjType)
			TrickyWriteString bte.stream, Obj.ObjType
			For K=EachIn MapKeys(Obj.Data) ' New field, with the next data
				WriteByte bte.stream,	  1
				'writeint bte.stream,	    Len(K)
				TrickyWriteString bte.stream, K
				'WriteInt			BT,Len(Obj.Cl(K))
				TrickyWriteString bte.stream, Obj.Cl(K)
			Next ' K
		Next ' Obj
	Next ' Y
Next ' X
' CloseFile BT
bte.close
' General Data
'BT = WriteFile(MP+"Data")
'For Local K$ = EachIn MapKeys(Map.DataMap)
'	Local V$ = String(MapValueForKey(Map.DataMap,K))
'	WriteInt    BT,Len(K)
'	WriteString BT,K
'	WriteInt    BT,Len(V)
'	WriteString BT,V
'	Next 
'CloseFile BT
BT.SaveMap Map.DataMap,"Data",Pack
' All done
BT.Close 		
Return "OK"
End Function
