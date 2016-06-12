Rem
        TUIC_Label.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.06.12
End Rem
' 15.02.24 - Fixed the font issue that caused the alignment to spook up.
' 16.06.12 - Removed dupe and outdated license block
'          - NG Adeptions

MKL_Version "Tricky's User Interface - TUIC_Label.bmx","16.06.12"
MKL_Lic     "Tricky's User Interface - TUIC_Label.bmx","Mozilla Public License 2.0"


Rem
bbdoc: Creates a label containing text 
End Rem
Function TUI_CreateLabel:TUI_Gadget(Text$,x,y,parent:TUI_Gadget,font:TImageFont=Null,alignment=0)
Local ret:TUI_Gadget = New TUI_Gadget
ret.kind = "Label"
ret.x = x
ret.y = y
ret.w = 0
ret.h = 0
ret.font = font
ret.text = text
ret.alignment = alignment
setparent parent,ret
Return ret
End Function



Type TUI_GDrvLabel Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget,Enabled)
	SetImageFont G.font
	Local tw = TextWidth(G.Text)
	Local ax[] = [0,TW,TW/2]
	Local px,py
	Local lines$[] = G.Text.split("~n")
	tui_parentcoords g,px,py
	Local y = py+g.y
	SetColor G.colors[1,0],g.colors[1,1],g.colors[1,2]
	'DrawText G.Text,px+g.x,py+g.y
	For Local L$=EachIn lines
		G.DText L,(px+g.x)-ax[G.Alignment],y
		y:+TextHeight(L)
		Next
	End Method

End Type

regtuidriver "Label",New TUI_GDrvLabel

