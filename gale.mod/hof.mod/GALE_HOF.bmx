Rem
        GALE_HOF.bmx
	(c) 2012, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
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
 * The Original Code is Jeroen P. Broks.
 *
 * The Initial Developer of the Original Code is
 * Jeroen P. Broks.
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 13.12.26

End Rem

' History
' 11.11.16 - Initial Version
' 12.03.31 - Moved to GALE




Strict
Import GALE.MaxLua4GALE
Import BRL.Filesystem
Import BRL.Retro





Type LHOF   ' BLD: Object HOF\nThis object contains several features that allows you to set up a Hall Of Fame in Lua Scripting.<br>Please note though that the hardcore settings (like the file its stored in and a few other things) are put in the engine itself and are not scriptable. Most of all this is a way to read the data and to make the script display it in the way you as scripter finds it most desirable.

	Method Name$(Rank)   ' BLD: Contains the name of the player in the specified rank
	Return HOFENTRY[RANK].NAME
	End Method
	
	Method Score$(Rank)  ' BLD: Contains the score of that player in string form
	Return HOFENTRY[RANK].SCORE
	End Method
	
	Method Extra$(Rank,Key$)  ' BLD: If the Hall Of Fame stores any information other than the name or a score it's shown here.
	Return String(MapValueForKey(HOFENTRY[RANK].EXTRA,KEY))
	End Method
	
	Method Load() ' BLD: Loads a Hall Of Fame
	HOF_Load
	End Method
	
	End Type
	
Global HOF:LHof = New LHOF   ' Brought in so that the functions are also callable from Blitzmax.

G_LuaRegisterObject HOF,"HOF"


Global HOF_File$      ' Will contain the file in which the Hall of Fame is stored
Global HOF_HIGH = 1   ' If 1 it sets the highest score on top, If any other value it'll set the lowest on top. Just depends on how the game works, eh? ;)
Global HOF_Count0 = 0 ' If set on 1 rank 0 will be counted as a valid rank, otherwise it'll be skipped in updating.



Type THOFEntry
	
	Field Name$
	Field Score:Long
	Field Extra:TMap = New TMap
	
	Method New()
	Name = AppTitle
	If HOF_HIGH=1 Score=0 Else Score=(2^63)-1
	End Method
	
	End Type

Private

Global HOFEntry:THOFEntry[21]

Public

Function HOF_Setup()	' Will create a hall of fame, if it doesn't exist
Local Ak
If FileType(HOF_File) Return HOF_Load()
For Ak=0 To 20
	HOFEntry[Ak] = New THOFEntry
	Next
HOF_Save
End Function

Function HOF_Save()
Local Ak,K$,V$
If Not HOF_File
	Print "Cannot save HOF_FILE$ has not been set"
	Return
	EndIf
Local BT:TStream = LittleEndianStream(WriteFile(HOF_File))
For ak=0 To 20
	WriteByte BT,0; WriteByte BT,Ak
	WriteByte BT,1; WriteInt BT,Len(HofEntry[Ak].Name); WriteString BT,HofEntry[Ak].Name
	WriteByte BT,2; WriteLong BT,Hofentry[Ak].Score
	For K=EachIn MapKeys(HofEntry[Ak].Extra)
		WriteByte BT,3
		V$ = String(MapValueForKey(HofEntry[AK].Extra,K))
		WriteInt BT,Len(K); WriteString BT,K
		WriteInt BT,Len(V); WriteString BT,V
		Next
	Next
CloseStream BT
End Function

Function HOF_Rank(E:THofEntry)
Local Rank=21
Local ak
Local go=1
If HOF_COunt0 go=0
For ak=20 To go Step -1
	If E.Score>HofEntry[ak].Score And HOF_High =1 rank=ak
	If E.Score<HofEntry[ak].Score And HOF_High<>1 rank=ak
	Next
Return Rank
End Function

Function HOF_Update(E:THofEntry)
Local Rank = HOF_Rank(E)
Local ak
If Rank>20 Return
For ak=20 To Rank+1 Step -1
	HofEntry[ak]=HofEntry[ak-1]
	Next
Hofentry[rank]=e
End Function

Function HOF_Load()
Local Ak,K$,V$,L,CR
Local Tag
If Not HOF_File
	Print "Cannot load HOF_FILE$ has not been set"
	Return
	EndIf
Local BT:TStream = ReadStream(HOF_File)
BT = LittleEndianStream(BT)
While Not Eof(BT)
	Tag = ReadByte(BT)
	Select Tag
		Case 0
			CR = ReadByte(BT)
			HOFEntry[CR] = New THofEntry
		Case 1
			L = ReadInt(BT)
			HOFEntry[CR].Name = ReadString(BT,L)
		Case 2
			HOFEntry[CR].Score = ReadLong(BT)
		Case 3
			L = ReadInt(BT) ; K = ReadString(BT,L)
			L = ReadInt(BT) ; V = ReadString(BT,L)
			MapInsert HOFEntry[CR].Extra,K,V
		Default 
			Print "Unknown tag: "+Tag
			Throw "Invalid tag: "+Tag
		End Select
	Wend
End Function
