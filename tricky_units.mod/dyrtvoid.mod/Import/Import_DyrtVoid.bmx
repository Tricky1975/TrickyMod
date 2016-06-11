Rem
  DyrtVoid.bmx
  
  version: 16.06.11
  Copyright (C) 2015, 2016 Jeroen P. Broks
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
' 14.00.00 - Initial
' 15.06.11 - Adepted to BlitzMax NG
Strict

Import tricky_units.MKL_Version
Import brl.linkedlist
Import brl.max2d

Private
MKL_Version "Tricky's Units - DyrtVoid.bmx","16.06.11"
MKL_Lic     "Tricky's Units - DyrtVoid.bmx","ZLib License"


Type DVTile
	Field X:Double,Y:Double
	Field SX:Double,SY:Double
	Field Tile
	Field Rad:Double,Spd:Double,Deg
	Field Scale#=1
	Field Col:Double=255
	Field MX:Double,MY:Double
	
	Method GetS()
	Local MX = GraphicsWidth()/2
	Local MY = GraphicsHeight()/2
	Self.SX = MX + (Sin(Self.Deg)*Self.Rad)
	Self.SY = MY + (Cos(Self.Deg)*Self.Rad)
	End Method
	
	End Type



Public
Rem
bbdoc: Creates a simple effect in which the current contents of the screen are 'sucked' into a blackhole. This function was originally created only for the 'Void' spell for Eric in "The Secrets of Dyrt". I decided to put it into a separate module for your use so you can use it all the way without having to use the LAURA engine.
End Rem
Function DyrtVoid(W=32,H=32)
Local TW = Floor(GraphicsWidth()/W)
Local TH = Floor(GraphicsHeight()/H)
Local numtiles = TW*TH
Local Tiles:TList = New TList
Local Tile:DVTile
Local P:TPixmap = GrabPixmap(0,0,GraphicsWidth(),GraphicsHeight())
Local I:TImage = LoadAnimImage(P,W,H,0,NumTiles)
Local PX=0,PY=0
Local TimeOut=0
If Not I 
	Print "VOID: WARNING! Could not convert the picture correctly into tiles!"
	Return
	EndIf
'DebugLog "Number of tiles: "+NumTiles	
' Get current tiles		
For PY=0 To TH-1
	For px=0 To TW-1
		Tile = New DVTile
		Tile.X = PX*W
		Tile.Y = PY*H
		Tile.Tile = (PY*TW)+(PX)
		Tile.Rad = Rand(10,GraphicsWidth())
		Tile.Deg = Rand(1,360)
		Tile.Spd = Tile.Rad		
		Tile.GetS()
		Tile.MX = (Tile.SX - Tile.X)/40
		Tile.MY = (Tile.SY - Tile.Y)/40
		'DebugLog "("+Tile.X+","+Tile.Y+")  ==> ("+Tile.SX+","+Tile.SY+")   MV("+Tile.MX+","+Tile.MY+")"
		If Not Tile.MX Tile.MX=1
		If Not Tile.MY Tile.MY=1
		'DebugLog "Added tile: #"+Tile.Tile+"    ("+PX+","+PY+") / ("+TW+","+TH+")"
		ListAddLast Tiles,Tile
		Next
	Next
' Move tiles to their radius postions
Local OK
Repeat
Ok=True
Cls
For Tile = EachIn Tiles
    'If Tile.X<Tile.SX Tile.X:+2 ElseIf Tile.X>Tile.SX Tile.X:-4
    'If Tile.Y<Tile.SY Tile.Y:+2 ElseIf Tile.Y>Tile.SY Tile.Y:-4
    Tile.X:+Tile.MX
    Tile.Y:+Tile.MY
    If Abs(Tile.X-Tile.SX)<5 Tile.X = Tile.SX
    If Abs(Tile.Y-Tile.SY)<5 Tile.Y = Tile.SY
    Ok = Ok And Tile.X=Tile.SX And Tile.Y=Tile.SY
    DrawImage I,Float(Tile.X),Float(Tile.Y),Tile.Tile
    Next
Flip
TimeOut:+1
Until OK Or  TimeOut>100 
' And now, let's all suck them up!
Repeat
Ok=True
Cls
For tile = EachIn tiles
    Tile.Deg = tile.Deg + tile.Spd
    Tile.Rad = Tile.Rad - (tile.spd/360)
    Tile.Col = Tile.Col - .5
    If Tile.Rad<1 Tile.Rad=0
    If Tile.Col<1 Tile.Col=0
    Tile.Scale:-.001
    If Tile.Scale<0 Tile.Scale=0
    If Tile.Rad<1 And Tile.Col<1 
	ListRemove Tiles,Tile
	Else
	Ok=False
	Tile.GetS()
	SetColor Tile.Col,Tile.Col,Tile.Col
	SetScale Tile.Scale,Tile.Scale
	DrawImage I,Tile.SX,Tile.SY,Tile.Tile
	EndIf
    Next
Flip
Until OK
SetColor $ff,$ff,$ff
SetScale $1,$1
End Function
