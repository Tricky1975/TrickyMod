Rem
bbdoc: Opens a file for appending
End Rem
Function AppendFile:TStream(file$)
Local Ret:TStream = OpenFile(file$)
SeekStream(ret,StreamSize(ret))
Return ret
End Function

