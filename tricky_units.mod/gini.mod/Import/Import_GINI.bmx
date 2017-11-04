Rem
  GINI.bmx
  2015, 2016
  version: 17.11.04
  Copyright (C) 2017 Jeroen P. Broks
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
End Rem
Strict
Import tricky_units.StringMap
Import tricky_units.advdatetime
Import tricky_units.Listfile

MKL_Version "Tricky's Units - GINI.bmx","17.11.04"
MKL_Lic     "Tricky's Units - GINI.bmx","ZLib License"


Rem
bbdoc: When set to "true" the .list method will automatically create a list when it doesn't yet exist
End Rem
Global GINI_AUTOCREATELIST = False

Private
Type tf
	Field f(Ini:TIni,para$)
	End Type
	
Global tfm:TMap = New TMap	

Function IniCall(name$,ini:TIni,para$)
Local f:tf = tf(MapValueForKey(tfm,Upper(name)))
If Not f Return Print("ERROR! Call: I could not retrieve function: "+name)
f.f(ini,para)
End Function

Public

Rem
bbdoc: Registers a function to initfile
about: These functions can be called when loading an ini file. I must note this is a read-only function, as the effect of it will be deleted when you write these functions. Just register a function with the ini and a single string as parameter. The Function can then do with the ini according to what the ini file wants. (This function works case INSENSITIVELY)
End Rem
Function Ini_RegFunc(Name$,Func(Ini:TIni,Para:String))
Local f:tf = New tf
f.f = func
MapInsert tfm,Upper(name),f
End Function

Rem 
bbdoc: Variable used by init reader/writer
End Rem
Type TIni
	Field Vars:StringMap = New StringMap
	Field Lists:TMap = New TMap
	
	Rem
	bbdoc:A list of all vars of use with eachin
	End Rem
	Method EachVar:tmapenumerator()
		Return MapKeys(Vars)
	End Method
	
	Rem
	bbdoc: Read var from ini
	End Rem	
	Method C$(T$)
	Return Vars.value(Upper(T))
	End Method
	
	Rem
	bbdoc: Write var to ini
	End Rem
	Method D(T$,V$)
	MapInsert Vars,Upper(T),V
	End Method
	
	Rem 
	bbdoc: Destroys a var from ini
	End Rem
	Method Kill(T$)
	MapRemove Vars,Upper(T)
	End Method
	
	Rem
	bbdoc: creates a list, in the ini
	End Rem
	Method CList(T$,OnlyIfNew=False)
	If OnlyIfNew And MapContains(lists,Upper(T)) Then Return
	MapInsert lists,Upper(T),New TList
	End Method
	
	Rem
	bbdoc: Returns a list if it exists as a TLIST. (Please note, this TLIST may ONLY contain strings).
	End Rem
	Method List:TList(T$)
		If GINI_AUTOCREATELIST And (Not MapContains(lists,Upper(T))) MapInsert lists,Upper(T),New TList
		Local ret:TList = TList(MapValueForKey(lists,Upper(T)))
		If Not ret Print("WARNING! List "+T+" not found!")
		Return ret
	End Method
	
	Rem
	bbdoc: Adds item to a list. If the list does not yet exist, it will automatically be created
	End Rem
	Method Add(T$,Item$)
	If Not MapContains(lists,Upper(T)) clist(T)
	ListAddLast list(T),item
	End Method
	
	Rem
	bbdoc: Creates a duplicate reference of the of the list in a new TAG. If the target list exists, it will be destroyed.
	End Rem
	Method DuplicateList(Original$,Target$)
	Local T:TList = list(original)
	Assert T Else "Original list does not exist"
	If Not t Return Print("WARNING! List "+original+" does not exist!")
	MapInsert lists,Upper(TARGET),T
	End Method
	
	End Type
	
	
Const AllowedChars$ = "qwertyuiopasdfghjklzxcvbnm[]{}1234567890-_+$!@%^&*()_+QWERTYUIOPASDFGHJKL|ZXCVBNM<>?/ '."

Function IniString$(A$,XAllow$="")
Local i
Local ret$[] = ["",A]
Local allowed = True
For i=0 Until Len(A)
	allowed = allowed And (allowedchars+XAllow).find(Chr(A[i]))>=0
	'If Not allowed Print "I will not allow: "+Chr(A[i])+"/"+A
	ret[0]:+"#("+A[i]+")"
	Next
Return ret[allowed]	
End Function

Function UnIniString$(A$)
Local ret$=A
Local i
For i=0 Until 256
	ret = Replace(ret,"#("+i+")",Chr(i))
	Next
Return ret	
End Function

Rem
bbdoc: Saves ini data into a file.
about: The "File" variable, may be a string containing the file name, or a stream to which you want to add this data.
End Rem
Function SaveIni(file:Object,Ini:TIni)	
Local BT:TStream
Local f
Local Done:TList = New TList
Local L:TList = New TList
Local LN$,Dupe
Local K$
If String(file)
	f = True
	bt = WriteFile(String(file))
ElseIf TStream(file)
	f = False
	bt = TStream(file) 	
	EndIf
If Not BT
	Print "ERROR!"
	If String(file) 
		Print "SaveIni: Error writing to "+String(file)
	Else
		Print "SaveIni: Either a file could not be created or an unsupported object type is given to me"
		EndIf
	Return
	EndIf	
WriteLine bt,"[rem]~nGenerated by: "+StripDir(AppFile)+" ("+AppTitle+")~n"+PNow()+"~n"
WriteLine bt,"[vars]"
For K$=EachIn(MapKeys(ini.Vars))
	WriteLine bt,IniString(K)+"="+IniString(Ini.C(K),",.")
	Next
WriteLine bt,""
For K$=EachIn(MapKeys(ini.lists))
	LN$=IniString(K)
	If Not ListContains(L,K)
		For Local K2$=EachIn(MapKeys(ini.lists))
			If K<>K2 And (Not ListContains(L,K2)) And ini.list(K)=ini.list(K2) Then
				LN:+","+IniString(K2)
				ListAddLast L,K2
				EndIf
			Next
		WriteLine BT,"[List:"+LN+"]"	
		For Local V$=EachIn ini.list(K)
			WriteLine bt,IniString(V,",.:;~q")
			Next
		WriteLine BT,""	
		EndIf	
	Next	
If f CloseFile bt
End Function			
			
Rem
bbdoc: Loads an ini into a file. 
about: When merge is set to 1, the data from the ini var is linked to the existing ini var if it's not null. The "File" variable can be any type ReadStream() accepts for filereading. <p>NOTE: After a bit of research I could implement the old syntax for inifiles as well in loading, however the support is limited, and when saving it will always use the new syntax.
End Rem
Function LoadIni(File:Object,Ini:TIni Var,Merge=False)
If Merge Or (Not Ini) Ini=New TIni
Local wtag$,Lst:TList,line$,tag$,tagsplit$[],tagparam$[],tline$,cmd$,para$,pos
tag$="OLD"
For line=EachIn Listfile(File)
	If line Then
		If Left(Trim(line),1)="[" And Right(Trim(line),1)="]" 
			wTag = Mid(Trim(line),2,Len(Trim(line))-2)
			tagsplit=wTag.split(":")
			tag = tagsplit[0].toupper()
			If Upper(Tagsplit[0])="LIST"
				If Len(Tagsplit[0])<2 Return Print("ERROR! Incorrectly defined list!")
				lst = New TList				
				For Local K$=EachIn tagsplit[1].split(",")
					'ini.clist(UnIniString(K))
					MapInsert Ini.Lists,Upper(UnIniString(K)),lst
					Next
				'lst=ini.list(UnIniString(K))	
				EndIf
		Else
			Select tag
				Case "REM"
				Case "OLD"
					tline = Trim(line)
					If Left(tline,2)<>"--" 
						tagsplit=tline.split(":")
						If Len(tagsplit)<2 
							Print "Invalid old definition: "+tline
						Else
							If Len(tagsplit)>2 
								For Local i=2 Until Len(tagsplit)
									tagsplit[1]:+":"+tagsplit[i]
									Next
								EndIf
							Select tagsplit[0]
								Case "Var"
									tagparam = tagsplit[1].split("=")
									If Len(tagparam)<2 
										Print "Invalid old var definition: "+Tline
									Else
										For Local ak=0 Until 256 
										    tagparam[1] = Replace(tagparam[1],"%"+Right(Hex(ak),2),Chr(ak))
										    Next
										ini.D(tagparam[0],tagparam[1])
										EndIf
								Case "Add"
									tagparam = tagsplit[1].split(",")
									If Len(tagparam)<2 
										Print "Invalid old var definition: "+Tline
									Else
										ini.Add(tagparam[0],Right(tagsplit[1],Len(tagsplit[1])-(Len(tagparam[0])+1)))
										EndIf
								Case "Dll"		
									tagparam = tagsplit[1].split(",")
									If Len(tagparam)<2 
										Print "Invalid old var definition: "+Tline
									Else
										ini.DuplicateList(tagparam[0],tagparam[1])
										EndIf
								End Select													
							EndIf
						EndIf
				Case "SYS","SYSTEM"		
					tline = Trim(line)
					pos = tline.find(" ")
					If pos<-1 pos = Len(tline)
					cmd  = Upper(tline[..pos])
					para = tline[pos+1..]
					Select cmd
						Case "IMPORT","INCLUDE"
							pos = para.find("/")<0
							?win32
							pos = pos And Chr(para[1])<>":"
							pos = pos And para.find("\")
							?
							If pos para=ExtractDir(String(file))+"/"+para
							?debug
							Print "Including: "+para
							?
							LoadIni para,ini
						Default
							Print "System command "+cmd+" not understood: "+tline
						End Select	 
				Case "VARS"
					If line.find("=")<0 
						Print "Warning! Invalid var definition: "+Line
					Else
						tagsplit=line.split("=")
						Ini.D UnIniString(tagsplit[0]),UnIniString(tagsplit[1])
						EndIf
				Case "LIST"
					ListAddLast lst,uninistring(line)
				Case "CALL"
					If line.find(":")<0
						Print "Call: Syntax error: "+line
					Else
						tagsplit=line.split(":")
						inicall tagsplit[0],ini,UnIniString(tagsplit[1])
						EndIf
						
				Default
					Print "ERROR! Unknown tag: "+tag
					Return	
				End Select	
			EndIf
		EndIf		
	Next
End Function

Rem
bbdoc: If LoadIni is too awkward for you to use, you can use this in stead
returns: The TIni loaded
End Rem
Function ReadIni:TIni(file:Object)
	Local ret:TIni = New TIni
	LoadIni file,ret
	Return ret
End Function	
	
