Rem
  CreateBlop.bmx
  
  version: 15.09.02
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
Graphics 600,600
Const N#=.2,Z=512
BlopRadius=511
Width=1024

For R#=1 To BlopRadius Step N
Print "R = "+R+" MaxRadius = "+BlopRadius
A#=R*R/Width
SetColor A,A,A
DrawOval R/2,R/2,Z-R,Z-R 'change to DrawRect for inverted blobs
Next

Pix:TPixmap = GrabPixmap(0,0,512,512)
SavePixmapPNG Pix,"Blop.png"
