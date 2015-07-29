Rem
/* 
  Black Hole

  Copyright (C) 2013, 2015 Jeroen Petrus Broks

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



Version: 15.01.22

End Rem

' 14.02.25 - Initial version
' 15.01.22 - Adepted to use with JCR6 in stead of JCR5

Strict 
Import jcr6.jcr6main
Import brl.max2d
Import brl.linkedlist
Import brl.map
Import brl.random

Global bh_dbg_chat = False

Type TBHObj
	Field Radius:Double
	Field Speed = Rand(20,500)
	Field Img:TImage
	Field Pos:Double = Rand(0,360)
	
	?Debug
	Field I
	Method New()
	I = MilliSecs()
	If bh_dbg_chat Print "New Object created:   #"+I
	End Method
	
	Method Delete()
	If bh_dbg_chat	Print "Old object destroyed: #"+I
	End Method
	?
	

	End Type

Rem
bbdoc: Contains all data about a blackhole. Create it with the InitBlackHole function only!
about: If you want different settings on your blackhole you can directly assign different values to the next field variables:
End Rem
Type TBlackHole
	Field BH_Img:TImage[]
	Field Objects:TList = New TList
	
	Rem
	bbdoc: Sets up the radius to start. 
	End Rem
	Field StartRadius:Double = 640
	
	Rem
	bbdoc: Sets the chance a new object appears. THe lower this number the more objects appear. (Min value = 1)
	End Rem
	Field StartRate = 100
	
	Rem
	bbdoc: Max amount of objects in this blackhole.
	End Rem
	Field MaxObjects = 100
	
	End Type
	


Rem
bbdoc:Initializes the Black Hole pictures
about:PictureList may either be a JCR based TJCRDir, a string containing a JCR main file or a TList containing images or pixmaps. The 'path' string is to refer the in-JCR path, and therefore it serves no function at all when you use a TList full of images.
End Rem
Function InitBlackHole:TBlackHole(PictureList:Object,Path$="")
Local Lst:TList = New TList
Local Ret:TBlackHole = New TBlackHole
If TList(PictureList)
	For Local I:TImage = EachIn TList(PictureList)
		ListAddLast Lst,I
		Next
	For Local P:TPixmap = EachIn TList(PictureList)
		ListAddLast Lst,LoadImage(P)
		Next
ElseIf String(PictureList) Or TMap(PictureList)
	Local MJ:TJCRDir = TJCRDir(PictureList)
	If String(picturelist) MJ = JCR_Dir(String(Picturelist))
	If Not MJ Print("WARNING: InitBlackHole received 'Null' for JCR data"); Return
	Local F$
	For F=EachIn MapKeys(MJ.Entries)
		If Left(F,Len(Path))=Upper(Path)
			ListAddLast Lst,LoadImage(JCR_B(MJ,F))
			EndIf
		Next
Else
	Print "WARNING: InitBlackHole got a type for a picturelist that it can't handle."
	Return
	EndIf
Ret.BH_Img = TImage[](ListToArray(Lst))
Return Ret
End Function		


Rem
bbdoc: Show the blackhole with the given center point
End Rem
Function BlackHole(BH:TBlackHole,X,Y)
Local O:tbhobj 
Local SX#,SY#; GetScale SX,SY
If BH.StartRate<1 BH.StartRate=1
If Rand(1,BH.startrate)=1 And CountList(BH.Objects)<BH.MaxObjects
	O = New TBHObj
	O.Radius = Bh.startradius
	O.img = BH.BH_Img[Rand(0,BH.BH_IMg.Length-1)]
	ListAddLast BH.Objects,O
	EndIf
For O=EachIn BH.Objects
	If Not O Print "WARNING! Null found in blackhole object list"
	Local Col:Double = (O.Radius/BH.StartRadius)*255
	Local SC:Double = (O.Radius/BH.StartRadius)
	SetColor Col,Col,Col
	SetScale SC,SC
	O.Pos    :+ Double(O.Speed)*.02
	O.Radius :- Double(O.Speed)*.01
	DrawImage O.Img,X+Sin(O.Pos)*O.Radius,Y+Cos(O.Pos)*O.Radius
	If O.Radius<=0 ListRemove BH.Objects,O
	Next
SetScale SX,SY	
End Function



Rem
bbdoc: SHow the blackhole and use the center of the screen for this 
about: (this will most likely only work in a real max2d screen and not a MaxGUI canvas, though I never tried it)
End Rem 
Function BlackHoleCenter(BH:TBlackHole)
BlackHole BH,GraphicsWidth()/2,GraphicsHeight()/2
End Function
