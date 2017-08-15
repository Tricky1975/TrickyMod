Rem
  UPB_JCR.bmx
  
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

' By default only realdir and jcr6 format are supported
' But if you have the tar driver for JCR6 loaded tar will be supported as well.
' Any driver goes here. ;)

Import jcr6.realdir
Import tricky_units.prefixsuffix
Import "UPB_Core.bmx"

MKL_Version "Tricky's Units - UPB_JCR.bmx","17.08.15"
MKL_Lic     "Tricky's Units - UPB_JCR.bmx","ZLib License"


JCR_Active = True

Type UPB_JCR Extends UPB_DRIVER

	Method recognize(O:Object)
		If TJCRDir(o) Return True
		If String(o) And JCR_Dir(String(O)) Return True
		Return False
	End Method
	
	Method makelist:TList(o:Object,prefix$="")
		Local J:TJCRDir
		Local P:TPixmap
		Local d$=Upper(prefix)
		Local r:TList = New TList
		If TJCRDir(o)
			J=TJCRDir(o)
		ElseIf String(o)
			J=JCR_Dir(String(O))
		Else
			Return Null
		EndIf
		For Local K$=EachIn MapKeys(J.entries)
			If Prefixed(k,d)
				p = LoadPixmap(JCR_B(J,k))
				If p ListAddLast r,p
			EndIf
		Next
		Return r
	End Method
	
End Type

New UPB_JCR	
			


