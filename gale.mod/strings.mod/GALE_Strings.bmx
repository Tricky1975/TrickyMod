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

Type TJBC_String ' BLD: Object Str\nString features

	Method Char$(A) ' BLD: returns the char of an ASCII code
	Return Chr(A)
	End Method
	
	Method ASCII(S$) ' BLD: returns ASCII code of first byte in a string
	Return Asc(S)
	End Method
	
	Method Mid$(S$,Ofs,Ln=1) ' BLD: returns a part of a string
	Local L=Ln; If Not L Ln=1
	Return BRL.Retro.Mid(S,Ofs,L)
	End Method
	
	Method Length(S$) ' BLD: Returns length of a string
	'Print "Len(~q"+S+"~q) = "+Len(S)
	Return Len(S)
	End Method
	
	Method Upper$(S$) ' BLD: returns string in uppercase
	Return S$.toUpper()
	End Method
	
	Method Lower$(S$) ' BLD: Returns string in lowercase
	Return S$.toLower()
	End Method
	
	Method FirstUpper$(S$) ' BLD: Returns strings in first letter upper case, the rest lowercase
	Return Left(S,1).toupper()+Right(S,Len(S)-1).tolower()
	End Method
	
	Method Left$(S$,L)
	Return brl.retro.Left(S,L)
	End Method
	
	' Added 13.06.15
	Method Trim$(S$) ' BLD: Trim function
	Return brl.retro.Trim(S)
	End Method
	
	Method Right$(S$,L)
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
	
	Method Replace$(S$,SBS$,REP$) ' BLD: Replaces a substring with another substring inside a string.
	Return brl.retro.Replace(S,SBS,REP)
	End Method
	
	End Type

G_LuaRegisterObject New TJBC_String,"Str"
