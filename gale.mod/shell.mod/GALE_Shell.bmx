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



Version: 13.12.26

End Rem
Import GALE.Main

MKL_Version "GALE - GALE_Shell.bmx","13.12.26"
MKL_Lic     "GALE - GALE_Shell.bmx","Mozilla Public License 2.0"

Global GALE_Shell_JCR:TMap ' This variable MUST be set in order to use GALE_Shell properly.

Global GALE_Shell_SavedVars:TMap = New TMap

Function GShell(Script$,LoadSavedVars=0)
Local SV$ = ""
If LoadSavedVars SV=String(MapValueForKey(GALE_Shell_SavedVars,Upper(Script)))
Local L:TLua = GALE_LoadScript(GALE_Shell_JCR,Script)
L.Run "Main",Null
If (MapContains(GALE_Shell_JCR,Upper(StripExt(Script)+".LSV")))
	MapInsert GALE_Shell_SavedVars,Upper(script),L.Save("SAVE")
	EndIf
End Function

Type GALE_Sh ' BLD: Object Shell\nIncludes "shell" to Lua.
	Method Shell(Script$,LoadSavedVars=0) ' BLD: Loads a script, executes it's Main() function and removes it from the memory.<br>If you have a .lsv file of the script it will store all variables with the "SAVE" tag into the memory and include them to the script if the LoadSavedVars parameter is set to 1 when you load the script again at a later occurance
	GShell Script,LoadSavedVars
	End Method
End Type

G_LuaRegisterObject New GALE_Sh,"Shell"
