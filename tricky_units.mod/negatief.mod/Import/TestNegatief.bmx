Rem
***********************************************************
TestNegatief.bmx
This particular file has been released in the public domain
and is therefore free of any restriction. You are allowed
to credit me as the original author, but this is not 
required.
This file was setup/modified in: 
2015, 2016
If the law of your country does not support the concept
of a product being released in the public domain, while
the original author is still alive, or if his death was
not longer than 70 years ago, you can deem this file
"(c) Jeroen Broks - licensed under the CC0 License",
with basically comes down to the same lack of
restriction the public domain offers. (YAY!)
*********************************************************** 
Version 16.03.01
End Rem
Import "Negatief.bmx"


AppTitle = "Test Negatief Pixmap"

file$ = RequestFile("Pix a file: ","portable network graphic:png")

Global I:TPixmap[2]
I[0] = LoadPixmap(file); If Not I[0] Notify "could not load pixmap" End
i[1] = PixNegatief(I[0]); If Not I[1] Notify "inverting failed" End

Graphics PixmapWidth(I[0]),PixmapHeight(I[0])
Global Neg
Repeat
DrawPixmap I[Neg],0,0
If KeyHit(KEY_S) SavePixmapPNG i[1],StripExt(file)+"_inverted.png"
If KeyHit(KEY_SPACE) Neg = Not Neg
Flip
Until KeyHit(KEY_ESCAPE) Or AppTerminate()




