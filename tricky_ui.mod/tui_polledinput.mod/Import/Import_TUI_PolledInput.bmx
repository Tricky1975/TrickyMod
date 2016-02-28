Rem
        TUI_PolledInput.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.02.28
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
 * Portions created by the Initial Developer are Copyright (C) 2015
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 15.02.06

End Rem
Import tricky_units.MKL_Version
Import tricky_ui.tui_core
Import brl.polledinput

MKL_Version "Tricky's User Interface - TUI_PolledInput.bmx","16.02.28"
MKL_Lic     "Tricky's User Interface - TUI_PolledInput.bmx","Mozilla Public License 2.0"

Type TUI_POLLEDINPUTDRIVER Extends TUI_InputDriver 

	Method getinput()
	Local k
	For k=0 Until Len(KeyHit) KeyHit[k]=brl.polledinput.KeyHit(k); KeyDown[k]=brl.polledinput.KeyDown(k) Next
	For k=0 Until Len(MouseHit) MouseHit[k]=brl.polledinput.MouseHit(k) Next
	MouseX = brl.polledinput.MouseX()
	MouseY = brl.polledinput.MouseY()
	End Method
	
	End Type

TUI_CID = New tui_polledinputdriver
