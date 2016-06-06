Rem
  ArrayMerger.bmx
  Array Merger
  version: 16.06.06
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


MKL_Version "Tricky's Units - ArrayMerger.bmx","16.06.06"
MKL_Lic     "Tricky's Units - ArrayMerger.bmx","ZLib License"

Rem
bbdoc: merges int arrays
returns: merged array
End Rem
Function MergedIntArray[](A[],B[])
	Local ret:Int[] = New Int[Len(a)+Len(B)]
	Local idx=0
	Local v
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges long int arrays
returns: merged array
End Rem
Function MergedLongArray:Long[](A:Long[],B:Long[])
	Local ret:Long[] = New Long[Len(a)+Len(B)]
	Local idx=0
	Local v:Long
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges byte int arrays
returns: merged array
End Rem
Function MergedByteArray:Byte[](A:Long[],B:Long[])
	Local ret:Byte[] = New Byte[Len(a)+Len(B)]
	Local idx=0
	Local v:Byte
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges float arrays
returns: merged array
End Rem
Function MergedFloatArray:Float[](A:Float[],B:Float[])
	Local ret:Float[] = New Float[Len(a)+Len(B)]
	Local idx=0
	Local v:Float
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges double arrays
returns: merged array
End Rem
Function MergedDoubleArray:Double[](A:Double[],B:Double[])
	Local ret:Double[] = New Double[Len(a)+Len(B)]
	Local idx=0
	Local v:Double
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges object arrays
returns: merged array
End Rem
Function MergedObjectArray:Object[](A:Object[],B:Object[])
	Local ret:Object[] = New Object[Len(a)+Len(B)]
	Local idx=0
	Local v:Object
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret
End Function

Rem
bbdoc: merges string arrays
returns: merged array
End Rem
Function MergedStringArray$[](A$[],B$[])
	' Return String[](MergedObjectArray(A,B)) ' Must work, but I guess BlitzMax is bugged.
	Local ret$[] = New String[Len(a)+Len(B)]
	Local idx=0
	Local v$
	For v=EachIn(a) ret[idx]=v; idx:+1 Next
	For v=EachIn(b) ret[idx]=v; idx:+1 Next
	Return ret	
End Function
