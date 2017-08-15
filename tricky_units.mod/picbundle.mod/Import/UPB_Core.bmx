Rem
  UPB_Core.bmx
  
  version: 17.08.15
  Copyright (C) 2017 Jeroen P. Broks
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

Import tricky_units.MKL_Version
Import brl.max2d

MKL_Version "Tricky's Units - UPB_Core.bmx","17.08.15"
MKL_Lic     "Tricky's Units - UPB_Core.bmx","ZLib License"

Global UPB_DRIVERS:TList = New TList

Global JCR_Active

Type UPB_DRIVER
	Method recognize(A:Object) Abstract
	Method makelist:TList(A:Object,prefix$="") Abstract
	Method hotspots(A:Object,I:TImage) End Method
	
	
	Method New() Final
		ListAddLast UPB_Drivers,Self
	End Method	
	
	
End Type	
