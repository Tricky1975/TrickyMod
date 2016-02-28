Rem
        TUIC_Picture.bmx
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

' 15.02.06 - Initial
' 16.02.28 - Fixed an bbdoc error

MKL_Version "Tricky's User Interface - TUIC_Picture.bmx","16.02.28"
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
	SetAlpha g.alpha
	DrawImage g.idleimage,px+g.x,py+g.y
	SetAlpha 1
	End Method

End Type

regtuidriver "Picture",New TUI_GDrvpicture


