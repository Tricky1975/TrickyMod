Rem
  altreadint.bmx
  Alt Read Int
  version: 16.03.15
  Copyright (C) 2016 Jeroen P. Broks
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

Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - altreadint.bmx","16.03.15"
MKL_Lic     "Tricky's Units - altreadint.bmx","ZLib License"


Rem
bbdoc: Can be used with the AltReadInt() function to denote it has to be read as LittleEndian (default setting)
End Rem
Const ALR_Little:Byte = 0

Rem
bbdoc: Can be used with the AltReadInt() function to denote it has to be read as BigEndian
End Rem
Const ALR_Big:Byte = 1

Private

Global ario


Function s2h$(f:TStream,bytes:Byte,endian:Byte)
Local H$ 
Local b,bh$
For Local i=1 To bytes
	ario:+1
	b = ReadByte(f)
	bh$ = Right(Hex(b),2)
	Select endian
		Case ALR_Little
			h = bh + h
		Case ALR_big
			h:+bh
		Default
			Throw "Unknown endian type ("+endian+")"
		End Select
	Next
h = "$"+h	
Return h
End Function

Public

Function resetario(v=0) ario=v End Function


Rem
bbdoc: Reads an integer from a string based on the number of bytes you want to read
about: This routine has been made, because BlitzMax has only a few kinds of setups that can be read, but some data files were never setup for this and require some setting BlitzMax does not support. Thus this simple function.<br>Please note you can give up any number of bytes you want, but going past the length a BlitzMax integer uses (currently 4 bytes) will cause some bad behavior.
End Rem
Function AltReadInt(f:TStream,Bytes:Byte,Endian=ALR_Little)
Return s2h(f,bytes,endian).toint()
End Function


Rem
bbdoc: Same as AltReadInt, but then for Long types. (limit here is 8 bytes)
End Rem
Function AltReadLong:Long(f:TStream,Bytes:Byte,Endian=ALR_Little)
Return s2h(f,bytes,endian).tolong()
End Function
