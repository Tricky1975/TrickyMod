Rem
/* 
  Safe String

  Copyright (C) 2012, 2015 Jeroen P. Broks

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



Version: 15.02.03

End Rem
Strict

Rem
Copyright (c) 2011, Jeroen P. Broks

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.

end rem

Rem
-- bbdoc: This module is only a quick way to make strings safe against characters that won't do to well in certain text files. It's been used as the InitFile module caused some errors when strange strings were used, but perhaps you have some use for it otherwise ;)
End Rem
Rem
Module tricky.SafeString

ModuleInfo "Version:12.11"
ModuleInfo "License:zlib"
ModuleInfo "Author:Jeroen P. Broks"
ModuleInfo "(C):Jeroen P. Broks"
ModuleInfo "Question:Are you not entertained?"
End Rem




Import Tricky_units.MKL_Version

MKL_Version "Units - SafeString/SafeString.bmx","15.02.03"
MKL_Lic     "Units - SafeString/SafeString.bmx","zLIB License"





Rem
bbdoc: This string may contain all characters you deem 'safe' so that they won't be translated. If you want it defined differently you can do so in your own app source.
End Rem
Global SafeChars$ 
SafeChars = "1234567890!@#$^&*()-_+=|qwertyuiop[]{}asdfghjkl;:'~qzxcvbnm,.<>/?QWERTYUIOPASDFGHJKLZXCVBNM"

Private
Function ByteHex$(A:Byte)
Return "%"+Right(Hex(A),2)
End Function
Public

Rem
bbdoc: Translate a string into a Safe String
end rem
Function SafeString$(SourceString$)
	Local Ret$ = Replace(SourceString,"%","%25")
	Local Ak
	For Ak=0 To 255
		If SafeChars.Find(Chr(Ak))<0 And ak<>$25 Ret = Replace(Ret,Chr(Ak),ByteHex(Ak))
	Next
	Return Ret
End Function

Rem
bbdoc: Translates a Safe String into a normal String
end rem
Function UnSafeString$(SourceString$)
	Local Ret$ = SourceString
	Local Ak
	For Ak=0 To 255
		Ret = Replace(Ret,ByteHex(Ak),Chr(Ak))
	Next
	Return Ret
End Function

		

