
Type TUI_GDrvCheckbox Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget, Enabled)
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
	TUI_DrawImage G,G.Checked
	GetViewport vpx,vpy,vpw,vph
	GetOrigin ox,oy
	SetViewport px+g.x,py+g.y,g.w,g.h
	SetOrigin px+g.x,py+g.y
	SetImageFont G.Font
	G.DText g.text,(g.w/2)-(TextWidth(g.text)/2),(g.h/2)-(TextHeight(g.text)/2),E
	SetViewport vpx,vpy,vpw,vph
	SetOrigin ox,oy
	If G.Action 
		If G.TB_Action G.TB_Action.CallFunc(G,TUI_CID.MouseX-(g.x+px),TUI_CID.MouseY-(g.y+py))
		G.Checked = Not G.Checked
		EndIf
	End Method
	
	End Type
	

regtuidriver "Checkbox",New TUI_GDrvCheckbox

Rem
bbdoc:Creates a checkbox. Clicking the button with the left mouse button will toggle it on or off.
End Rem
Function TUI_CreateCheckbox:TUI_Gadget(x,y,parent:TUI_Gadget,IdleButton:TImage,ActionButton:TImage)
Local Ret:TUI_Gadget = New TUI_Gadget
'Assert IdleButton And ActionButton Else "Proper images required to create a button"
ret.kind = "Checkbox"
ret.x = x
ret.y = y
If IdleButton ret.IdleImage = IdleButton Else ret.IdleImage = TUI_IDLEBUTTON; ret.ACtionImage = TUI_ACTIONBUTTON
If ActionButton And IdleButton
	If ImageWidth(actionbutton)=ImageWidth(Idlebutton) And ImageHeight(actionbutton)=ImageHeight(actionbutton) ret.actionimage = actionbutton
	EndIf
If Not ret.actionimage ret.actionimage = ret.idleimage
ret.w = ImageWidth(ret.idleimage)
ret.h = ImageHeight(ret.idleimage)
'ret.text = caption
setparent parent,ret
Return ret
End Function

MKL_Version "TrickyUI - TUI_Core/TUIC_Checkbox.bmx","15.02.11"
MKL_Lic     "TrickyUI - TUI_Core/TUIC_Checkbox.bmx","Mozilla Public License 2.0"
