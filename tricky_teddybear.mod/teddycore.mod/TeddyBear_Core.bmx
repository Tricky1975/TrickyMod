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

' History:
' 14.xx.xx -- Initial version
' 15.02.03 -- Converted to JCR6
Strict


Import jcr6.jcr6main
Import jcr6.zlibdriver
Import jcr6.realdir
Import tricky_units.TrickyReadString
Import Brl.Map
Import brl.max2d

'Version
MKL_Version "TeddyBear - TeddyBear_Core.bmx","14.03.17"
MKL_Lic     "TeddyBear - TeddyBear_Core.bmx","Mozilla Public License 2.0"

Type TeddyLayer
	Field T   ' 0 = Byte, in future versions other types can be used to allow higher values than 256.
	Field F:Int[,]
	Field W,H
	Field Hot$ = "TL"
	Rem   Hot Codes
	      TL = Top Left
	      TC = Top Center
	      TR = Top Right
	      BL = Bottom Left
	      BC = Bottom Center
	      BR = Bottom Right
	End Rem
End Type


Rem 
bbdoc: Contains the data of a Teddy Bear object
End Rem
Type TeddyObject
	Field Data:TMap = New TMap
	
	Rem
	bbdoc: Contains a string with the type of object
	end rem
	Field ObjType$
	
	Rem
	bbdoc: Defines a database field of an object
	end rem
	Method Df(F$,V$)
		MapInsert Data,F,V
		End Method
		
	Rem
	bbdoc: Returns a database field of an object
	end Rem
	Method Cl$(F$)	
		Return String(MapValueForKey(Data,F))
		End Method
		
	Rem
	bbdoc: Returns a database field of an object as an integer (if not possible to convert into an integer 0 will be returned)
	End Rem
	Method ClI(F$)
		Return Cl(F).ToInt()
		End Method
		
	Rem
	bbdoc: True if a field exists, otherwise false
	End Rem
	Method Ex(F$)
		Return MapContains(Data,F)
		End Method
	End Type


Type TeddyZoneName ' This is only to form a return value to the ZName method in the 'TeddyBear' method
	Field Name$[256]
	End Type


Rem
bbdoc: This object type is used to store your TeddyBear map information.
End Rem
Type TeddyBear ' BLD_: Object Teddybear\nCannot be called directly but some project using GALE (like the LAURA engine for example) have subobject to call this object. It contains all kinds of data about a Teddybear map.
  ' The BLD tags are used to use my BLD tool to document this for GALE based projects
	Field GridX = 40
	Field GridY = 40
	Field TexResize:Byte = False
	Field SizeX = 50
	Field SizeY = 50
	Field Texture$[256]
	Field TextureImg:TImage[256]
	Field Layers:TMap = New TMap
	Field ZoneNameMap:TMap = New TMap
	Field Objects:TList[,] = New TList[SizeX+1,SizeY+1]
	Field OW=SizeX,OH=SizeY ' NEVER ASSIGN DATA TO OW OR OH YOURSELF OR CRASHES MAY BE INEVITABLE.
	Field DataMap:TMap = New TMap
	
	Method NewLayer(ID$,W=0,H=0,T=0,Hot$="TL")
		Local TW = W; If Not TW TW=SizeX
		Local TH = H; If Not TH TH=SizeY
		Local TL:TeddyLayer = New TeddyLayer
		TL.F = New Int[TW+1,TH+1]
		TL.T=T
		TL.W=W
		TL.H=H
		TL.Hot = Hot
		MapInsert Layers,ID,TL
	End Method
		
	Rem
	bbdoc: Returns a map tile layer.
	about: Will contain a field named F containing an 2D array containing the map stuff needed. Map.Layer("Walls").F[X,Y], that's the idea. You follow?<p>When a layer does not exit it will return NULL.
	End Rem
	Method Layer:TeddyLayer(ID$) ' BLD_: Contains a Teddybear layer. See the object Teddybear/Layer to see how.
		Return TeddyLayer(MapValueForKey(Layers,ID))
	End Method
	
	Rem
	bbdoc: This function will resize the size of the object field. (Default is 50x50)
	about:	Please note that, unless the 'conserve' paramete is set, all object data will be destroyed. Furthermore it can never be guaranteed that any data is succesfully transferred. When making the object field smaller, all data outside the new bounderies will always be lost regardless of any setting.
	end rem
	Method ResizeObjects(Width,Height,Conserve=False)
		If Width<5 Or Height<5 Then
			Print "WARNING! <TeddyBearLevel>.ResizeObjects("+Width+","+Height+","+Conserve+"): Object field too small. Must be 5x5 at least! Request ignored!"
			Return
			EndIf
		Select Conserve
			Case False
				Objects = New TList[Width+1,Height+1]
				OW = Width
				OH = Height
			Case True
				Local NewObjects:TList[Width+1,Height+1]
				Local W,H
				For W=0 To Width-1
						For H=0 To Height-1
							If W<OW And H<OH NewObjects[W,H]=Objects[W,H]
							Next
						Next
				Objects = NewObjects
				OW = Width
				OH = Height
			Default	 
				Print "WARNING! <TeddyBearLevel>.ResizeObjects("+Width+","+Height+","+Conserve+"): Invalid 'Conserve' setting. Request ignored!"
			End Select 
		End Method
		
	Rem
	bbdoc: Returns a TList containing all objects tied to a certain tile in the map.
	about: All entries in this TList are in the TeddyObject format.<p>Though a direct call to the Objects field variable is possible I recommend against it, as this function is meant for possible future functionality. Also, all lists are by default Null, this function will create a list upon the first call. Saves you a lot of trouble :)
	End Rem
	Method ObjectList:TList(X,Y)
		Assert X<=OW And Y<=OH And X>=0 And Y>=0 Else "<TeddyBearLevel>.ObjectList("+X+","+Y+"): Request out of bounds. (ObjListSize = "+OW+"x"+OH+")"
		If Not Objects[X,Y] Objects[X,Y] = New TList
		Return Objects[X,Y]
		End Method
		
	Rem
	bbdoc: Width of the object list array
	end rem
	Method ObjectsWidth()
		Return OW ' Never access OW and OH directly, as the usage of the var may change, but this function will always be updated on that. Futhermore NEVER assign data to it, always let TeddyBear do that!!!
		End Method

	Rem
	bbdoc: Height of the object list array
	end rem
	Method ObjectsHeight()
		Return OH
		End Method

	Rem
	bbdoc: Returns an array with zone names for a zone layer.
	about: This function can be called combined with .Name with is a String[256] array. Like TeddyMap.ZName("Zone").Name[10], for example.<br>When you don't put in the "Zone_" prefix TeddyBear will do so automatically.<br>Don't even try to use this on other kinds of layers, even if you succeed the results might be undesirable.
	End Rem
	Method ZName:TeddyZoneName(ZoneLayer$)
		Local L$ = ZOneLayer
		If Left(L,5)<>"Zone_" L = "Zone_"+L
		Local Ret:TeddyZoneName
		If MapContains ( ZoneNameMap , L )
			Ret = TeddyZoneName(MapValueForKey(ZoneNameMap,L))
			Else 
			Ret = New TeddyZoneName
			MapInsert ZoneNameMap,L,Ret
			EndIf 
		Return Ret
		End Method
		
	Rem
  bbdoc:Returns or defines a 'data' field of the map. 
	about:What I had in mind for this field were some basic definitions, like, the title of the map as the players will see it on screen. The default background music, a standard ceiling or floor texture or color in a Wolfenstein 3D clone, that sort of thing.<br>When the DF$ parameter is set to "*** DO NOT DEFINE ***", as it's set when you don't enter a definition, you won't assign data to it, only read it.	 When it's set to any other value it will assign this value to this database field.
	end rem
	Method Data:String(Fld$,D$="*** DO NOT DEFINE ***")
		If D<>"*** DO NOT DEFINE ***"
			MapInsert DataMap,Fld,D
			EndIf
		Return String(MapValueForKey(DataMap,Fld))
		End Method
			
End Type
	
Rem
bbdoc:When loading a Teddybear level results into an error, the error is stored in this variable. When no errors occur the variable will contain the string 'Ok'
End Rem	
Global TeddyLoadError:String

Private 
Function TeddyLE:TeddyBear(E$)
TeddyLoadError = E$
Print "* Error in loading a Teddybear Level *~n"+E+"~n"
Return Null
End Function
Public

Rem
bbdoc:Loads a level written in Teddybear
about:You can only do this from a JCR map either made JCR_Dir. Furthermore, note that a Teddybear map contains a collection of files all stored in a folder with the name of the level. Always point to that path and Teddybear will automatically load the rest.
about:Any errors that occur during loading are stored in the variable TeddyLoadError
End Rem
Function LoadTeddyBear:TeddyBear(JCR:TJCRDir,MapName$)
TeddyLoadError = "Ok"
Local Ret:TeddyBear = New TeddyBear
Local MN$ = Replace(MapName,"\","/"); If Right(MN$,1)<>"/" And Len(MN) MN:+"/"
'Local BT:JCR_Stream = JCR_ReadFile(JCR,MN+"Defs")
Local BT:TStream = JCR_ReadFile(JCR,MN+"Defs")
Local Tag,TID
Local LayLoad$
Local X,Y
Local TedObj:TeddyObject
Local K$
Local LLayer$ ' Last found layer.
Local Idx
If Not BT
	Return TeddyLE("Defs could not be retrieved from level.~n~nJCR returned:~n"+JCR_Error.ErrorMessage)
	EndIf
If Eof(BT) CloseFile(BT) Return TeddyLE("Defs file of map "+MapName+" appears to be an empty file")
While Not Eof(BT)
	Tag = ReadByte(BT)
	'debuglog "DefTag #"+Tag
	Select Tag
	Case 0 Ret.GridX = ReadInt(bt); Ret.GridY=ReadInt(bt); 'debuglog "DEF:>Grid = ("+Ret.GridX+","+ret.GridY+")"
	Case 1 Ret.TexResize = ReadByte(bt); 'debuglog "DEF:Texture Resizing = "+Ret.TexResize
	Case 2 Ret.SizeX = ReadInt(bt); Ret.SizeY=ReadInt(bt); 'debuglog "DEF:>Default Size = ("+Ret.GridX+","+ret.GridY+")"
	Case 3 TID = ReadByte(bt) Ret.Texture[TID] = TrickyReadString(bt); 'debuglog "DEF:>Texture["+TID+"] = ~q"+Ret.Texture[TID]+"~q"
	Case 4 LLayer = TrickyReadString(bt); Ret.NewLayer LLayer,Ret.SizeX,Ret.SizeY,0;
	Case 5 Idx = ReadByte(bt); Ret.ZName(LLayer).Name[Idx] = TrickyReadString(bt); 'debuglog "ZoneName[~q"+LLayer+"~q,"+Idx+"] = ~q"+Ret.ZName(LLayer).Name[Idx]+"~q; Len="+Len(Ret.ZName(LLayer).Name[Idx])+"~n"
	Default
		CloseFile BT
		Return TeddyLE("Incorrect tag found ("+Tag+") in loading the defs of level "+MapName+".~nYou are either trying to load an illegal level, or the level has been produced with a later version of Teddybear.~nTry to get ahold of the latest version, if the error persists, the level is most likely illegal or damaged!")
	End Select
	Wend
	CloseFile BT
' Load the layers
For LayLoad$ = EachIn MapKeys(Ret.Layers)
	Local Prefix$ = "Layer_"
	If Left(LayLoad,5)="Zone_" Prefix=""
	BT = JCR_ReadFile(JCR,MN+Prefix+LayLoad)
	If Not BT Return TeddyLE("Layer ~q"+LayLoad+"~q could not be retrieved from level.~n~nJCR returned:~n"+JCR_Error.errormessage)
	Repeat
	If Eof(BT) CloseFile(BT); TeddyLE("Layer ~q"+LayLoad+"~q in map "+MapName+" appears to be truncated! ($ffnf)")
	Tag = ReadByte(bt)
	Select Tag
		Case 0 Ret.Layer(Layload).T = ReadByte(bt); If Ret.Layer(LayLoad).T CloseFile bt; Return TeddyLE("Sorry dude, higher bit levels are not supported in this level of Teddybear. Try a higher version.")
		Case 1 Ret.Layer(LayLoad).W = ReadInt(bt); Ret.Layer(LayLoad).H = ReadInt(bt)
		       Ret.Layer(LayLoad).F = New Int[Ret.Layer(LayLoad).W+1,Ret.Layer(LayLoad).H+1]
		Case 2 Ret.Layer(LayLoad).Hot = ReadString(bt,2)
		Case $ff
			  For X=0 To Ret.Layer(LayLoad).W 
				For Y=0 To Ret.Layer(LayLoad).H
					Ret.Layer(LayLoad).F[X,Y] = ReadByte(bt)
					Next
				Next
			Exit
	Default
		CloseFile bt
		Return TeddyLE("Incorrect tag found ("+Tag+") in loading the layer ~q"+LayLoad+"~q of level "+MapName+".~nYou are either trying to load an illegal level, or the level has been produced with a later version of TeddyBear.~nTry to get ahold of the latest version, and if the error persists, the level is most likely illegal or damaged!")
	End Select
	Forever
	CloseFile bt
	Next		
' Load the objects (if available)
If MapContains(JCR.Entries,Upper(MN)+"OBJECTS")
	BT = JCR_ReadFile(JCR,MN+"Objects")
	Ret.OW = ReadInt(bt)
	Ret.OH = ReadInt(bt)
	Ret.Objects = New TList[Ret.OW+1,Ret.OH+1]
	While Not Eof(bt)
		Tag = ReadByte(bt)
		Select Tag
			Case 0
				X = ReadInt(bt)
				Y = ReadInt(bt)
				TedObj = New TeddyObject
				ListAddLast Ret.ObjectList(X,Y),TedObj
			Case 1
				K = TrickyReadString(bt)
				TedObj.Df(K,TrickyReadString(bt))
			Case 2	
				TedObj.ObjType = TrickyReadString(bt)
			Default
				CloseFile bt
				Return TeddyLE("Incorrect tag found ("+Tag+") in loading objects of map "+MapName+".	~nYou are either trying to load an illegal level, or the level has been produced with a later version of TeddyBear.~nTry to get ahold of the latest version, and if the error persists, the level is most likely illegal or damaged!")
			End Select
		Wend
	CloseFile bt
	EndIf
' Load the general data (if available)
If MapContains(JCR.Entries,Upper(MN)+"DATA")
	Ret.DataMap = JCR_LoadMap(JCR,MN+"Data")
	EndIf
Return Ret
End Function
	
