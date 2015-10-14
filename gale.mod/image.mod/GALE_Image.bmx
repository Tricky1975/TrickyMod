Rem
        GALE_Image.bmx
	(c) 2012, 2014, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.10.14
End Rem
Rem

	(c) 2012, 2014, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.08.05

End Rem

' History
' 11.11.17 - Initial Version
' 12.03.31 - Moved to GALE
' 12.04.01 - AssignLoad was broken and has been fixed.
' 12.04.06 - Image codes now case INSENSITIVE
'          - Added Image.Exist so lua can check if an image is even loaded
' 12.11.18 - Fixed a bug concerning the case sensivity in the Image.Tile() API
'          - Added Image.ScalePC() for full compatibility in PPC (which was a serious issue)
'          - Updated the license to MPL 2.0
' 13.03.30 - Added GrabScreen
'          - Added Hot
' 13.06.12 - Worked out the fontloader a bit.
' 13.08.27 - Added support for Tricky.SpecialLoadImage in Image.Load()
' 14.03.15 - Adpeted for new GALE version with drivers. Please note this module will automatically import the M2D driver is is therefore COMPLETELY incompatible with any other drivers!!!
' 14.06.04 - Support for circle drawing
' 14.09.06 - Added: Image.Image2Anim()
' 15.01.23 - Updated the image module to JCR6
' 15.07.17 - Added HSV support

Strict

Import brl.map
Import brl.max2d
'Import Gale.MaxLua4GALE
Import BRL.FreeTypeFont
Import jcr6.jcr6main
Import tricky_units.MKL_Version
Import Tricky_units.specialloadimage
Import Tricky_units.TrickyCircle
Import tricky_units.negatief
Import tricky_units.hsvrgb
Import Gale.M2D
'Import "../../JCR/UseJCR.bmx"


MKL_Version "GALE - GALE_Image.bmx","15.10.14"
MKL_Lic     "GALE - GALE_Image.bmx","Mozilla Public License 2.0"

Rem
bbdoc: In order to work you need a JCR TMap containing your images and copy this map into this variable.
End Rem
Global JCR_Lua_Image_PatchMap:TJCRDir

Global MJBC_Lua_Image:TMap = New TMap

Global MJBC_Lua_Font:TMap = New TMap

Type TJBCFontIndex
	Field File$
	Field Size
	End Type
	
Global LI_JCRTempMap$ = AppDir	


Type TJBC_Lua_Image  ' BLD: Object Image\nIn this object you can find all sorts of stuff on the graphic front and most of all images

  Field NoFontIsConsoleFont  ' BLD: When set to any value other than 0 (which is the default value), the NoFont function will use the standard debug console function in stead of the default font. This function came to be because Windows appears to hate the original BMax fonts in some projects.
  Field DontUseSpecial = False ' BLD: When set to 1 the Special load abilities of Image.Load will be ignored. When set to 0, everything will load

	Method Load$(File$)  ' BLD: Loads an image (from the JCR file if the project uses that. And it reacts automatically on patches) and stores it into the image buffer and storage and leaves returns an ID to find it back there.<p>When you load mypic.png and mypic.png.hot is loaded the picture will automatically be hotspotted according to the settings inside the .hot file. When a mypic.png.frame file exists, it'll be automatically loaded as an animated picture with the settings inside the file. When the files don't exist they will be ignored. When you want to prevent Image.Load() to check this then set the Image.DontUseSpecial variable to 1.
	Local I:TImage
	Local B:TBank
	Local C=0
	If JCR_Lua_Image_PatchMap Then 
		B = JCR_B(JCR_Lua_Image_PatchMap,File)
		If B 
		 ' I = LoadImage(B) 'LoadImage(P_JCR_LoadBank(JCR_Lua_Image_PatchMap,File)) 
		 If DontUseSpecial 
		    I = LoadImage(B) 
		    Else 
		    I = AdvLoadImage(JCR_Lua_Image_PatchMap,File)		  
		    If Not I Then Print "Advanced load failed. Doing normal load instead"; I = LoadImage(B)
		    If Not I Then Print "Normal load failed as well!"
		    EndIf
		 EndIf
		Else 
		Print "Trying to do a load outside a JCR file!"
		I = LoadImage(File)
		EndIf
	While MapValueForKey(MJBC_Lua_Image,Hex(C)) 
		C:+1
		Wend
	If I	
		Print "LUA>Image "+File+" has been succesfully loaded and been assigned to image slot: "+Hex(C)
		MapInsert MJBC_Lua_Image,Hex(C),I 
		Else
		Print "LUA>Image "+File+" could NOT be loaded!"
		ConsoleWrite("WARNING!! Image "+file+" could NOT be loaded!",255,180,0)
		Return "ERROR"
		EndIf
	Return Hex(C)
	End Method
	
	
	Method LoadAnim$(File$,W,H,S,A) ' BLD: Loads an animated image (same way as Image.Load).\n<p>W = Image width<br>H = Image height<br>S = Start frame (leave at 0 unless you know what you are doing)<br>A = Number of animation Frames
	Local I:TImage
	Local C=0
	If JCR_Lua_Image_PatchMap Then I = LoadAnimImage(JCR_B(JCR_Lua_Image_PatchMap,File),w,h,s,a)  Else I = LoadAnimImage(File,w,h,s,a)
	While MapValueForKey(MJBC_Lua_Image,Hex(C)) 
		C:+1
		Wend
	MapInsert MJBC_Lua_Image,Hex(C) , I 
	Return Hex(C)
	End Method
	
	Method LoadNew(Tag$,File$) ' BLD: Loads an image to the specified tag, but only if the tag has not yet been assigned with another image.
	If MapContains(MJBC_Lua_Image,Upper(Tag)) Return 
	Rem
	?debug
	Print "LoadNew(~q"+Tag+"~q,~q"+File+"~q)~n~tTag: "+Tag+" resulted in "+MapContains(MJBC_Lua_Image,Tag)+" so I'm gonna load this picture!"
	?
	End Rem
	AssignLoad(Tag,File)
	End Method
	
	Method Loaded(Tag$) ' BLD: Returns 1 if there is a loaded picture found on the requested tag, and 0 if not. Please note that Lua deems both values as "true" when used in a direct boolean check!
	Return MapContains(MJBC_Lua_Image,Upper(tag))
	End Method
	
	Method Image2Anim$(Image$,W,H,S,A,Frame,KeepOriginal=0) ' BLD: Converts an image into an animated image.<p>Please note if the original is already an animation you can only pick one frame and convert it into an animation.<p>If KeepOriginal is 0 the animated image will overwrite the original. If you keep the original, this function will keep the original an return a value containing the newly created animated image in stead.
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Image2Anim("+Image+","+W+","+H+","+S+","+H+","+Frame+","+KeepOriginal+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	Local I:TImage
	Local P:TPixmap = TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))).PixMaps[Frame]
	Local C=0
	Local ret$ = Image
	I = LoadAnimImage(P,W,H,S,A)
	If KeepOriginal 
  	   While MapValueForKey(MJBC_Lua_Image,Hex(C)) 
		 C:+1
		 Wend
	   ret = Hex(C)
	   EndIf
	MapInsert MJBC_Lua_Image,ret,I  ' Any old image will now automatically be removed by the garbage collector eventually ;)
	Return ret
	End Method
	
	Rem
	Method GrabScreen$(Assign$) ' -- BLD: Captures the entire screen as an image and it to 'Assign'. If you don't set it the computer will assign it to an ID number and return that.
	Local C,Ret$=Assign
	If Not Assign
 		While MapValueForKey(MJBC_Lua_Image,Hex(C)) 
			C:+1
			Wend
		ret = Hex(C)	
		EndIf
	Local Pix:TPixmap = GrabPixmap(0,0,GraphicsWidth(),GraphicsHeight())
	Local Img:TImage = LoadImage(Pix)
	MapInsert MJBC_Lua_Image,Ret
	Return ret
	End Method
	End Rem

	Method Show(Image$,X,Y,F=0) ' BLD: Shows the image. When the image is not animated (or if you want ot show frame #0) you can skip the F parameter (which is the frame) :)
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Show("+Image+","+X+","+Y+","+F+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	DrawImage TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))),X,Y,F
	End Method
	
	Method ReturnHot$(Image$)
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.ReturnHot("+Image+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	Local I:TImage = TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image)))
	Return "("+Int(I.handle_x)+","+Int(I.Handle_y)+")"
	End Method

	Method HotCenter(Image$)  ' BLD: Set the hotspot of an image to the center of the image
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.HotCenter("+Image+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	MidHandleImage TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image)))
	End Method

	Method Hot(Image$,X,Y)  ' BLD: Set the hotspot of an image to the X and Y of the image
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Hot("+Image+","+X+","+Y+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	SetImageHandle TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))),X,Y
	End Method
	 
	Method Draw(Image$,X,Y,F=0) ' BLD: Alias for Image.Show
	Show Image,X,Y,F
	End Method
	
	Method Width(Image$)
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Width("+Image+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	Return ImageWidth(TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))))
	End Method

	Method Height(Image$)
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Height("+Image+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	Return ImageHeight(TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))))
	End Method
	

	Method Scale(X#,Y#) ' BLD: Scales the next graphic actions. 1 = full size, 0 = so small that you won't see it. 0.5 = half as big, 2 = twice as big. Remains until script is over or another Image.Scale is called
	SetScale X,Y
	End Method
	
	Field CurrentRed,CurrentGreen,CurrentBlue

	Method Color(R,G,B) ' BLD: Set the color in RGB format. Min = 0, max=255
	SetColor Abs(R),Abs(G),Abs(B)
	CurrentRed = R
	CurrentGreen = G
	CurrentBlue = B
	End Method
	
	Method ColorHSV(Hue,Saturation,Value) ' BLD: Tries to set the color based on HSV.<p>NOTE! This routine is not yet toroughly tested, so bugs could be expected!
	Local h:HsvColor = New HsvColor
	h.h = hue
	h.s = saturation
	h.v = value
	Local r:RgbColor = HsvToRgb(h)
	color r.r,r.g,r.b
	End Method

	Method Rotate(D) ' BLD: Set rotation by <i>D</i> degrees. Remains until script is over or another Image.Rotation is called.
	SetRotation D
	End Method

	Method Free(Image$) ' BLD: Removes an image from the storage.<br>It's very important (especially for images only used on occasion) that they are removed from the storage before the script ends otherwise they'll be living there forever without any way to access them.
	MapRemove MJBC_Lua_Image,Image
	Print "LUA>Image "+Image+" has been removed from the image storage!"
	End Method
	
	' Alignments 0 = left, 1 = right, 2 = center  Vertical 0=Up, 1=Down, 2=Center 
	Method Text(X,Y,Txt$,Align=0,Valign=0) ' BLD: Puts in text. For the alignment codes<br>Left/top = 0, Right/Bottom = 1, Center = 2
	Local DX
	Local DY
	Select Align
		Case 0
			DX=X
		Case 1 
			DX=X-TextWidth(Txt)
		Case 2
			DX=X-(TextWidth(Txt)/2)
		Default
			L_ImageError "Image.Text("+X+","+Y+",~q"+Txt+"~q,"+Align+"): Unknown alignment code! (Known codes 0=Left,1=Right,2=Center)"
			Return
		End Select
	Select VAlign
		Case 0
			DY=Y
		Case 1 
			DY=Y-TextHeight(Txt)
		Case 2
			DY=Y-(TextHeight(Txt)/2)
		Default
			L_ImageError "Image.Text("+X+","+Y+",~q"+Txt+"~q,"+Align+"): Unknown alignment code! (Known codes 0=Top,1=Bottom,2=Center)"
			Return
		End Select
	DrawText	Txt,DX,DY
	End Method
	
	Method DText(T$,X,Y,HA=0,VA=0) ' BLD: Puts in text like Image.Text. The argument order is only different for easier access when you are too used to BlitzMAX order.
	Text(X,Y,t,HA,VA)
	End Method
	
	Method Assign(Image$,NewImageName$,KeepOriginal=0) ' BLD: Assigns an image to a new name so that it can be used in an easier way with other scripts.<pre class=code>function Main()\n img = Image.Load("MyImage.png")\n Image.Assign(img,"MyImage")\n Image.Show("MyImage",10,10)\nend</pre>Of course, the code above can also be made shorter. Like this:<pre class=code>function Main()\n Image.Assign(Image.Load("MyImage.png"),"MyImage")\n Image.Draw("MyImage",10,10)\nend</pre>\n<b>Notes</b><ul><li>You don't have to release the original image code. That happens automatically unless you set the KeepOriginal parameter.<li>If an image is already on that spot it's automatically removed. You do not have to free it first.<li>The strings you use for this feature are CASE SENSITIVE!</ul>
	MapInsert MJBC_lua_Image,Upper(NewImageName),MapValueForKey(MJBC_Lua_Image,Upper(Image))
	If Not keeporiginal
		MapRemove MJBC_lua_Image,Upper(Image)
		EndIf
	Print "Image "+Image+" assigned to "+newImageName
	End Method
	
	Method AssignLoad(Image$,File$) ' BLD: Loads an image and assings it automatically to the correct name.
	Assign Load(File),Upper(Image)
	End Method
	
	Method Negative$(Image$,ToImage$="") ' BLD: Inverts an image into a negative and return the new adress. If you place data in "ToImage" it will directly assign the data to the requested adress. Placing the same adress for both Image and ToImage, the original image will be overwritten. :)
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Negative("+Image+","+ToImage+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	Local II:TImage = (TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))))
	Local OI:TImage = ImgNegatief(II)
	Local Ret$ = ToImage,C=0
	If Not ret
		While MapValueForKey(MJBC_Lua_Image,Hex(C)) 
			C:+1
			Wend
		ret = Hex(C)
		EndIf	
	MapInsert MJBC_Lua_Image,Upper(ret),OI
	Return ret
	End Method
	
	Method TextWidth(Txt$) ' BLD: Returns the width of a textstring in pixels
	Return Brl.Max2D.TextWidth(Txt)
	End Method
	
	Method TextHeight(Txt$) ' BLD: Returns the height of a textstring in pixels
	Return Brl.Max2D.TextHeight(txt)
	End Method
	
	Method Line(SX,SY,EX,EY) ' BLD: Draws a line
	DrawLine SX,SY,EX,EY
	End Method
	
	Method Circle(X,Y,Rad,Filled=0) ' BLD: Draws a circle
	If filled Then
		DrawFilledCircle(X,Y,Rad)
		Else
		DrawOpenCircle(X,Y,Rad)
		EndIf
	End Method
	
	Method Cls() ' BLD: CLear Screen. Oldest command in the box I think!
	brl.max2d.Cls
	End Method
	
	Method Flip() ' BLD: Shows the result of all graphic actions you did since the last Image.Flip().
	brl.Graphics.Flip
	End Method
	
	Method Font(FontFile$,size) ' BLD: Sets the font to work with.\nThis font will basically remain set until another call to this is made over a lua script or by some internal features of the engine.\nIt will only load the font once and cache it after that for later use.\nImage.NoFont() can be used to go back to the default font!
	Local F:TJBCFontIndex = New TJBCFontIndex
	F.File = FontFile
	F.Size = Size
	Local I:TImageFont
	Local TF$,NF$
	If MapValueForKey(MJBC_Lua_font,fontfile+"||"+size)
		I = TImageFont(MapValueForKey(MJBC_Lua_Font,fontfile+"||"+size))
		Else
		If JCR_Lua_Image_PatchMap Then 
			TF = JCR_E(JCR_Lua_Image_PatchMap,FontFile)
			NF = ExtractDir(TF)+"/"+StripDir(Fontfile)
			Print "Checking existance "+TF+" ==> "+FileType(TF)
			'Print "Copying "+TF+" to "+NF+" ==> "+CopyFile(TF,NF)
			Print "Loading font file: "+TF+"     (Size="+Size+");  ("+FileType(NF)+")  ("+FileSize(NF)+")"
			I = LoadImageFont(TF,Size) 
			If I Print "Loading font succesfully" Else Print "Loading font failed!!!!"
			JCR_E_Clear()
			DeleteFile(NF)
			Else 
			I = LoadImageFont(FontFile,Size)
			EndIf
		MapInsert MJBC_Lua_Font,fontfile+"||"+size,I
		EndIf	
	If I SetImageFont I
	End Method
	
	Method NoFont()  ' BLD: Sets the font back to the default font
	If NoFontIsConsoleFont Then SetImageFont ConsoleFont() Else 	SetImageFont Null
	End Method
	
	Method CFont()  ' BLD: Use the console font
	SetImageFont ConsoleFont()
	End Method
	
	Method Blend() ' BLD: Returns the number of the current blend setting
	Return GetBlend()
	End Method
	
	Method SetBlend(Blend) ' BLD: Set the blend for next drawing features
	BRL.Max2D.SetBlend Blend
	End Method
	
	Method Rect(X,Y,W,H) ' BLD: Draws a rectangle
	DrawRect X,Y,W,H
	End Method
	
	Method SetAlpha(Alpha:Double) ' BLD: Sets the alpha value (if the blend is in Alpha setting)
	BRL.Max2D.SetAlpha Alpha
	End Method

	Method SetAlphaPC(Alpha) ' BLD: Sets the alpha value in a scale from 1 till 100 (floats and doubles are not always carried over from Lua too well, so this function will have to suffice).
	Local AlphaP:Double = Double(Alpha) / 100.0
	BRL.Max2D.SetAlpha AlphaP
	End Method
	
	Method SetAlphaBlend() ' BLD: Set the blend setting to ALPHABLEND
	SetBlend alphablend
	End Method
	
	Method Tile(image$,X,Y,F) ' BLD: Tile image inside the current viewport
	If Not MapValueForKey(MJBC_Lua_Image,Upper(Image))
		L_ImageError "Image.Tile("+Image+","+X+","+Y+","+F+"): Image buffer "+Image+" is empty!"
		Return
		EndIf
	TileImage TImage(MapValueForKey(MJBC_Lua_Image,Upper(Image))),X,Y,F
	End Method
	
	Method Viewport(X,Y,W,H) ' BLD: Set current viewport
	SetViewport X,Y,W,H
	End Method
	
	Method Origin(X,Y) ' BLD: origin point
	SetOrigin X,Y
	End Method
	
	Method Exist(image$) ' BLD: Returns 1 if an image exists, 0 if it doesn't<p>Note that Lua does not count 0 as false!
	If MapContains(MJBC_Lua_Image,Upper(Image)) Return True Else Return False
	End Method
	
	Method ScalePC(W,H) ' BLD: Scale based on percent. So 100 is actual size and 50 is half size.<p>This is very handy when working on a project that should work on both PPC and x86, as the scaling was serious trouble there. This is a BlitzMax issue which never got fixed, and from this API it seems to work. Don't ask me why.
		Local WW:Double = Double(W)/100
		Local HH:Double = Double(H)/100
		SetScale WW,HH
		End Method
		
	Method GrabScreen$(imgid$="") ' BLD: Grab the entire screen and return the image code. If you set the <i>imgid</i> parameter this code will be used.
		Local image:TImage =CreateImage(GraphicsWidth(),GraphicsHeight(),1,DYNAMICIMAGE|MASKEDIMAGE)
		Local ret$ = Upper(imgid)
		Local C$
		GrabImage image,0,0
		If Not imgid
			Repeat
				C$ = Hex(Rand(0,MilliSecs()))
			Until Not MapContains(MJBC_Lua_Image,C)
			ret = C
			EndIf
		MapInsert MJBC_Lua_Image,ret,image
		Return ret
		End Method
		
End Type

Rem
bbdoc:This global allows you to to call the functions this module adds to Lua directly from BlitzMax.
about:Important to note that these functions are specifically designed to be called from Lua and using them in BlitzMax is mostly highly inefficient. The feature was implemented as Lua has not full access to BMax data (and therefore uses the special reference system I set up for it here). By giving BMax access directly you can make Lua send in Lua Image references to other APIs enabling them to use those. I hope that was clear as I suck in explanations like these :P
End Rem
Global OJBC_Lua_Image:TJBC_Lua_Image = New TJBC_Lua_Image

G_LuaRegisterObject OJBC_Lua_Image,"Image"




' Some internal functions
Private

Function L_ImageError(E$)
Rem
Cls
SetImageFont Null
SetColor 255,0,0
DrawText "Error in LUA Script Image function call!",0,0
SetColor 255,255,255
DrawText E,0,40
DrawText "Hit any key to continue...",0,80
Flip
WaitKey
End Rem
GALE_Error("Image Error: "+E)
End Function
