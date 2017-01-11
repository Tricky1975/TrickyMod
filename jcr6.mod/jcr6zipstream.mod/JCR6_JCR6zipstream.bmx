Rem
  JCR6_JCR6zipstream.bmx
  
  version: 17.01.11
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

Import jcr6.jcr6main
Import koriolis.zipstream

Private

copycompdriver "Store","zipped"


Type DRV_ZIPSTREAM Extends DRV_JCRDIR

	Method Recognize(fil$)
		DebugLog "Reading zip::"+fil+"//JCR6/index"
		Local Test:TStream = ReadFile("zip::"+fil+"//JCR6/index")
		Local ret = test<>Null
		If ret DebugLog "Zip succesfully read" Else DebugLog "This is not a zip, or it has no index. Either way, I must reject it"
		If ret CloseFile test
		Return ret
	End Method
		
	Method Dir:TJCRDir(fil$)
		Local ret:TJCRDir = New TJCRDir
		JCR_ReadIndex ret,"zip::"+fil+"//JCR6/index",fil,True,True,"PKZIP",fil
	End Method
	
	Method Name$() 
		Return "PKZIP"
	End Method
	
	Method INE$(N$,r$)
		Return "zip::"+r+"//"+N
	End Method

     End Type

New DRV_ZIPSTREAM
