Rem
        JCR6_TAR4JCR6.bmx
	(c) 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.03.10
End Rem
Import jcr6.jcr6main

MKL_Version "JCR6 - JCR6_TAR4JCR6.bmx","16.03.10"
MKL_Lic     "JCR6 - JCR6_TAR4JCR6.bmx","Mozilla Public License 2.0"

Private
Function Term0$(a$)
Local s$[]=a.split(Chr(0))
Return s[0]
End Function

Function RS$(s:TStream,l)
Return term0(ReadString(s,l))
End Function

Function O2D(GET:String)
Local A$=Trim(GET)
Local e = Len(A)-1
Local ret = 0
For i=0 Until Len(a)
	'Print "Calc: i = "+i+" e = "+e+" ch = "+a[e-i]+" 8^"+i+"="+Int(8^i)
	ret :+ (a[e-i]-48)*(8^i)
	Next
Return ret
End Function

Global warned
Function ExperimentalTAR()
Local Warning$ = "Please note!~n~nALPHA VERSION OF TAR DRIVER~nThe support for TAR is only in an experimental stage, and should not be used at all except for experimentation purposes.~n~nI cannot yet guarantee that the generated data is fully generated the way it should be."
If warned Return
Print Warning
'Notify Warning
End Function

Public


Type DRV_TAR Extends DRV_JCRDIR
	Method Name$()
	Return "Tape ARchive (TAR)"
	End Method

	Method Recognize(fil$)
	Return Upper(ExtractExt(fil))="TAR"
	End Method
	
	Method Dir:TJCRDir(fil$)
	ExperimentalTAR
	Local Ret:TJCRDir = New TJCRDir
	Local entries:TMap = ret.entries
	Local TheEnd
	Local E:TJCREntry
	Local BT:TStream = ReadFile(fil$)
	Repeat
	e = New TJCREntry
	e.mainfile = fil
	E.PVars = New StringMap ' Must be present, some TAR values will be put in it, but they will not have that much value. ;)
	E.Storage = "Store"     ' TAR does not support compression, so always deal this as "Store"
	E.FileName = rs(bt,100); 
	For Local k$=EachIn(["MODE","UID","GID"])
		MapInsert E.PVars,"TAR."+k,rs(bt,8)
		Next
	e.size = o2d(rs(bt,12))
	e.compressedsize = e.size
	If e.size<0 Return ret
	MapInsert E.PVars,"TAR.MTIME",rs(bt,12)
	MapInsert E.PVars,"TAR.CHECKSUM",rs(bt,8)
	MapInsert E.PVars,"TAR.TYPEFLAG","$"+Right(Hex(ReadByte(Bt)),2)
	MapInsert E.PVars,"TAR.LINKNAME",rs(bt,100)
	MapInsert e.pvars,"TAR.MAGIC",rs(bt,6)
	MapInsert E.PVars,"TAR.VERSION",rs(bt,2)
	MapInsert e.pvars,"TAR.UNAME",rs(bt,32)
	MapInsert e.pvars,"TAR.GNAME",rs(bt,32)
	MapInsert e.pvars,"TAR.DEFMAJOR",rs(bt,8)
	MapInsert e.pvars,"TAR.DEFMINOR",rs(bt,8)
	MapInsert e.pvars,"TAR.PREFIX",rs(bt,155)
	MapInsert e.pvars,"TAR.?????",rs(bt,12) 'Repeat Print "===" Until ReadByte(bt)<>0
	e.offset = StreamPos(bt)	
	MapInsert entries,Upper(e.filename),E ' This must come last in case of the ustar extention.
	theend =  e.offset+e.size>=StreamSize(bt)
	'Print "Next: "+Int(e.offset+e.size)
	Local c=0 ' debug
	Local b
	If Not theend SeekStream bt,e.offset+e.size
	b = ReadByte(bt)
	While Not b
		c:+1; 
		If Eof(bt) Return ret
		b = ReadByte(bt)
		Wend
	'Print c+" NUL bytes > "+b+" > "+Chr(b)
	SeekStream bt,StreamPos(bt)-1
	Until theend
	Return ret
	End Method

End Type

New DRV_TAR

