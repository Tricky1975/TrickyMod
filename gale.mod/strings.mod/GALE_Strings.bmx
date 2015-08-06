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
 * Portions created by the Initial Developer are Copyright (C) 2012, 2013, 2014
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 14.01.01

End Rem
Import brl.retro
Import gale.Main
Import tricky_Units.prefixsuffix

Type TJBC_String ' BLD: Object Str\nString features\n\n<span style='color:#ff0000'>Note! Several features in this object have been deprecated as of version 15.08.06 and may be removed somewhere after the year 2017 or later. The object itself is not deprecated and may even be expanded in the future.<br>Several deprecated features are now brought in my strings.lua file which can be found in several repositories of mine. I hope to give it (along with a few other lua "libraries" of mine their own repository soon).

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
	
	Method Left$(S$,L)<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
	Return brl.retro.Left(S,L)
	End Method
	
	' Added 13.06.15
	Method Trim$(S$) ' BLD: Trim function
	Return brl.retro.Trim(S)
	End Method
	
	Method Right$(S$,L)<p style='color:#ff0000;background-color:#000000; font-family:impact; font-size:20'>DEPRECATED!</p>
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
	Return tricky.units.Prefixed(S,Prefix)
	End Method

	Method Suffixed(S$,Prefix$) ' BLD: Returns 1 if suffixed with the requested suffix and 0 if not
	Return tricky.units.Suffixed(S,Prefix)
	End Method
	
	End Type

G_LuaRegisterObject New TJBC_String,"Str"
