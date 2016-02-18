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



Version: 15.02.11

End Rem

' 15.02.16 - Fixed an x y issue in the buttons if the parent's coordinates are not (0,0)
'          - Due to a bug the alternate keys still worked when the button was disabled. This has been fixed.

'Strict

'Import tricky_units.MKL_Version
'Import "Button/BUTTONINCBIN.bmx"
'Import "TUIC_Core.bmx"

MKL_Version "TrickyUI - TUI_Core/TUIC_Button.bmx","15.02.11"
MKL_Lic     "TrickyUI - TUI_Core/TUIC_Button.bmx","Mozilla Public License 2.0"



' First the gadget driver

Type TUI_GDrvButton Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget, Enabled)
	'If G.idleimage DrawImage G.idleimage,g.x,g.y
	Local px,py
	Local vpx,vpy,vpw,vph,ox#,oy#
	Local E = G.Enabled And Enabled
	G.w = ImageWidth(G.ActionImage)
	g.h = ImageHeight(g.ActionImage)
	TUI_ParentCoords G,px,py
	G.Action = ((TUI_CID.MouseX>=px+G.X And TUI_CID.MouseX<=px+G.X+G.W And TUI_CID.MouseY>=py+G.Y And TUI_CID.MouseY<=py+G.Y+G.H And TUI_CID.MouseHit[1]) Or (G.AltKey And TUI_CID.KeyHit[G.Altkey])) And G.Enabled And Enabled
	If G.AltKeys And E
		For Local k=EachIn G.AltKeys G.Action = G.Action Or (K And TUI_CID.KeyHit[K]) Next
		EndIf
	TUI_DrawImage G,G.Action
	GetViewport vpx,vpy,vpw,vph
	GetOrigin ox,oy
	SetViewport px+g.x,py+g.y,g.w,g.h
	SetOrigin px+g.x,py+g.y
	SetImageFont G.Font
	G.DText g.text,(g.w/2)-(TextWidth(g.text)/2),(g.h/2)-(TextHeight(g.text)/2),E
	SetViewport vpx,vpy,vpw,vph
	SetOrigin ox,oy
	If G.Action And G.TB_Action G.TB_Action.CallFunc(G,TUI_CID.MouseX-(g.x+px),TUI_CID.MouseY-(g.y+py))
	'If G.Action Print "ACTION BUTTON" ' Debug line
	'Print "Screeny!"
	End Method

End Type

regtuidriver "Button",New TUI_GDrvButton

Rem
bbdoc:Creates a button. Clicking the button with the left mouse button will activate it.
about:When the images are not set, TUI will use an internal button in stead. If IdleButton is properly set and actionbutton is not, the system will use the IdleButton for action as well, and the same will happen if the formats of both images differ (yes only one pixel difference will make that happen!).<p>If you desire to change the font you can set the new font in the gadgets "Font" field. When you set a value to the AltKey you can also activate that button by pressing the set key.
End Rem
Function TUI_CreateButton:TUI_Gadget(Caption$,x,y,parent:TUI_Gadget,IdleButton:TImage=Null,ActionButton:TImage=Null)
Local Ret:TUI_Gadget = New TUI_Gadget
ret.kind = "Button"
ret.x = x
ret.y = y
If IdleButton ret.IdleImage = IdleButton Else ret.IdleImage = TUI_IDLEBUTTON; ret.ACtionImage = TUI_ACTIONBUTTON
If ActionButton And IdleButton
	If ImageWidth(actionbutton)=ImageWidth(Idlebutton) And ImageHeight(actionbutton)=ImageHeight(actionbutton) ret.actionimage = actionbutton
	EndIf
If Not ret.actionimage ret.actionimage = ret.idleimage
ret.w = ImageWidth(ret.idleimage)
ret.h = ImageHeight(ret.idleimage)
ret.text = caption
setparent parent,ret
Return ret
End Function
