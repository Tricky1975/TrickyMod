Rem
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is (c) Jeroen P. Broks.
 *
 * The Initial Developer of the Original Code is
 * Jeroen P. Broks.
 * Portions created by the Initial Developer are Copyright (C) 2013
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 14.03.17

End Rem
' 13.xx.xx - Initial version
' 15.02.03 - Converted into the JCR6 version
Strict

Import brl.Map
Import brl.max2d
Import Brl.pngloader
Import brl.jpgloader
'Import Tricky.JCR5
Import tricky_teddybear.teddycore
Rem
?win32
Import tricky.Teddybear_CoreOnly
?Not WIn32
Import "TeddyBear_Core.bmx"
?
End Rem
' This is dev measure.... will be different in release

't2d-remove
'Import "TeddyBear_Core.bmx"
't2d-end-remove
't2d-add: Import Tricky.Teddybear_CoreOnly


Rem
bbdoc: This function loads all textures into the level.
about: For doing this this function will assume all texture files live inside a JCR5 file that has been called by JCR_Dir. If you don't want to use textures from a JCR5 file you can still use JCR5_ReadDir to fetch the directory to work from.
about: The 'prefix' parameter will result into prefixing all texture files as stored inside the JCR file. Specifically meant for when your textures live inside a certain directory inside the JCR5 file. It's up to how you setup Teddybear if you actually 'need' this.<p>Note: If you use the prefix for pathnames you MUST end it with a "/" or the textures will NOT be found.
End Rem
Function TeddyLoadAllTextures(Level:TeddyBear, JCRMap:TJCRDir, Prefix$="")
Local ak
Print "Checking "+Level.Texture.Length+" slots for textures"
For ak=0 To Level.Texture.Length-1
	'Print AK+" >> "+Level.Texture[Ak]
	If Level.Texture[Ak]
		?Debug
		WriteStdout Right("  "+AK,3)+"> Loading Texture: "+Prefix+Level.Texture[Ak]+" ... "
		?
		level.TextureImg[ak] = LoadImage(JCR_B(JCRMap,Prefix+level.Texture[Ak]))
		?Debug
		If level.TextureImg[ak] Print "Success" Else Print "Failed"
		Else
		'Print Right("  "+Ak,2)+"> No texture define here"
		?
		EndIf
	Next
End Function



Rem
bbdoc: Draws a level layer.
about: Returns true if succusful and false when fails. (Mostly fails only when you send in a NULL object for a level). It does not animate anything. If you need animation you'll have to come up with an alternate routine.
end rem
Function TeddyDrawLayer(Level:TeddyBear, Layer:String,ScreenX=0,ScreenY=0)
Local X,Y
Local L:TeddyLayer = Level.Layer(Layer)
Local I:TImage
Local HX,HY
If Not Level.Layer(Layer) Return
For Y=0 To L.H
		For X=0 To L.W
			If L.F[X,Y]
				I = Level.TextureImg[L.F[X,Y]]
				Select L.Hot
					Case "TC"
						HX = ImageWidth(I)/2
						HY = 0
					Case "TR"
						HX = ImageWidth(I)
						HY = 0
					Rem I must sort the proper Y coordinate first here
					Case "ML"
						HX = 0
						HY = ImageHeight(I)/2
					Case "MC"
						HX = ImageWidth(I)/2
						HY = ImageHeight(I)/2
					Case "MR"
						HX = ImageWidth(I)
						HY = ImageHeight(I)/2
					End Rem	
					Case "BL"
						HX = 0
						HY = ImageHeight(I)-Level.GridX
					Case "BC"
						HX = (ImageWidth(I)/2)-(Level.GridX/2)
						HY = ImageHeight(I)-Level.GridX
					Case "BR"
						HX = ImageWidth(I)-Level.GridX
						HY = ImageHeight(I)-Level.GridX
					Default
						HX = 0
						HY = 0
					End Select	
				If Not I
					SetImageFont Null
					DrawText "?"+Hex(L.F[X,Y]),(X*Level.GridX)-ScreenX,(Y*Level.GridY)-ScreenY
					Else
					If level.TexResize
						Local SX:Double = Double(Level.GridX) / Double(ImageWidth(I))
						Local SY:Double = Double(Level.GridY) / Double(ImageHeight(I))
						SetScale SX,SY
						EndIf
					DrawImage I,((X*Level.GridX)-ScreenX)-HX,((Y*Level.GridY)-ScreenY)-HY
					EndIf
				EndIf 
			Next
		Next
If level.TexResize SetScale 1,1
Return 1
End Function



Rem
bbdoc: Draws all level layers.
about: Important to note is that it will always draw all layers in alphabetic order of the layer names. If that's not the order you want, you'll have to draw them all manually in your own order.
End Rem
Function TeddyDrawAllLayers(Level:TeddyBear,ScreenX=0,ScreenY=0)
For Local L$ = EachIn MapKeys(level.Layers)
		TeddyDrawLayer Level,L,ScreenX,ScreenY
		Next
End Function


