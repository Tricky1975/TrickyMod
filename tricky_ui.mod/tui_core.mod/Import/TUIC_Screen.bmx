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
'Strict

'Import tricky_units.MKL_Version
'Import "TUIC_Core.bmx"

MKL_Version "TrickyUI - TUI_Core/TUIC_Screen.bmx","15.02.06"
MKL_Lic     "TrickyUI - TUI_Core/TUIC_Screen.bmx","Mozilla Public License 2.0"


Rem
bbdoc: Makes the entire screen the gadget. 
about: Though a parent for a screen is accepted mostly it's wiser not to go for this. These screen will not produce any events, but they simply handy to use as parent for all the buttons and other stuff you have on the screen. If the Image is set the screen will always contain this picture, please note though that the sizes of this pictures do not play a role in the size of the screen.
End Rem
Function TUI_CreateScreen:TUI_Gadget(screen:TImage=Null,parent:TUI_Gadget=Null)
Local ret:TUI_Gadget = New TUI_Gadget
ret.kind = "Screen"
ret.x = 0
ret.y = 0
ret.w = GraphicsWidth()
ret.h = GraphicsHeight()
ret.idleimage = screen
ret.parent = parent
setparent parent,ret
Return ret
End Function



Type TUI_GDrvScreen Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget, Enabled)
	'If G.idleimage DrawImage G.idleimage,g.x,g.y
	If G.TIledImage
		TUI_TileImage G
	Else
		TUI_DrawImage G
		EndIf
	'Print "Screeny!"
	End Method

End Type

regtuidriver "Screen",New TUI_GDrvScreen
