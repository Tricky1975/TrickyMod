Strict

Rem

This is an experimental driver for reading ZIP files.
This module itself can only analyse the ZIP file's contents.
It is not able to read any of the compression methods used within zip.

Now I am interested in some help with implementing the 'Deflate' algorithm. 
It seems to be much like zlib, but there appear to be some significant differences in the headers of zlib and the zip-deflate, not making them 100% compatible.
I do not care about the original Implode and Shrink methods ZIP originally used. Modern ZIPPERS never use these any more and modern unZIPpers only support them for backward compatibility reasons.

At this moment I am NOT interested in supporting encrypted zip files! Maybe somewhere in the future.

Also JCR6 itself does not have support for adding folders. It just stores stuff with full path names. ZIP does have this support (and can therefore contain empty folders)
JCR6 will just ingore these.

End Rem

Import tricky_units.altreadint
Import jcr6.jcr6main

MKL_Version "",""
MKL_Lic     "",""

Rem
bbdoc: When this has been set to true, you can see all kinds of errors and warnings. Only for debugging purposes.
End Rem
Global jcr_zip_chat = False


Private
Function ZipReadString(F:TStream)
	Local l = altreadint(f,2)
End Function

Function zipsay(msg$)
If jcr_zip_chat Print "ZIP: "+msg
End Function

Type EndOfDirIndexType
	Field Signature
	Field DiskNum
	Field DiskStart
	Field CentDirRecs
	Field Size
	Field Offset
	Field Comment$
End Type
	
Function GetEndOfDirIndex:endofdirindextype(f:TStream)
	' Searching for index
	Local c=0
	Local want[] = [$50,$4b,$05,$06]
	Local found[] = New Int[Len want]
	Local x,ok	
	' I know there should be a faster method to do this.
	Repeat
		x = ReadByte(f)
		If x=want[c]
			found[c]=x
			c:+1
		Else
			c=0
		EndIf
		If Eof(f) 
			zipsay("EOF encountered without finding a proper zip index! This file ain't a ZIP file I guess.")
			Return
			EndIf
		ok=True
		For Local ci=0 Until Len want ok=ok And found[ci]=want[ci] Next			
	Until c=Len(want) And ok
	' Reading the index
	Local ret:endofdirindextype = New endofdirindextype
	ret.signature = $06054b50
	ret.disknum = altreadint(f,2)
	ret.diskstart = altreadint(f,2)
	ret.CentDirRecs = altreadint(f,2)
	ret.size = altreadint(f,4)
	ret.offset = altreadint(f,4)
	ret.comment = zipreadstring(f)
	Return ret
End Function

Type DRV_ZIP Extends DRV_JCRDIR
	Method Name$()
		Return "ZIP"
	End Method

	Method Recognize(fil$)
		Local st:TStream = ReadFile(fil)
		If Not st zipsay("Sorry! I could not open "+fil+" for being a zipfile analysis!") Return
		Local GI = GetEndOfDirIndex(st)<>Null
		CloseStream st
		Return gi	
	End Method
	
	Method Dir:TJCRDir(fil$)
		Local st:TStream = ReadFile(fil)
		If Not st zipsay("Sorry! I could not open "+fil+" for directory analysis!") Return
		Local EOCD:endofdirindextype = getendofdirindex(st)
		If Not eocd zipsay("ERROR! Is this really a zip file: "+fil) Return
		zipsay fil
		zipsay "eocd.sig = "+Hex(eocd.signature)
		zipsay "eocd.disknum = "+eocd.disknum
		zipsay "eocd.diskstart = "+eocd.diskstart
		zipsay "eocd.centdirrecs = "+eocd.centdirrecs
		zipsay "eocd.offsize = "+eocd.offset
		zipsay "eocd.comment = "+eocd.comment
	End Method

End Type

New DRV_ZIP


