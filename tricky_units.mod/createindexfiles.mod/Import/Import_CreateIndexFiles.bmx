Rem
  CreateIndexFiles.bmx
  
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
Import tricky_units.MD5
Import tricky_units.ListDir

MKL_Version "Tricky's Units - CreateIndexFiles.bmx","17.01.11"
MKL_Lic     "Tricky's Units - CreateIndexFiles.bmx","ZLib License"

Function CIF_FileData$(file$,author$="",notes$="")
	If Not (FileType(file)=1) Return 
	Local c$
	Local ret$=""
	ret:+"__Size:"+file+"~n"
	c = LoadString(file)
	ret:+"__Hash_md5:"+MD5(c)+"~n"
	ret:+"__Author:"+author+"~n__Notes:"+notes
	Return ret
End Function	

Function CIF_DirData$(dir$,verbose)
	If Not (FileType(dir)=2) Return
	Local ret$=""
	For Local f$ = EachIn ListDir(dir)
		If f$<>"JCR6/index" 
			ret:+"ENTRY:"+f+"~n"+CIF_FileData(dir+"/"+f)+"~n"
			If verbose Print "= "+f+" indexed"
		endif
	Next
Return ret
End Function

Function CIF_IndexDir(Dir$)
	If Not (FileType(dir)=2) Return
	If Not CreateDir(dir+"/JCR6",1) Return Print("ERROR! I could not creaete: "+dir+"/JCR6")
	SaveString(CIF_DirData(dir),dir+"/JCR6/index")		
End Function		
	
	
