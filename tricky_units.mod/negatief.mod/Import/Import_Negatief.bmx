Rem
  Negatief.bmx
  
  version: 16.06.12
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
' PLEASE NOTE THIS MODULE IS STILL UNDER CONSTRUCTION, SO DON'T BE SURPRISED IF IT DOESN'T WORK PROPERLY (IF IT WORKS AT ALL).
Strict 
Import tricky_units.ImageCopier

MKL_Version "Tricky's Units - Negatief.bmx","16.06.12"
MKL_Lic     "Tricky's Units - Negatief.bmx","ZLib License"

Rem
bbdoc: Inverts a pixmap coloring in order to create a "negative".
returns: The Pixmap containing the reverted image
End Rem
Function PixNegatief:TPixmap(Pixmap:TPixmap)
If Not pixmap Print "WARNING! PixNegatief(Null): Cannot invert a Null Pixmap!" Return
Local x,y
Local r,g,b,p$,newp$
Local ret:TPixmap = CreatePixmap(PixmapWidth(Pixmap),PixmapHeight(pixmap),PF_BGRA8888) ' Pixmap.format)
For y=0 Until PixmapHeight(Pixmap) For x=0 Until PixmapWidth(Pixmap)
	p = Hex(ReadPixel(pixmap,x,y))
	r = ("$"+p[2..4]).toint() 
	g = ("$"+p[4..6]).toint()
	b = ("$"+p[6..8]).toint()
	r = 255 - r
	g = 255 - g
	b = 255 - b
	newp = "$"+p[0..2]+Right(Hex(r),2)+Right(Hex(g),2)+Right(Hex(b),2)
	'Print "Inverting ("+x+","+y+")~t of ("+PixmapWidth(Pixmap)+","+PixmapHeight(Pixmap)+") => ("+r+","+g+","+b+")/"+newP ' debug line
	WritePixel ret,x,y,newp.toint()
	Next; Next ' Twice For = twice Next
Return ret	
End Function


Rem
bbdoc: Inverts an image coloring
returns: The inverted image as a TImage
about: This function has been setup to support both single pic images as animated images (though I must admit that animated images do not work the way they should yet, and I don't know what causes it. If you can fix it, let me know).<br>The image can be an existing image, a Pixmap, a file name, or a bank containing the contents of a picture file (provided the loader for it is imported in your program).
End Rem
Function ImgNegatief:TImage(Image:Object)
Local work:TImage = TImage(Image)
If Not work work = LoadImage(Image)
If Not work Return
Local rpx:TPixmap
Local ret:TImage 
If Len(work.pixmaps)>1 ' Animated images. Somehow it doesn't work too well, and I don't know why. (The inverter itself complains all pixmaps are 'null', but tests pointed out that these pixmaps are NOT null).
	'Print "anim"
	ret = copyimage(work)
	For Local ak = 0 Until Len(ret.pixmaps)	ret.pixmaps[ak] = PixNegatief(ret.pixmaps[ak])	Next
	Else
	'Print "single"
	rpx = PixNegatief(work.Pixmaps[0])
	'SavePixmapPNG rpx,"Test.png",9; Print "Saving test pic"
	ret = LoadImage(rpx)	EndIf
Return ret
End Function
