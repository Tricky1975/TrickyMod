Rem
***********************************************************
TestNegatief.bmx
This particular file has been released in the public domain
and is therefore free of any restriction. You are allowed
to credit me as the original author, but this is not 
required.
This file was setup/modified in: 
2015
If the law of your country does not support the concept
of a product being released in the public domain, while
the original author is still alive, or if his death was
not longer than 70 years ago, you can deem this file
"(c) Jeroen Broks - licensed under the CC0 License",
with basically comes down to the same lack of
restriction the public domain offers. (YAY!)
*********************************************************** 
Version 15.09.02
End Rem
Rem
/*


   The file you are currently accessing is a file released in the public
   domain, meaning you can freely alter it distribute it without any means of
   restriction whatsoever, and the only thing you cannot do is claim ownsership
   on it.
   
   Please note, Public Domain means no restriction at all, you may mention me
   (Jeroen Broks) as the original programmer, but you don't have to (if you
   find anything on the internet claiming to be public domain forcing you to
   name the source you obtained it from, then it simply ain't public domain,
   meaning the one who told you so is lying about its license type).
   
   Please note, that should any file in the public domain be a clear referrence
   to a real person (either dead or alive) the restrictionless status of the
   public domain gets a restriction as you may not give out references to 
   real people out without that person's permission (which is not a copyright
   issue), and that is one of the many examples that could void the freedom
   of public domain. The file must fulfill the rules of other laws. I guess
   that was pretty obvious.
   
   This file is released "AS IS", meaning that the creator of this file 
   dislaims any form of warranty, without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   
   In other words, you're using this file at your own risk.
   
*/
   


Version: 15.07.12

End Rem
Import "Negatief.bmx"


AppTitle = "Test Negatief Pixmap"

file$ = RequestFile("Pix a file: ","portable network graphic:png")

Global I:TPixmap[2]
I[0] = LoadPixmap(file); If Not I[0] Notify "could not load pixmap" End
i[1] = pixnegatief(I[0]); If Not I[1] Notify "inverting failed" End

Graphics PixmapWidth(I[0]),PixmapHeight(I[0])
Global Neg
Repeat
DrawPixmap I[Neg],0,0
If KeyHit(KEY_SPACE) Neg = Not Neg
Flip
Until KeyHit(KEY_ESCAPE) Or AppTerminate()




