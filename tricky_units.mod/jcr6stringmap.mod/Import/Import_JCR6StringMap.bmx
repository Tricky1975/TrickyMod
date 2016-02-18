Rem
  JCR6StringMap.bmx
  7
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
  JCR6StringMap.bmx
  
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
  StringMap for JCR6

  Copyright (C) 2015 Jeroen Broks

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



Version: 15.02.28

End Rem
Strict 
Import jcr6.jcr6main 
Import tricky_Units.StringMap 
Import tricky_units.TrickyReadString
Import tricky_Units.MKL_Version

MKL_Version "Tricky's Units - JCR6StringMap.bmx","15.09.02"
MKL_Lic     "Tricky's Units - JCR6StringMap.bmx","ZLib License"


Rem
bbdoc: Saves a stringmap into a JCR6 file
End Rem
Function SaveStringMap(T:TJCRCreate,Entry$,SM:StringMap,alg$="Store")
Local BT:TJCRCreateStream  
bt = T.CreateEntry(Entry,alg)  
For Local key$=EachIn MapKeys(SM)
	WriteByte bt.stream,1
	TrickyWriteString bt.stream,key
	TrickyWriteString bt.stream,sm.value(key)
	Next
WriteByte bt.stream,255
bt.close()	
End Function

Rem
bbdoc: Loads a stringmap from a jcr6 file
End Rem
Function LoadStringMap:StringMap(JCRMain:Object,Entry$)
Local JCR:TJCRDir
Local ret:StringMap = New StringMap
If String(JCRMain)
	JCR = JCR_Dir(String(JCRMain))
ElseIf TJCRDir(JCRMain)
	JCR = TJCRDir(JCRMain)
Else
	Throw "Unknown type for LoadStringMap"
	End
	EndIf
Assert JCR Else "Could not identify JCR object"
Local BT:TStream = JCR_ReadFile(JCR,Entry)
Local tag,key$,Value$
While Not Eof(BT)
	tag = ReadByte(BT)
	If tag=255 Exit
	Select tag
		Case 1
			key = TrickyReadString(BT)
			value = TrickyReadString(BT)
			MapInsert ret,key,value
		Default
			?Debug
			Print "ERROR READING STRINGMAP!"
			Print "Offset: "+StreamPos(BT)
			For Local k$ = EachIn MapKeys(ret)
				Print "K[~q"+k+"~q] = ~q"+ret.value(k)+"~q"
				Next
			?
			Throw "Unknown tag in stringmap! ("+Tag+")"
			Print "ERROR!"
			End
		End Select	
	Wend
CloseStream BT
Return ret
End Function
