Rem
  BlopPlasma.bmx
  
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

' The original code was written by Imaginary Human, and he dedicated this work to the Public domain.
' In 2012 Jeroen Broks fixed some bugs in this routine and turned this into a module
' In 2016 he tried to make this compatible with BlitzMax NG 

Strict

Import brl.Max2d
Import brl.Random
Import tricky_units.MKL_Version
Rem

	Blop Plasma.
	Based on Blop Plasma by Imaginary Human
	Recoded by: Tricky
	
	Version 2.0
	
End Rem	

Incbin "BlopPlasma/Blop.png"

MKL_Version "Tricky's Units - BlopPlasma.bmx","16.06.11"
MKL_Lic     "Tricky's Units - BlopPlasma.bmx","ZLib License"

Global Blops=60
Global PlasmaWidth=1024,PlasmaHeight=768
Const Z=512,S=256,W=511,N#=0.2
'Graphics B,M,32'

Private
Global PicBlop:TImage
Global  C[200],D[200],E[200],F[200],K#[200],E2[200],F2[200]

Public

Rem
bbdoc: Initize the BlopPlasma. The other functions cannot work without calling this one first.
End Rem
Function InitBlopPlasma(NumberOfBlops=60,Width=1024,Height=768,BlopRadius=511)
Print "Initiating Blop Plasma"
If BlopRadius=511
	Print "Blop taken from internal picture"
	PicBlop = LoadImage("incbin::BlopPlasma/Blop.png")
	Else
	Cls
	Print "Blop will be generated realtime"
	Local A#,R#,G
	For R#=1 To BlopRadius Step N
		A#=R*R/Width
		SetColor Int(A),Int(A),Int(A)
		DrawOval R/2,R/2,Z-R,Z-R 'change to DrawRect for inverted blobs
		Next
	PicBlop=CreateImage(Z,Z)
	GrabImage(PicBlop,0,0)
	EndIf
NewBlopPlasma NumberofBlops,Width,Height
Print "Blop Plasma initiated"
End Function

Rem
bbdoc: This function should set new values to a plasma. As you cannot use InitBlopPlasma again. Please note, the radius cannot be changed after being chosen with @InitBlopPlasma
End Rem
Function NewBlopPlasma(NumberOfBlops=60,Width=1024,Height=768)
Local G
Blops=NumberOfBlops
PlasmaWidth=Width
PlasmaHeight=Height
For G=0 To Blops-1
C[G]=Rand(0,PlasmaHeight)
D[G]=Rand(0,PlasmaWidth)
E[G]=Rand(0,4)-2; E2[G]=Abs(E[G]);
F[G]=Rand(0,4)-2; F2[G]=Abs(F[G]);
K[G]=C[G]
Next
End Function

Rem
bbdoc: Draw the blopplasma
End Rem
Function DrawBlopPlasma(NumBlops=0,Chat=False)
DrawBlopPlasmaCol 1,1,1,NumBlops,Chat
End Function

Rem
bbdoc: Draw the blopplasma in a desired color, 1 is the max value and 0 the min value for colores.
End Rem
Function DrawBlopPlasmaCol(PlasR#=1,PlasG#=1,PlasB#=1,NumBlops=0,Chat=0)
Local G,CTxt$,CX,CY
Local NBlops=Blops
Local Blend=GetBlend()
If NumBlops NBlops=NumBlops
Cls
SetBlend 4
For G=0 To NBlops-1
C[G]:+E[G]
D[G]:+F[G]
If C[G]>=PlasmaWidth Then 
	E[G]=-E2[G]
	If E[G]>0 E[G]=E2[G]
	EndIf
If D[G]>=PlasmaHeight Then 
	F[G]=-F2[G]
	If F[G]>0 F[G]=F2[0]
	EndIf 
If C[G]<=0 Then 
	E[G]=E2[G]
	If E[G]<0 E[G]=-E2[G]
	EndIf
If D[G]<=0 Then 
	F[G]=F2[G]
	If F[G]<0 E[G]=-F2[G]
	EndIf	
K[G]:+N
If K[G]>360 K[G]:-360
'SetColor (PlasmaWidth-K[G])*PlasR,(Z-C[G])*PlasG,(Z-D[G])*PlasB
SetColor Int((Z-K[G])*PlasR),Int((Z-C[G])*PlasG),Int((Z-D[G])*PlasB)
SetRotation K[G]
DrawImage PicBlop,C[G],D[G]
If Chat Then
	SetBlend maskblend
	SetRotation 0
	CTxt = "Object: "+G+" ("+C[G]+","+D[G]+") M("+E[G]+","+F[G]+")"
	CX=0
	CY=G*15
	While CY>PlasmaHeight-15 
		CY:-(PlasmaHeight-15);
		CX:+300;
		Wend
	SetColor 0,0,0
	DrawText CTXT,CX+2,CY+2
	SetColor 255,255,255
	DrawText CTXT,CX,CY
	SetBlend 4
	EndIf
Next	
SetRotation 0
SetColor 255,255,255
SetBlend Blend
End Function
