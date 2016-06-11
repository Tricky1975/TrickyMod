Rem
        JCR6_JCR6WebRead.bmx
	(c) 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.06.11
End Rem
' 16.03.21 - Initial version
' 16.06.11 - A few fixes for NG
Import jcr6.jcr6main
Import tricky_units.prefixsuffix

MKL_Version "JCR6 - JCR6_JCR6WebRead.bmx","16.06.11"
MKL_Lic     "JCR6 - JCR6_JCR6WebRead.bmx","Mozilla Public License 2.0"


Private
	Function wname$(n$) 
		'Print n[0..7]
		If n[0..7]="http://" n="http::"+n[7..]
		'Print n
		Return n
	End Function
	
	Function GetRead:TStream(fil$ Var)
		Local tr$
		fil$ = wname(fil)
		If fil[0..6]="http::" 
			tr=fil
		Else
			If Not FileType(fil) Return
			'tr=wname(Trim(LoadString(fil)))
			Local b:TStream = ReadFile(fil)
			tr = wname(Trim(ReadLine(b)))
			CloseFile b
			'If tr.find("~n") DebugLog "<NL> found"; Return 
			'If tr.find("~r") DebugLog "<CR> found"; Return 
			If tr[0..6]<>"http::" DebugLog tr[0..6]+"Not the prefix I wanted" Return
			fil=tr
		EndIf
		Local bt:TStream = OpenFile(tr)
		Local rl$
		Repeat		
		If Eof(bt) DebugLog "No WELCOME found on the net"; CloseFile bt; Return
		rl = Trim(Upper(ReadLine(bt)))
		DebugLog "Read line: "+rl
		Until rl="WELCOME:JCR6"
		If Trim(Upper(ReadLine(BT)))="HANDSHAKE:WEBDRIVE" Return bt Else DebugLog "Handshake not received"
		CloseFile bt
		End Function

Public

Type DRV_WebRead Extends DRV_JCRDIR
	Method Name$()
		Return "Web Collection"
	End Method

	Method Recognize(fil$)
		Local bt:TStream = getread(fil)
		Local ret = bt<>Null
		If bt CloseFile bt
		Return ret		
	End Method
	
	Method Dir:TJCRDir(file$)
		Local ret:TJCRDir = New TJCRDir
		Local e:TJCREntry
		Local fil$=file
		Local bt:TStream = getread(fil)
		Local l$,lc$,lp$,s
		Repeat
			l = Trim(ReadLine(BT))
			If l="GOODBYE:JCR6" Exit
			If l
				s=l.find(":")
				If s=-1 JCR_JAMERR("Invalid command in webread",fil,"N/A","Driver.WebRead.Dir") 
				lc = l[..s]
				lp = l[s+1..]
				Select Upper(lc)
					Case "COMMENT"
						Local t$,rt$
						Repeat
							rt = ReadLine(BT)
							If Trim(rt)="END" Exit
							If Eof(bt) Exit
							t:+rt+"~n"
						Forever
						MapInsert ret.Comments,lp,t
					Case "IMPORT"
						If JCR_Type(lp) JCR_AddPatch	ret,lp
					Case "REQUIRE"
						If JCR_Type(lp) 					
							JCR_AddPatch ret,lp 
						Else
							CloseStream bt
							JCR_JAMERR("Required file ~q"+fil+"~q not found",fil,"N/A","Driver.WebRead.Dir")
							Return
						EndIf
					Case "VAR"
						s = lp.find("=")
						If s=1
							Local vd$[] = lp.split("=")
							MapInsert ret.variables,vd[0],vd[1]
						EndIf
					Case "FILE","ENTRY"
						e = New TJCREntry
						MapInsert ret.entries,Upper(lp),e
						e.filename = lp
						e.storage = "Store" ' If not defined, "Store" will do
						e.mainfile = wname(fil)+lp
					Case "SIZE"
						If e e.size = lp.toint()
					Case "COMP","COMPRESSED","COMPRESSEDSIZE"
						If e e.compressedsize = lp.toint()
					Case "STORAGE"
						e.storage = lp
					Case "AUTHOR"
						e.author = lp
					Case "NOTES"
						e.notes = lp
					Default
						CloseStream bt
						JCR_JAMERR "Unknown command: "+lc,fil,"N/A","Driver.WebRead.Dir"	
						Return
				End Select
				If Eof(bt) Exit
			End If	
		Forever
		CloseStream bt		
		Return ret
	End Method

End Type

New DRV_WebRead

