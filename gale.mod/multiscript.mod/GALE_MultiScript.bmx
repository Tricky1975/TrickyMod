Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.07.12

End Rem
' 15.02.14 - Initial version
' 15.05.05 - Added LoadNew and LN_Run
' 15.05.19 - Saved vars in caps????? I removed the caps, as this could only spook up Lua
'          - GALE_SaveMSVars() and GALE_MapMSSavedVars added
     

Strict
Import GALE.Main
Import tricky_units.MKL_Version
Import brl.map
Import jcr6.jcr6main
Import tricky_units.StringMap

Rem
bbdoc: Set the JCR file here or the Lua script loaders will not know where to look
End Rem
Global GALEMSJCR:TJCRDir

Private
Global Map:TMap = New TMap
Global MapVars:StringMap = New StringMap

Public

Rem
bbdoc: Saves all saved vars into a JCR file.
End Rem
Function GALE_SaveMSVars(BT:TJCRCreate,Storage$="Store",Prefix$="MS_Save/",UpdateFirst=1)
Local BT2:TJCRCreateStream
If updatefirst 
	For Local Tag$=EachIn MapKeys(Map)
		GALE_MS.Update Tag
		Next
	EndIf
If Not BT Return Print("WARNING! Cannot save MS vars into an empty JCR file!")
For Local K$=EachIn MapKeys(MapVars)
	BT2 = BT.CreateEntry(Prefix+K,Storage)
	WriteString bt2.stream, Mapvars.value(K)
	BT2.Close
	Next	
End Function

Rem 
bbdoc: Saved vars in a stringmap
End Rem
Function GALE_MapMSSavedVars:StringMap()
Return MapVars
End Function


Rem
bbdoc: Returns the script data bound to a tag.
End Rem
Function GALE_GetScript:TLua(Tag$)
Return TLua(MapValueForKey(Map,Upper(Tag)))
End Function

Rem
bbdoc: Runs a script. Same as GALE_MS.Run(), but this function can be called easier as you can already split the function parameters in an array right away, making this function faster, from BlitzMax.
End Rem
Function GALE_MS_Run(Tag$,f$="main",pr$[]=Null)
Local fn$=f
If Not fn fn="main"
Local gs:TLua = GALE_GetScript(Tag)
If Not GS GALE_Error "No script found on tag: "+Tag
gs.Run fn,pr
End Function

Rem
bbdoc: Bind a script already loaded to tag. 
End Rem
Function GALE_AddScript(Tag$,L:TLua)
MapInsert map,Upper(Tag),L
End Function

Private
Type TMSByeDriver Extends tbasebyedriver 
	Method ByeDo()
		If Not GALE_MS.ContainsScript(ByeItem.Script) Return ConsoleWrite("WARNING! Bye cannot execute script on tag: "+ByeItem.scipt+" (it doesn't exist)")
		GALE_MS.Run ByeItem.Script,Null
		End Method
	End Type
	
Public

Rem
bbdoc: This object is automatically tied to the variable GALE_MS and contains the same features the Lua script can call on.
End Rem
Type TScriptBase ' BLD: Object MS\nThis object contains the manager for the multiscripter

    Rem
	bbdoc: True is a script is found. False if not.
	End Rem
    Method ContainsScript(tag$) ' BLD: Returns 1 if a script is there on that entry, or false if there's not.
	Return MapContains(map,Upper(tag))
	End Method
	
	Rem
	bbdoc: Load a script to a tag
	End Rem
	Method Load(Tag$,File$) ' BLD: Load a script to a tag
	If ContainsScript(Tag) Destroy(tag)	
	MapInsert map,Upper(tag),GALE_LoadScript(GALEMSJCR,file,MapVars.value(Upper(file)))
	End Method
	
	Rem
	bbdoc: Updates all saved variables marked as MS_SAVE. When calling Destroy this function is called automatically. Same will happen when you overwrite an existing script with Load. When you load a script for which these variables exist they are automatically loaded.
	End Rem
	Method Update(Tag$) ' BLD: Updates all saved variables marked as MS_SAVE. When calling Destroy this function is called automatically. Same will happen when you overwrite an existing script with Load. When you load a script for which these variables exist they are automatically loaded.
	MapInsert MapVars,GALE_GetScript(Tag).FileName.ToUpper(),GALE_GetScript(Tag).Save("MS_SAVE") ' .toUpper() '???
	End Method
	
	Rem
	bbdoc: Removes a scripts from the MS database. Variables marked as MS_SAVE in the .lsv file are automatically being updated. The GALE_OnUnload() function inside the script is being called on the moment the garbage collector picks this up. Please note that is pretty unstable and you can never tell when this will happen.
	End Rem
	Method Destroy(Tag$) ' BLD: Removes a scripts from the MS database. Variables marked as MS_SAVE in the .lsv file are automatically being updated. The GALE_OnUnload() function inside the script is being called on the moment the garbage collector picks this up. Please note that is pretty unstable and you can never tell when this will happen.
	Update(Tag$)
	MapRemove Map,Upper(Tag)
	End Method
	
	Rem
	bbdoc: Loads a script only if no script is loaded to this tag.
	End Rem
	Method LoadNew(Tag$,File$) ' BLD: Loads a script only if no script is loaded to this tag.
	If ContainsScript(tag) Return
	Load Tag,File
	End Method
			
	Rem
	bbdoc: Runs a script. If the second parameter is not given, it will automatically run the function called "main". The 3rd parameter should contain the function paramters in one string separated by ";". Please note, this function only accepts strings, so if you send numbers be sure you convert them to numbers in your called function! From BlitzMax you may also want to use GALE_MS_Run in stead!
	End Rem
	Method Run(Tag$,f$="main",p$="") ' BLD: Runs a script. If the second parameter is not given, it will automatically run the function called "main". The 3rd parameter should contain the function paramters in one string separated by ";". Please note, this function only accepts strings, so if you send numbers be sure you convert them to numbers in your called function!
	Local fn$=f
	Local pr:String[]
	If Not fn fn="main"
	If p pr=p.split(";")
	Local gs:TLua = GALE_GetScript(Tag)
	If Not gs GALE_Error "MS.Run(~q"+Tag+"~q,~q"+f+"~q,~q"+p+"~q): Called non-existent script"
	gs.Run fn,pr
	End Method
	
	Rem
	bbdoc: Loads and runs a script, but only if the script has not been loaded before. 
	about: I set this one up, in order to allow you to load the script on the moment they are first called. My Star Story game took great advantage of this possibility
	End Rem
	Method LN_Run(Tag$,File$,f$="main",p$="") ' BLD: Loads and runs a script, but only if the script has not been loaded before. <p>I set this one up, in order to allow you to load the script on the moment they are first called. My Star Story game took great advantage of this possibility
	LoadNew Tag,File
	Run tag,f,p
	End Method
	
	Rem
	bbdoc: Adds a script from MultiScript to be executed when Bye or similar instruction is called.
	about: Inside the requested script, the function GALE_BYE() will be searched for and executed. No parameters will be taken, and no values will be returned. If a script is not loaded on the moment Bye is called, this part in the sequence will be ignored
	End Rem
	Method AddBye(Tag$) ' BLD: Adds a script from MultiScript to be executed when Bye or similar instruction is called.<p>Inside the requested script, the function GALE_BYE() will be searched for and executed. No parameters will be taken, and no values will be returned. If a script is not loaded on the moment Bye is called, this part in the sequence will be ignored
	End Method
	
	End Type

Rem
bbdoc: A variable which contains the ScriptMS object in the same manner your Lua scripts have it so you can code it the same way in BlitzMax as you script it in Lua.
End Rem
Global GALE_MS:TScriptBase 
GALE_MS = New TScriptBase
GALE_Register GALE_MS,"MS"
