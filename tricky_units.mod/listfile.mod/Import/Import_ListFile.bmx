Rem
  ListFile.bmx
  
  version: 17.11.17
  Copyright (C) 2015, 2016, 2017 Jeroen P. Broks
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


'History
' 15.02.17 - Initial version
' 15.11.19 - Removed some shit a buggy auto-licenser put in above. No big deal
' 16.03.09 - Support for List2File
Strict
Import tricky_units.MKL_Version
Import brl.stream
Import brl.linkedlist

MKL_Version "Tricky's Units - ListFile.bmx","17.11.17"
MKL_Lic     "Tricky's Units - ListFile.bmx","ZLib License"

Rem
bbdoc:Lists a text file in a TList, and with for eachin you can read out all the lines
End Rem
Function Listfile:TList(file:Object)
Local BT:TStream = ReadStream(file)
Assert bt Else "File "+String(file)+" could not be read!"
If Not bt Print "File could not be read!" Return Null
Local ret:TList = New TList
While Not Eof(BT)
	ListAddLast ret,ReadLine(BT)
	Wend
CloseStream BT	
Return ret
End Function

Rem
bbdoc:Saves all string elements within a TList to a file, separarated by Unix line breaks (ASCII 10).
about:All non-string elements are ignored. The 'file' parameter can be either a filename or an already open stream.
End Rem
Function List2File(file:Object,list:TList)
Local T:TStream
If String(file) 
	T = WriteFile(String(file))
ElseIf TStream(file)
	T = TStream(file)
Else
	Print "HEY! I don't know that file type!"
	Return
	EndIf
For Local s$=EachIn list
	WriteLine t,s
	Next
If String(file) 
	CloseStream T
	EndIf
End Function	
