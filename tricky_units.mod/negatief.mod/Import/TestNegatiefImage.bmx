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


AppTitle = "Test Negatief Image"


file$ = RequestFile("Pix a file: ","portable network graphic:png")

Global I:TImage[2]
I[0] = LoadImage(file); If Not I[0] Notify "could not load image" End
i[1] = imgnegatief(file); If Not I[1] Notify "inverting failed" End
'i[1] = LoadImage(pixnegatief(i[0].pixmaps[0]))

Graphics ImageWidth(I[0]),ImageHeight(I[0])
Global Neg
Global N$[] = ["false","true"]
cls
Repeat
SetColor 255,255,255
DrawImage I[Neg],0,0
SetColor 0,0,0
DrawRect 0,0,200,20
SetColor 255,255,255
DrawText "Negatief: "+N[neg],0,0
If KeyHit(KEY_SPACE) Neg = Not Neg
Flip
Until KeyHit(KEY_ESCAPE) Or AppTerminate()




