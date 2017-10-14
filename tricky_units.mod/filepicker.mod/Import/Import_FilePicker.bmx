Rem
  FilePicker.bmx
  
  version: 17.10.14
  Copyright (C) 2012, 2015, 2016, 2017 Jeroen P. Broks
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

' 12.10.02 - Turned this file into a module
' 12.11.06 - Enabled double clicking for selection
' 15.03.02 - Compiliation dependencies restructured :P
' 16.06.11 - Removed dupe license blocks
'          - Adapted to BlitzMax NG
Strict

Import maxgui.drivers
Import brl.retro
Import brl.eventqueue

Import Tricky_Units.MaxGUI_Input
Import Tricky_units.Tree
Import Tricky_Units.MKL_Version

MKL_Version "Tricky's Units - FilePicker.bmx","17.10.14"
MKL_Lic     "Tricky's Units - FilePicker.bmx","ZLib License"

Private
Global FPWin:TGadget = CreateWindow("???",0,0,400,600,Null,Window_TitleBar|Window_Center|Window_Hidden)
Global FPLst:TGadget = CreateListBox(0,0,ClientWidth(FPWin),ClientHeight(FPWin)-28,FPWin)
Global FPOk:TGadget = CreateButton("Ok",0,ClientHeight(FPWin)-25,100,25,FPWin,Button_ok)
Global FPCancel:TGadget = CreateButton("Cancel",110,ClientHeight(FPWin)-25,100,25,FPWin)
Global FPNew:TGadget = CreateButton("New",ClientWidth(FPWin)-110,ClientHeight(FPWin)-25,100,25,FPWin)
Public

Rem
bbdoc: A quick list of files to pick, from the specified folder and only there.
end rem
Function FilePicker$(Caption$,Dir$,FType=1,AllowNew=False,extmode$="")
Local emm:StringMap = New StringMap
ClearGadgetItems FPLst
SetGadgetText FPWin,Caption
ShowGadget FPWin
Local Ret$ = ""
Local DD$ = Replace(Dir,"\","/")
?Not bmxng
Local BDFP = ReadDir(Dir) 
?bmxng
Local BDFP:Byte Ptr = ReadDir(dir)
?
Local F$
Local List:TList = CreateList()
If Not AllowNew Then HideGadget FPNew Else ShowGadget FPNew
If Not BDFP Then
	Print "FilePicker(~q"+Caption+"~q,~q"+Dir+"~q,"+FType+") - Couldn't read directory!"
	FreeGadget FPWin
	Return ""
	EndIf
If Right(DD,1)<>"/" Then DD:+"/"
Repeat
F = NextFile(BDFP)
If f="" Then Exit
If (Left(F,1)<>".") And (FileType(DD+F)=FType Or FType=3) Then 
	'AddGadgetItem FPLst,F
	'Print "FilePicker.Add("+F+")"
	If extmode And ExtractExt(f).toupper()=Upper(extmode) MapInsert StripExt(f),f f=StripExt(f)
	ListAddLast List,F
	EndIf
Forever
SortList List
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
				Case FPLst	Ret = GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								If Ret>=0 Exit
				Case FPOK		Ret = GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								Exit
				Case FPNew	Ret = MaxGUI_Input("Please enter the name for your new entry")
							If Ret<>"" Then Exit
				Case FPCancel	Exit
				End Select
	End Select
Forever
HideGadget FPWin
If extmode
	ret = emm.value(ret)
endif
Return Ret
End Function


Rem
bbdoc: A quick dialog box asking a question
about: Basically you could see this routine as the GUI variant of the Blitz command Input. The A$ variable contains the 'question', the B variable contains the default answer if applicable.<p>This routine has been deprecated as of version 14.02.25! Please use the routine in module tricky.maxgui_input in stead!
End Rem 
Function GUI_Input$(A$="Input:",B$="")
Local GIWin:TGadget = CreateWindow(A,100,100,600,60,Null,Window_ClientCoords|Window_TitleBar|Window_Menu)
Local GIInp:TGadget = CreateTextField(0,0,ClientWidth(GIWin),25,GIWin)
Local GICan:TGadget = CreateButton("Cancel",ClientWidth(GIWin)-110,ClientHeight(GIWin)-25,100,25,GIWin)
Local GIOk:TGadget = CreateButton("Ok",ClientWidth(GIWin)-210,ClientHeight(GIWin)-25,100,25,GIWin,Button_Ok)
SetGadgetText GIInp,B$
Local Ret$ = ""
Repeat
WaitEvent
Select EventID()
	Case Event_WindowClose		Exit
	Case Event_Gadgetaction
		Select EventSource()
 			Case GICan		Exit
			Case GIOk			Ret = TextFieldText(GIInp)
							Exit
			End Select
	End Select
Forever
FreeGadget GIWin
Return Ret
End Function

Rem
bbdoc: A quick input routine. I it will contain an extra browse feature so you can make the system fill in its output. You follow?
End Rem
Function GUI_Pick_Input$(A$="Input:",B$="",Dir$,Tpe=1,Tree=False)
Local GIWin:TGadget = CreateWindow(A,100,100,600,60,Null,Window_ClientCoords|Window_TitleBar)
Local GIInp:TGadget = CreateTextField(0,0,ClientWidth(GIWin),25,GIWin)
Local GICan:TGadget = CreateButton("Cancel",ClientWidth(GIWin)-110,ClientHeight(GIWin)-25,100,25,GIWin)
Local GIOk:TGadget = CreateButton("Ok",ClientWidth(GIWin)-210,ClientHeight(GIWin)-25,100,25,GIWin,Button_Ok)
Local GIPck:TGadget = CreateButton("Browse",0,ClientHeight(GIWin)-25,100,25,GIWin)
SetGadgetText GIInp,B$
Local Ret$ = ""
Local Pck$
Repeat
WaitEvent
Select EventID()
	Case Event_WindowClose		Exit
	Case Event_Gadgetaction
		Select EventSource()
 			Case GICan		Exit
			Case GIOk			Ret = TextFieldText(GIInp)
							Exit
			Case GIPck	Select Tree
							Case 0 Pck=FilePicker(A$,Dir,Tpe)
							Case 1 Pck=TreePicker(A$,Dir)
							End Select
						If Pck<>"" Then SetGadgetText GIInp,Pck		
			End Select
	End Select
Forever
FreeGadget GIWin
Return Ret
End Function


Rem
bbdoc: Same as FilePicker, however this routine will work recursively.
end rem
Function TreePicker$(Caption$,Dir$,AllowNew=False)
Rem
Local FPWin:TGadget = CreateWindow(Caption,0,0,400,600,Null,Window_TitleBar)
Local FPLst:TGadget = CreateListBox(0,0,ClientWidth(FPWin),ClientHeight(FPWin)-28,FPWin)
Local FPOk:TGadget = CreateButton("Ok",0,ClientHeight(FPWin)-25,100,25,FPWin,Button_ok)
Local FPCancel:TGadget = CreateButton("Cancel",110,ClientHeight(FPWin)-25,100,25,FPWin)
Local FPNew:TGadget = CreateButton("New",ClientWidth(FPWin)-110,ClientHeight(FPWin)-25,100,25,FPWin)
EndRem
ClearGadgetItems FPLst
SetGadgetText FPWin,Caption
ShowGadget FPWin
Local Ret$ = ""
Local F$
Local FPTree:TList
If Not AllowNew Then HideGadget FPNew
Print "TreePicker(~q"+Caption+"~q,~q"+dir+"~q,"+AllowNew+"): Analysing Tree"
FPTree = CreateTree(Dir)
SortList FPTree
For F=EachIn FPTree
	AddGadgetItem FPLst,F
	Next
DisableGadget FPOk
Repeat
WaitEvent
If SelectedGadgetItem(FPLst)>-1 Then EnableGadget FPOk
Select EventID()
	Case Event_WindowClose Exit
	Case Event_GadgetAction
			Select EventSource()
				Case FPLst	Ret = GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								If Ret>=0 Exit
				Case FPOK		Ret = GadgetItemText(FPLst,SelectedGadgetItem(FPLst))
								Exit
				Case FPNew	Ret = GUI_Input("Please enter the name for your new entry")
							If Ret<>"" Then Exit
				Case FPCancel	Exit
				End Select
	End Select
Forever
HideGadget FPWin
Return Ret
End Function

