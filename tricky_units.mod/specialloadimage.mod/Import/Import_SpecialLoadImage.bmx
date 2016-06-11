Rem
  SpecialLoadImage.bmx
  Special - Load Image
  version: 16.06.12
  Copyright (C) 2013, 2015, 2016 Jeroen P. Broks
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

' 14.02.25 - initial version
' 15.01.23 - adepted to jcr6
' 16.06.12 - Removed dupe license block
'          - Adapted for Blitz NG
Strict

Import    jcr6.jcr6main
Import    tricky_units.MKL_Version
Import    tricky_units.HotSpot
Import    brl.stream
Import    brl.max2d



Const HOT_CENTER = 1
Const HOT_BOTTOMCENTER = 2



Rem
bbdoc: This will load a TImage from a JCR Map, but that is not all. If a file called "<mypicfile>.Frames" (original extention of the image removed) exists, it will automatically read this file and turn the TImage into an animation TImage according to the settings in the file. You can just set the values width, height, start and frames into this file in this order separated by either enters or commas. (only use one of these, not both). When a file called "<myimage>.HOT" exists inside the JCR it will set the 'hotspot' or 'image handle' as BMax calls it to this file. X and Y in that order and separated by commas or enters. If a .HOT file is not present you can set the hotflag to HOT_CENTER or HOT_BOTTOMCENTER for automated HotSpot settings.
End Rem
Function AdvLoadImage:TImage(JCR:TJCRDir,Imagefile$,hotflag=0)
Local HotX = 0, HotY = 0
Local P[],L$
Local HotF$ = StripExt(Upper(ImageFile$))+".HOT"
Local FrmF$ = StripExt(Upper(ImageFIle$))+".FRAMES"
Local BT:TStream
Local Ret:TImage
Local ErrHead$ = "AdvLoadImage(<Object>,~q"+Imagefile+"~q,"+HotFlag+"): "
Local RL$,RS$[]
If MapContains(JCR.entries,FrmF)
	BT = JCR_ReadFile(JCR,FrmF)
	L$ = Trim(ReadString(BT,Int(StreamSize(BT))))
	CloseFile BT
	P = SplitUp(L,4,FrmF)
	If Not P 
	   Print ErrHead+"Frame information not properly received!"
	   Return
	   EndIf
	Ret = LoadAnimImage(JCR_B(JCR,ImageFile),P[0],P[1],P[2],P[3])
	Else ' Not an animated image?
	ret = LoadImage(JCR_B(JCR,ImageFile))
	EndIf
If MapContains(JCR.entries,HotF) And Ret
	Rem old
	BT = JCR_ReadFile(JCR,HotF)
	L$ = Trim(ReadString(BT,StreamSize(BT)))
	CloseFile BT
	P = SplitUp(L,2,HotF)
	If Not P
	 Print ErrHead+"Hotspot data not properly received!"
	 Return
	 EndIf
	SetImageHandle Ret,P[0],P[1]
	End Rem
	RL = Trim(LoadString(JCR_B(JCR,hotf)))
	RL = Replace(RL,"#WC#",Int(ImageWidth(ret)/2))
	RL = Replace(RL,"#HC#",Int(ImageHeight(ret)/2))
	RL = Replace(RL,"#WE#",Int(ImageWidth(ret)))
	RL = Replace(RL,"#HE#",Int(ImageHeight(ret)))	
	If Left(RL,5)="@HOT:"
		RS=Replace(RL,"@HOT:","").Split(",")
		If Len(RS)>=2			
			HotSpot ret,RS[0].toint(),RS[1].toint()
			EndIf
	ElseIf RL="@HOTCENTER"
		HotCenter ret
	ElseIf RL="@HOTEND"
		HotEnd ret
	ElseIf Left(RL,6)="@RHOT:"
		RS=Replace(RL,"@RHOT:","").Split(",")
		If Len(RS)>=2			
			SetImageHandle ret,RS[0].toint(),RS[1].toint()
			EndIf
	Else
		RS = RL.Split(",")
		SetImageHandle Ret,RS[0].toint(),RS[1].toint()	
		EndIf			
	Else ' -- MapContains(JCR.entries,HotF) And Ret
	Select HotFlag
		Case HOT_CENTER
			MidHandleImage Ret
		Case HOT_BOTTOMCENTER
			SetImageHandle Ret,ImageWidth(Ret)/2,ImageHeight(Ret)
		End Select
	EndIf
If Not ret Print ErrHead+"Image could not be loaded!"
Return ret
End Function



Private

Function SplitUp[](S$,NeededValues,F$)
Local R$[],RL:TList,SS$,C$
Local Ret[]
If S.find("~n")=-1 And S.Find(",")>=0
	R$ = S.Split(",")
ElseIf S.find("~n")>=0 And S.Find(",")=-1
	R$ = S.SPlit("~n")
ElseIf S.find("~n")>=0 And S.Find(",")>=0
	RL = New TList
	SS = ""
	For Local p=0 Until Len s
		C$ = Chr(S[p])
		If C = "," Or C="~n" Then
			ListAddLast RL,SS
			SS = ""
		Else
			SS = SS + C
			EndIf
		Next
	If SS ListAddLast RL,SS
	R$ = String[](ListToArray(RL))
Else
	Print "WARNING! File "+F+" has an illegal format!"
	Return
	EndIf
If R.length<Neededvalues 
	Print
	Print "WARNING! File "+F+" has an incorrect number of values defined in it!"
	Return
	EndIf
Ret = New Int[R.Length]
For Local ak=0 To R.Length-1
	Ret[ak] = Trim(R[ak]).toint()
	Next
Return Ret
End Function

MKL_Lic     "Tricky's Units - SpecialLoadImage.bmx","ZLib License"
MKL_Version "Tricky's Units - SpecialLoadImage.bmx","16.06.12"
