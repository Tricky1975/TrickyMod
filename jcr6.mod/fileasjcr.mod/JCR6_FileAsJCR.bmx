Rem
        JCR6_FileAsJCR.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.05.20

End Rem
Strict
Import jcr6.jcr6Main
Rem
bbdoc: Loads a raw file as it were a one-entry JCR file. Handy For quick patching raw files into a great JCR file.
about: This routine works on both real files stored on disk as on incbin files. Bankstreams are not supported since JCR did never support that in the first place. 
End Rem
Function Raw2JCR:TJCRDir(Rawfile$,EntryName$="")
Local EN$ = entryname; If Not EN EN = StripDir(RawFile)
Local ret:TJCRDir = New TJCRDir
Local E:TJCREntry
Local BT:TStream = readFile(RawFile)
If Not BT
	Print "WARNING! File "+RawFile+" could not be opened for analysis."
	Return ret
	EndIf
Local FileSze = StreamSize(BT)
CloseFile bt
ret.config.def("&__CaseSensitive",0)
E = New TJCREntry
MapInsert ret.entries,Upper(EN),e
E.FileName = EN
E.Size = FileSze 'FileSize(rawfile)
E.CompressedSize = E.Size
E.Storage = "Store"
E.Offset = 0
E.MainFile = RawFile
E.PVars = New StringMap
Return ret
End Function


MKL_Version "JCR6 - JCR6_FileAsJCR.bmx","15.09.02"
MKL_Lic     "JCR6 - JCR6_FileAsJCR.bmx","Mozilla Public License 2.0"
