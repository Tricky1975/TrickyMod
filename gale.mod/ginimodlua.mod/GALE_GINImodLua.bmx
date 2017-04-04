Rem
        GALE_GINImodLua.bmx
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.04.04
End Rem
Rem
        GALE_GINI.bmx
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.03.22
End Rem
Strict

Import gale.Main
Import tricky_units.GINI

MKL_Lic     "GALE - GALE_GINImodLua.bmx","Mozilla Public License 2.0"
MKL_Version "GALE - GALE_GINImodLua.bmx","17.04.04"


Private

	Global inimap:TMap = New TMap
	
Public


	Rem
	bbdoc: Register an actually loaded ini into GALE
	End Rem
	Function GALE_RegisterIni(Ini:TIni,Tag$)
		MapInsert inimap,Upper(tag),ini
	End Function
	
	Rem
	bbdoc: For JCR6 functionality this must be set
	End Rem
	Global JCR_Lua_Ini_PatchMap:TJCRDir

Private	
	Type GALEINIAPI
		Method RawLoad(Tag$,File$)
			MapInsert inimap,Upper(tag),ReadIni(file)
		End Method
		
		Method Have(Tag$)
			Return MapContains(inimap,Upper(tag))
		End Method
		
		Method JCRLoad(Tag$,Entry$)
			MapInsert inimap,Upper(tag),ReadIni(JCR_B(JCR_Lua_Ini_PatchMap,entry))
		End Method
		
		Method RawSave(tag$,File$)
			SaveIni file,Get(Tag)
		End Method
		
		Method Get:TIni(Tag$)
			Return TIni(MapValueForKey(inimap,Upper(tag)))
		End Method
		
	End Type
	
	GALE_Register New GaleINIAPI,"GINI"			
