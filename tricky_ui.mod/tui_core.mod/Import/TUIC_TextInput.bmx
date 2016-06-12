Rem
        TUIC_TextInput.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.06.12
End Rem

' 16.02.06 - Initial
' 16.02.29 - Fixed bbdoc text and license block
' 16.06.11 - Adepted to make it work in blitzmax ng

MKL_Version "Tricky's User Interface - TUIC_TextInput.bmx","16.06.12"
MKL_Lic     "Tricky's User Interface - TUIC_TextInput.bmx","Mozilla Public License 2.0"


Rem
bbdoc: Creates a user input bar 
about: Though a parent for a screen is accepted mostly it's wiser not to go for this. These screen will not produce any events, but they simply handy to use as parent for all the buttons and other stuff you have on the screen. If the Image is set the screen will always contain this picture, please note though that the sizes of this pictures do not play a role in the size of the screen.
End Rem
Function TUI_CreateUserInput:TUI_Gadget(x,y,w,parent:TUI_Gadget)
Local ret:TUI_Gadget = New TUI_Gadget
ret.kind = "UserInput"
ret.x = x
ret.y = y
ret.w = w
ret.h = TextWidth("Test")
ret.parent = parent
ret.enabledcolor 0,0,0
ret.alpha = .5
setparent parent,ret
Return ret
End Function



Type TUI_GDrvUserInput Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget,Enabled)
	Local px,py
	Local a:Double = GetAlpha()
	Local Cursor$
	Local T$=Right(CurrentTime(),1)
	Local active = tui_activegadget = G
	If (T="0" Or T="2" Or T="4" Or T="6" Or T="8") And active And G.Enabled And Enabled Cursor="|"
	tui_parentcoords G,px,py
	G.h = TextHeight(G.Text)
	?bmxng
	SetAlpha Float(g.alpha
	?Not bmxng
	SetAlpha G.alpha
	?
	SetColor G.colors[(g.enabled And enabled),0],G.colors[(g.enabled And enabled),1],G.colors[(g.enabled And enabled),2]
	DrawRect G.x+px,G.y+py,g.w,g.h
	SetAlpha a
	SetColor G.colors[(g.enabled And enabled)+2,0],G.colors[(g.enabled And enabled)+2,1],G.colors[(g.enabled And enabled)+2,2]
	SetImageFont G.Font
	g.dtext g.text+Cursor,G.X+PX,G.Y+PY
	Local ac$ = G.allowedchars.toupper()
	Local ak,ch$,ok
	G.Action = False
	If active And G.Enabled And enabled
		If TUI_CID.KeyHit[KEY_BACKSPACE]
			If G.Text G.Text = Left(G.Text,Len(G.Text)-1)
			G.Action=True
			EndIf
		For ak=0 Until Len(ac)
			'Print "Keyhit["+ac[ak]+"] = "+TUI_CID.KeyHit[ac[ak]]
			If TUI_CID.KeyHit[ac[ak]] And (Not TUI_CID.KeyHit[KEY_BACKSPACE])
				ch = Chr(ac[ak])
				If Not(TUI_CID.KeyDown[KEY_LSHIFT] Or TUI_CID.KeyDown[KEY_RSHIFT]) ch=Lower(ch)
				Ok = TextWidth(G.Text+ch)<G.W
				Ok = Ok And ((Not g.Maxlen) Or Len(G.Text+Ch)<G.MaxLen)
				'Print "Ch = "+ch+" Ok = "+Ok
				If Ok G.Text:+ch; G.Action=True
				EndIf			 			
			Next
		EndIf
	If ((TUI_CID.MouseX>=px+G.X And TUI_CID.MouseX<=px+G.X+G.W And TUI_CID.MouseY>=px+G.Y And TUI_CID.MouseY<=py+G.Y+G.H And TUI_CID.MouseHit[1]) Or (G.AltKey And TUI_CID.KeyHit[G.Altkey])) And G.Enabled TUI_ActivateGadget G	
	End Method

End Type

regtuidriver "UserInput",New TUI_GDrvUserInput

