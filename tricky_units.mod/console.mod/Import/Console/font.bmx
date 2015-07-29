Rem
/* 
  Console Font

  Copyright (C) 2013, 2015 JPB

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

*/



Version: 15.01.22

End Rem
Import brl.freetypefont
Import brl.max2d
Import brl.basic
Incbin "unispace.ttf"


Rem

The unispace font is free for both personal AND commercial use as long as you don't sell the font itself.

Please read the PDF file provided inside this module for more information.

All credit goes to its respective creator!


End Rem


Private
Global CF:TImagefont
Public


Rem
bbdoc:Contains the font that the console uses.
about:You can also load it by reading it from 'incbin:unispace.ttf', but be warned... You never know if I ever pick a different font for this so using this function is a safer route.
End Rem
Function ConsoleFont:TImageFont()
If Not CF Then
  Print "Loading Console Font"
	CF = LoadImageFont("incbin::unispace.ttf",12)
	Assert CF Else "Tricky.Console.ConsoleFont(): Internal font could not be loaded!"
	Return Null
	EndIf
Return CF
End Function
