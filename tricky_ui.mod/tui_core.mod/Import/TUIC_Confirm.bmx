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
Type TUIConfirmType
	Field Yes$ = "Yes"
	Field No$ = "No"
	Field Cancel$ = "Cancel"
	Field Back:TImage
	Field Font:TImagefont
	End Type
	

Rem
bbdoc: This variable contains some global config for confirmation screens. 
about: The field variables "Yes", "No" and "Cancel" are strings containing their own names respectively. You can can alter those values if you wish your project to be in a foreign language for example.<p>If the variable Back contains a valid TImage it will be shown during the question and you can set the variable "Font" just the same for the fonts used in such an event.
End Rem
Global TUI_ConfirmConfig:TUIConfirmType	
TUI_ConfirmConfig:TUIConfirmType = New TUIConfirmType	



Rem
bbdoc: Asks a yes or no question.
about: Returns 1 if the user clicks "yes", 0 if the user clicks "no". If a cancel button is present -1 will be returned if it's clicked.
End Rem
Function TUI_Confirm(Question$,CancelButton=False,Head:TImage=Null,AltConfig:TUIConfirmType=Null)
Local cfg:tuiconfirmtype = altconfig; If Not cfg cfg = tui_confirmconfig
Local Scr:TUI_Gadget = TUI_CreateScreen()
Scr.idleimage = cfg.back
Local y = 50
Local x = GraphicsWidth()/2
If head
	SetImageHandle Head,ImageWidth(head)/2,0
	tui_createpicture head,x,y,scr
	y:+(50+ImageHeight(head))
	EndIf
TUI_CreateLabel Question,x,y,scr,cfg.font,2
Local Yes:TUI_Gadget = TUI_CreateButton(cfg.yes,0,GraphicsHeight()-150,scr)
Local No:TUI_Gadget = TUI_CreateButton(cfg.no,GraphicsWidth()-250,GraphicsHeight()-150,scr)
Local Cancel:TUI_Gadget = TUI_CreateButton(cfg.Cancel,GraphicsWidth()-250,GraphicsHeight()-250,scr)
cancel.visible = cancelbutton
Local ret
Repeat
cls
tui_run Scr
Flip
If yes.action		ret= 1; Exit
If no.action		ret= 0; Exit
If cancel.action	ret=-1; Exit
Forever
Print "Releasing the confirm stuff"
TUI_Free scr
Return ret
End Function

