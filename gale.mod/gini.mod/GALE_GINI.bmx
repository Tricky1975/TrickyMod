Strict

Import gale.Main

MKL_Lic        "",""
MKL_Version    "",""


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
			MapInsert inimap,Upper(tag),ReadIni(JCR_B(JCR_Lua_Ini_PatchMap))
		End Method
		
		Method RawSave(tag$,File$)
			SaveIni file,Get(Tag)
		End Method
		
		Method Get:TIni(Tag$)
			Return TIni(MapValueForKey(inimap,Upper(tag)))
		End Method
		
	End Type
	
	GALE_Register New GaleINIAPI,"GINI"			
