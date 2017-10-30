Rem
  MKL_Version.bmx
  
  version: 17.10.31
  Copyright (C) 2012, 2016, 2017 Jeroen P. Broks
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


' Additions:
' Version: 12.04.19 - Turned into part of a module, which shall be used henchforth
' Version: 12.10.02 - Built in safety features as the lists do sometimes (mysteriously) turn back to NULL. Cause unknown, but it should now longer allow a project to crash.
' Version: 15.01.21 - Adepted for the new JCR6 time (not that JCR6 was actually used, but at the start of the switch I basically adepted nearly all my modes)
' Version: 16.06.11 - Confirmed to be compatible with Brucey's BlitzMax NG

Strict
Import brl.map
Import brl.retro

Private
Global SourceVersions:TMap = New TMap	
Global SourceLicenses:TMap = New TMap
Public

Rem
bbdoc: Defines a version of the current source.
about: File$ should basically the name of the source file this definition is set in
End Rem
Function MKL_Version(File$,Version$)
	If Not SourceVersions
		Print "MKL_Version(~q"+File+"~q,~q"+Version+"~q): WARNING! Version lists has mysteriously gone to NULL!"
		Return
		EndIf
MapInsert Sourceversions,File,Version
End Function


Rem
bbdoc: Asks for the version of the requested file
End Rem
Function MKL_Getversion$(File$)
Return String(MapValueForKey(SourceVersions,File))
End Function

Rem
bbdoc: Shows a list of all versions
about: When ShowLic is set to True it will also show the license the files were released in
End Rem
Function MKL_GetAllversions$(ShowLic=True)
Local Ret$="Versions of all sources:"
If Not Sourceversions
	Print "MKL_GetAllVersions("+ShowLic+"): WARNING! Version lists is Null"
	Return
	EndIf
For Local K$=EachIn MapKeys(Sourceversions)
	Ret :+ "~n= "+Left(K$+" ................................................................................",80)+" "+MKL_Getversion(K)
	If ShowLic Ret:+"  "+MKL_GetLic(K)
	Next
Return Ret
End Function


Rem
bbdoc: Will turn the version number into an int. 
about: For example version 17.08.09 will become the integer 170809
returns: The int
End Rem
Function MKL_VerToNum(A$="")
	Local V$=A
	If Not V V=MKL_NewestVersion()
	Return Replace(V,".","").toint()
End function

Rem
bbdoc: Defines a license of the current source.
about: File$ should basically the name of the source file this definition is set in
End Rem
Function MKL_Lic(File$,Version$)
		If Not SourceLicenses
		Print "MKL_Lic(~q"+File+"~q,~q"+Version+"~q): WARNING! License lists has mysteriously gone to NULL!"
		Return
		EndIf

MapInsert SourceLicenses,File,Version
End Function

Rem
bbdoc: Asks for the lciense of the requested file
End Rem
Function MKL_GetLic$(File$)
		If Not SourceLicenses
		Print "MKL_GetLic(~q"+File+"~q): WARNING! License lists has mysteriously gone to NULL!"
		Return
		EndIf
Return String(MapValueForKey(SourceLicenses,File))
End Function

Rem
bbdoc: Returns the version number of the source file with the highest version number.
about: I always use this to declare the version number of the executable file
End Rem
Function MKL_NewestVersion$()
Local CL=0;
Local VL
Local Ret$
	If Not SourceVersions
		Print "MKL_NewestVersion(): WARNING! Version lists has mysteriously gone to NULL!"
		Return
		EndIf
For Local K$=EachIn MapKeys(Sourceversions)
	VL = Replace(MKL_Getversion(K),".","").toint()
	If VL>CL 
		Ret = MKL_Getversion(K)
		CL=VL
		EndIf
	Next
Return Ret
End Function

MKL_Version "Tricky's Units - MKL_Version.bmx","17.10.31"
MKL_Lic     "Tricky's Units - MKL_Version.bmx","ZLib License"
