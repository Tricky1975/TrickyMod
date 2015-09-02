Rem
        GALE_Time.bmx
	(c) 2012-2015, 2015 Jeroen Petrus Broks.
	
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



Version: 14.01.01

End Rem

' History
' 11.11.17 - Initial Version
' 12.03.31 - Moved to GALE
' 13.11.21 - Made sure the GALE.maxlua is used (I was surprised no conflicts came up yet).


Strict

Import brl.System
'Import gale.maxlua
Import gale.Main


import Tricky_UNITS.MKL_Version

MKL_Version "GALE - GALE_Time.bmx","15.09.02"
MKL_Lic     "GALE - GALE_Time.bmx","Mozilla Public License 2.0"


Type TJBC_Time ' BLD: Object Time \n Contains some functions for time usage

	Method Sleep(ms) ' BLD: Makes the system wait for <i>ms</i> milliseconds
	Delay ms
	End Method
	
	Method MSecs()  ' BLD: The number of milliseconds that have passed since the last start up of your OS
	Return MilliSecs()
	End Method
	
	Method Date$()  ' BLD: Returns the current date in a format like 12 jan 2011
	Return CurrentDate()
	End Method
	
	Method Time$()  ' BLD: Retuns the current time as 12:34:42
	Return CurrentTime()
	End Method
			
End Type

GALE_Register New TJBC_Time,"Time"
