Import jcr6.jcr6main
Import tricky_units.prefixsuffix

MKL_Version "",""
MKL_Lic     "",""


Private
	Function wname$(n$) 
		'Print n[0..7]
		If n[0..7]="http://" n="http::"+n[7..]
		'Print n
		Return n
	End Function
	
	Function GetRead:TStream(file$)
		Local tr$
		Local fil$ = wname(file)
		If fil[0..6]="http::" 
			tr=fil
		Else
			If Not FileType(fil) Return
			tr=wname(Trim(LoadString(fil)))
			If tr.find("~n") DebugLog "<NL> found"; Return 
			If tr.find("~r") DebugLog "<CR> found"; Return 
			If tr[0..6]<>"http::" DebugLog tr[0..6]+"Not the prefix I wanted" Return
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
	
	Method Dir:TJCRDir(fil$)
		ret:TJCRDir = New TJCRDir
		Local e:TJCREntry
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
						e.filename = lc
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

