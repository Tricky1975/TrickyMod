Rem
  MaxGUI_Input.bmx
  
  version: 15.09.02
  Copyright (C) 2014, 2015 Jeroen P. Broks
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
End Rem
Rem
/* 
  MaxGUI Input

  Copyright (C) 2014 Jeroen P. Broks

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/



Version: 15.04.19

End Rem
' 15.02.03 - Adeption to the new module setup that came in place since JCR6
' 15.04.10 - Fixed the bug that would not remove the input window out of the screen, if the user cancelled the input
Strict
Import MaxGUI.Drivers
Import Tricky_units.MKL_Version
Import brl.eventqueue

MKL_Version "Tricky's Units - MaxGUI_Input.bmx","15.09.02"
MKL_Lic     "Tricky's Units - MaxGUI_Input.bmx","ZLib License"


Rem
bbdoc:If the last input request was actually accepted then this value will contain the value 'True', in any other case this value contains the value 'False'
End Rem
Global MaxGUI_InputAccepted


Private
DebugLog "MGIWX = "+Double(ClientWidth(Desktop()))*.75
Global GI_Win:TGadget = CreateWindow("---",0,0,Double(ClientWidth(Desktop()))*.75,75,Null,WINDOW_CLIENTCOORDS | WINDOW_CENTER | WINDOW_HIDDEN | WINDOW_TITLEBAR)
Global GI_Qst:TGadget = CreateLabel("---",0,0,ClientWidth(GI_WIN),25,GI_WIN)
Global GI_Txt:TGadget = CreateTextField(0,25,ClientWidth(GI_WIN),25,GI_WIN)
Global GI_OkB:TGadget = CreateButton("Ok",ClientWidth(GI_WIN)-100,50,100,25,GI_WIN,BUTTON_OK)
Global GI_Cnc:TGadget = CreateButton("Cancel",ClientWidth(GI_WIN)-225,50,100,25,GI_WIN,BUTTON_CANCEL)



Function TrueInput:String(Caption$,DefaultText$,InpT$,AllowCancel,CustomAllow$="")
'DebugLog "Input(~q"+Caption+"~q,~q"+DefaultText+"~q,~q"+InpT+"~q,"+AllowCancel+",~q"+CustomAllow+"~q)"
SetGadgetText GI_Win,AppTitle
SetGadgetText GI_Qst,Caption
SetGadgetText GI_Txt,DefaultText
ShowGadget GI_Win
If allowcancel Then ShowGadget GI_Cnc Else HideGadget GI_Cnc
Local allow$
Repeat
Select Upper(InpT)
	Case "INT"
		Allow="0123456789"
		If Left(TextFieldText(GI_Txt),1)="$" Allow:+"$ABCDEFabcdef"
	Case "DOUBLE"
		Allow="0123456789."
	Case "BIN"
		Allow="01"
	Case "OCT"
		Allow="01234567"	
	Case "CUSTOM"
		Allow=CustomAllow	
	End Select
WaitEvent
Local Ret$ = TextFieldText(GI_Txt)
If Allow
	For Local ak=1 To Len(Ret)
		If Allow.find(Mid(Ret,ak,1))=-1 Then ret = Replace(ret,Mid(ret,ak,1),"")
		Next
	SetGadgetText GI_Txt,Ret	
	EndIf
If Ret EnableGadget GI_Okb Else DisableGadget GI_OkB	
Select EventID()
	Case Event_GadgetAction
		Select EventSource()
			Case GI_OkB
				MaxGUI_InputAccepted = True
				HideGadget GI_Win
				Return ret
			Case GI_Cnc
				MaxGUI_InputAccepted = False
				HideGadget GI_Win
				Return
			End Select
	End Select			
Forever
End Function

Public

Rem
bbdoc:Puts up a quick diaglog box and returns a string of what the user wanted
about:Most parameters are self-explaining. The 'AllowedChars' one will only allow those characters in the text you have chosen. When you leave it empty all characters the user can enter are allowed.
End Rem
Function MaxGUI_Input$(Caption$="Please enter a character string:",DefaultText$="",AllowCancel=True,AllowedChars$="")
Return TrueInput(Caption,DefaultText,"CUSTOM",AllowCancel,AllowedChars)
End Function

Rem
bbdoc:Quick Diaglog returning an integer
End Rem
Function MaxGUI_Input_Int(Caption$="Please enter a number:",DefaultInput$="",AllowCancel=True)
Return TrueInput(Caption,DefaultInput,"INT",AllowCancel).ToInt()
End Function

Rem
bbdoc:Quick Diaglog returning a long
End Rem
Function MaxGUI_Input_Long(Caption$="Please enter a number:",DefaultInput$="",AllowCancel=True)
Return TrueInput(Caption,DefaultInput,"INT",AllowCancel).ToLong()
End Function

Rem
bbdoc:Quick Diaglog returning a double
End Rem
Function MaxGUI_Input_Double:Double(Caption$="Please enter a number:",DefaultInput$="",AllowCancel=True)
Return TrueInput(Caption,DefaultInput,"DOUBLE",AllowCancel).ToDouble()
End Function

