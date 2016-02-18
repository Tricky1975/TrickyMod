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
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 14.03.15

End Rem
Strict

Rem
History:
12.03.31 - Initial version
14.03.15 - Adeptions for the driver based GALE
End Rem

import Tricky_UNITS.MKL_Version
Import gale.Main

MKL_Version "GALE - GALE_Chain.bmx","14.03.15"
MKL_Lic     "GALE - GALE_Chain.bmx","Mozilla Public License 2.0"


Global GALE_Chain_JCR:TMap ' This variable must contain the JCR dir you are using for this project, or the project will most likely crash

Type TChain
	Field SavedVariablesScript$
	Field ScriptFile$
	Field Lua:TLua
	End Type

Type TChainList Extends TMap
	Method Add(Script$,ID$="")
	Local L:TLua = GALE_LoadScript(GALE_Chain_JCR,Script$)
	If Not L
		GALE_JBC_Error L,"Runtime Error","Chain >> Add Script ~q"+Script+"~q >> Script could not be built!"
		Return
		EndIf
	Local I$ = ID
	If I="" I=StripAll(Script)
	Local TC:TChain = New TChain
	TC.Lua = L	
	TC.ScriptFile = Script
	MapInsert Self,Upper(I),TC
	End Method
	
	Method Run(ID$)
	Local TC:TChain = TChain(MapValueForKey(Self,Upper(ID)))
	If Not TC Return GALE_JBC_Error(TC.LuA,"Runtime Error","Chain >> Run Script ~q"+ID+"~q >> Script could not be found")
	TC.Lua.Run("Main",Null)
	TC.SavedVariablesScript = TC.Lua.Save("SAVE")
	End Method
	
	Method Reload(ID$,EmptySave=0)
	Local TC:TChain = TChain(MapValueForKey(Self,Upper(ID)))
	If Not TC GALECON.GALEConsoleWrite("WARNING! Cannot reload script ~q"+ID+"~q, because it doesn't exist!"); Return
	If EmptySave TC.SavedVariablesScript=""
	TC.Lua = GALE_LoadScript(GALE_Chain_JCR,TC.ScriptFile,TC.SavedVariablesScript)
	End Method
	
	Method ReloadAll(EmptySave=0)
	For Local ID$ = EachIn MapKeys(Self)
		Reload ID,EmptySave
		Next
	End Method
	End Type

Global ChainList:TChainList = New TChainList

	
	

Type TGALE_Chain ' BLD: Object Chain\nThis is the chaining object some GALE based project use.<br>The setup is that the multiple scripts all with a different function, and that this object is a maneger between them. It will contantly search for the "Main" function in the desired script, when the main function has stopped it will look for the Main function in the next script.<p>Perhaps it's a bit hard to explain, but I guess when you actually work with all this you get the picture.<p>After the exectution of the main function the system will automatically perform a 'Serialize' on all variables marked as 'SAVE' in the .lsv file.<br>But a manual go, also works.
	Field Chain$ ' BLD: Assign a value to this variable to determine which script to execute once this one has been completed. By default the value is set to "START", and thus as soon as the 'chaining' has begun the script loaded under that ID will be executed. When set to "QUIT"," "EXIT" or "BYE" the system will execute the script under that value (if available) and terminate the chaining immediately after.
	
	Method Script(ScriptFile$,ID$="") ' BLD: Loads a script to a chain ID, when you don't give up an ID, the ID will be the name of the script file with path names and extentions removed. The ID are case insenstive, meaning that GaMeScRiPt and GAMESCRIPT are handled as the same ID. <p><i>NOTE</i><br>When the ID already exists the new script will overwrite the old one.
	ChainList.Add ScriptFile,ID
	End Method
	
	Method Reload(ID$) ' BLD: Reloads + recompiles a scripts from the start. This can be an important measure when you need to load a save game with saved variables. Please note that, nearly all projects of mine this is done automatically at the time I need to, however if you plan to make a new project by yourself including GALE you may need to deal with this.
	ChainList.Reload(ID)
	End Method
	
	Method ReloadAll() ' BLD: Reloads + recompiles all scripts.
	ChainList.reloadAll
	End Method
	
	Method Path(PathName$) ' BLD: Loads an entire folder for chaining and the ID will be the filename without pathname. <p>NOTES:<ol type=i><li>For security reasons this will NOT work recursively<li>To make sure only lua scripts are included the extention .lua must be given to all scripts.<li>Should an existing ID pop up, it will be overwritten, so use this one with care</ol>
	For Local File$=EachIn MapKeys(GALE_Chain_JCR)
		If ExtractDir(File)=Upper(pathName) Or (ExtractDir(File)+"/")=Upper(pathname) 
			DebugLog "Adding chain lua ~q"+File+"~q to chain ID: "+StripAll(File)
			Script File,StripAll(File)
			EndIf
		Next	
	End Method
	
	Method New() ' Should NOT be documented in BLD :)
	Print "New chainer object started"
	Chain = "START"
	End Method
	
	End Type

Global Chain:TGALE_Chain = New TGALE_Chain
G_LuaRegisterObject Chain,"Chain"

Function ChainStart()
Local ChainNow$
Repeat
ChainNow = Chain.Chain
If Not MapContains(Chainlist,ChainNow)
	'EndGraphics
	GALE_Error "GALE - Chain~n~nThere is no Lua script tied to: "+ChainNow+"~n~nApplication ~q"+StripAll(AppFile)+"~q has been terminated!"
	End
	EndIf
Print "CHAIN - running script ID: "+ChainNow	
Chainlist.Run(ChainNow)
Until Upper(ChainNow)="BYE" Or Upper(ChainNow)="EXIT" Or Upper(ChainNow)="QUIT"
End Function
