Rem
  TrickyReadString.bmx
  
  version: 16.06.11
  Copyright (C) 2012, 2015, 2016 Jeroen P. Broks
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

' 15.01.21 - initial after original in 2012
' 16.06.11 - adepted for BlitzMax NG

Strict

Import brl.stream
Import brl.retro
Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - TrickyReadString.bmx","16.06.11"
MKL_Lic     "Tricky's Units - TrickyReadString.bmx","ZLib License"

Rem
bbdoc: Whenever an error happens, the message is in this string. It contains OK when nothing's wrong
End Rem
Global TrickyReadStringError$ 

Rem
bbdoc: Reads a string with a int prior to string containing the length of the string
End Rem
Function TrickyReadString$(BT:TStream)
TrickyReadStringError$ = "OK"
Local P = StreamPos(BT)
Local S = StreamSize(BT)
If P+4>S Then TrickyReadStringError$ = "Stream not long enough to read the string length"; Return ""
Local L = ReadInt(BT)
P = StreamPos(BT)
If P+L>S Then TrickyReadStringError$ = "Stream not long enough to read a string of "+L+" characters long ("+P+"/"+S+")"; Return ""
Return ReadString(BT,L)
End Function

Rem
bbdoc: Writes a string with a int containing the string length prior to the string
End Rem
Function TrickyWriteString$(BT:TStream,S$)
TrickyReadStringError$ = "OK"
WriteInt BT,Len(S)
WriteString BT,S
End Function


Rem
bbdoc: Writes a string terminated by null (as C does)
End Rem
Function NullWriteString(BT:TStream,S$)
TrickyReadStringError$ = "OK"
WriteString BT,S+Chr(0)
End Function

Rem
bbdoc: Reads a string terminated by null (as C does)
End Rem
Function NullReadString$(BT:TStream)
Local R$,X
TrickyReadStringError$ = "OK"
Repeat
X = ReadByte(BT)
If X=0 Exit
R:+Chr(X)
If Eof(BT) Exit
Forever
Return R
End Function
