Strict
Import brl.streams
Import tricky_units.MKL_Version

MKL_Version "Append","INIT"
MKL_Lic     "Append","USE PROHIBITED UNTIL LICENSE HAS BEEN PROPERLY DEFINED! (Which will be soon)"


Rem
bbdoc: Opens a file for appending
End Rem
Function AppendFile:TStream(file$)
Local Ret:TStream = OpenFile(file$)
SeekStream(ret,StreamSize(ret))
Return ret
End Function

