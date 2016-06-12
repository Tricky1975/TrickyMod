Rem
        TUIC_Picture.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.06.12
End Rem

' 15.02.06 - Initial
' 16.02.28 - Fixed an bbdoc error

MKL_Version "Tricky's User Interface - TUIC_Picture.bmx","16.06.12"
MKL_Lic     "Tricky's User Interface - TUIC_Picture.bmx","Mozilla Public License 2.0"


Rem
bbdoc: Uses a picture (loaded as a TImage) as a gadget. 
about: This picture is affected by color and alpha settings. If you desire a special alignment, you can just handle the picture with setimagehandle().
End Rem
Function TUI_CreatePicture:TUI_Gadget(Image:TImage,x,y,parent:TUI_Gadget)
Local ret:TUI_Gadget = New TUI_Gadget
ret.kind = "Picture"
ret.x = x
ret.y = y
ret.w = 0
ret.h = 0
ret.idleimage = image
setparent parent,ret
Return ret
End Function



Type TUI_GDrvpicture Extends TUI_Gadgetdriver

	Method Run(G:TUI_Gadget,Enabled)	
	Local px,py
	If Not G.idleimage Return
	tui_parentcoords g,px,py
	SetColor G.colors[1,0],g.colors[1,1],g.colors[1,2]
	?bmxng
	SetAlpha Float(g.alpha)
	?Not bmxng
	SetAlpha g.alpha
	?
	DrawImage g.idleimage,px+g.x,py+g.y
	SetAlpha 1
	End Method

End Type

regtuidriver "Picture",New TUI_GDrvpicture


