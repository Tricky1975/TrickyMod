Rem
/* 
  Append

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



Version: 15.08.15

End Rem
Strict
Import brl.stream
Import tricky_units.MKL_Version

MKL_Version "Units - Append/Append.bmx","15.08.15"
MKL_Lic     "Units - Append/Append.bmx","zLIB License"


Rem
bbdoc: Opens a file for appending
End Rem
Function AppendFile:TStream(file$)
Local Ret:TStream = OpenFile(file$)
SeekStream(ret,StreamSize(ret))
Return ret
End Function

