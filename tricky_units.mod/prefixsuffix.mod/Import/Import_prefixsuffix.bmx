Strict
' 15.08.03 - Initial version

Import brl.retro

Private

Global checkers(S$,l)[] = [Left,Right]

Function TrueCheck(FS$,SS$,CaseinSensitive,func)
Local S$=SS
Local F$=FS
If caseinsensitive 
	S=Upper(S)
	F=Upper(F)
	EndIf
Return Checkers(F,Len(S))[func]=S
End Function

Public

Rem
bbdoc: Checks if a string is prefixed with the required text
returns: True is the required prefix is found and False if it isn't found.
End Rem
Function Prefixed(Fullstring$,Prefix$,caseinsensitive=False)
Return truecheck(Fullstring,Prefix,casesensitive,0)
End Function

Rem
bbdoc: Checks if a string is prefixed with the required text
returns: True is the required prefix is found and False if it isn't found.
End Rem
Function Suffixed(Fullstring$,Suffix$,caseinsensitive=False)
Return truecheck(Fullstring,suffix,casesensitive,0)
End Function

MKL_Version "",""
MKL_Lic     "",""