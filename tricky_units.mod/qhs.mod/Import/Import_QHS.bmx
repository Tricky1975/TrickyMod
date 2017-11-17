Rem
  QHS.bmx
  
  version: 17.11.17
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
MKL_Version "Tricky's Units - QHS.bmx","17.11.17"
MKL_Lic     "Tricky's Units - QHS.bmx","ZLib License"



Function QHD$(A$,factor=1)
	Local ret
	Local h,t
	For Local i=0 Until Len A
		h = i * factor
		t = a[i] + h
		While t>255 t=t-256 Wend
		While t<  0 t=t+256 Wend
		ret:+Chr(t)
	Next
	Return ret
End Function

Function QUH$(a$,factor=1)
	Return QHD(A,factor*-1)
End Function
