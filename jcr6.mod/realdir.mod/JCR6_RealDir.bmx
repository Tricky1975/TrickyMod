Rem
        JCR6_RealDir.bmx
	(c) 2015, 2016, 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.04.27
End Rem
Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.05.20

End Rem
' 15.02.01 - Initial version
' 15.03.11 - Real dirs always case insensitive
' 16.03.12 - All realdir "archives" will have the 'multi-file' tag. The CLI tools need this
' 17.04.27 - Unix permissions support

Import tricky_units.MKL_Version
Import tricky_units.tree
Import jcr6.jcr6main

MKL_Version "JCR6 - JCR6_RealDir.bmx","17.04.27"
MKL_Lic     "JCR6 - JCR6_RealDir.bmx","Mozilla Public License 2.0"

Private
Type DRV_REALDIR Extends DRV_JCRDIR
     Method Recognize(fil$) 
     Return FileType(fil)=2
     End Method

     Method Dir:TJCRDir(fil$) 
		Local ret:TJCRDir = New TJCRDir
		ret.config.def("&__CaseSensitive",0)
		Local Tree:TList = CreateTree(fil)
		Local File$
		Local e:TJCREntry
		Local bdir$ = Replace(fil,"\","/")
		ret.multifile = True
		?win32
		If (Not(Len(bdir)=2 And Right(bdir,1)=":")) Or (Right(bdir,1)<>"/") bdir:+"/"
		?Not win32
		If (Right(bdir,1)<>"/") bdir:+"/"
		?
		For file=EachIn Tree
			E = New TJCREntry
			MapInsert ret.entries,Upper(file),e
			E.FileName = File
			E.Size = FileSize(bdir+File)
			E.CompressedSize = E.Size
			E.Storage = "Store"
			E.Offset = 0
			E.MainFile = bdir+File
			E.PVars = New StringMap
			?Not win32
			e.unixpermissions = FileMode(bdir+File)
			?
			Next
		Return ret
     End Method

     Method Name$() Return "Real Dir" End Method


     End Type


New DRV_REALDIR
