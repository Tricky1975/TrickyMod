Rem
  Tree.bmx
  
  version: 16.06.11
  Copyright (C) 2012-2015, 2016 Jeroen P. Broks
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


' Updates
' 12.03.08 - Updated by Tricky
'            = Deprecated the old CreateTree (which is now CreateTree1), may be removed in future versions
'            = Created new CreateTree function (which is faster and more stable)
'            = Created FCreateTree function (which uses a tempfile and returns its stream variable, in stead of using a memory buffer)
'              This appeared needed as the MacOS Console appears to have very little memory at its dispaosal
'              causing programs with large Tree calls to crash with a "Bus Error" (behavior in Windows and Linux unknown).
' 12.04.15 - Updated by Tricky
'            = I was wrong on the memory shortage on the 'Bus Error', it was just a tiny bug elsewhere in the code, which is nwo fixed. the FCreateTree function does remain for whoever needs it ;)
' 12.07.29 - Updated by Tricky
'            = Turned into a BlitzMax module
' 13.05.27 - = Fixed the 'double_mkl' mistake
'            = License became zLib in stead of MPL
' 14.02.04 - Lots of programs appeared to be crashing. Trying out some things, that could work as a fix... (hopefully, as it's not clear where the evil lies)
' 14.06.21 - Oops, I left the debugger on. Turned it off ;)
' 16.06.11 - Adepted for BlitzMax NG

Strict

Import brl.retro
Import maxgui.drivers

Import tricky_units.MKL_Version

MKL_Version "Tricky's Units - Tree.bmx","16.06.11"
MKL_Lic     "Tricky's Units - Tree.bmx","ZLib License"

Private

Const MaxLayer=100
Global DirLayer$[MaxLayer+1]
Global DirLastFile$[MaxLayer+1]
Global Layer=0


Function FullDir$()
Local Ret$ = ""
Local Ak
For Ak=1 To Layer
	Ret:+DirLayer[Ak]+"/"
	Next
Return Ret
End Function

Public


Function CreateTree1:TList(Dir$="")   ' Older version..... as of version 12.03.08 this function is deprecated (too slow)
Local Ret:TList = CreateList()
Local File$
Local Ak
Local CurDir$ = CurrentDir()
?bmxNG
Local BD:Byte Ptr
?Not bmxNG
Local BD
?
Local FFN$
Local F$
If Dir<>"" Then ChangeDir Dir
Layer=0
For Ak=0 To MaxLayer
	DirLayer[Ak]=""
	DirLastFile[Ak]=""
	Next
BD = ReadDir(CurrentDir())
Repeat
File = NextFile(BD)
While File="" And Layer<>0
	CloseDir BD
	Layer:-1
	BD=ReadDir(CurrentDir()+"/"+FullDir())
	While F<>DirLastFile[Layer]
		F=NextFile(BD)
		Wend
	file=NextFile(BD)
	Wend
If File="" And Layer=0 Then Exit
If Left(File,1)<>"." Then
	FFN = FullDir()+File
	If FileType(FFN)=1 Then ListAddLast Ret,FFN
	If FileType(FFN)=2 And Layer<MaxLayer Then
		DirLastFile[Layer] = File
		Layer:+1
		DirLayer[Layer] = File
		CloseDir BD
		BD = ReadDir(CurrentDir()+"/"+FFN)
		EndIf
	EndIf
Forever
ChangeDir(CurDir)
SortList Ret
Return Ret
End Function


Rem
bbdoc: Analysis the directory tree of a folder and stores all files in a TList containing all file names in strings.
about: This function just adds the files as they pass through. When you set the 'Sort' parameter, all files will be put into alphabetic order
End Rem
Function CreateTree:TList(Dir$="",Sort=False,allowhidden=False)
Local Debug = 0
Local Ret:TList = New TList
Local PDirs:TList 
Local FDirs:TList = New TList
Local CDir$ = CurrentDir()
?bmxNG
Local BD:Byte Ptr
?Not bmxNG
Local BD
?
Local F$,D$,SD$
If Dir 
	If FileType(dir)<>2 
	   Print "WARNING! Requested dir "+dir+" does not seem to be a directory I can tree."
	   Return Ret  ' If dir doesn't exist, just return an empty TList
	   EndIf
	ChangeDir(Dir)
	EndIf
ListAddLast FDirs,"./"
Repeat
PDirs = FDirs
FDirs = New TList
If debug Print "New list with "+CountList(Pdirs)+" entries found"
For D$=EachIn PDirs
	SD=Replace(D,"./","")
	If debug Print "Analysing dir:    "+D+"   ==> "+SD
	BD = ReadDir(D)
	Repeat
	F = NextFile(BD)
	If Not F Exit
	If (Left(F,1)<>"." Or (allowhidden)) And F<>"." And F<>".."
		If FileType(SD+F)=1 ListAddLast Ret,SD+F; If Debug Print "Found file: "+SD+F
		If FileType(SD+F)=2 ListAddLast FDirs,SD+F+"/"
		EndIf
	Forever
	CloseDir BD
	Next
Until ListIsEmpty(FDirs)
If Sort SortList Ret
ChangeDir CDir
Return Ret
End Function


' Uses files to store the results and not a memory buffer, in case you're using a low memory environment.
Function FCreateTree:TStream(Dir$="",File$)
Local Debug = 0
Local Ret:TStream = WriteStream(File) If Not Ret Return Null
Local PDirs:TStream 
Local FDirs:TStream = WriteStream(File+".fdir")
Local CDir$ = CurrentDir()
?bmxng
Local BD:Byte Ptr
?Not bmxng
Local BD
?
Local F$,D$,SD$
Local NotEmpty
Local FCount:Long=0
If Dir ChangeDir(Dir)
WriteLine FDirs,"./"
CloseFile FDirs
Repeat
RenameFile File+".fdir",File+".pdir"
'PDirs = FDirs
'FDirs = New TList
PDirs = ReadStream(File+".pdir")
FDirs = WriteStream(File+".fdir"); NotEmpty=False
If debug Print "New list found"
'For D$=EachIn PDirs
While Not Eof(PDirs)
	D=ReadLine(PDirs)
	SD=Replace(D,"./","")
	BD = ReadDir(D)
	If debug Print "Analysing dir:    "+D
	Repeat
	F = NextFile(BD)
	If Not F Exit
	If Left(F,1)<>"."
		If FileType(SD+F)=1 WriteLine Ret,SD+F; FCount:+1 If Debug Print Right("     "+Fcount,5)+"> Found file: "+SD+F
		If FileType(SD+F)=2 WriteLine FDirs,SD+F+"/"; NotEmpty=True
		EndIf
	Forever
	CloseDir BD
	Wend
CloseFile FDirs
CloseFile PDirs	
Until Not notempty 'ListIsEmpty(FDirs)
'If Sort SortList Ret   ' Not possible in this setup.
DeleteFile File+".fdir"
DeleteFile File+".pdir"
CloseFile Ret
ret = ReadFile(File)
ChangeDir CDir
Return Ret
End Function




