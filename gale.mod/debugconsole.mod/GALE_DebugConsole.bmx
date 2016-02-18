Rem
        GALE_DebugConsole.bmx
	(c) 2012,2013,2014, 2015 2012, 2013, 2014.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
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



Version: 14.03.15

End Rem

' History
' 11.11.17 - Initial Version
' 12.03.31 - Moved to GALE
' 12.04.01 - Fixed a bug, due to improper movement to GALE
' 14.03.15 - FIle taken out of use and contests being imported into the main routine. The main routine needs them anyway, and this way I can put in a more proper support on this in all uses. Expect this file to be removed completely in future updates.




'Import brl.maxlua
Rem No longer needed!
Import GALE.MaxLua4GALE


IMPORT TRICKY_UNITS.CONSOLE
import Tricky_UNITS.MKL_Version

MKL_Version "GALE - GALE_DebugConsole.bmx","15.09.02"
MKL_Lic     "GALE - GALE_DebugConsole.bmx","Mozilla Public License 2.0"

Type LConsole ' BLD: Object Console\nAllows a lua script to write something on the (debug) console

	
	Method Write(Txt$,R=255,G=255,B=255) ' BLD: Writes something onto the console in the desired color
	ConsoleWrite Txt,R,G,B
	End Method

	Method Print(Txt$,R=255,G=255,B=255) ' BLD: Alias for Console.Write
	ConsoleWrite Txt,R,G,B
	End Method
	
	Method Show() ' BLD: Show the console the way it looks now (you'll require to do a FLIP, to make it actually appear on the physical screen) :)
	ConsoleShow
	End Method
	
	Method Flip() ' BLD: Same as Image.Flip, but included here just in case the Image object wasn't used in the particular project ;)
	'DebugLog "Flipping in Console object"
	brl.Graphics.Flip
	End Method
	
	End Type
	
G_LuaRegisterObject New LConsole,"Console"
End Rem
