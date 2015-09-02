Rem
  jcr_filepicker.bmx
  
  version: 15.09.02
  Copyright (C) 2015 7
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
  jcr_filepicker.bmx
  
  version: 15.09.02
  Copyright (C) 2015 Jeroen P. Broks
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
  JCR FilePicker

  Copyright (C) 2012, 2015 Jeroen P. Broks

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



Version: 15.02.14

End Rem
Strict

Rem
- bbdoc: Tricky.JCR5FilePicker
- about: A quick MaxGui File Picker for JCR5 patch lists
End Rem

Rem
Module Tricky.JCR5FilePicker

ModuleInfo "Version:14.03"
ModuleInfo "Author: Jeroen ~qTricky~q Broks"
ModuleInfo "License: Mozilla Public License 2.0"
ModuleInfo "Requirements: JCR5, MaxGui"
ModuleInfo "Update:14.03.17 - Fixed the filter"
ModuleInfo "Update:14.06.03 - Fixed the not emptying of filebox every new use!"
ModuleInfo "Quote:She NEEDS to sort out her priorities"
End Rem

Import jcr6.jcr6main
Import MaxGui.Drivers
Import brl.Map
Import brl.eventqueue

Private
Global FPWin:TGadget = CreateWindow("-",0,0,400,600,Null,Window_TitleBar|WIndow_Hidden)
Global FPLst:TGadget = CreateListBox(0,0,ClientWidth(FPWin),ClientHeight(FPWin)-28,FPWin)
Global FPOk:TGadget = CreateButton("Ok",0,ClientHeight(FPWin)-25,100,25,FPWin,Button_ok)
Global FPCancel:TGadget = CreateButton("Cancel",110,ClientHeight(FPWin)-25,100,25,FPWin)
Public

Rem
bbdoc: Allows you to pick a file from a JCR dir TMap
End Rem
Function JCR_FilePicker$(Caption$,PJCR:TJCRDir,Dir$="",Recursive=False,filterext$="")
'Local FPWin:TGadget = CreateWindow(Caption,0,0,400,600,Null,Window_TitleBar)
'Local FPLst:TGadget = CreateListBox(0,0,ClientWidth(FPWin),ClientHeight(FPWin)-28,FPWin)
'Local FPOk:TGadget = CreateButton("Ok",0,ClientHeight(FPWin)-25,100,25,FPWin,Button_ok)
'Local FPCancel:TGadget = CreateButton("Cancel",110,ClientHeight(FPWin)-25,100,25,FPWin)
'Local FPNew:TGadget = CreateButton("New",ClientWidth(FPWin)-110,ClientHeight(FPWin)-25,100,25,FPWin)
Local JCR:TMap = PJCR.entries
SetGadgetText FPWin,Caption
ShowGadget FPWin
Local Ret$ = ""
Local DD$ = Replace(Dir,"\","/")
Local E:TJCREntry
'Local BDFP = ReadDir(Dir) 
Local F$
Local List:TList = CreateList(); ClearGadgetItems FPLst
Local tex$[]
If filterext tex = filterext.split(";")
'If Not AllowNew Then HideGadget FPNew
If Not JCR Then
	Print "JCR_FilePicker(~q"+Caption+"~q,Null,~q"+Dir+"~q,) - JCR Map appears To be Null!"
	HideGadget FPWin 'FreeGadget FPWin
	Return ""
	EndIf
If Right(DD,1)<>"/" Then DD:+"/"
If DD="/" DD=""
Local DDNS$ = Left(DD,Len(DD)-1).toUpper()
For E=EachIn MapValues(JCR)
    Local F=Not Tex
    If tex 
		For Local Ex$=EachIn Tex
			DebugLog "File: "+E.FIleName+" leads to: "+Upper(ExtractExt(E.FileName))+"; requested: "+Upper(Ex)+";   F="+F
		    F = f Or Upper(Ex)=Upper(ExtractExt(E.FileName))
		    Next
		EndIf
	If F	
	    Select Recursive
			Case False 
				If Upper(ExtractDir(E.FileName))=DDNS ListAddLast List,Right(E.FileName,Len(E.FileName)-Len(DD))
			Default
				If Left(E.FileName,Len(DD)).ToUpper() = DD.ToUpper() Or Dir$="" ListAddLast List,Right(E.FileName,Len(E.FileName)-Len(DD))
			End Select
		EndIf
    Next
For F=EachIn(List)
	AddGadgetItem FPLst,F
	Next
ClearList List
DisableGadget FPOk
Repeat
WaitEvent
If SelectedGadgetItem(FPLst)>-1 Then EnableGadget FPOk
Select EventID()
	Case Event_WindowClose Exit
	Case Event_GadgetAction
			Select EventSource()
				Case FPLst	Ret = DD+GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								If Ret>=0 Exit
				Case FPOK		Ret = DD+GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								Exit
				'Case FPNew	Ret = GUI_Input("Please enter the name for your new entry")
				'			If Ret<>"" Then Exit
				Case FPCancel	Exit
				End Select
	End Select
Forever
HideGadget FPWin
'FreeGadget FPWin
Return Ret
End Function

