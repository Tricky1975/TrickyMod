Rem
  Console.bmx
  
  version: 16.06.11
  Copyright (C) 2012, 2015, 2016 Jeroen P. Broks
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

'Updates
' 12.04.01 - Fixed a bug in ConsoleShow()
' 12.09.26 - Turned into a module
' 16.06.11 - Removed dupe license text (long live bugged auto license tools)
'          - Investigating NG compatibility.



Strict

Import brl.max2d
Import brl.retro
Import brl.stream
Import tricky_units.MKL_Version

Import "Console/font.bmx"

MKL_Version "Tricky's Units - Console.bmx","16.06.11"
MKL_Lic     "Tricky's Units - Console.bmx","ZLib License"

Private

Type ConsoleLine
	Field Y
	Field Txt$
	Field R,G,B
	Field X=0
	End Type

Global ConsoleLines:TList = New TList

Global ConsoleCom$ = ""

Global ConsoleWidth,ConsoleHeight

Global ConsoleLogBT:TStream

Function HTMCol$(R,G,B)
 Return "#"+Right(Hex(R),2)+Right(Hex(G),2)+Right(Hex(B),2)
End Function

Function HTMTxt$(T$)
Local Ret$ = T
ret = Replace(ret,"&","&amp;")
ret = Replace(ret,"<","&lt;")
ret = Replace(ret," ","&nbsp;")
ret = Replace(ret,"~n","<br>")
Return Ret
End Function
Public

Rem
bbdoc: Contains the image used for the background of the console.
about: Just assign and image to it and the console will tile it onto the background. Animation not yet supported, maybe in future versions!
endrem
Global ConsoleBackGroundPicture:TImage
Global ConsoleResultLine$

Rem
bbdoc: When the user types a command into the console, the result will be stored into this variable
end rem
Global ConsoleCommand$=""

Rem
bbdoc: Will start a log file that logs all stuff that is put onto the console. The output is in HTML code. 
about: Though the result of this file should be readable by any browser I only tested this out in Firefox and Apple Safari. If there are issues with Opera and Chrome I'm willing to look into that but I will under NO CONDITION work this out in IE (because a. that browser was screwed from it's very first release, and b. since my main system is not Windows, it's too much trouble to test this properly).
End Rem
Function ConsoleWriteLogFile(LogFile$,BGCOLOR$="#000000")
ConsoleLogBT = WriteFile(LogFile$)
WriteLine ConsoleLogBT,"<?xml version=~q1.0~q encoding=~qUTF-8~q?>"
WriteLine COnsoleLogBT,"<!DOCTYPE HTML PUBLIC ~q-//W3C//DTD HTML 4.01 Transitional//EN~q  ~qhttp://www.w3.org/TR/html4/loose.dtd~q><html Lang=~qEnglish~q dir=~qltr~q>"
WriteLine ConsoleLogBT,"<head><title>Log from "+AppTitle+" ("+AppFile+")</title></head><body>"
WriteLine COnsoleLogBT,"<center><table width='95%'>"
WriteLine ConsoleLogBT,"<tr valign=top><td align=right>Log from:</td><td>"+AppTitle+"</td></tr>"
WriteLine ConsoleLogBT,"<tr valign=top><td align=Right>Application File:</td><td>"+AppFile+"</td></tr>"
WriteLine ConsoleLogBT,"<tr valign=top><td align=right>Log Started:</td><td>"+CurrentDate()+"; "+CurrentTime()+"</td></tr>";
WriteLine ConsoleLogBT,"</table><p>";
WriteLine ConsoleLogBT,"<table style='font-family: Courier; Background-Color:"+BGCOLOR+"' width='95%'>"
End Function

Rem
bbdoc: Will close the Console Log file.
about: For proper usage it's always advisable to do this before ending your program
End Rem
Function ConsoleCloseLogFile()
If ConsoleLogBT
 WriteLine consolelogbt,"</table></center>"
 WriteLine consolelogbt,"<p><a href=~qhttp://validator.w3.org/check?uri=referer~q><img src=~qhttp://www.w3.org/Icons/valid-html401~q alt=~qValid HTML 4.01 Transitional~q height=~q31~q width=~q88~q></a></p><p>(As this document was automatically generated validation errors may exist, though I deem it unlikely)</p>"
 WriteLine consolelogbt,"</body></html>"
 CloseFile consolelogbt
 ConsoleLogBT = Null
 EndIf
End Function


Rem
bbdoc: Show the contents of the console onto the screen.
about: Of course you need to use the Flip command before you can actually see it ;)
End Rem
Function ConsoleShow()
Local CL:ConsoleLine
SetImageFont ConsoleFont() 'null
ConsoleWidth=GraphicsWidth()
ConsoleHeight=GraphicsHeight()
Cls
SetColor 255,255,255
SetScale 1,1
SetImageFont ConsoleFont() 'Null
If ConsoleBackGroundPicture TileImage ConsoleBackGroundPicture,0,0
For CL=EachIn ConsoleLines
	SetColor 0,0,0
	DrawText Cl.Txt,CL.X+2,CL.y+2
	SetColor CL.R,CL.G,CL.B
	DrawText CL.Txt,CL.X,Cl.Y
	Next
SetColor 255,255,255
DrawText ">"+ConsoleCommand+"_",0,GraphicsHeight()-15
End Function

Rem 
bbdoc: Puts text into a new console line.
About: Txt$ is the text and R,G,B are the colors in which to put the text<P>The return is something you'll hardly need but that's just the data about the line you just added
end rem
Function ConsolePrint:ConsoleLine(Txt$,R=255,G=255,B=255)
Local CL:ConsoleLine = New ConsoleLine
Local CL2:ConsoleLine
Local MaxY=0
'Enter the text
Print "Console: "+Txt
Cl.Txt = Txt
Cl.R=R
Cl.G=G
Cl.B=B
'Find the right screen position
For Cl2=EachIn ConsoleLines
	If CL2.Y>MaxY MaxY=CL2.Y
	Next
MaxY:+15
CL.Y=MaxY
'Add this text to the screen
ListAddLast ConsoleLines,CL
'Move text up when as long is there's text below the bottom of the screen
While MaxY>GraphicsHeight()-30
	For CL2=EachIn ConsoleLines
		CL2.Y:-15
		MaxY=CL2.Y
		Next
	Wend
'Remove all text that has gone past the top of the screen
For CL2=EachIn Consolelines
	If CL2.Y<0 ListRemove ConsoleLines,CL2
	Next
If ConsoleLogBT
	WriteLine ConsoleLogBT,"<tr valign=top><td colspan=2 style='font-family: Courier; color:"+HTMCol(R,G,B)+"'>"+HTMTxt(Txt)+"</td></tr>"
	EndIf
Return CL
End Function

Rem
bbdoc: Puts first text at the start and the second text halfaway the screen. Handy for some upsummings
end rem
Function ConsoleDoublePrint(T1$,T2$,R1=255,G1=255,B1=255,R2=255,G2=255,B2=255)
Local CL:ConsoleLine = New ConsoleLine
Local CL2:ConsoleLine
Local ClA:Consoleline = New ConsoleLine
Local MaxY=0
Local f:Timagefont = GetImageFont()
SetImageFont ConsoleFont()
'Enter the text 1
Cl.Txt = T1
Cl.R=R1
Cl.G=G1
Cl.B=B1
'Find the right screen position
For Cl2=EachIn ConsoleLines
	If CL2.Y>MaxY MaxY=CL2.Y
	Next
MaxY:+15
CL.Y=MaxY
'Add this text to the screen
ListAddLast ConsoleLines,CL
'Now let's put in the second part of all this
CLA.Txt = T2
ClA.R = R2
CLA.G = G2
CLA.B = B2
CLA.X = GraphicsWidth()/2
CLA.Y = CL.Y
If TextWidth(CL.Txt)>GraphicsWidth()/2 CLA.Y:+15
'Add second part to the screen
ListAddLast ConsoleLines,CLA
'Move text up when as long is there's text below the bottom of the screen
While MaxY>GraphicsHeight()-30
	For CL=EachIn ConsoleLines
		CL.Y:-15
		MaxY=CL.Y
		Next
	Wend
'Remove all text that has gone past the top of the screen
For CL=EachIn Consolelines
	If CL.Y<0 ListRemove ConsoleLines,CL
	Next
Print "DOUBLECONSOLE>>> 1>"+T1+";  2>"+T2
If ConsoleLogBT
	WriteLine ConsoleLogBT,"<tr valign=top><td col style='font-family: Courier; color:"+HTMCol(R1,G1,B1)+"'>"+HTMTxt(T1)+"</td><td col style='font-family: Courier; color:"+HTMCol(R2,G2,B2)+"'>"+HTMTxt(T2)+"</td></tr>"
	EndIf
SetImageFont f	
End Function

Rem
bbdoc: Same as #ConsoleDoublePrint but the offset allows you the define X coordinate on where to start the second collumn
end rem
Function ConsoleDoublePrint2(T1$,T2$,Offset,R1=255,G1=255,B1=255,R2=255,G2=255,B2=255)
Local CL:ConsoleLine = New ConsoleLine
Local CL2:ConsoleLine
Local ClA:Consoleline = New ConsoleLine
Local MaxY=0
Local f:Timagefont = GetImageFont()
SetImageFont ConsoleFont()
'Enter the text 1
Cl.Txt = T1
Cl.R=R1
Cl.G=G1
Cl.B=B1
'Find the right screen position
For Cl2=EachIn ConsoleLines
	If CL2.Y>MaxY MaxY=CL2.Y
	Next
MaxY:+15
CL.Y=MaxY
'Add this text to the screen
ListAddLast ConsoleLines,CL
'Now let's put in the second part of all this
CLA.Txt = T2
ClA.R = R2
CLA.G = G2
CLA.B = B2
CLA.X = Offset 'GraphicsWidth()/2
CLA.Y = CL.Y
If TextWidth(CL.Txt)>Offset CLA.Y:+15
'Add second part to the screen
ListAddLast ConsoleLines,CLA
'Move text up when as long is there's text below the bottom of the screen
While MaxY>GraphicsHeight()-30
	For CL=EachIn ConsoleLines
		CL.Y:-15
		MaxY=CL.Y
		Next
	Wend
'Remove all text that has gone past the top of the screen
For CL=EachIn Consolelines
	If CL.Y<0 ListRemove ConsoleLines,CL
	Next
Print "DOUBLECONSOLE2>> 1>"+T1+";  2>"+T2
If ConsoleLogBT
	WriteLine ConsoleLogBT,"<tr valign=top><td col style='font-family: Courier; color:"+HTMCol(R1,G1,B1)+"'>"+HTMTxt(T1)+"</td><td col style='font-family: Courier; color:"+HTMCol(R2,G2,B2)+"'>"+HTMTxt(T2)+"</td></tr>"
	EndIf
SetImageFont f	
End Function

Rem
bbdoc: Alias for #ConsolePrint()
End Rem 
Function ConsoleWrite:ConsoleLine(Txt$,R=255,G=255,B=255)
Return ConsolePrint(Txt,R,G,B)
End Function

Rem 
bbdoc: Allows you to modify a line present on the console.
about: In order to modify you must have stored the return value of ConsolePrint into a variable. Next make sure the line you want to modify is still on the screen or else nothing will happen.<p>Another note... When you created a log file it will not be altered by this routine!
End Rem
Function ConsoleModify(AConsoleLine:Object,Txt$,R=-1,G=-1,B=-1)
Local CL:ConsoleLine=ConsoleLine(AConsoleLine)
If Not CL Return
CL.Txt = Txt
If (R>=0) CL.R=R 
If (G>=0) CL.G=G
If (B>=0) CL.B=B
End Function
