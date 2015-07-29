Rem
/* 
  ListDir

  Copyright (C) 2015 Jeroen Petrus Broks

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



Version: 15.05.26

End Rem
Strict
Import brl.linkedlist
Import brl.retro
Import tricky_units.MKL_Version


Const LISTDIR_FILEONLY = 1
Const LISTDIR_DIRONLY  = 2

MKL_Version "Units - ListDir/ListDir.bmx","15.05.26"
MKL_Lic     "Units - ListDir/ListDir.bmx","zLIB License"

Rem
bbdoc: Returns a TList containing all files inside a dir. It does not work recursively (for that use the Tree module). If the t parameter is set to LISTDIR_FILEONLY then you'll only get files and if it's set to LISTDIR_DIRONLY it will only contain directories (or folders if you like). When set to 0 it will add directories and folders alike.
End Rem
Function ListDir:TList(dir$=".",t=0,allowunixhidden=False)
Local d$ = Replace(dir,"\","/")
Local ret:TList = New TList
If Right(D,1)<>"/" D:+"/"
Local BD = ReadDir(d)
If BD=0
	Print "listdir: Could not access dir: "+dir
	Return 
	EndIf
Local F$
Repeat
F = NextFile(BD)
If Not F Exit
If (Left(F,1)<>"." Or allowunixhidden) And (t=0 Or FileType(D+F)=t)
	ListAddLast ret,F
	EndIf
Forever
CloseDir BD
SortList ret
Return ret
End Function


