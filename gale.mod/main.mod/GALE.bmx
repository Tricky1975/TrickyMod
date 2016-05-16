Rem
        GALE.bmx
	(c) 2012-2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.02.19
End Rem
Strict

Rem

General Allpurpose Lua Engine, for short: GALE




The GALE project is a bundle of files specifically created to make my own life a lot easier when it comes to Lua Scripting.
GALE is a reader, pre-processor and serializer, which can be combined with all extra Lua APIs that come with GALE.
GALE was been specifially designed to work with JCR5 - http://jcr5.sourceforge.net
This version of GALE was upgraded to work with JCR6 
If you want to use GALE yourself, but you are not game to use JCR files, you can always decide to use the JCR_RealDir to make working with GALE possible.
(Direct file access is present in GALE but deprecated, and strongly discouraged to use).

GALE has been specifically designed to work in a true Max2D screen, and in the initial version I don't plan to make other things possible, however, in future versions I may add full support for MaxGUI and console, however I don't promise anything.



What is very impartant to note is that GALE requires a modified version of brl.MaxLua module see the MaxGALE_Modifications.txt file for more information on that.




When you intend to use GALE you'll need a bundle of files I call "Units" in order to build most of the GALE files.
You can download a zip file containing these "Units" here: http://dl.dropbox.com/u/40442193/Units/Units.zip
Any time I modify any of my "Units" I'll make sure that zip file is updated immediately, so that you always have the latest versions.




A few advantages of using GALE over just using the regular BlitzMax module:

- GALE has its own inclusion routines, handy when you have to use multiple scripts with the same functions
- GALE has its own compiler directives. Very handy for debugging
- GALE has a pretty expanded error messaging system
- GALE has (unlike Lua itself) as SELECT CASE system :P, the pre-processor converts this into true Lua language
- GALE has a "serializer" routine that can be used to 'save variables'. If you've ever been messing around with addons of World of Warcraft, you'll get the picture :)






GALE has been coded entirely by Jeroen Petrus Broks, otherwise known as "Rachel", "Rachel Peterson" or "Tricky".
It uses the brl.MaxLua module which is together with BlitzMax itself created and copyrighted by Blitz Research Incorperated.
Lua has been created by PUC-Rio.
JCR5 which GALE uses is from the same creator as GALE itself.



History:
12.03.30 - Start of the GALE project (by cannibalizing my old Lua routines).
12.04.01 - Removed some "Private" statements, for better communication with the other GALE files
12.04.23 - Calls JCR5 and MKL_Version from modules now in stead of just .bmx files. Calling the old imports is still possible, by just placing a few "REM" lines differently ;)
12.09.26 - GALE and all its substuff have been converted into a module. A modified version of MaxLua has been included in order to make GALE always work, the zlib license allows that, but the copyright of MaxLua remains with Blitz Research Ltd.
12.11.12 - Added a few updates to make it more compatible for use in MiniB3D.
13.05.20 - Added a way to cause an error in full GALE style.
13.05.25 - Added prior script. This is basically a script tied to the front for the script. This is for scripts that MUST be executed BEFORE the rest of the script takes place. It was added as (even though saved vars were usable for this) for this script the guarantee will always be done that this comes first!
13.06.01 - Added GALE_HasFunction
13.06.21 - Added support for GALE_OnLoad and GALE_OnUnload. Also noted in the docs that GALE_ is now the reserved prefix for all functions called by GALE.
13.06.25 - Fixed an issue that dumped all saved vars together regardless of any setting.
13.07.20 - Improved GALE_Error making references to lines be translated into the actual lines and script files
13.12.26 - Renamed the modified MaxLua, hoping this could remove some errors that randomly pop up in Windows when compiling Lua scripts.
13.12.26 - Merged GALE_Sys.bmx with this file. If you have older versions of GALE, I strongly recommend to remove the entire GALE.mod folder from your BMax directory before putting the files of this new version in or compilation conflicts can (most likely will) arise.
14.01.01 - Added the IDirective function which allows your BlitzMax program to add internal directives. Recommended is to prefix them all with a "*" which should block the Lua Scripts from changing them
14.01.08 - Added an security plug which should prevent from scripts being removed by the garbage collector while the script is still running. I hope this might prevent the "EXCEPTION_ACCESS_VIOLATION" errors I randomly get in Windows. Of course for Mac and Linux it might also be safer this way even though they don't got these errors!
14.03.15 - Reading from normal files completely removed (it already WAS deprecated). In the process a bug with uncompressed files was fixed, not to mention that this will also help me to make GALE work on JCR6 once that project is officially released.
         - Re organized some module settings
         - Max2D support has been put into a driver. Most other modules will require this driver for proper usage.
         - Driver for GALE use in MaxGUI has been created
15.01.23 - Updated for JCR6
15.01.28 - The "-- @USE" function was not yet properly adepted for JCR6, this should be fixed now.
         - The "AutoUse.lua" function has been added. Thanks to this any AutoUse.Lua file found in the same folder as the main file will automatically be included.
15.02.10 - Fixed the GET variable routine for the serializer as that was not properly converted to JCR6.
15.02.17 - Added an error driver to catch JCR6 errors.
15.08.14 - Sys object now also directly accessible from BlitzMax, but in BlitzMax it's GALE_Sys (In Lua it's still Sys)
         - Ability to make Bye always execute a certain sequence 
15.10.17 - Removed a few unneeded annoying debug lines.
16.02.18 - The "USING" messages are now only printed to the console if needed, and even the loading and compiling stuff in general can be put on "silent".
16.02.19 - Removal of "USING" (unless the GALE_USING var is set true) did work on single -- @USE, but not on -- @USEDIR. That has now been fixed.
16.03.13 - Removed some outdated debug shit from the error handler
16.03.13 - Compilation error in the serializer fixed. (Odd thing is... the Star Story project could NEVER have worked if this bug was for real. Still it popped up in the JCR6 scripting utilities. Do you believe in ghosts? I do now. Well it's fixed, and let's hope my ghost doesn't change it again.
End Rem

Import brl.map
Import brl.retro
Import brl.system
Import jcr6.jcr6main
Import tricky_units.MKL_Version
Import GALE.MaxLua4Gale
Import tricky_units.Bye

' Importing the Lua Serializer Script
Incbin  "Serializer.lua"


'This is just some shit the BLD utilty (which I use to set up a quick documentation) needs for documenting the Lua directives created by this program
'Directive USE <FILE>				' BLD: This directive makes you add a script to this script.<br>Note: It does not include on the spot, the new file will be added below the current script file<br>Note: Files are added in the order in which they are called.<br>Note: When you don't enter a path the preprocessor will either use the same path as the main file or the path set in the project the Lua processor has been included to. If you are picky about your paths, set it well!
'Directive IF &lt;DEF1> [&lt;DEF2>...]	' BLD: Is a definition set, then compile the next stuff, if not, ignore it. When you put a "!" before a definition it will count as a 'NOT' statement.<br>NOTE:You cannot make an IF in an IF. If not done before, this IF will automatically close the IF statement made before.
'Directive ELSEIF &lt;DEF1> [&lt;DEF2>...]	' BLD: Works with IF as an ELSEIF. Some bugs I cannot trace well make this directive irreliable so I recommend not to use it until I got that fixed.
'Directive FI						' BLD: Ends an IF statement made before
'Directive ENDIF  					' BLD: Alias for FI
'Directive DEFINE &lt;DEF>			' BLD: Set a defition for IF/ELSEIF/FI to use.
'Directive UNDEF &lt;DEF>			' BLD: Unset a definition for IF/ELSEIF/FI. It also undoes DEFINE
'Directive USEDIR &lt;DIR> 			' BLD: In JCR based projects, this directive can include all .lua files in a directory within the JCR patchlist and it works recursive.
'Directive SELECT &lt;var/function>	' BLD: You can use this directive to create a "SELECT" statement (same as "switch" in C-syntax languages). As Lua doesn't support that itself I made this preprocessor do it.<br>You cannot place a remark behind this statement or the preprocessor will create faulty Lua scripts. If you want a remark with this, put it either above or below it :)<br>NOTE: Only one SELECT can be open at a time. When you open a new one, the old one will be closed, however keep closing your SELECT statements anyway, as you never know if I might improve this in the future :)
'Directive CASE &lt;value>			' BLD: Case command for @SELECT
'Directive DEFAULT 				' BLD: Default command for @SELECT
'Directive ENDSELECT 				' BLD: Closes Select statement
'Info GALE_ prefix ' BLD: This prefix is reserved for any features that GALE may react on or assign data to. So only use GALE_ prefixed stuff in accordance with this manual. When more functions are added in the future this prefix is very likely to be put in front of it. Some projects using GALE might also use their own prefixes (for example the LAURA engine uses "__" as reserved prefix), so check the data on that.
'Info GALE_OnLoad() function ' BLD: When this function is present anywhere in the script GALE will automatically execute it after compiling
'Info GALE_OnUnload() function ' BLD: When this function is present anywhere in the script GALE will automatically execute it when the script is removed from the memory. Please note that the BlitzMax garbage collector is responsible for this, and you never know when the garbage collector cleans up the memory as that is when the function will be called.
'Info Preset Definitions			' BLD: The next definitions can not be set/unset with DEFINE or UNDEF, but IF and ELSEIF can see them and they can be used there.<p><table><tr><td>$WINDOWS</td><td>Set if running from Windows</td></tr><tr><td>$MAC</td><td>Set if running from MacOS X</td></tr><tr><td>$MACOS</td><td>Alias for $MAC</td></tr><tr><td>$LINUX</td><td>Set if running from Linux</td></tr><tr><td>$DEBUGBUILD</td><td>Set if you happen to use the debug build of the engine</td><tr><td>$RELEASEBUILD</td><td>Set if you use the release build of your engine</td><tr><td>$LITTLEENDIAN</td><td>Set if processor uses LittleEndian</td><tr><td>$BIGENDIAN</td><td>Set if your processor uses BigEndian</td></tr><tr><td>$X86</td><td>Set if you have use and X86 processor (Intel or compatible)</td></tr><tr><td>$PPC</td><td>Set if you use a PowerPC processor</td></tr></table>


MKL_Version "GALE - GALE.bmx","16.02.19"
MKL_Lic     "GALE - GALE.bmx","Mozilla Public License 2.0"


Private 
Const LuaDebugChat = False
Public 
Global LuaConsoleOutput = True 
Global LuaConsoleFlip = True 
Global LuaUseDir$ 
Rem 
bbdoc: If set true the program will end when a Lua Error occurs
End Rem 
Global LuaErrorCrash = True  
Rem 
bbdoc: When set to true, the program will end the current graphics mode and resume in a windowed graphics mode.
about: I placed this one in to ensure compatibility with MiniB3D (otherwise you'd just get a black screen when an error occurs). Please note that when you don't make the game crash out on errors that you have to reinitize the Graphics3D mode or minib3d will probably not work properly.
end rem
Global LuaErrorRewindow = False ' If set the error console will end the old graphics mode and use a new 'Windowed' one. Set up for debugging in MiniB3D. Please note that MiniB3D will no longer work after an error then unless you reinitialize the 3D Graphics. 
Rem
bbdoc: When set the script loader will after all preprocessing is done, dump the generated code to STDOUT. Recommended only to use when some serious issues arise.
End Rem
Global LuaScriptDump = False 


Rem
bbdoc: When set, GALE will crash out the program when a JCR6 error occurs during running a program with GALE imported.
about: Important note, the error does not have to be caused by GALE. Any failed JCR call will cause this to happen when GALE is imported.
End Rem
Global GALEJCRCRASH = True


Rem
bbdoc: When set to true, it will show all files that are tied to a script with the USE directive.
End Rem
Global GALE_USING = False

Rem
bbdoc: When set to true, none of the compilation messages will be shown (except from errors of course).
End Rem
Global GALE_SilentCompile = False


Type GALEJCRERRORDRIVER Extends JCR_JAMERR_Driver
	Method DumpError(Dump$,ERR:TJCR_Error)
	Local R,G,B
	GALECON.FullView
	For Local L$=EachIn Dump.split("~n")
		If Left(L,5)="==== " R=255 G=0 B=0 Else R=255 G=255 B=0 
		L_ConsoleWrite L,R,G,B
		Next	
	If GALEJCRCRASH GALECON.GaleErrorClosureRequest
	End Method
	End Type
	
New GALEJCRERRORDRIVER	


'This is to make all modules work with the same console routines
Public
Type GALE_DebugConsole
	Method GaleConsoleWrite(Txt$,R=255,G=255,B=255) Abstract
	Method GaleConsoleDoublePrint2(Txt1$,Txt2$,T,R1=255,G1=255,B1=255,R2=255,G2=255,B2=255) Abstract
	Method GaleConsoleCloseLogFile() Abstract
	Method GaleConsoleShow() Abstract
	Method DoFlip(A=-1) Abstract
	Method DoCls() Abstract
	Method ReWindow() Abstract
	Method GaleErrorClosureRequest() Abstract	
	Method StopGraphics() Abstract	
	Method RequestAppTerminate() Abstract
	Method FullView() Abstract
	End Type

Global GaleCon:GALE_DebugConsole
Function setGALECON(C:Object)
GaleCon = GALE_DebugConsole(C)
End Function

Private

Global LastSerializer$ = "-- Nothing here --";
Global LastReturner$ = LastSerializer;

Type TLuaSavedVar
	Field SType$
	Field SVar$
	End Type
	
Type TLuaLine
	Field Line$
	Field File$
	Field LineNumber
	End Type

Public
Rem
bbdoc:When this variable is set to True, it will dump out the data of function calls from your engine to GALE scripts.
about:If you think something went wrong here, you can use this to debug either your own engine, or to try to find a bug in GALE if that would in fact be the evil. The data will be dumped onto the inprogram console (but everything put in there will be dumped onto the STDOUT as well). Under normal circumstances I strongly recommand to leave this variable on "False" in all circumestances!
End Rem

Global GALE_RunChat = False

Private	
Type TRunner	
	Field Script:TLua
	Field LastFunction$
	Field Tag$
	Field AllowChat = GALE_RunChat
	
	Method Chat(A$)
	If AllowChat GALECON.GaleConsoleWrite("Run session "+Tag+" -- "+A)
	End Method
	
	Method Delete()
	Chat "Session removed! -- "+Script.FileName+" -- "+LastFunction
	End Method
	End Type

Global RunnerMap:TMap = New TMap	

Function Runner:TRunner(Tag$)
If Not MapContains(RunnerMap,Tag) MapInsert RunnerMap,Tag,New TRunner
Local R:TRunner = TRunner(MapValueForKey(RunnerMap,Tag))
Return R
End Function

Public	




Rem
bbdoc: Contains the data about a loaded Lua Script
End Rem
Type TLua
	Field FileName$
	Field Line:Object[]
	Field SavedVars:TList = New TList
	Field Functions:TList = New TList
	Field Class:TLuaClass
	Field Instance:TLuaObject
	Field LastCalledFunction$=""
	
	Method Compile()
	Local source$
	For Local L:TLuaLine = EachIn Line
		Source :+ L.Line + "~n"
		Next
	If LuaScriptDump Print "~n~n=== GALE - Lua Code Dump ===~n"+Source+"~n=== END  - Lua Code Dump ===~n~n"	   
	'Print "++ SOURCE ++~n"+source
	Class:TLuaClass=TLuaClass.Create( source )
	If GALE_JBC_Error(Self,"Compile error") Return
	Instance=TLuaObject.Create( Class,Null )
	If GALE_JBC_Error(Self,"Compile error") Return
	If Not Instance Return GALE_JBC_Error(Self,"Compile Error","Unknown compilation failure")
	End Method
	
	Rem
	bbdoc: Runs a script with the called function with its arguments
	end rem
	Method Run(RFunction$,args$[])
	Rem     Old way
	SysLuaErrorCrash = LuaErrorCrash
	Self.LastCalledFunction=RFunction+"("+(",".join(args))+");"
	If Not Instance Return GALE_JBC_Error(Self,"Runtime Error","Trying to run a script that was not correctly compiled!")
	Instance.Invoke(RFunction,args)
	GALE_JBC_Error(Self,"Runtime error")
	End Rem
	SysLuaErrorCrash = LuaErrorCrash
	Local Tag$ 
	Repeat
	Tag = Hex(MilliSecs()) 
	Until Not MapContains(RunnerMap,Tag)
	Runner(Tag).Script = Self
	Runner(Tag).LastFUnction = RFunction
	Runner(Tag).Tag = Tag
	Runner(Tag).Chat("Session Created")
	Runner(Tag).Chat("Calling function: "+RFunction+"()")
	Self.LastCalledFunction=RFunction+"("+(",".Join(args))+");"
	If Not Instance Return GALE_JBC_Error(Self,"Runtime Error","Trying to run a script that was not correctly compiled!")
	Instance.Invoke(RFunction,args)
	Self.LastCalledFunction=RFunction+"("+(",".Join(args))+");"
	GALE_JBC_Error(Self,"Runtime error")
	Runner(Tag).Chat("Session completed!")
	MapRemove RunnerMap,Tag
	End Method
	
	Method Lines:TList()
	Local ret:TList = New TList
		For Local L:TLuaLine = EachIn Line
		'Source :+ L.Line + "~n"
		ListAddLast ret,L.Line
		Next
	Return ret		
	End Method
	
	Rem
	bbdoc: Returns a string containing all saved variables scripted out in a Lua string
	about: You can save this string into a .lua file in order to include it when a script is being reloaded. The 'tpe' you can give up is the type given up in the .lsv file that is used to determine which variables to save. When you don't give it up the system will use 'VAR'.
	End Rem
	Method Save$(Tpe$="")
	Local Ret$ = ""
	Local KEY$=Tpe.toUpper()
	If Not Key Key="VAR"
	Rem
	For Local SV:TLuaSavedVar=EachIn SavedVars
		Select SV.SType.toUpper()
			Case "VAR" 
				'Run("serialize2",[SV.SVar])
				RunString "serialize(~q"+SV.Svar+"~q,"+SV.Svar+")"
				Ret:+LastReturner+"~n"
			Default
				If Tpe.toUpper()=SV.SType.ToUpper() And Tpe
					Run("serialize2",[SV.SVar])
					Ret:+LastReturner+"~n"
					Else
					ConsoleWrite("Warning! Unknown var type!   "+SV.Stype+": "+SV.SVar)
					EndIf
			End Select	
		Next
	EndRem
	LastReturner = "-- Nothing Here --"
	RUN "___SER___"+KEY+"___SER___",Null
	Return LastReturner
	End Method
	
	Method RunString(Str$)
	Local strC$ = Replace(Replace(Str,"~q","\~q"),"'","\'")
	Run "___JBC___loadstring",[StrC]
	End Method		
	
	Method Delete()
	If Not Instance Return
	L_ConsoleWrite "Lua>GALE_OnUnload() -- "+FileName,100,100,100
	Instance.Invoke "GALE_OnUnload",Null
	End Method
			
	End Type
	

'Directives
Private
Global Directives:TList = New TList
?Win32
ListAddLast Directives,"$WINDOWS"
?MacOS
ListAddLast Directives,"$MACOS"
ListAddLast Directives,"$MAC"
?Linux
ListAddLast Directives,"$LINUX"
?
?DEBUG
ListAddLast Directives,"$DEBUGBUILD"
?Not Debug
ListAddLast Directives,"$RELEASEBUILD"
?
?LittleEndian
ListAddLast Directives,"$LITTLEENDIAN"
?BigEndian
ListAddLast Directives,"$BIGENDIAN"
?
?Threaded
ListAddLast Directives,"$THREADED"
?
?X86
ListAddLast Directives,"$X86"
?PPC
ListAddLast Directives,"$PPC"
?
SortList Directives
If LuaDebugChat 
	Print "Directives: "+("; ".Join(String[](ListToArray(Directives))))
	For Local SD$ = EachIn Directives 
		'Print "===> "+SD
		Next
	EndIf

Type TLuaSerial
	Method Returner(A$)
	LastSerializer = A
	LastReturner = A
	End Method
	Method DebugLog(A$)
	?Debug
	Print "Lua-DebugLog: "+A
	?
	EndMethod
	End Type
GALE_Register New TLuaSerial,"JBCSYSTEM"

Public ' ---------- PUBLIC --------------

Rem
bbdoc:Add a directive from the engine.
about:When you start the directive name with a * the setting cannot be changed by the Lua Scripts, only by your game engine! ($ can also be used, but may cause conflicts if I add extra directives to GALE in future versions and I accidentally chose the same name as you did).
End Rem
Function IDirective(ID$,add=True)
If add 
	ListAddLast Directives,ID$
Else
	ListRemove  Directives,ID$
EndIf
End Function

Function L_ConsoleWrite(A$,R=255,G=255,B=255)
If Not LuaConsoleOutput Return
GALECON.GaleConsoleWrite A,R,G,B
If LuaConsoleFlip 
	GALECON.DoCls
	GALECON.GaleConsoleShow
	GALECON.DoFlip
	EndIf
End Function

Function GALE_JBC_Error(LO:TLua,ErrorType$,Message$="",ForceLineNumber=0)
GALE_Sys.ErrorFound:+1
Local EH$ = "Error loading script :~n[string ~q-- GALE LUA SCRIPT --...~q]:"
Local EHL = Len(EH)
Local EH2$ = "[string ~q-- GALE LUA SCRIPT --...~q]:"
Local EHL2 = Len(EH2)
Local EMsg$
Local TMsg$
Local LineNumber
Local P
Local Line:TLuaLine
Local GW,GH
Local LineRef$[],LineRefs:TList = New TList
If (Not JBC_CatchLuaError) And (Not(Message)) Return False
'Print "Lua Error --"+JBC_CatchLuaError+"--"
If LuaErrorRewindow	
	GALECON.Rewindow
	GALECON.FullView
	EndIf
' Message Settings
If Message 
	EMsg = Message
	LineNumber=ForceLineNumber
	Else
	TMsg = Right(JBC_CatchLuaError,Len(JBC_CatchLuaError)-EHL)
	P=TMsg.Find(":")
	LineNumber = Tmsg[..p].toint()
	EMsg = Trim(TMsg[p+1..])
	If Not LineNumber
		TMsg = Right(JBC_CatchLuaError,Len(JBC_CatchLuaError)-EHL2)
		P=TMsg.Find(":")
		LineNumber = Tmsg[..p].toint()
		EMsg = Trim(TMsg[p+1..])
		EndIf
	EndIf
' Translate line referrences inside error message
If EMsg.find("line") Then
	Local EW$[] = EMsg.Split(" ")
	Local LN
	For Local ak=0 To EW.Length-1
		'Print "Word "+ak+" is '"+EW[ak]+"'"
		If EW[ak].tolower()="line" And ak<EW.Length-1
			LN = EW[ak+1].ToInt()
			If Right(EW[ak+1],1)=")" Then 
				EW[AK+1] = Left(EW[AK+1],Len(EW[Ak+1])-1)
				LN = EW[ak+1].ToInt()
				'Print "LN = "+LN
				EndIf
			Line=TLuaLine(LO.Line[LN-1]);
			If LN 
				'Print "Adding data"
				ListAddLast LineRefs,["Line "+LN+" => File:",Line.File]
				ListAddLast LineRefs,["Line "+LN+" => Line:",Line.LineNumber+""]
				ListAddLast LineRefs,["Line "+LN+" => Code:",Line.Line]
				EndIf
			EndIf
		Next
	EndIf
' Dump the error itself	
If Not EMsg Then 
	EMsg = "Unprintable Error"
	ListAddLast LineRefs,["Caught string:",JBC_CatchLuaError]
	ListAddLast LineRefs,["MSG string: ",Message]
	EndIf
GALECON.FullView	
GALECON.GaleConsoleWrite ""
GALECON.GaleConsoleWrite "==== LUA ERROR ====",255,0,0
GALECON.GaleConsoleDoublePrint2 "Error Type:",ErrorType,200,255,255,0,0,255,255
GALECON.GaleConsoleDoublePrint2 "Error Message:",EMsg,200,255,255,0,0,255,255
If LO Then
	GALECON.GaleConsoleDoublePrint2 "Main Script:",LO.FileName,200,255,255,0,0,255,255
	If LineNumber >= LO.Line.Length LineNumber=Lo.Line.Length
	If LineNumber
		Line=TLuaLine(LO.Line[LineNumber-1]);
		GALECON.GaleConsoleDoublePrint2 "Sub Script:",Line.File,200,255,255,0,0,255,255
		GALECON.GaleConsoleDoublePrint2 "Line #:",Line.LineNumber,200,255,255,0,0,255,255
		GALECON.GaleConsoleDoublePrint2 "Code:",Line.Line,200,255,255,0,0,255,255
		EndIf
	For LineRef = EachIn LineRefs
		GALECON.GaleConsoleDoublePrint2 LineRef[0],LineRef[1],200,255,255,0,0,255,255
		Next	
	If LO.LastCalledFunction
		GALECON.GaleConsoleDoublePrint2 "Function:",LO.LastCalledFunction,200,255,255,0,0,255,255
		EndIf
	If EMsg="Unprintable Error" Then
		GALECON.GaleConsoleDoublePrint2 "ErrorCall:","GALE_JBC_Error(<Object>,~q"+Errortype+"~q,~q"+Message+"~q,"+ForceLineNumber+")",200,255,255,0,0,255,255
		EndIf
	End If
GALECON.GaleErrorClosureRequest	
If LuaErrorCrash = True GALECON.GaleConsoleCloseLogFile; Bye
Return True
End Function




Function ExpF$(F$)
Local O$[] = ["_"," ",":","/","\","*","@",".",","]
Local R$[] = ["_UNDERSCORE_","_SPACE_","_COLON_","_SLASH_","_BACKSLASH_","_ASTERISK_","_AT_","_DOT_","_COMMA_"]
Local Ret$ = F
For Local Ak=0 To O.length-1
	Ret = Replace(Ret,O[ak],R[Ak])
	Next
Return Ret
End Function

Function StarFunction$(Lin$,Fil$)
Local newf$ = ExpF(Fil)
Local Ret$ = Replace(Lin,"function *","function SF_"+newf+"_")
'If Ret<>Lin DebugLog "GALE_Preprocessor - StarFunction!~n~nOld: "+Lin+"~nNew: "+Ret+"~n~n"
Return Ret$
End Function

Function DetectFunction(Line$,Script:TLua)
Local f$ = "function "
If Left(Line,Len(F))<>f Return
Local L$ = Replace(Line,f,"")
Local p = L.find("(")
Local ff$ = Trim(L[..p])
ListAddLast Script.Functions,ff
'DebugLog "Detected function: "+ff
End Function

Rem
bbdoc: True if a function exists within the script (when the script is Null then it will always return false)
End Rem
Function GALE_ScriptHasFunction(Script:TLua,Func$)
If Not script Return False
Return ListContains(Script.Functions,Func)
End Function

Rem
bbdoc: Loads a script preprocesses it and tries to compile it
End Rem
Function GALE_LoadScript:TLua(MainList:Object,Entry$,SavedVariables$="",priorscript$="")
Local Loader:TList = New TList
Local Line:TLuaLine
'Local FBT:TStream
'Local JBT:JCR_Stream
Local BT:TStream
Local JCR=MainList<>Null
Local TheEnd
Local LineCount = 1
Local RLine$
Local Ok
Local Directive$[]
Local DOk = True     ' Always true unless there's a compiler directive set to be not true.
Local IncList:TList
Local CFile$
Local Ret:TLua = New TLua
Local SVFile$
Local CaseVar$ = ""
If Not GALE_SilentCompile L_ConsoleWrite "Processing Script: "+Entry
IncList = GALE_GetIncludes(TJCRDir(MainList),Entry)
If Not IncList Return Ret
'Start up (and makes errors appear accordingly, lateron)
Line = New TLuaLine
Line.Line = "-- GALE LUA SCRIPT --"
Line.File = "-- INTERNAL --"
ListAddLast Loader,Line
'Put the priorscript in the script
If priorscript<>""
	Local SVLins$[] = PriorScript.Split("~n")
	For Local SVLin$ = EachIn SVLins
		Line = New TLuaLine
		Line.Line = SVLin
		Line.File = "-- PRIOR SCRIPTING --"
		ListAddLast Loader,Line
		Next
	EndIf
'Put the saved variables in the script
If SavedVariables<>""
	Local SVLins$[] = SavedVariables.Split("~n")
	For Local SVLin$ = EachIn SVLins
		Line = New TLuaLine
		Line.Line = SVLin
		Line.File = "-- SAVED VARIABLES --"
		ListAddLast Loader,Line
		Next
	EndIf
'Get general in script functions
'GALE_IncludeInternalScript Loader,"Internal Lua Script/Gen.lua"
For CFile=EachIn Inclist
	LineCount=0
	DOK=1
	If LuaDebugChat Print "READING: "+CFile
	If Not JCR
		Print "Non-JCR loads, no longer supported!"
		Return Null
		EndIf
	BT = ReadFile(JCR_B(MainList,CFile)) 'If JCR JBT = JCR_Open(MainList,CFile) Else FBT=ReadFile(CFile)
	'TheEnd = (JCR And JCR_Eof(JBT)) Or ((Not JCR) And Eof(FBT))
	TheEnd = Eof(BT) ' (JCR And (JBT.Eof())) Or ((Not JCR) And Eof(FBT))
	While Not TheEnd
		RLine = Trim(ReadLine(BT)) 'If JCR RLine = Trim(ReadLine(JBT.Stream)) Else RLine=Trim(ReadLine(FBT))
		RLine = StarFunction(RLine,CFile)
		'DebugLog "RLine = "+RLine
		DetectFunction RLine,Ret
		LineCount:+1
		If Left(RLine,4) = "-- @"
			Directive = RLine.Split(" ")
			Select Upper(Directive[1])
				Case "@USE"
					Ok=False
				Case "@DEFINE"
					L_Define(Directive[2],1,CFile)
					Ok=False
				Case "@UNDEF"
					L_Define(Directive[2],0,CFile)
					Ok=False
				Case "@FI","@ENDIF"
					DOK=1
					Ok=False
				Case "@IF"
					If Not L_DefCheck(Directive) Dok=0
					Ok=False
				Case "@ELSE"
					Dok=Not Dok
					Ok=False
				Case "@ELSEIF"
					If Dok 
						Dok=False
					Else
						Dok=1
						If Not L_DefCheck(Directive) Dok=0
					EndIf
					Ok=False
				Case "@SELECT"
					Line = New TLuaLine
					Line.Line = "if false then"
					Line.LineNumber = LineCount
					Line.File = CFile
					ListAddLast Loader,Line						
					CaseVar = Right(RLine,Len(RLine)-Len("-- @SELECT "))
					Ok=False
				Case "@CASE"
					If Not CaseVar
						L_ConsoleWrite "@CASE without @SELECT. Request ignored!"
						Else
						Line = New TLuaLine
						Line.Line = "elseif "+CaseVar+"=="+Right(RLine,Len(RLine)-Len("-- @CASE "))+" then"
						Line.LineNumber = LineCount
						Line.File = CFile
						ListAddLast Loader,Line
						'Print ">>> "+Line.Line
						EndIf
					ok=False	
				Case "@DEFAULT"
					If Not CaseVar
						L_ConsoleWrite "@DEFAULT without @SELECT. Request ignored!"
						Else
						Line = New TLuaLine
						Line.Line = "else"
						Line.LineNumber = LineCount
						Line.File = CFile
						ListAddLast Loader,Line
						EndIf
					Ok=False
				Case "@ENDSELECT"
					Line = New TLuaLine
					Line.Line = "end -- Select "+CaseVar
					Line.LineNumber = LineCount
					Line.File = CFile
					ListAddLast Loader,Line						
					CaseVar = ""
					Ok=False
				Default Ok = True
				End Select					
			Else 
			Ok = True
			EndIf
		If Ok And DOK Then
			Line = New TLuaLine
			Line.Line = RLine
			Line.LineNumber = LineCount
			Line.File = CFile
			ListAddLast Loader,Line
			'Print LineCount+": "+RLine
			EndIf
		TheEnd = Eof(BT) ' TheEnd = (JCR And JBT.Eof()) Or ((Not JCR) And Eof(FBT))
		Wend
	CloseFile BT ' If JCR JBT.Close() Else CloseFile FBT	
	L_Remover(";") 'Remove SuperLocal Directives
	Next
L_Remover(":"); 'Remove Local Directives	
'Get Saved Variables
GALE_GetSavedVariables Ret,IncList,MainList,Loader
'Adding an EOF line
Line = New TLuaLine
Line.Line = "-- << EOF >> --"
Line.LineNumber=0
Line.File = "-- << EOF >> --"
ListAddLast Loader,Line
'Finalizing preprocessing
Ret.FileName = Entry
Ret.Line = ListToArray(Loader)
'Compile the result
If Not GALE_SilentCompile L_ConsoleWrite "Compiling script"
Ret.Compile
L_ConsoleWrite "Lua>GALE_OnLoad(~q"+Entry+"~q)",100,100,100
Ret.Run "GALE_OnLoad",[Entry]
Return Ret
End Function

Rem
bbdoc: BlitzMax' Lua RegisterObject.
about: As GALE uses a modified version of MaxLua, which has been built into the core of GALE, this function has been added, and I recommend you use it all the time when using GALE to prevent any sort of conflicts!
end Rem
Function GALE_Register(obj:Object,Name$)
	'GALE.MaxLua4GALE.G_LuaRegisterObject( obj,name )
	G_LuaRegisterObject(obj,Name)
End Function

Private
Type VarTMap Extends TMap
  Method L:TList(M$)
  If Not MapContains(Self,M) MapInsert Self,M,New TList
  Return TList(MapValueForKey(Self,M))
  End Method
End Type

Function GALE_GetSavedVariables(L:TLua,IL:TList,JPM:Object,Loader:TList)
Local RFile$,CFile$
Local JCR = JPM<>Null
'Local JBT:JCR_Stream
'Local FBT:TStream
Local BT:TStream
Local RLine$
Local FV$[]
Local SV:TLuaSavedVar
Local theend
'Local BT:TStream
Local SVM:VarTMap = New VarTMap
Local Line:TLuaLine
Local Allow$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890"
Local chkL$,chkch,lncnt,chki
If Not TJCRDir(JPM) Then 
	Print "JCR Dir expected in GALE_GetVariables"
	Return
	EndIf
For Cfile=EachIn IL
	RFile = StripExt(CFile)+".lsv"	
	'If (JCR And MapContains(TMap(JPM),Upper(RFile))) Or ((Not JCR) And FileType(RFile)=1) Then
	If MapContains(TJCRDir(JPM).Entries,Upper(RFile))
		If LuaDebugChat Print "READING: "+RFile
		'If JCR JBT = JCR_Open(JPM,RFile) Else FBT = ReadFile(RFile)
		BT = ReadFile(JCR_B(JPM,RFile))
		TheEnd = Eof(bt) ' (JCR And JBT.Eof()) Or ((Not JCR) And Eof(FBT))
		While Not TheEnd
			lncnt:+1
			rline = Trim(ReadLine(BT)) 'If JCR RLine = Trim(ReadLine(JBT.stream)) Else RLine=ReadLine(FBT)			
			TheEnd = Eof(BT) ' (JCR And (JBT.Eof())) Or ((Not JCR) And Eof(FBT))
			If RLine And Left(RLine,2)<>"--" 
				FV=RLine.Split(" ")
				If FV.Length=2
					For chkl=EachIn FV
						For chki=0 Until Len chkl
							chkch = chkl[chki]
							If allow.find(Upper(Chr(chkch)))<0 
								CloseFile bt
								GALE_Error "Illegal .lsv definition",["File,"+RFile,"Line #,"+lncnt,"Definition "+RLine]
								EndIf
							Next
						Next
					SV = New TLuaSavedVar
					SV.SType = FV[0]
					SV.SVar  = FV[1]
					ListAddLast L.SavedVars,SV
					'MapInsert SVM,SV.SType.toupper(),L.SavedVars
					ListAddLast SVM.L(SV.SType),SV
					ListAddLast SVM.L("ALLSAVEDVARS"),SV
					If LuaDebugChat Then Print "Added Saved Var "+SV.SVar+" under type: "+SV.SType
					EndIf
				EndIf
			Wend					
		CloseFile BT 'If JCR JBT.close() Else CloseFile FBT
		EndIf
	Next
'Only if there are actually saved variables include the script to serialize those
If Not ListIsEmpty(L.SavedVars)
	'GALE_IncludeInternalScript(Loader,"Internal Lua Script/Serializer.lua")
	For Local KEY$=EachIn (MapKeys(SVM))
		'DebugLog "Making Script for type: "+KEY
		Line = New TLuaLine
		Line.Line = "function ___SER___"+KEY+"___SER___()~nlocal Ret~nRet=~q~q~n"
		Line.File = "Serializer script"
		ListAddLast Loader,Line;   'DebugLog Line.Line
		For Local VARSL:TLuaSavedVar=EachIn(TList(MapValueForKey(SVM,KEY)))
			Local Vars$=VARSL.SVar
			Line = New TLuaLine
			Line.File = "Serializer script"
			Line.Line = "Ret=Ret..serialize(~q"+Vars+"~q,"+Vars+")..~q\n~q"
			ListAddLast Loader,Line; 'DebugLog Line.Line
			Next
		Line = New TLuaLine
		Line.Line = "JBCSYSTEM.Returner(Ret)~nend -- function ___SER___"+KEY+"___SER___()"
		Line.File = "Serializer script"
		ListAddLast Loader,Line; 'DebugLog Line.Line
		Next
	EndIf
End Function

Function GALE_IncludeInternalScript(L:TList,Script$)
Local BT:TStream
Local Count=0
Local RLine$
Local Line:TLuaLine
BT = ReadFile("incbin::"+Script)
If Not BT
	GALECON.GaleConsoleWrite("WARNING! Internal script ~q"+Script+"~q not found!",255,0,0)
	Return
	EndIf
While Not Eof(BT)
	RLine = ReadLine(BT)
	Count:+1
	Line = New TLuaLine
	Line.Line = RLine
	Line.LineNumber = Count
	Line.File = "INTERNAL SCRIPT: "+Script
	ListAddLast L,Line
	Wend
End Function

Function GALE_IncBin2JCR:TJCREntry(IBF$,RF$="")
Local Ret:TJCREntry = New TJCREntry
Local IBFS$ = "incbin::"+IBF
Local BT:TStream = ReadStream(IBFS)
If Not BT 
	GALECON.STOPGRAPHICS()
	Notify "Incbin ~q"+IBFS$+"~q does not exist!~nThis is an internal error. Please notify the project leader!"
	End
	EndIf
Ret.MainFile = IBFS
Ret.Size = StreamSize(BT)
Ret.FileName = RF
Ret.CompressedSize = Ret.Size
Ret.Encryption = 0
Ret.Storage = "Store"
CloseStream BT
'DebugLog "Data for IncBin2JCR~nMainfile: "+IBFS+"~nSize: "+Ret.Size
Return ret
End Function



'This function makes a list of all files that get included into the source with the '-- @USE' and '-- @USEDIR' directives

Function GALE_GetIncludes:TList(MainList:TJCRDir,Entry$)
Local RetList:TList = New TList; ListAddLast RetList,Entry
Local TmpList:TList = New TList; ListAddLast TmpList,Entry
Local RunList:TList = New TList
Local CapList:TList = New TList
'Local FBT:TStream
'Local JBT:JCR_Stream
Local BT:TStream
Local CFile$
Local JCR=True ' MainList<>Null
Local TheEnd
Local RLine$
Local RFile$
Local EDir$
Local Directive$[]
Local Dok=1
Local LO:TLua = New TLua
Local CntLine
If Not JCR
	Print "Get Includes: Non-JCR based loads not longer supported"
	Return New TList
	EndIf
' Include the serializer by defailt
RFile = "GALE:SERIALIZER.LUA"
MapInsert MainList.entries,RFile,GALE_IncBin2JCR("Serializer.lua",RFile)
MainList.UpdateMain ' As of version 15.09.23 of JCR6 this line is required as otherwise the JCR6 files will not work properly with GALE.
ListAddLast TmpList,RFile
ListAddLast CapList,RFile.ToUpper()
ListAddLast RetList,RFile
' If there is an AutoUse.Lua
RFile = ExtractDir(Entry)+"/AutoUse.Lua"
If MapContains(MainList.Entries,RFile.ToUpper())
	ListAddLast TmpList,RFile
	ListAddLast CapList,RFile.ToUpper()
	ListAddLast RetList,RFile
	EndIf
' Now for the rest
LO.FileName=Entry
Rem
If LuaDebugChat 
	Select JCR
	Case 0	ConsoleWrite "Getting includes from file: "+Entry
	Case 1	ConsoleWrite "Getting includes from JCR entry: "+Entry
	End Select
	EndIf
EndRem
If LuaUseDir 
	LuaUseDir=Replace(LuaUseDir,"\","/")
	If Right(LuaUseDir,1)<>"/" LuaUseDir:+"/"
	EndIf
Repeat
RunList = TmpList
TmpList = New TList;
For CFile = EachIn RunList
	'DebugLog "Checking script: "+CFile
	Dok=1
	EDir = ExtractDir(Entry)
	If EDir
		EDir = Replace(EDir,"\","/");
		If Right(EDir,1)<>"/" EDir:+"/"
		EndIf
	If (JCR And (Not MapContains(MainList.entries,CFile.ToUpper()))) Or ((Not JCR) And FileType(CFile)<>1)
		GALE_JBC_Error(LO,"Project Managing Error","Requested script has Not been found -- "+CFile)
		Return Null
		EndIf
	BT  = ReadFile(JCR_B(MainList,CFile)) ' If JCR JBT = JCR_Open(MainList,CFile) Else FBT=ReadFile(CFile)
	CntLine=0
	TheEnd = Eof(BT) ' (JCR And JBT.Eof()) Or ((Not JCR) And Eof(FBT))
	While Not TheEnd
		RLine = ReadLine(BT) 'If JCR RLine = Trim(ReadLine(JBT.Stream)) Else RLine=ReadLine(FBT)
		CntLine:+1
		Theend = Eof(BT) ' TheEnd = (JCR And JBT.Eof()) Or ((Not JCR) And Eof(FBT))
		'If LuaDebugChat Print "CRL = '"+Left(RLine,8)+"'; CRLL = '"+Left(RLine,11)+"';" 
		Directive=Trim(RLine).Split(" ")
		If Directive[0]="--" And directive.length>1
		If Left(Directive[1],1)="@" Then
			Select Upper(Directive[1])
				Case "@DEFINE"
					L_Define(Directive[2],1,CFile)
				Case "@UNDEF"
					L_Define(Directive[2],0,CFile)
				Case "@FI","@ENDIF"
					DOK=1
				Case "@IF"
					If Not L_DefCheck(Directive) Dok=0
				Case "@ELSE"
					Dok=Not Dok
				Case "@ELSEIF"
					If Dok 
						Dok=False
					Else
						Dok = L_DefCheck(Directive)
					EndIf
				End Select
			EndIf		
			EndIf
		If Left(RLine,8)="-- @USE " And Dok
			RFile = Trim(Right(RLine,Len(RLine)-8))
			If Not ExtractDir(RFile) And LuaUseDir
				RFile=LuaUseDir+RFile
				ElseIf (Not ExtractDir(RFile)) Or (JCR And Left(RFile,1)<>"/")
				RFile=EDir+RFile
				EndIf
			If JCR And Left(RFile,1)="/" RFile=Right(RFile,Len(RFile)-1)
			If GALE_USING And (Not GALE_SilentCompile) L_ConsoleWrite "= Using:           "+RFile	
			If (JCR And (Not MapContains(MainList.entries,RFile.ToUpper()))) Or ((Not JCR) And FileType(RFile)<>1)
				Local LL:TLuaLine = New TLuaLine
				LO.Line = [LL]
				LL.Line = RLine
				LL.File = CFile
				LL.LineNumber = CntLine
				GALE_JBC_Error(LO,"Project Managing Error","File requested by '-- @USE' could not be found -- "+RFile,1)
				Return Null
				EndIf
			If ListContains(CapList,RFile.ToUpper())
				L_ConsoleWrite "= Duplicate Include - Request ignored (Request done in: "+CFile+")",255,0,0
				Else
				ListAddLast TmpList,RFile
				ListAddLast CapList,RFile.ToUpper()
				ListAddLast RetList,RFile
				EndIf
			EndIf	
		If Left(RLine,11)="-- @USEDIR " And Dok 'And JCR
			RFile = Trim(Right(RLine,Len(RLine)-11))
			RFile = Replace(RFile,"\","/").toupper()
			'DebugLog "Including JCR Dir: "+RFile
			For Local DFile$=EachIn MapKeys(MainList.entries)
				'DebugLog "Requested '"+RFile+"'; found: '"+DFile+"'; FD='"+Left(RFile,Len(DFile))+"';  Ext="+ExtractExt(DFile)+"; Ok="+Int(Left(DFile,Len(RFile))=RFile)
				If ExtractExt(DFile)="LUA" And Left(DFile,Len(RFile))=RFile 
					If GALE_USING And (Not GALE_SilentCompile) L_ConsoleWrite "= Using:           "+DFile
					If ListContains(CapList,DFile.ToUpper())
						L_ConsoleWrite "= Duplicate Include - Request ignored (Request done in: "+CFile+")",255,0,0
						Else
						ListAddLast TmpList,DFile
						ListAddLast CapList,DFile.ToUpper()
						ListAddLast RetList,DFile
						EndIf
					EndIf
				Next
			EndIf	
		Wend
		CloseFile BT 'If JCR JBT.close() Else CloseFile FBT
	Next
Until ListIsEmpty(TmpList)
For Local T$ = EachIn(RetList)
	'Print "===> "+T
	Next
Return RetList
End Function

Function L_DefCheck(A$[])
Local Ret=True
Local B$
For B=EachIn(A$)
	If Left(B,1)<>"-" And Left(B,1)<>"@" And Left(B,1)<>"!" And (Not ListContains(Directives,B                )) Ret=False
	If Left(B,2)<>"-" And Left(B,2)<>"@" And Left(B,1)= "!" And (    ListContains(Directives,Right(B,Len(B)-1))) Ret=False
	Next
Return Ret
End Function
	


Function L_Define(Directive$,DU=True,File$="")
Local Forbidden$[]=["!","@","#","$","%","^","&","*","(",")","_","-","=","+","[","]","{","}"]
Local D$=Upper(Trim(Directive))
Local X$=Left(D$,1)
Local Q$
Local LO:TLua = New TLua
If File LO.FileName=File Else LO.FileName="< INTERNAL DEFINITION >";
If X="!" Or X="$" Or X="@" Or X="-" Or File
	For Q=EachIn Forbidden
		If X=Q
			Return GALE_JBC_Error(LO,"Definition Error","Illegal directive: "+X)
			EndIf
		Next
	EndIf
If DU 
	ListAddLast Directives,D
	SortList Directives
	Else
	If ListContains(Directives,D) ListRemove Directives,D
	EndIf
If LuaDebugChat Then 
	Local DUL$[]=["Undefined","Defined"]
	Print LO.FileName+" ... "+DUL[DU]+" directive "+D
	EndIf
End Function

Function L_Remover(X$)
For Local D$=EachIn Directives
	If Left(D,Len(X))=X ListRemove(Directives,D)
	Next
End Function

Public

Rem
bbdoc: You can use this to create a "bye" driver.  It can be used to set up stuff to be used in Sys.Bye()
End Rem
Type TBaseByeDriver
	
	Rem
	bbdoc: Define this method in the driver to set up the feature done in the Bye sequence. No parameters are taken, and no values are returned either.
	End Rem
	Method ByeDo() Abstract
	
	End Type

Type tByeItem
	'Field ByeTag$
	Field ByeDriver:TBaseByeDriver
	Field Script$
	Field Param$[]
	End Type

Rem
bbdoc: This variable should contain the name of the work JCR when adding Bye scripts is being used through the Sys object
End Rem
Global ByeGALEJCR:TJCRDir
Global ByeItem:tByeItem

Private
'Global ByeDrivers:TMap = New TMap
Global ByeSequence:TList = New TList
Public
Function AddToByeSequence()
ListAddLast ByeSequence,byeitem
End Function


Rem 
xbbdoc: Registers a new bye driver
End Rem	
'Function RegisterByeDriver(Tag$,Driver:TBaseByeDriver)
'MapInsert ByDrivers,tag,driver
'End Function
	
Private
Type TSysByeDriver Extends TBaseByeDriver

	Method ByeDo()
	Local TS:TLua = GALE_LoadScript(ByeGALEJCR,ByeItem.Script)
	End Method
	
	End Type

Global SysByeDriver:Tsysbyedriver = New TSysByeDriver	
'RegisterByeItem "SYS",SysByeDriver

' -- Contents of GALE_Sys.bmx
Public
Global SysLuaErrorCrash
Global SysLuaThrow = 1 ' Make a throw to the IDE when in debug mode

Type TJBC_Sys      ' BLD: Object Sys\nThis object contains a few system features that the game could use.

	Field ErrorFound ' BLD: Increases by 1 if an error has been found. Should you have configured gale not to crash out when an error occurs, you'll have to set to back this variable to 0 manually if you want to check if any errors have occured.
	
	Method Alert(A$)   ' BLD: Pops up a dialog box with A$ as message<br>\n(Does not work in full screen games)
	Notify A$
	End Method
	
	Method Sure(Q$,Cancel=0)    ' BLD: Opens a dialog box that asks the user for confirmation.<br>The question is in Q$. When Cancel is 0 it's only a yes or no question (though some platforms may ask "OK" and "Cancel"), when Cancel is 1, it will ask "yes", "no" or "cancel".<br>Answer yes returns 1, no returns 0 and cancel returns -1. Please note that LUA does not see "0" as false!
	Select Cancel
		Case 0 Return Confirm(Q)
		Case 1 Return Proceed(Q)
		Default Notify "Sure type code not recognized ("+Cancel+")"
		End Select
	End Method
	
	Method Val(S$)   ' BLD: Tuns a number in a string into an integer.<br>This function is brought in as BlitzMax (in which the project was written) can only send in strings for arguments, but LUA will sometimes need an integer and nothing else.<br>Sys.Val was brought in to solve that.<br>Sys.Val("10") just returns the integer 10 ;)
	Return S.ToInt()
	End Method

	Method ByeExecute() ' Only here for engine purposes and therefore undocumented to Lua.
		For ByeItem=EachIn ByeSequence
		If Not ByeItem.ByeDriver	GALE_Error("Not a valid Bye Driver for script: "+byeitem.script)
		ByeItem.ByeDriver.ByeDo
		Next
	GALECON.GaleConsoleCloseLogFile
	End Method
	
	Method Bye()     ' BLD: Ends the game immediately.<br>Please note that if there was any closure to be done, that it's skipped now. The game ends, and there it ends.<p>NOTE: NEVER use os.exit() for the job. GALE is able to clean up it's own shit before exitting your program. os.exit() will skip that and that can lead to things to properly closed. Depending on your GALE version this might lead to leaks.
	ByeExecute
	'End
	tricky_units.Bye.Bye
	End Method
	
	Method Error(Message$,R$="") ' BLD: Causes a script to report an error, following the complete GALE tradtions. Depending on the underlying application this can cause the entire program to crash out or not, though the setting is taken from the moment the last script was started. When the application has not been set to crash out entirely, the script will just resume after this error has taken place.
	If R GALE_Error(Message$,R.Split(";")) Else GALE_Error Message
	End Method 
	
	Method RequestTerminate() ' BLD: Returns 1 if the user requested to close down the app that runs this Lua Script otherwise it returns 0.<p>This only works in MAX2D based apps, so don't even try this with GALE.MGUI
	Return GALECON.RequestAppTerminate()
	End Method
	
	Method TerminateWhenRequested() ' BLD: When the user requested to close down the app that runs this Lua Script, the application will do so. <p>USE WITH CAUTION!!!<br>The system will NOT ask for confirmation and if things need to be done before closing down it won't happen. Only use this feature when you are sure closing down is no trouble at all. (This does not work with GALE.MGUI)
	If RequestTerminate() GALECON.GaleConsoleCloseLogFile; Bye
	End Method
	
	Method AddByeScript(LuaScript$) ' BLD: Adds a Lua Script to be executed on the moment Sys.Bye() is called or when the application is terminated by TerminateWhenRequested(). Some applications may also be linked to this feature.
	ByeItem = New tByeItem
	ByeItem.Script = LuaScript
	ByeItem.ByeDriver = SysByeDriver
	ListAddLast ByeSequence,ByeItem
	End Method
		
End Type

Rem
bbdoc: This function will crash out with an error on GALE style.
End Rem
Function GALE_Error(Message$,R$[]=Null)
	GALE_Sys.ErrorFound:+1
	Local EH$ = "Error loading script :~n[string ~q-- GALE LUA SCRIPT --...~q]:"
	Local EHL = Len(EH)
	Local EH2$ = "[string ~q-- GALE LUA SCRIPT --...~q]:"
	Local EHL2 = Len(EH2)
	Local EMsg$
	Local TMsg$
	Local LineNumber
	Local P
	'Local Line:TLuaLine
	Local GW,GH	
	If (Not(Message)) Return False
	'Print "Lua Error --"+JBC_CatchLuaError+"--"
	'If LuaErrorRewindow
		'GW = GraphicsWidth()
		'GH = GraphicsHeight()
		'EndGraphics
		'Graphics GW,GH
		GALECON.ReWindow
	'	EndIf
	'If Message 
		EMsg = Message
	'	'LineNumber=ForceLineNumber
	'	Else
	'	TMsg = Right(JBC_CatchLuaError,Len(JBC_CatchLuaError)-EHL)
	'	P=TMsg.Find(":")
	'	LineNumber = Tmsg[..p].toint()
	'	EMsg = Trim(TMsg[p+1..])
	'	If Not LineNumber
	'		TMsg = Right(JBC_CatchLuaError,Len(JBC_CatchLuaError)-EHL2)
	'		P=TMsg.Find(":")
	'		LineNumber = Tmsg[..p].toint()
	'		EMsg = Trim(TMsg[p+1..])
	'		EndIf
	'	EndIf
	GALECON.FullView
	GALECON.GaleConsoleWrite ""
	GALECON.GaleConsoleWrite "==== LUA ERROR ====",255,0,0
	GALECON.GaleConsoleDoublePrint2 "Error Type:","Custom Error",200,255,255,0,0,255,255
	GALECON.GaleConsoleDoublePrint2 "Error Message:",EMsg,200,255,255,0,0,255,255
	If R
		'Local R2$[] = R.Split(";")
		Local R3$,R4$[] 
		For R3 = EachIn R
			R4 = R3.Split(",")
			If R4.Length<>2 GALE_Error("Invalid Error Request!")
			GALECON.GaleConsoleDoublePrint2 R4[0]+":",R4[1],200,255,255,0,0,255,255
			Next
		EndIf
	GALECON.GALEErrorClosureRequest	
	?Debug
	If SysLuaThrow Then Throw "Lua Error:~n~n"+EMsg
	?
	If SysLuaErrorCrash = True GALECON.GALEConsoleCloseLogFile; Bye
	Return True
End Function

'G_LuaRegisterObject New TJBC_Sys,"Sys"
Rem
bbdoc: Allows direct access to the Sys object for Lua from BlitzBasic, in case such action is required :)
End Rem
Global GALE_Sys:TJBC_Sys = New TJBC_sys
GALE_Register New GALE_Sys,"Sys"
'GALE.MaxLua4GALE.G_LuaRegisterObject TJBC_Sys,"Sys"



