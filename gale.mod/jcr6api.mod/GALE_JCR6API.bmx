Rem
        GALE_JCR6API.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.06.12
End Rem

'History:
'15.04.29 - Intiial version
'15.07.12 - No problems in Mac, but Windows does not work well. I really hate Microsoft for causing me this trouble. Anyway, I'm trying to get this to work in Windows now.
'16.06.12 - Removed dupe license block
'         - NG compatibility

Strict
Import JCR6.JCR6MAIN
Import gale.Main
Import tricky_units.TrickyReadString

MKL_Version "GALE - GALE_JCR6API.bmx","16.06.12"
MKL_Lic     "GALE - GALE_JCR6API.bmx","Mozilla Public License 2.0"

Rem
bbdoc: This variable must contain the JCR map if own JCR is not allowed
End Rem
Global GALEAPIJCRDIR:TJCRDir

Rem
bbdoc: When set to true, the Lua scripts can access JCR files themselves, otherwise only the map defined within the BMax application
End Rem
Global AllowOwnJCR = False


Private
Global JBTM:TMap = New TMap

Function NewEntry(B:TStream)  
Local ret 
While MapContains(JBTM,"$"+Hex(ret)); ret:+1 Wend 
MapInsert JBTM,"$"+Hex(ret),B 
Return ret 
End Function

Function E:TStream(ret)
Return TStream(MapValueForKey(JBTM,"$"+Hex(ret)))
End Function

Function E_Kill(ret)
MapRemove JBTM,"$"+Hex(ret)
End Function


Public


Type TJCR6API ' BLD: Object JCR6\nContains an object for reading JCR6 from Lua in GALE.
	
	Method ReadFile(M$,F$="") ' BLD: Loads a file from the main JCR dir. (The F parameter is not needed unless you have an engine that allows you to pick any JCR file, then M is the JCR file and F the entry. Most engines are configured not to support this though).
	Local Own = False
	Local MJ:TJCRDir = GALEAPIJCRDIR
	Local Entry$ = M
	Local ret:TStream
	If AllowOwnJCR
   		Own = F<>""
		If M And F MJ=JCR_Dir(M); entry = F
		EndIf
	If Not MJ GALE_Error("JCR6 could not access the JCR file or the requested entry!",["Entry,"+Entry])
	ret =  JCR_ReadFile(MJ,Entry)
	Return NewEntry(ret)
	End Method
	
	Method LoadString$(M$,F$) ' BLD: Loads the content of an entire file and returns it as a string (In windows it's recommended only to use this feature as Windows appears allergic to the other read file functions. Cause unknown).
	Local Own = False
	Local MJ:TJCRDir = GALEAPIJCRDIR
	Local Entry$ = M
	If AllowOwnJCR
   		Own = F<>""
		If M And F MJ=JCR_Dir(M); entry = F
		EndIf
	If Not MJ GALE_Error("JCR6 could not access the JCR file or the requested entry!",["Entry,"+Entry])
	Local BT:TStream = JCR_ReadFile(MJ,Entry)
	Local ret$ = ReadString(BT,Int(StreamSize(BT)))
	CloseStream BT
	Return ret	
	End Method
	
	
	Method Exists(M$,F$) ' BLD: Returns 1 if an entry exists, and 0 if not.<br>(The F parameter is not needed unless you have an engine that allows you to pick any JCR file, then M is the JCR file and F the entry. Most engines are configured not to support this though).<p>Please note that Lua counts 0 as true. You gotta remember this or you'll easily create a bug ;)
	Local Own = False
	Local MJ:TJCRDir = GALEAPIJCRDIR
	Local Entry$ = M
	If AllowOwnJCR
   		Own = F<>""
		If M And F MJ=JCR_Dir(M); entry = F
		EndIf
	If Not MJ GALE_Error("JCR6 could not access the JCR file or the requested entry!",["Entry,"+Entry])
	Return JCR_Exists(MJ,entry)
	End Method	
	
	Method ReadB(BT) ' BLD: Reads and returns a byte from the JCR file
	Local B:TStream = E(BT)
	If Not B GALE_Error("Cannot read bytes from null stream")
	Return ReadByte(B)
	End Method
	
	Method ReadI(BT) ' BLD: Reads and returns an int from the JCR file
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read ints from null stream"
	Return ReadInt(B)
	End Method

	Method ReadL:Long(BT) ' BLD: Reads and returns an long from the JCR file.<p>Warning, Lua can become unreliable when you're dealing with high numbers. This function does NOT take that in account!! So use this function with care!
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read long ints from null stream"
	Return ReadLong(B)
	End Method

	Method ReadD:Double(BT) ' BLD: Reads and a double from the JCR file
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read Doubles from null stream"
	Return ReadDouble(B)
	End Method

	Method ReadF:Float(BT) ' BLD: Reads and a float from the JCR file. (Please note. Floats are not a very reliable data type in BlitzMax in which this API was written, so only read them when you got no other choice).
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read Doubles from null stream"
	Return ReadFloat(B)
	End Method
	
	Method ReadLn$(BT) ' BLD: Reads and a line from the JCR file. (Basically as well UNIX single byte EOLNs as Windows/DOS styled two byte EOLNs should be read).
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read lines from null stream"
	Return ReadLine(B)
	End Method
	
	Method ReadStr$(BT,L=0) ' BLD: Reads and a string from the JCR file.<br>If L is 0 the interpreter will read an int to determine the length and then read the string itself. If the length is any other number this step will be skipped and the system will read the string with the given length.
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read strings from null stream"
	Return ReadDouble(B)
	End Method
	
	Method ReadNullStr$(BT) ' BLD: Reads a string terminated by null in the JCR file, like most C and C++ programs do by default.
	Local ret$,c
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot read null-terminated strings from null stream"
	If Eof(BT) Return
	Repeat
	c = readb(BT)
	If c=0 Or Eof(BT) Exit
	ret:+Chr(c)
	Forever
	Return ret
	End Method
	
	
	Method Eof(BT) ' BLD: 1 is the end of the file is reached otherwise 0. Please note, 0 is taken for true by Lua is "if JCR6.Eof(mystream) then" will always be true, so use "if JCR6.Eof(mystream)==1 then" in stead!
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot determine the EOF from null stream"
	Return brl.stream.Eof(B)
	End Method
	
	Method Close(BT) ' BLD: Closes a JCR stream.
	Local B:TStream = E(BT)
	If Not B GALE_Error "Cannot close a null stream"
	CloseFile B
	E_Kill BT
	End Method
	
	Method DirTable$(M$) ' BLD: Returns a Lua script in which a table variable is defined with all entries inside a JCR file. In order to use this table you need loadstring(). <pre style='background:black; color:white'>-- A way to do this<br>function JCR6DirTable()<br>&nbsp;local f=loadstring(JCR6.DirTable())<br>&nbsp;return f()<br>end</pre><p>Include this in the Lua script and you should have a table containing all files inside the Lua file. :)<p>NOTE! In most applications the M should not be defined unless you use an engine where free JCR6 access is allowed.
	Local MJ:TJCRDir = GALEAPIJCRDIR
	'Local Entry$ = M
	Local ret$ 
	If AllowOwnJCR
		If M  MJ=JCR_Dir(M); 
		EndIf
	If Not MJ GALE_Error "No JCR6 file has been prolerly assigned. Cannot dir it as result!"	
	For Local E:TJCREntry = EachIn MapValues(MJ.entries)
		If ret ret:+",~n~t" Else ret= "ret = {~n~t"
		ret:+"~q"+Replace(E.FileName,"~q","\~q")+"~q"
		Next
	ret:+"}~n~nreturn ret"
	Return ret	
	End Method
	
	End Type

GALE_Register New TJCR6API,"JCR6"
