Rem
  HotSpot.bmx
  
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
Rem
  HotSpot.bmx
  
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
Rem
/* 
  HotSpot

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

*/



Version: 15.02.24

End Rem
Strict

Import brl.max2d

Const HS_TOP = 0
Const HS_CENTER = 2
Const HS_BOTTOM = 1

Const HS_LEFT = 0
Const HS_RIGHT= 1

Const HS_START = 0
Const HS_END = 1

Rem
bbdoc: Set the Hotspot (or image handle) to a basic spot.
about: In stead of coordinates (as we already got SetImageHandle for that) this routine just goes for HS_START, HS_CENTER and HS_END. The computer will calculate the actual coordinates automatically.
End Rem
Function HotSpot(I:TImage,HX,HY)
Assert I Else "No image to hotspot!"
Assert HX>=0 And HX<=2 Else "Hotspot X out of bounds!"
Assert HY>=0 And HY<=2 Else "Hotspot Y out of bounds!"
Local X[] = [0,ImageWidth(I) ,ImageWidth(i) /2]
Local y[] = [0,ImageHeight(I),ImageHeight(I)/2]
SetImageHandle I,x[HX],Y[HY]
End Function


Rem
bbdoc: Move the hotspot to the center of the picture
End Rem
Function HotCenter(I:TImage)
Hotspot I,HS_Center,HS_CENTER
End Function

Rem
bbdoc: Move the hotspot to the bottom right of the picture
End Rem
Function HotEnd(I:TImage)
hotspot I,HS_RIGHT,HS_BOTTOM
End Function

