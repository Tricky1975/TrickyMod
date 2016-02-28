' 16.02.29 - Initial (yeah, Feb 29, the day we only have once in the four years, hehe).


Rem
bbdoc: Creates a listbox. 
about: Though a parent for a screen is accepted mostly it's wiser not to go for this. These screen will not produce any events, but they simply handy to use as parent for all the buttons and other stuff you have on the screen. If the Image is set the screen will always contain this picture, please note though that the sizes of this pictures do not play a role in the size of the screen.
End Rem
Function TUI_CreateListBox:TUI_Gadget(x,y,w,h,parent:TUI_Gadget)
Local ret:TUI_Gadget = New TUI_Gadget
ret.kind = "ListBox"
ret.x = x
ret.y = y
ret.w = w
ret.h = h
ret.parent = parent
ret.enabledcolor 0,0,0
ret.alpha = .5
setparent parent,ret
Return ret
End Function



Type TUI_GDrvListbox Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget,Enabled)
	Local px,py
	tui_parentcoords G,px,py
	SetImageFont g.font
	Local a:Double = GetAlpha()
	SetAlpha G.alpha
	SetColor G.colors[(g.enabled And enabled),0],G.colors[(g.enabled And enabled),1],G.colors[(g.enabled And enabled),2]
	DrawRect G.x+px,G.y+py,g.w,g.h
	SetAlpha a
	SetColor G.colors[(g.enabled And enabled)+2,0],G.colors[(g.enabled And enabled)+2,1],G.colors[(g.enabled And enabled)+2,2]

	End Method

	Method ScrollUp(md=1)
	End Method

	End Type

regtuidriver "ListBox",New TUI_GDrvListBox