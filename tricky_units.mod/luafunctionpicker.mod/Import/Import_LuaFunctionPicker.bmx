Rem
/* 
  Lua Function Picker

  Copyright (C) 2013, 2015 Jeroen P. Broks

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



Version: 15.02.03

End Rem
' 13.xx.xx - Original Version
' 14.03.02 - Adepted to new versions
Strict

Rem
This code is based on my 'FilePicker' routine, but with a slight different twist.
It scans a Lua file for functions and will list all functions in order to pick one.
This code has primarily been set up for the TeddyBear map editor in order to easily 
pick the function to run in order to start scripted events in the "Realms of Ryromia" 
game where the editor was initially created for. But this picker can be of help in any
project.

All you need to compile are the BRL modules and MaxGUI
end Rem

Import brl.linkedlist
Import maxgui.drivers
Import brl.stream
Import brl.bank
Import brl.bankstream
Import brl.eventqueue
Import brl.retro
Import tricky_units.MKL_Version

MKL_Version "Units - LuaFunctionPicker/LuaFunctionPicker.bmx","15.02.03"
MKL_Lic     "Units - LuaFunctionPicker/LuaFunctionPicker.bmx","zLIB License"

Private
Global Fn$ = "function "
Global FnL = Len(Fn)
Global Functions:TList

Function AddFunc(Line$)
	Local C$[] = Line.Split(" ")
	Local F$[]
	If C.length<2 Return
	F = C[1].Split("(")
	If Not Functions Functions = New TList
	ListAddLast Functions,F[0]
End Function
	
' The picker itself, not to be accessed from the main code directly!!!
' In other words, only the functions inside this file should do so :)
Function Picker$(Caption$)
SortList Functions
Local FPWin:TGadget = CreateWindow(Caption,0,0,400,600,Null,Window_TitleBar)
Local FPLst:TGadget = CreateListBox(0,0,ClientWidth(FPWin),ClientHeight(FPWin)-28,FPWin)
Local FPOk:TGadget = CreateButton("Ok",0,ClientHeight(FPWin)-25,100,25,FPWin,Button_ok)
Local FPCancel:TGadget = CreateButton("Cancel",110,ClientHeight(FPWin)-25,100,25,FPWin)
'Local FPNew:TGadget = CreateButton("New",ClientWidth(FPWin)-110,ClientHeight(FPWin)-25,100,25,FPWin)
Local Ret$ = ""
'Local DD$ = Replace(Dir,"\","/")
'Local BDFP = ReadDir(Dir) 
Local F$
Local List:TList = CreateList()
'If Not AllowNew Then HideGadget FPNew
'If Not BDFP Then
'	Print "FilePicker(~q"+Caption+"~q,~q"+Dir+"~q,"+FType+") - Couldn't read directory!"
'	FreeGadget FPWin
'	Return ""
'	EndIf
'If Right(DD,1)<>"/" Then DD:+"/"
'Repeat
'F = NextFile(BDFP)
'If f="" Then Exit
'If (Left(F,1)<>".") And (FileType(DD+F)=FType Or FType=3) Then 
'	'AddGadgetItem FPLst,F
'	'Print "FilePicker.Add("+F+")"
'	ListAddLast List,F
'	EndIf
'Forever
'SortList List
' Above is old FilePicker Code... Not needed here :)
For F=EachIn(Functions)  ' Replaced 'List' with 'Functions' and voila, everything should work :)
	AddGadgetItem FPLst,F
	Next
'ClearList List
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
				'Case FPNew	Ret = GUI_Input("Please enter the name for your new entry")
				'			If Ret<>"" Then Exit
				Case FPCancel	Exit
				End Select
	End Select
Forever
FreeGadget FPWin
Return Ret
End Function


Public

Rem
bbdoc: Scans a Lua file for functions, and let's the user pick one and returns that as a string.
about: The 'Lua' variable can be either a filename or it can be a memory bank in which the code is loaded (by means of 'LoadBank' for example, but also handy to use with JCR5's JCR_B() function.<p>If you want to read the stuff directly from a string containing the script, use the FuncFromScriptPicker function in stead!
end rem
Function FuncPicker:String(Lua:Object,Caption$="Please pick a function:")
	Local BT:TStream
	Local L$
	If String(Lua) BT = ReadStream(String(Lua))
	If TBank(Lua) BT = CreateBankStream(TBank(Lua))
	If Not BT 
		Print "FuncPicker: No stream could be created from the data given in the 'lua' variable"
		Return 
		EndIf 
	Functions = New TList
	While Not(Eof(BT))
		L$ = Trim(ReadLine(BT))
		If Left(L,Fnl)=Fn AddFunc L$
		Wend
	CloseStream BT
	Return Picker(Caption)
End Function


Rem
bbdoc: Scans a string for lua functions and lists them just the same as FuncPicker
End Rem
Function FuncFromStringPicker:String(Script$,Caption$="Please pick a function")
	Local Lines$[] = Script.Split("~n")
	Local L$
	Functions = New TList
	For L = EachIn Lines
		If Left(L,Fnl)=Fn AddFunc L$
		Next
	Return Picker(Caption)
End Function


