Rem
  PicBundle.bmx
  
  version: 18.05.04
  Copyright (C) 2017, 2018 Jeroen P. Broks
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
Strict

Import brl.pngloader

Import "UPB_JCR.bmx"
Import "UPB_TList.bmx"
Import "UPB_Dir.bmx"


Rem
	if you don't want to include JCR6 in this simply put the import line into a comment.
	The import for dir is only valuable if JCR6 is not loaded, as it has been set not to operate to prevent conflicts.
	Plaese note, when you want to use this module in combination with Kthura, you MUST have JCR in it or Kthura will NOT work!
End Rem


Rem
bbdoc: When set true debug information can be shown on the output
End Rem
Global BundleChat = False

Rem
bbdoc: If something went wrong while trying to load a bundle, this variable will contain the error
End Rem
Global BundleError$


Rem
bbdoc: Reads all images within the given object and turns it into an animation, similar as LoadAnimImage.
about: Accepted parameters for 'bundle' are <ol type=i><li>A string leading to a folder or JCR6 file</li><li>A Tlist with either Pixmaps, Images or a string leading to a picture file. When you use an animated image, all the frames will just be added to the frames we got</li><li>A JCR6 dir object tied to a JCR6 file in which images are stored.</li></ol>When using JCR6 you can use 'Prefix' for pure directories or JCR6 files to require a prefix. This is basically meant for allowing you to put multiple bundles in one JCR6 file.<p>One note, all images MUST have the same height and width. The first image will dictate the settings for the rest. Images not following this requirement lead to an error.
returns: A TImage with an animated image. If there is an error it retuns "nul" and the BundleError variable will tell you what went wrong.
End Rem
Function GetBundle:TImage(bundle:Object, prefix$="",flags=-1)
	BundleError="All is well."
	Local drv:upb_driver
	For Local tdrv:upb_driver=EachIn(upb_drivers)
		If tdrv.recognize(bundle) drv=tdrv
	Next
	If Not drv 
		BundleError = "None of the bundle drivers recognized the bundle you tried to load"
		Return
	EndIf
	Local l:TList = drv.makelist(bundle,prefix)
	If CountList(l)=0 Then
		BundleError = "Received an empty list from the bundle reader ("+drv.Name()+")"
		Return
	EndIf
	Local P:TPixmap
	p = TPixmap(l.valueatindex(0))
	If Not p
		' this should NEVER be possible, but IF it happens at least there won't be a crash.
		BundleError = "NULL pixmap on first value. This is an impossible error. Please report!"
		Return
	EndIf
	Local w=PixmapWidth(p)
	Local h=PixmapHeight(p)
	Local n=CountList(l)
	Local cnt=0
	Local ret:TImage = CreateImage(w,h,n,flags)
	For p = EachIn l
		If PixmapWidth(p)<>w And PixmapHeight(p)<>h
			BundleError = "Format mismatch "+PixmapWidth(p)+"x"+PixmapHeight(p)+"~nMust be "+w+"x"+h
			Return
		EndIf
		If cnt>n
			BundleError = "Too many pixmaps. "+n+" expected"
			Return
		EndIf
		ret.pixmaps[cnt]=p
		cnt:+1
	Next
	If cnt<>n
		BundleError = "Count mismatch. "+cnt+" pixmaps counted, but "+n+" were expected"	
		Return
	EndIf
	drv.HotSpots bundle,ret,prefix
	Return ret
End Function	

Rem
bbdoc: Saves an animated TImage as a picbundle JCR file.
about: The files will all be in PNG format inside the JCR file.
returns: "Ok" if nothing went wrong, an error message if something did go wrong
End Rem
Function SaveBundleJCR$(output:Object,Image:TImage,prefix$="",Storage$="Store",Quality=5)
      Local outfile$=".BUNDLECREATION_" If String(output) outfile=String(output)
	Local i=0
	Local p:TPixmap
	Local bt:TJCRCreate 
	Local of$ = outfile+"__TEMP__.png"
	If TJCRCreate(output) Then 
	   bt=TJCRCreate(output)
	Else
	   bt=JCR_Create(outfile)
	   If Not bt Return "Could not create file: "+outfile
	EndIf
	For p=EachIn image.pixmaps
		SavePixmapPNG p,of,Quality
		bt.addentry of,Right("000000000"+i,9)+".png",Storage
		i:+1
	Next	
	If String(output) bt.close Storage
	If Not DeleteFile(of) Return "Could not delete swapfile: "+of
	Return "Ok"
End Function
