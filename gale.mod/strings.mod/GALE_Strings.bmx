Rem

	(c)  Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.08.06

End Rem
Import brl.retro
Import gale.Main
Import tricky_Units.prefixsuffix

Type TJBC_String ' BLD: Object Str\nString features\n\n<p><span style='color:#ff0000'>Note! Several features in this object have been deprecated as of version 15.08.06 and may be removed somewhere after the year 2017 or later. The object itself is not deprecated and may even be expanded in the future.<br>Several deprecated features are now brought in my strings.lua file which can be found in several repositories of mine. I hope to give it (along with a few other lua "libraries" of mine their own repository soon).

	Method Char$(A) ' BLD: returns the char of an ASCII code<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return Chr(A)
	End Method
	
	Method ASCII(S$) ' BLD: returns ASCII code of first byte in a string
	Return Asc(S)
	End Method
	
	Method Mid$(S$,Ofs,Ln=1) ' BLD: returns a part of a string<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Local L=Ln; If Not L Ln=1
	Return BRL.Retro.Mid(S,Ofs,L)
	End Method
	
	Method Length(S$) ' BLD: Returns length of a string<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	'Print "Len(~q"+S+"~q) = "+Len(S)
	Return Len(S)
	End Method
	
	Method Upper$(S$) ' BLD: returns string in uppercase<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return S$.toUpper()
	End Method
	
	Method Lower$(S$) ' BLD: Returns string in lowercase<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return S$.toLower()
	End Method
	
	Method FirstUpper$(S$) ' BLD: Returns strings in first letter upper case, the rest lowercase
	Return Left(S,1).toupper()+Right(S,Len(S)-1).tolower()
	End Method
	
	Method Left$(S$,L)  ' BLD: <p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return brl.retro.Left(S,L)
	End Method
	
	' Added 13.06.15
	Method Trim$(S$) ' BLD: Trim function <p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return brl.retro.Trim(S)
	End Method
	
	Method Right$(S$,L) ' BLD: <p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return Brl.Retro.Right(S,L)
	End Method
	
	Method BackSpace$(S$) ' BLD: Removes the last char from a string
	If Len(S)<2 Return ""
	Local L = Len(S)-1
	'Print "S = "+S+", Len = "+Len(S)+", L = "+L+", Left('"+S+"',"+L+") = "+Left(S,L)
	'Return Left(S,L)
	' When good and fast routines get bugged let's use a SLOWER, but WORKING method instead
	Local ret$ = ""
	For Local ak=1 To L
		ret:+Mid(S,ak,1)
		Next
	Return Ret
	End Method
	
	Method Replace$(S$,SBS$,REP$) ' BLD: Replaces a substring with another substring inside a string.<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return brl.retro.Replace(S,SBS,REP)
	End Method
	
	Method Prefixed(S$,Prefix$) ' BLD: Returns 1 if prefixed with the requested prefix and 0 if not
	Return tricky_units.prefixsuffix.Prefixed(S,Prefix)
	End Method

	Method Suffixed(S$,Prefix$) ' BLD: Returns 1 if suffixed with the requested suffix and 0 if not
	Return tricky_units.prefixsuffix.Suffixed(S,Prefix)
	End Method
	
	End Type

G_LuaRegisterObject New TJBC_String,"Str"
