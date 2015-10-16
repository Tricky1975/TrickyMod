Rem
  Rectangles.bmx
  
  version: 15.10.16
  Copyright (C) 2015 Jeroen P. Broks
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
' History
' 15.10.16 - Initial version


Import BRL.StandardIO
Import brl.max2d

Rem 
bbdoc: Draw a rectangle.
about: This function draw unfilled rectangle unlike drawrect, unless you explicitly set "empty" to false
End Rem
Function Rect(x,y,w,h,empty=1)
Select empty
	Case 1
		DrawLine x  ,y  ,x+w,y   ' top
		DrawLine x+w,y  ,x+w,y+h ' right
		DrawLine x+w,y+h,x  ,y+h ' bottom
		DrawLine x  ,y+h,x  ,y   ' left
	Case 0
		DrawRect x,y,w,h
	Default
		Print "Warning! I cannot draw a rectangle with the given paramters. 'full' is invalid!"
		End Select
End Function


Rem
bbdoc: This type can be used to set up an advrectangle (which would otherwise have too many parameters. 
about: It does contain the x,y,w,h, but also 'outalpha', 'inalpha' and 'inr', 'ing' and 'inb' to define the inner color and the same prefixed with out for the outter color.
End Rem
Type tAdvRect
	Field x,y,w,h
	Field outalpha:Double = 1
	Field inalpha:Double = 1
	Field inr,ing,inb
	Field outr,outg,outb
	End Type
	
Rem
bbdoc: Draw the rectangle with the advanced settings defined in your tAdvRect variable.
End Rem	
Function AdvRect(r:tadvrect)	
SetColor r.inr,r.ing,r.inb
SetAlpha r.inalpha
rect r.x,r.y,r.w,r,h,0
SetColor r.outr,r.outg,r.outb
SetAlpha r.outalpha
rect r.x,r.y,r.w,r,h,1
End Function
