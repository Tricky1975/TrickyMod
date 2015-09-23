Rem
        JCR6_Main.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.23
End Rem

' History:
' 15.02.01 - JCR6 Main module declared "safe"
' 15.02.17 - Added an error driver so your game or utility can set up a callback based error handling whenever a JCR6 error pops up.
' 15.03.11 - Fixed a bug that could cause errors when having multiple dir drivers loaded and recognizing only the first in line.
' 15.08.04 - Add Patch can now force all files in the patch JCR file into a path in the entire dir repository. Please note this is optional, though older code using this routine will NOT have to be changed. :)
'          - Development note removed. This file should now be safe to use, though keep in mind that unless downloaded from sourceforge, this version may constantly be updated and show some bugs are a result. 8)
' 15.08.15 - Added a function to grab an entry easily.
' 15.09.15 - JCR6 can now check if files were changed. JCR_B is now also protected against usage in modified files and will throw an error if a JCR6 file was changed.
Strict


Import brl.map
Import brl.linkedlist
Import brl.stream
Import brl.filesystem
Import brl.retro
Import brl.system
Import bah.volumes

Import tricky_Units.StringMap
Import tricky_units.MKL_Version
Import tricky_units.MD5 ' Will be used for verification purposes. Full support for this comes later.

?linux
Import "-ldl"
?

MKL_Version "JCR6 - JCR6_Main.bmx","15.09.23"
MKL_Lic     "JCR6 - JCR6_Main.bmx","Mozilla Public License 2.0"

Private
Const DEBUG = False
Public

' -------------- READER

Rem
bbdoc:When set to true, JCR6 will dump any errors that occur to stdout.
End Rem
Global JCR6DumpError = True
Rem
bbdoc:When set to true, JCR6 will crash out on an error, and (if possible) put on a comment box containing the error. If set to true, it will also dump on std out, like JCR6DumpError does. Cut short, if this is set the JCR6DumpError state doesn't matter any more :)
End Rem
Global JCR6CrashError = False
 
Type ConfigMap Extends TMap
     Method T$(Tag$)
	If MapContains(Self,"$"+Tag) Return "Str"
	If MapContains(Self,"&"+Tag) Return "Bool"
	If MapContains(Self,"%"+Tag) Return "Int"
	Return "Uknown"
	End Method
     Method S$(Tag$)
      Return String(MapValueForKey(Self,"$"+Tag))
	End Method
     Method I(Tag$)
      Return String(MapValueForKey(Self,"%"+Tag)).ToInt()
	End Method
     Method B:Byte(Tag$)
      Return String(MapValueForKey(Self,"&"+Tag)).Toint()
	End Method
     Method Call$(Tag$)
	Return String(MapValueForKey(Self,Tag))
	End Method
     Method Def(Tag$,value$)
	MapInsert Self,Tag,Value
	End Method	
     End Type

Private
Function ALT_READSTRING$(BT:TStream)
Local L = ReadInt(BT)
Return ReadString(BT,L)
End Function

Function ALT_WRITESTRING(BT:TStream,S$)
WriteInt BT,Len(S)
WriteString BT,S
End Function
Public

Rem
bbdoc: This type contains all entry data. 
about: For those who went into the deep of JCR5, this type REPLACES TRFATEntry!<p>NEVER assign any data to this yourself or JCR6 will malfunction (only exception is of course when you are writing a new file format driver for JCR6).
EndRem
Type TJCREntry
	Field FileName$
	Field MainFile$
	Rem
  	bbdoc: Contains the size of an entry (the REAL size, not the compressed size)
 	 End Rem
	Field Size:Int
	Field Offset:Int
	Field Storage$
	Field Encryption$
	Field CompressedSize:Int
	Field MV:TMap = New TMap
	Field Author$
	Field Notes$
	Field PVars:StringMap
	Method M$(T$) Return String(MapValueForKey(MV,T)); End Method
	Method MI(T$) Return String(MapValueForKey(MV,T)).ToInt(); End Method
	Method MD(T$,V$) MapInsert(MV,T,V); End Method
	Rem
	bbdoc: Shows the notes with all variables substituted.
	End Rem
	Method VNotes$()
	Local ret$ = Notes
	If Not PVars Return ret
	For Local Key$=EachIn MapKeys(PVars)
		ret = Replace(ret,key,PVars.value(Key))
		Next
	Return ret
	End Method
	EndType
	
Type TJCRMFiles
	Field size
	Field ftime
	End Type	

Rem
bbdoc: This type is used by JCR_Dir() to store all information in.
End Rem
Type TJCRDir
	Field Entries:TMap = New TMap
	Field comments:StringMap = New StringMap
	Field config:ConfigMap = New Configmap
	Field Variables:StringMap = New StringMap
	Field DirDrvName$
	Field FATSize,FATCSize,FATAlg$
	Field FATOffset
	Field MainFiles:Tmap = New Tmap
	
	Method EntryData:TJCREntry(fil$)
	Return TJCREntry(MapValueForKey(entries,Upper(fil)))
	End Method
	
	Method UpdateMain() ' Undocumented, and should only be used by the JCR6 module itself.
	Local MF:tjcrMFiles
	ClearMap mainfiles
	For Local E:TJCREntry = EachIn MapValues(entries)
		If Not MapContains(Self,E.MainFile)
			MF = New tjcrmfiles
			MapInsert E.Mainfile
			mf.size  = FileSize(E.Mainfile)
			mf.fTime = FileTime(E.Mainfile)
			EndIf
		Next
	End Method
	
	End Type

Type TJCR_Error
	Field ErrorMessage$
	Field File$
	Field Entry$
	Field Func$
	End Type
	
Rem
bbdoc:This variable will be set to Null when no error occurred in the last JCR operation. Otherwise it will contain an object with the field ErrorMessage containing the error message, the field File with the JCR file you were trying to access and Entry with the entry (if one is asked for). The variable function contains the name of the function in which the error was caused.
End Rem
Global JCR_Error:TJCR_Error

Global JCR_JAMERR_DRIVERLIST:TList = New TList
Rem
bbdoc: This type can be used to extend in order to make JCR respond with your own error messaging! If you chain this to multiple ones, then they will ALL be executed (in the order in which they were added during running), so use this feature with care!
End Rem
Type JCR_JAMERR_Driver
	Rem
	bbdoc: This function will be called in order to give your own error messaging.
	about: The dump$ stat will contain the full error as a (multi-line) string, the ERR will contain the actual object var in which all error data is stored. What is best to you?
	End Rem
	Method DumpError(Dump$,ERR:TJCR_Error) Abstract
	
	Method New() ListAddLast JCR_JAMERR_DRIVERLIST,Self End Method
	
	End Type

'Private
'I decided to make this public in order to make drivers able to call to it!
Function JCR_JAMERR(Error$,File$,Entry$,Func$)
Local Dump$
JCR_Error = New TJCR_Error
JCR_Error.Errormessage = Error
JCR_Error.File = File
JCR_Error.Entry = Entry
JCR_Error.Func = Func
Dump$ =  "==== JCR6 ERROR!~n"
Dump$ :+ "     Error:         "+Error+"~n"
Dump$ :+ "     File:          "+File+"~n"
Dump$ :+ "     Entry:         "+Entry+"~n"
Dump$ :+ "     Function:      "+Func+"~n"
Dump$ :+ "==== END ERROR MESSAGE"
If JCR6DumpError Or JCR6CrashError
	Print Dump
	EndIf
For Local JD:JCR_JAMERR_Driver = EachIn JCR_JAMERR_DRIVERLIST
	JD.DumpError Dump,JCR_Error
	Next		
If JCR6CrashError
	Notify Dump,True
	End
	EndIf	
End Function
'Public


Private
Global DIRDRIVERS:TList = New TList
Global COMPDRIVERS:TMap = New TMap
Public


Rem
bbdoc:Driver type. 
about:This type can be used to add your own file formats to JCR6. It must contain three methods. Called Recognize(fil$) which returns true if a file is recognized as readable by your driver, and Dir(fil$) which returns the data into a TJCRDir object. Both methods will only take the filename for a parameter. The third method is Name$() which should just return the name of the file type.<p>When you just use JCR6 the way it is, you won't need this type :)
End Rem
Type DRV_JCRDIR
     Rem
     bbdoc: When writing a driver, this method must be present in order to tell JCR6 how to recognize a file.
     End Rem
     Method Recognize(fil$) Abstract
     Rem 
     bbdoc: When writing a driver, this method must be present in order to tell JCR6 how to read a directory. I recommend a thorough analysis of the BlitzMax source code of JCR6 for this!
     End Rem
     Method Dir:TJCRDir(fil$) Abstract
     Rem
     bbdoc: This function should return the name of your driver as a string. Nothing more.
     EndRem
     Method Name$() Abstract

     Method New()
     ListAddLast DIRDRIVERS,Self
     End Method     

     End Type


Rem
bbdoc: This type can be used to create your own compression driver. Just extend it.
about: When you just leave it to the drivers JCR6 has by default, then ignore the existance of this type!
End Rem
Type DRV_Compression
	Rem
	bbdoc: This function must tell the driver how to compress a file. The B parameters must contain the bank to be compressed, and it should return the compressed data into a bank.
	End Rem
	Method compress:TBank(B:TBank) Abstract
	Rem
	bbdoc: This Function must tell the driver how To decompress (Or expand) a file. The B parameter must contain the bank To be decompressed, And it should Return the decompressed data into a bank.
	EndRem
	Method Expand:TBank(B:TBank,realsize) Abstract
	End Type
	
Rem
bbdoc: If you made a driver, you need this function to register it.
about: For example if you made a driver for lzma in a type named 'JCR_LZMA' then type: RegisterCompDriver("lzma",New JCR_LZMA).<br>As this function acts case sensitive it's recommended to only use LOWER CASE for driver names.
End Rem	
Function RegisterCompDriver(Name$,Driver:Object)
If DEBUG Print "Added compression driver named: "+Name
If Not Driver
	JCR_JamErr("Tried to put in an emptry driver under name: "+Name,"N/A","N/A","RegisterCompDriver(~q"+Name+"~q,Null)")
	EndIf
MapInsert COMPDRIVERS,Name,Driver
End Function

Rem
bbdoc: Returns all the names of the currently registered drivers in an array.
End Rem
Function ListCompDrivers:String[]()
Local ret$[]
Local k$,c
For k=EachIn MapKeys(COMPDRIVERS) c:+1 Next
ret = New String[c]
c=0
For k=EachIn MapKeys(COMPDRIVERS) ret[c]=k; c:+1 Next
Return ret
End Function

Private
Function CDRIVE:DRV_Compression(Tag$)
Local D:DRV_Compression = DRV_Compression(MapValueForKey(COMPDRIVERS,Tag))
If Not D Return
Return D
End Function

'A standard driver to make sure 'Store' is supported without much hassle. As 'Store' doesn't compress at all, it's just returning the banks without doing anything.
Type DRV_STORE Extends DRV_Compression
	Method compress:TBank(B:TBank) Return B; End Method
	Method Expand:TBank(B:TBank,realsize) Return B; End Method
	End Type
RegisterCompDriver "Store",New DRV_STORE	
Public

Private
'The standard JCR6 driver. As this is the default setting this driver will ALWAYS be loaded!
Type DRV_JCR6 Extends DRV_JCRDIR

      Method Name$()
      Return "JCR6"
      End Method

	Method Recognize(fil$)
	If FileType(fil)<>1 And Left(fil,8)<>"incbin::" Return False
	Local bt:TStream = ReadFile(fil)
	If Not bt Return False
	Local head$ = ReadString(bt,5)
	CloseFile bt
	Return head="JCR6"+Chr(26)
	End Method
	

	Method Dir:TJCRDir(fil$)
	Local ret:TJCRDir = New TJCRDir
	Local bt:TStream = ReadFile(fil)
	If Not bt JCR_JAMERR("File could not be opened!",fil,"<NONE>","JCR6.Dir()"); Return Null
	Local head$ = ReadString(bt,5)
	If head<>"JCR6"+Chr(26)
		'Print "NOT A JCR6 FILE! HOW COULD THIS HAPPEN!?"
		Throw "NOT A JCR6 FILE! HOW COULD THIS HAPPEN!?"
		End
		'Yes a guaranteed crashout, as this can only happen when you use JCR6 on a manner in which it should NOT be used!!!
		EndIf
	ret.FATOffset = ReadInt(BT)	
	Local ttag = ReadByte(BT)
	Local Tag$
	While ttag<>255
		'Print "typetag = "+ttag
		Tag = alt_readstring(BT)
		'Print "Tag:"+Tag
		Select ttag
			Case 1	ret.Config.def("$"+Tag,Alt_readstring(bt))
			Case 2	ret.config.def("&"+Tag,ReadByte(BT)) 'Print "value: "+ret.config.i(tag)
			Case 3	ret.config.def("%"+Tag,ReadInt(BT))
			Default
				JCR_JAMErr("Unknown config type tag ("+Tag+")",fil,"N/A","Dir()")
				CloseFile bt
				Return				
			End Select	
		ttag = ReadByte(BT)
		Wend
	If DEBUG
		For Local K$ = EachIn MapKeys(ret.config)
			Print "Config['"+K+"'] = "+ret.config.call(K)
			Next
		EndIf	
	SeekStream BT,ret.FATOffset
	ret.fatSize		= ReadInt(BT)
	ret.fatCSize	= ReadInt(BT)
	ret.FATAlg		= ALT_Readstring(BT)
	Local FATBANK:TBank = CreateBank(ret.fatCSize)
	ReadBank(FATBANK,BT,0,ret.fatCSize)
	If Not CDrive(ret.FATALG) 
		CloseFile BT
		JCR_JAMERR("Unknown compression method for FAT ("+ret.FATALG+")",Fil$,"N/A","JCR_Dir(~q"+fil+"~q)")
		Return Null
		EndIf
	If debug Print "Expanding with algorithm: "+Ret.FATALG
	Local FATTRUEBANK:TBank = CDrive(Ret.FATALG).Expand(FATBANK,ret.FATSIZE)
	FATBANK = Null ' Let the old data we no longer need be picked up by the Garbage Collector.
	Local BTF:TStream = CreateBankStream(FATTRUEBank)
	Local TheEnd = Eof(BTF)
	Local mtag,fttag$,ftag
	'Local tag$
	Local E:TJCREntry
	While Not Eof(BTF) 
		mtag = ReadByte(BTF)
		If debug Print "New Main Tag: "+mtag
		Select MTag
			Case $ff	TheEnd = True
			Case   1	
				tag = ALT_ReadString(BTF)
				Select tag
					Case "FILE"
						If DEBUG Then Print "Gonna add a new entry!"
						E = New TJCREntry
						E.MainFile = Fil
						ftag=ReadByte(BTF)						
						While ftag<>255
							If debug Print "New File Entry tag: "+ftag
							Select FTag
								Case 1
									Local T$ = alt_readstring(BTF)
									Local V$ = alt_readstring(BTF)
									If debug Print "string "+t+" = ~q"+V+"~q"
									E.MD(T,V)
								Case 2
									E.MD(alt_readstring(BTF),ReadByte(BTF))
								Case 3
									Local IT$,IV
									IT = alt_readstring(BTF)
									IV = ReadInt(BTF)
									If debug Print "int "+IT+" = "+IV
									E.MD(IT,IV)
								Case 255
								Default
									JCR_JamErr("Unknown type in JCR6 dir! ("+ftag+")!",fil,"N/A","JCR_Dir(~q"+fil+"~q)")
									Return
								End Select ' FTag
							If Eof(BTF) JCR_JamErr("Entry beyond EOF!",fil,"N/A","JCR_Dir(~q"+fil+"~q)")	
							ftag=ReadByte(BTF)
							Wend ' tfag <>255
						E.FileName = E.M("__Entry")
						E.Size = E.MI("__Size")
						E.CompressedSize = E.MI("__CSize")
						E.Offset = E.MI("__Offset")
						E.Storage = E.M("__Storage")						
						E.Author = E.M("__Author")
						E.Notes = E.M("__Notes")
						E.PVars = ret.Variables
						If ret.Config.B("__CaseSensitive") MapInsert ret.Entries,E.FileName,E Else MapInsert ret.entries,Upper(E.filename),E							
					Case "COMMENT"
					    Local T$ = alt_readstring(BTF)
						Local C$ = alt_Readstring(BTF)
						MapInsert ret.Comments,T,C
					Case "VAR"
					    Local K$ = alt_readstring(BTF)
						Local V$ = alt_Readstring(BTF)
						MapInsert ret.Variables,K,V			
					Case "REQUIRE","IMPORT"
						Local deptag = ReadByte(BTF)
						Local depk$,depv$
						Local depm:StringMap
						depm = New StringMap
						While deptag<>255
							depk = alt_readstring(BTF)
							depv = alt_readstring(BTF)
							MapInsert depm,depk,depv
							deptag = ReadByte(BTF)
							Wend
						Local depfile$ = depm.value("File")
						Local deppath = depm.value("AllowPath").toUpper()="TRUE"
						Local depsig$ = depm.value("Signature")
						Local depgetpaths:TList[2] 
						Local depcall$
						Local owndir$ = ExtractDir(fil)
						If owndir owndir:+"/"
						depgetpaths[0] = New TList
						depgetpaths[1] = New TList
						ListAddLast depgetpaths[0],owndir
						ListAddLast depgetpaths[1],owndir
						ListAddLast depgetpaths[1],GetUserAppDir()+"/JCR6/Dependencies/"						
						If Left(depfile$,1)<>"/" And Left(depfile$,2)<>":"
							For Local depdir$=EachIn depgetpaths[deppath]
								If (Not depcall) And FileType(depdir+depfile) depcall=depdir+depfile
								Next
						Else
							If FileType(depfile) depcall=depfile
							EndIf
						If depcall
							If (Not JCR_AddPatch(ret,depcall,depsig)) And MTag="REQUIRE"
								JCR_JAMErr("Required JCR6 addon file ("+depcall+") could not imported!~n~nImporter reported:~n"+JCR_Error.Errormessage,fil,"N/A","JCR 6 Driver: Dir()")
								Return
								EndIf
						ElseIf MTag="REQUIRE"
							JCR_JAMErr("Required JCR6 addon file ("+depcall+") could not found!",fil,"N/A","JCR 6 Driver: Dir()")
							EndIf
					Default
						CloseFile BTF
						CloseFile BT
						JCR_JamErr("Unknown command: "+tag,fil,"N/A","JCR_Dir(~q"+fil+"~q)")
						Return Null
					End Select ' tag
				Default
					JCR_JamERR("Unknown main tag("+MTag+")",fil,"N/A","JCR_Dir()")
					CloseFile btf
					CloseFile bt
					Return
			End Select	' Mtag
		Wend
	CloseFile BTF	
	CloseFile bt	
	Return ret
	End Method
	 
	End Type
New DRV_JCR6
Public	



Rem
bbdoc:Reads the directory contents of a JCR file.
about:Though you can request to access the JCR file directy, using this function is preferred (as the feature you request will do it otherwise, anyway). Having a pre-read directory also allows you to use the patching possibilities. The file types that can be read this way are defined by the drivers you loaded. When the file was not found or no drivers were present that recognize this file, this function will return Null
End Rem
Function JCR_Dir:TJCRDir(JCRFile$)
Local Ret:TJCRDir
Local RealJCRFile$ = JCRFile
If Not ExtractDir(RealJCRFile$) And RealJCRFile.find("::")<0 Then RealJCRFile = "./"+RealJCRFile
For Local DRV:DRV_JCRDIR = EachIn DirDrivers
      If DEBUG WriteStdout "Driver: "+DRV.NAME()+" ... "
	If DRV.Recognize(JCRFIle) Then
		If DEBUG Print "Recognized!"
		ret = New TJCRDir
		ret = Drv.Dir(realJCRFile)
		If ret ret.DirDrvName = DRV.Name()
		ret.UpdateMain		
		Return Ret
		EndIf		
	Next
If DEBUG Print "Not recognized!"
JCR_JAMERR "File not recognized!",JCRFile,"N/A","JCR_Dir()"
End Function

Rem
bbdoc: True if a JCR file contains a certain entry. False if it doesn't
End Rem
Function JCR_Exists(JCR:Object,Entry$)
Local M:TJCRDir
Local PM$
If String(JCR) 
	M=JCR_Dir(String(JCR))
	PM = "~q"+String(JCR)+"~q"
ElseIf TJCRDir(JCR)
	M=TJCRDir(JCR)
	PM = "<Dir Object>"
Else
	JCR_JamErr("Unknown object!","<???>",Entry,"JCR_B(<???>,~q"+Entry+"~q)")
	Return
	EndIf
If Not M Return
Local E$ = Entry$
If Not M.Config.B("__CaseSensitive") E=Upper(E)
Return MapContains(M.Entries,E)
End Function

Rem
bbdoc: Returns an entry record from a JCR with the given name.
End Rem
Function JCR_Entry:TJCREntry(JCR:Object,Entry$)
Local M:TJCRDir
Local PM$
If String(JCR) 
	M=JCR_Dir(String(JCR))
	PM = "~q"+String(JCR)+"~q"
ElseIf TJCRDir(JCR)
	M=TJCRDir(JCR)
	PM = "<Dir Object>"
Else
	JCR_JamErr("Unknown object!","<???>",Entry,"JCR_B(<???>,~q"+Entry+"~q)")
	Return
	EndIf
Local E$ = Entry$
If Not M.Config.B("__CaseSensitive") E=Upper(E)	
If Not MapContains(M.Entries,E)
	JCR_JamErr("Entry does not appear to exist!",PM,Entry+" ("+E+")","JCR_B")
	Return
	EndIf
Local Ret:TJCREntry = TJCREntry(MapValueForKey(M.Entries,E))
Return Ret
End Function
	
Rem
bbdoc:Reads the contents of a JCR entry into a bank. 
about:Some functions within BlitzMax allow you to load data from this. LoadImage for example. LoadImage(JCR_B("MyJCR.JCR","MyImage.png")) works.
End Rem
Function JCR_B:TBank(JCR:Object,Entry$)
Local M:TJCRDir
Local PM$
If String(JCR) 
	M=JCR_Dir(String(JCR))
	PM = "~q"+String(JCR)+"~q"
ElseIf TJCRDir(JCR)
	M=TJCRDir(JCR)
	PM = "<Dir Object>"
Else
	JCR_JamErr("Unknown object!","<???>",Entry,"JCR_B(<???>,~q"+Entry+"~q)")
	Return
	EndIf
If Not M Return
If JCR_Changed(M) 
	JCR_JamErr("Underlying JCR6 resource files have been modified since original load ("+JCR_Changed(M)+")",PM,entry,"JCR_B")
	Return
	EndIf
Local E$ = Entry$
If Not M.Config.B("__CaseSensitive") E=Upper(E)
If Not MapContains(M.Entries,E)
	JCR_JamErr("Entry does not appear to exist!",PM,Entry+" ("+E+")","JCR_B")
	Return
	EndIf
Local Ent:TJCREntry = TJCREntry(MapValueForKey(M.Entries,E))
If Not Ent JCR_JAMERR "Incorrect data received from entry!","<?>",entry,"JCR_B(<???>,~q"+Entry+"~q)"; Return
If Debug
	Print "Going to access "+E+" from file: "+Ent.Mainfile
	Print "Offset: "+Ent.Offset
	Print "Size: "+Ent.Size
	Print "CSize: "+Ent.CompressedSize
	Print "Storage: "+Ent.Storage
	EndIf
If Not CDrive(Ent.Storage) 
	JCR_JamErr "Compression algorithm '"+Ent.Storage+"' is unknown. Make sure the driver is loaded!",Ent.MainFile,Entry,"JCR_B"
	Return
	EndIf
Local BT:TStream	
Local cb:TBank
Local ucb:TBank
bt = ReadFile(Ent.MainFile)
SeekStream bt,ent.offset
cb = CreateBank(Ent.Compressedsize)
ReadBank cb,bt,0,ent.compressedsize
ucb = CDrive(Ent.Storage).Expand(cb,ent.size)
If ent.size<>BankSize(ucb)
	JCR_JamErr "Expansion error. Size mismatch ("+ent.size+"!="+BankSize(ucb)+")",Ent.MainFile,Entry,"JCR_B"
	EndIf
Return ucb	
End Function


Rem
bbdoc:Reads a JCR entry as a TStream. All TStream commands which can read out TStreams should be useable on this.
about:This is just a quick shortcut for ReadFile(JCR_B("MyJCR.JCR","MyEntry")), so you may use that in stead, but this shortcut is easier, I think :P
End Rem
Function JCR_ReadFile:TStream(JCR:Object,Entry$)
Return CreateBankStream(JCR_B(JCR,Entry))
End Function


Rem
bbdoc: This variable should contain the directory path of where to store the files created by JCR_E. Please always pick a folder in which files can be safely removed without doing any damage to your users.
End Rem
Global JCR_EDir$

Private
Global JCR_E_Swapfiles:TList = New TList
Global JCR_E_Cnt
Public

Rem
bbdoc: Extracts a JCR File to the given location
about: Please note that Dest$ will normally be considered a folder in which the extract the file to, however when 'DirectDest' is set to 'True' it will be a direct file to write to.
EndRem
Function JCR_Extract(JCR:Object,Entry:String,Dest$="",DirectDest=False)
'Local BT:JCR_Stream
Local DestDir$ = Replace(Dest,"\","/")
Local O:TStream
If Not DestDir DestDir="JCR_OUTPUT/"
If Right(DestDir,1)<>"/" DestDir:+"/"
Local DestFile$ = DestDir+Entry
If DirectDest DestFile = Dest
'JCRR_DumpError=""
'BT = JCR_Open(JCR,Entry)
Local bank:TBank = JCR_B(jcr,entry)
Rem
If Not BT 
	'If JCRR_DumpError="" JCRR_DumpError = "JCR_Extract("+(POBJ(JCR)+",~q"+Entry+"~q,~q"+Dest$+"~q,"+DirectDest)+"): Source could not be read!"
	Return False
	EndIf
End Rem	
CreateDir ExtractDir(Destfile),True
If Bank
	SaveBank(Bank,Destfile)
	Rem
	Else
	O = WriteFile(Destfile)
	If Not O
		'JCRR_Error "JCR_Extract("+(POBJ(JCR)+",~q"+Entry+"~q,~q"+Dest$+"~q,"+DirectDest)+"): Cannot write target file!"
		Print "JCR_E could not write a file!"
		Return False
		EndIf
	For Local P=1 To BT.EntrySize 
		WriteByte O,ReadByte(BT.Stream)
		Next
	CloseFile O
	EndRem
	Else
	Return False
	EndIf
'BT.Close	
Return True
End Function


Rem
bbdoc: Extracts a file to a temp folder and returns the name of the file where the data was extracted to. 
about: Frankly, this one has only been added for cases in which you really cannot use #JCR_B for any reason. But if JCR_B works, then you best not use this one, but that's my humble opinion.
Before using this function, you really shouldset the variable JCR_EDir$ first, in which you store the full path of your swap dir. Please note, I cannot guarantee the safety of any files stored in that folder. In other words, you should use a folder for this that is explicitly set up for this purpose.
JCR creates a log of all files JCR_E creates, and when you use the #JCR_E_Clear function, all these files will be deleted.
about: When you set the <i>Prefix</i> parameter this function will place that prefix in. This can prevent nasty effects from caching when doing this with two entries with the same bare filename (which is only an issue if JCR_E_Clear was used between loading the two).
End Rem
Function JCR_E$(JCR:Object,Entry$,Prefix$="")   
Local OP$
If Not JCR_EDir Return
JCR_EDir = Replace(JCR_EDir,"\","/")
If Right(JCR_EDir,1)<>"/" JCR_EDir:+"/"
OP = JCR_EDir+Hex(JCR_E_Cnt)+"_"+Prefix+StripDir(Entry)
JCR_Extract JCR,Entry,OP,1
DebugLog "JCR: Extracting "+Entry+" to "+OP
If FileType(OP)=1
	ListAddLast JCR_E_SwapFiles,OP
	JCR_E_Cnt:+1
	Return OP
	EndIf
End Function

Rem
bbdoc: Deletes all files previously created by #JCR_E
about: Important Note!<br>Please note that when your program ends all data #JCR_E creates for JCR_E_Clear is lost, meaning that JCR_E_Clear won't see this files any more and leave them alone. If left untended they'll remain there eating diskspace forever. Therefore I really recommand to use JCR_E_Clear immediately after nearly every time you've been loading stuff from a file created with JCR_E.
End Rem
Function JCR_E_Clear()   ' Delete all files created by JCR_E()
For Local F$ = EachIn JCR_E_SwapFiles
	DeleteFile F
	Next
JCR_E_SwapFiles = New TList
JCR_E_Cnt=0
End Function




' -------------- WRITER/CREATOR

Private
Global JCR_DefaultCreateConfig:configmap = New configmap
JCR_DefaultCreateConfig.Def("&__CaseSensitive","0")
Public

Rem
bbdoc: This is an extended stream you need for writing data directly into a JCR6 entry. Use the Stream variable inside it for the stream commands
about: If you want a JCR entry in which you can write directly, use the CreateEntry() method from the TJCRCreate type and a value this type will be returned. You can use all regular streaming comments on it you can use in a 'writeonly' file. Closure however should not be done with CloseFile/Closestream, but with the Close() method of this type. Only this way will the file be correctly added to the JCR6 file!
End Rem
Type TJCRCreateStream 
	Field stream:TStream
	Field JCR:TJCRCreate
	Field TempFile$
	Field TargetEntry$,TargetAuthor$,TargetNotes$,TargetAlg$
	
	Rem
	bbdoc:Closes an entry inside a JCR file.
	about:Use this in stead of CloseFile() or CloseStream()<p>When you close the JCR as a whole all open entries should automatically be closed, however it's better you close them yourself before closing the JCR file as a whole to prevent any bad stuff.
	End Rem
	Method CloseEntry()
	CloseStream Self.Stream
	JCR.AddEntry(TempFile,TargetEntry,TargetAlg,TargetAuthor,TargetNotes)
	DeleteFile TempFile
	ListRemove JCR.OpenEntries,Self
	End Method
	
	Method Close()
	CloseEntry()
	End Method
	
	

	
	End Type


Private
Type TImport
	Field file$,sig$,kind$
	End Type
Public
Rem
bbdoc: This type is needed to create a JCR file.
End Rem
Type TJCRCreate Extends TJCRDir
	Field JCRWriteFile$
	Field BT:TStream
	Field OffsetForFAT:Int
	Field oof:Int ' I just used this to make sure the offset is written at the right offset (you follow). It basically should always have the same value :)
	Field OpenEntries:TList = New TList
	Field ImportList:TList = New TList
	
	Rem
	bbdoc: Creates an entry on the fly for directly writing data to it. You can use all streaming commands that write-only streams support. In stead of closefile() or closestream(), you should use the CloseEntry() method in the returned value.
	End Rem	
	Method CreateEntry:TJCRCreateStream(EntryName$,Algorithm$="Store",Author$="",Notes$="")
	Local Ret:TJCRCreateStream = New TJCRCreateStream
	Local cnt = 0
	While FileType(JCRWriteFile+".$$TEMP$$"+cnt+"$$")
		cnt:+1
		Wend
	Local F$ = JCRWriteFile+".$$TEMP$$"+cnt+"$$"
	ret.stream = WriteStream(F)
	ret.stream = LittleEndianStream(ret.stream)
	If Not ret 
		JCR_JAMERR("Couldn't create temp file "+F,JCRWriteFile,EntryName,"CreateEntry")
		Return
		EndIf
	ret.TempFile = F
	ret.TargetEntry = EntryName
	ret.TargetAuthor = Author
	ret.TargetNotes = Notes
	ret.TargetAlg = Algorithm
	ret.JCR = Self
	ListAddLast OpenEntries,ret
	Return ret
	End Method
	
	Rem
	bbdoc: Saves a string into a JCR6 file as an entry
	End Rem
	Method AddString(OriString$,Entry$,Algorithm$="Store",Author$="",Notes$="")
	Local bt:TJCRCreateStream = CreateEntry(Entry,Algorithm,Author,Notes)
	WriteString bt.stream,OriString
	bt.close
	End Method
	
	Rem
	bbdoc: Adds a files as an entry into a JCR6 file
	End Rem
	Method AddEntry:TJCREntry(Original:Object,Entry$="",Algorithm$="Store",Author$="",Notes$="")
	Local Bnk:TBank
	Local OF$
	Local CBnk:TBank
	Local Alg$ = Algorithm
	Local Ent:TJCREntry = New TJCREntry
	Local EntryName$ = Entry
	Local NNE
	If TBank(Original) 
		Bnk = TBank(Original)
		OF$ = "<Bank>"
		If Not EntryName 
			While Not MapContains(entries,"NONAME"+NNE)
				NNE:+1
				Wend
			entryName="NONAME"+NNE
			EndIf
	ElseIf String(Original)
		OF = String(Original)
		Bnk = LoadBank(OF)
		If Not entryname EntryName = OF
	Else
		JCR_JAMERR("'Original' parameter must be either a string or a TBank!",JCRWriteFIle,"<???>","TJCRCreate.AddEntry")
		Return
		EndIf
	If Not bnk Then JCR_JAMERR("Data to store could not be retrieved.",JCRWriteFIle,OF,"TJCRCreate.AddEntry")
	If Not CDrive(Algorithm) 
		JCR_JamErr "Compression algorithm '"+Algorithm+"' is unknown. Make sure the driver is loaded!",JCRWriteFile,OF,"TJCRCreate.AddEntry"
		Return
		EndIf
	CBnk = CDRIVE(Algorithm).compress(Bnk)
	If BankSize(CBnk)>=BankSize(Bnk) ' Store if compression failed.
		CBnk = Bnk
		Alg = "Store"
		EndIf		
	ent.FileName = EntryName
	ent.MainFile$ = JCRWriteFIle
	ent.Size = BankSize(Bnk)
	ent.Offset = StreamPos(BT)
	ent.Storage = Alg	
 	ent.CompressedSize = BankSize(CBnk)
	ent.Author = Author
	ent.Notes = Notes
	MapInsert ent.mv,"$__Entry",Ent.FileName
	MapInsert ent.mv,"%__Size",Ent.Size+""
	MapInsert ent.mv,"%__CSize",Ent.CompressedSize+""
	MapInsert ent.mv,"%__Offset",Ent.Offset+""
	MapInsert ent.mv,"$__Storage",Ent.Storage
	MapInsert ent.mv,"$__Author",Ent.Author
	MapInsert ent.mv,"$__Notes",Ent.Notes
	WriteBank CBnk,BT,0,BankSize(CBnk)
	MapInsert Self.Entries,Entry,Ent
	Return ent
	End Method
	
	Rem 
	bbdoc: Adds an optional dependency to a JCR6
	End Rem
	Method AddImport(A$,sig$="")
	AddDepedency A,sig,"IMPORT"
	End Method
	
	Rem
	bbdoc: adds an require dependency to a JCR6
	End Rem
	Method AddRequire(A$,sig$="")
	AddDepedency A,sig,"REQUIRE"
	End Method
	
	Method AddDepedency(A$,sig$="",Kind$="IMPORT")
	Local I:TImport = New timport
	I.file = A
	I.sig = sig
	I.kind = Upper(kind)
	ListAddLast importlist,I
	End Method
	

	Rem
	bbdoc: Closes a JCR file
	End Rem
	Method Close(algorithm$="Store")
	For Local Stream:TJCRCreateStream=EachIn OpenEntries ' Close all open streams
		Stream.CloseEntry()
		Next
	' And now let's save the File Table
	Local F$ = JCRWriteFile+".$$$TEMP$$$FAT$$$"
	Local BTF:TStream = WriteStream(F)
	Local FTPos = StreamPos(BT)
	Local FullK$,K$,TK$
	Local e:TJCREntry
	For Local EntryName$=EachIn(MapKeys(Self.entries))
		WriteByte BTF,1
		Alt_writestring BTF,"FILE"
		e = TJCREntry(MapValueForKey(Self.entries,entryname))
		For fullk=EachIn MapKeys(e.mv)
			K = Right(FullK,Len(fullK)-1)
			TK$ = Left(FullK,1)
			Select TK
				Case "$"
					WriteByte btf,1
					alt_writestring btf,k
					alt_writestring btf,e.m(fullk)
				Case "&"
					WriteByte btf,2
					alt_writestring btf,k
					WriteByte btf,e.mi(fullk)
				Case "%"
					WriteByte btf,3
					alt_writestring btf,k
					WriteInt btf,e.mi(fullk)
				Default
					Print "WARNING!! Unknown tag type "+TK+" in "+Fullk+" in entry "+EntryName+"  -- Request ignored!"
				End Select	
			Next
		WriteByte btf,255	
		Next
	For Local dependency:Timport=EachIn importlist
		WriteByte btf,1
		alt_writestring btf,dependency.kind
		WriteByte btf,1 alt_writestring btf,"File" alt_writestring btf,dependency.file
		WriteByte btf,1 alt_writestring btf,"Signature" alt_writestring btf,dependency.Sig
		WriteByte btf,$ff
		Next	
	WriteByte btf,255		
	CloseFile BTF
	Local bnk:TBank = LoadBank(F)
	If Not bnk
		JCR_JamErr "Temporary file "+F+" could not be read for addition to the JCR file",JCRWriteFIle,"N/A","TJCRCreate.Close"
		Return
		EndIf
	Local alg$ = algorithm
	Local cbnk:TBank
	If Not CDrive(Algorithm) 
		JCR_JamErr "Compression algorithm '"+Algorithm+"' is unknown. Make sure the driver is loaded!",JCRWriteFile,"N/A","TJCRCreate.Close"
		Return
		EndIf
	CBnk = CDRIVE(Algorithm).compress(Bnk)
	If BankSize(CBnk)>=BankSize(Bnk) ' Store if compression failed.
		CBnk = Bnk
		Alg = "Store"
		EndIf
	WriteInt BT,BankSize(Bnk)
	WriteInt BT,BankSize(CBnk)
	Alt_WriteString BT,Alg
	WriteBank CBnk,Bt,0,BankSize(CBnk)
	SeekStream BT,oof
	WriteInt BT,FTPOs
	CloseFile BT
	DeleteFile F
	End Method
	
	Rem
	bbdoc: Saves a TMap or StringMap (which is nothing more but an extended TMap) into a JCR file. Only maps in which all keys and values are strings and only strings work here.
	End Rem
	Method SaveMap(Map:TMap,Entry$,Algorithm$="Store",Author$="",Notes$="")
	Local bte:TJCRCreateStream = createentry(Entry,Algorithm,Author,Notes)
	Local k$,v$
	For k=EachIn MapKeys(Map)
		v = String(MapValueForKey(Map,k))
		alt_writestring bte.stream,k
		alt_writestring bte.stream,v
		Next
	bte.close
	End Method
	
	End Type


Rem
bbdoc: This function will start the creation of a JCR file
End Rem	
Function JCR_Create:TJCRCreate(JCRFile$,Config:configmap=Null)
Local ret:TJCRCreate = New TJCRCreate
ret.JCRWriteFIle = JCRFile
ret.bt = WriteStream(JCRFile$)
If Not ret.bt JCR_JAMERR("JCR file could not be created",JCRFILE,"N/A","JCR_Create"); Return
WriteString ret.bt,"JCR6"+Chr(26)
ret.oof = StreamPos(ret.bt)
WriteInt ret.bt,0
Local C:configmap = config
If Not C C=JCR_DefaultCreateConfig
Local kk$
For Local k$ = EachIn MapKeys(C)
	kk = Right(k,Len(k)-1)
	Select Left(K,1)
		Case "&"
			WriteByte ret.bt,2
			alt_writestring ret.bt,kk
			WriteByte ret.bt,c.b(kk)
		Case "$"
			WriteByte ret.bt,1
			alt_writestring ret.bt,kk
			alt_writestring ret.bt,c.s(kk)
		Case "%"
			WriteByte ret.bt,3
			alt_writestring ret.bt,kk
			WriteInt ret.bt,c.i(kk)
		Default
			Print "WARNING! Config tag found with an unknown type. Request ignored ("+k+")"
		End Select
	Next
WriteByte ret.bt,255
Return ret
End Function

Rem 
bbdoc: Lists all entries.
about: These are only string values containing file names. In case insensitive files they are all in UPPERCASE!<br>This function should be useable with EachIn.
End Rem
Function EntryList:TMapEnumerator(JCR:TJCRDir)
Assert JCR Else "EntryList(<NULL>): Cannot list a JCR map when it's Null!"
Return MapKeys(JCR.Entries)
End Function


Rem
bbdoc: Patch a JCR file. The patch will be added to the "MainJCR".
about: You can either call for a new file or an existing TJCRDir.<br>Important to note is that the config of the patch file is ignored, so the settings of the main file are dominant.<p>It does not matter if the original or the patch are true JCR6 files. As long as the filetype is supported by JCR6 by default or any included drivers, the patcher will work all the same.<p>If the 'requiresignature' parameter is set, then the patched file MUST have the same signature as requested or the patch will fail. If the parameter is not set, any signature or even no signature at all will all be fine.<p>Returns True when the patch is succesful and False if it failed. 
End Rem
Function JCR_AddPatch(MainJCR:TJCRDir,Patch:Object,requiresignature$="",Path$="")
Local TPatch:TJCRDir
Local TPath$ = Replace(Path,"\","/")
If tpath And Right(tpath,1)<>"/" tpath:+"/"
If TJCRDir(Patch)
	TPatch = TJCRDir(Patch)
	ElseIf String(Patch)
	tpatch = JCR_Dir(String(patch))
	Else
	JCR_JAMERR("Patch must be either object or string","N/A","N/A","JCR_Patch")
	Return
	EndIf
If Not TPatch
	JCR_JAMERR("Patch is null. Either a null value was given or a non-existent or damaged patch file was attempted to load.","N/A","N/A","JCR_Patch")
	Return
	EndIf
If Not MainJCR	
	JCR_JAMERR("Main is null.","N/A","N/A","JCR_Patch")
	Return
	EndIf
If requiresignature And TPatch.Config.S("__Signature")<>requiresignature
	JCR_JAMERR("Signature mismatch","???","N/A","JCR_AddPatch")
	Return
	EndIf
Local casesensitive = MainJCR.Config.B("__CaseSensitive")
Local E$,OE$
' Entries
For OE$ = EachIn MapKeys(TPatch.Entries)
	Local CE$ = tpath+OE
	If Not casesensitive CE = Upper(CE)
	E = tpath+OE
	TJCREntry(MapValueForKey(TPatch.Entries,OE)).Filename = E
	MapInsert MainJCR.Entries,CE,MapValueForKey(TPatch.Entries,OE)
	Next
For E$ = EachIn MapKeys(TPatch.Comments)
	Local CE$ = E
	If Not casesensitive CE = Upper(CE)
	MapInsert MainJCR.Comments,CE,MapValueForKey(TPatch.Comments,E)
	Next
For E$ = EachIn MapKeys(TPatch.Variables)
	MapInsert MainJCR.Variables,E,MapValueForKey(TPatch.Variables,E)
	Next	
MainJCR.UpdateMain
Return True	
End Function

Rem 
bbdoc:Checks wither or not one of the loaded JCR6 main files have been changed since its original load
returns:
The next values may be returned:<ul>
<li>0 = No changes found</li>
<li>1 = One of the main files' size was changed</li>
<li>2 = One of the main files' datetime stamp was changed</li>
<li>3 = One of the main files has been deleted</li>
<li>4 = A new main file was added. This one can only happen if an improper patching was done. When doing everything according to JCR6 rules, this value can never be returned. If this value is returned then either your program or JCR6 contains a bug which needs to be fixed asap.</li>
</ul>
End Rem
Function JCR_Changed(JCRDIR:TJCRDir)
Local m$,mf:tjcrmfiles,e:TJCREntry
Assert JCRDIR Else "JCR_Changed(Null):~nJCR_Changed received a null value in stead of a dir"
For m=EachIn MapKeys(JCRDIR.MainFiles)
	mf = MapValueForKey(JCRDir.MAINFILES,m)
	If mf.size <>FileSize(m) Return 1
	If mf.ftime<>FileTime(m) Return 2
	If Not FileType(m)       Return 3
	Next
For e=EachIn MapValues(JCRDir.Entries)
	If Not MapContains(JCRDIR.MainFiles,e) 
		Print "WARNING! JCR file has an unregistered main file in it!~nThis can only be the result of a bug in your program, improper use of the JCR6 module, or a bug inside JCR6!"
		Return 4	
		EndIf
	Next
End Function


Rem
bbdoc:Lists a text file within a JCR6 file in a TList, and with for eachin you can read out all the lines
End Rem
Function JCR_ListFile:TList(MainFile:Object,file$)
Local BT:TStream = JCR_ReadFile(mainfile,file)
Assert bt Else "File "+String(file)+" could not be read!"
If Not bt Return
Local ret:TList = New TList
While Not Eof(BT)
	ListAddLast ret,ReadLine(BT)
	Wend
CloseStream BT	
Return ret
End Function

Rem
bbdoc: Loads a string from a JCR6 file
End Rem
Function JCR_LoadString$(JCR:Object,Entry$)
Local B:TBank = JCR_B(JCR,Entry)
If Not B Return
Return LoadString(B)
End Function

	
Rem
bbdoc: Loads a stringmap / tmap stored in a JCR file.
about: This only works for StringMaps or TMaps on which the keys and values are both strings. Though the result is returned as a StringMap, you can assign the data into a TMap as well.
End Rem	
Function JCR_LoadMap:StringMap(JCR:Object,Entry$)
Local BT:TStream = JCR_ReadFile(JCR,entry$)
Local ret:StringMap = New StringMap
Local LK,SK$,LV,SV$
While Not Eof(BT)
	LK = ReadInt(BT)
	SK = ReadString(BT,LK)
	LV = ReadInt(BT)
	SV = ReadString(BT,LV)
	MapInsert Ret,SK,SV
	Wend
CloseFile BT
Return ret
End Function

Rem
bbdoc: Returns a string with all loaded drivers separated by commas.
End Rem
Function JCR_DirDrivers$()
Local ret$ 
For Local DRV:DRV_JCRDIR = EachIn DirDrivers
	If ret ret:+", "
    ret:+DRV.NAME()
 	Next
Return ret
End Function
