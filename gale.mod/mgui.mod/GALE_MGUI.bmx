Rem
        GALE_MGUI.bmx
	(c) 2014, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2014, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.08.06

End Rem
Import MaxGUI.Drivers
Import brl.eventqueue
Import Gale.Main
Import tricky_units.MKL_Version

MKL_Version "GALE - GALE_MGUI.bmx","15.09.02"
MKL_Lic     "GALE - GALE_MGUI.bmx","Mozilla Public License 2.0"


Rem
bbdoc: When set to 'null' (default value) all console output requests will be ignored. When a textfield gadget is tied to this variable, a log will be stored in there for the user of your program to see (if that gadget is visible at the time that is).
End Rem
Global GALE_ConsoleGadget:TGadget


Rem
bbdoc: This variable should be set to the Window gadget your ending console is part of. Then the system will show this window when a Lua error pops up and when this window is closed the app will end. When not set nothing will be shown in case of a Lua error. (When running your BlitzMax program from the console you should see the error on the console, <i>if</i> you turned the #GALEMGUISTDOUT variable to 'true' that is.
End Rem
Global GALE_ExitGadget:TGadget


Rem
bbdoc: If set to true all console output will be displayed on the STD OUT output as well. Handy when you work from the MaxIDE or similar programs ;)
End Rem
Global GALEMGUISTDOUT = True

Rem 
bbdoc: In this variable you should add all gadgets which should be hidden in case an error pops up
End Rem
Global GALEGUI_HideOnError:TList = New TList



Private
Type GALEMainCon Extends GALE_DebugConsole
	
	'Method GALEConsoleWrite(Txt$,R=255,G=255,B=255)
	Method GaleConsoleWrite(Txt$,R=255,G=255,B=255)
	If GALEMGUISTDOUT Print Txt
	If GALE_ConsoleGadget AddTextAreaText( GALE_ConsoleGadget,Txt$+"~n" )		
	End Method

	Method GaleConsoleShow()
	' This is TOTALLY unneeded here, but the method has to exist for proper co-existence with other drivers.
	End Method

	Method GaleConsoleDoublePrint2(Txt1$,Txt2$,T,R1=255,G1=255,B1=255,R2=255,G2=255,B2=255)
	'ConsoleDoublePrint2 txt1,txt2,t,r1,g1,b1,r2,g2,b2
	GALEConsoleWrite txt1+"~t"+txt2
	End Method

	Method GaleConsoleCloseLogFile()
	'ConsoleCloseLogFile
	End Method
	
	Method GaleErrorClosureRequest()
	'GALEConsoleWrite "Hit any key to coninue",255,0,255
	'FlushKeys
	'Cls
	'ConsoleShow
	'Flip
	'WaitKey	
	If GALE_ExitGadget 
		GaleConsoleWrite "Close this window to quit!"
		For Local G:TGadget = EachIn GALEGUI_HideOnError HideGadget G Next
		ShowGadget GALE_ExitGadget
		Repeat
		WaitEvent
		Until EventID()=Event_windowclose Or EventID()=event_appterminate
		Else
		Notify "FATAL LUA ERROR!"
		EndIf
	End 
	End Method
	
	Method DoFlip(A=-1)
	End Method
	
	Method DoCls()
	End Method
	
	Method ReWindow()
	End Method
		
	Method StopGraphics()
	End Method	
	
	Method RequestAppTerminate()
	End Method
	
	Method FullView()
	End Method
	
	End Type
	
Type LConsole 

	Field G:Galemaincon = New galemaincon
	
	Method Write(Txt$,R=255,G=255,B=255) 
	GALECON.GaleConsoleWrite Txt,R,G,B
	End Method

	Method Print(Txt$,R=255,G=255,B=255) 
	Write Txt,R,G,B
	End Method
	
	Method Show() 
	G.GaleConsoleShow
	End Method
	
	Method Flip() ' Crash prevention as we don't need it at all.
	'DebugLog "Flipping in Console object"
	'brl.Graphics.Flip
	End Method
	
	End Type
	
G_LuaRegisterObject New LConsole,"Console"
	

Public
SetGaleCon New GALEMainCon
Private
