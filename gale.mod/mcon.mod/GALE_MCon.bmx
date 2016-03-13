'Import GALE.MaxLua4Gale
Import Gale.Main

Type GALEtxtMainCon Extends GALE_DebugConsole 'GALE_DebugConsole
	Method GaleConsoleWrite(Txt$,R=255,G=255,B=255)
	Print txt
	End Method

	Method GaleConsoleShow()
	'ConsoleShow
	End Method

	Method GaleConsoleDoublePrint2(Txt1$,Txt2$,T,R1=255,G1=255,B1=255,R2=255,G2=255,B2=255)
	'ConsoleDoublePrint2 txt1,txt2,t,r1,g1,b1,r2,g2,b2
	Local p=Len(txt1)
	If t=0 t=40
	WriteStdout txt1
	If p>=t
		Print 
		p=0
		EndIf
	While p<t p:+1 WriteStdout " " Wend
	Print txt2		
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
	Input "Hit ENTER to continue: "
	End 
	End Method
	
	Method DoFlip(A=-1)
	'Flip
	End Method

	Method DoCls()
	'Cls
	?Not Win32
	system_ "clear"
	?win32
	system_ "cls"
	?
	End Method
	
	Method Rewindow()
	'Local GW = GraphicsWidth()
	'Local GH = GraphicsHeight()
	'EndGraphics
	'Graphics GW,GH
	End Method	
	
	Method StopGraphics()
	'EndGraphics
	End Method
	
	Method RequestAppTerminate()
	'Return AppTerminate()
	End Method
	
	Method FullView()
	'SetViewport 0,0,GraphicsWidth(),GraphicsHeight()
	'SetOrigin 0,0
	End Method
	
	End Type

Public
GaleCon = New GALEtxtMainCon
Private




Type LConsole ' BLD: Object StdOut\nAllows a lua script to write something to StdOut

	
	Method Write(Txt$,R=255,G=255,B=255) ' BLD: Writes something onto the console in the desired color
	'ConsoleWrite Txt,R,G,B
	BRL.StandardIO.Print txt
	End Method

	Method Print(Txt$,R=255,G=255,B=255) ' BLD: Alias for Console.Write
	'ConsoleWrite Txt,R,G,B
	write txt
	End Method
	
	Method SL_Write(txt$) ' BLD: Writes to STD_Out, but will not go to the next line
	WriteStdout txt
	End Method
	
	Method Input$(question$) ' BLD: Takes user input from the command console
	Return BRL.StandardIO.Input(Question)	
	End Type
	
G_LuaRegisterObject New LConsole,"Console"
G_LuaRegisterObject New LConsole,"StdOut"

