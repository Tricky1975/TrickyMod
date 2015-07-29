Rem
/* 
  List File

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
'History
' 15.02.17 - Initial version
Strict
Import tricky_units.MKL_Version
Import brl.stream
Import brl.linkedlist

MKL_Version "Units - ListFile/ListFile.bmx","15.02.24"
MKL_Lic     "Units - ListFile/ListFile.bmx","zLIB License"

Rem
bbdoc:Lists a text file in a TList, and with for eachin you can read out all the lines
End Rem
Function Listfile:TList(file:Object)
Local BT:TStream = ReadStream(file)
Assert bt Else "File "+String(file)+" could not be read!"
If Not bt Return
Local ret:TList = New TList
While Not Eof(BT)
	ListAddLast ret,ReadLine(BT)
	Wend
CloseStream BT	
Return ret
End Function
