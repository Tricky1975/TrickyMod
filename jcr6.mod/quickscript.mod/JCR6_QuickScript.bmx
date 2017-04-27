Rem
        JCR6_QuickScript.bmx
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.04.27
End Rem
Strict
Import jcr6.jcr6main

MKL_Version "JCR6 - JCR6_QuickScript.bmx","17.04.27"
MKL_Lic     "JCR6 - JCR6_QuickScript.bmx","Mozilla Public License 2.0"

Const chkline:String = "::JCR6_QUICKSCRIPT::"


Type DRV_QuickScript Extends DRV_JCRDIR
	Method Name$()
		Return "QuickScript"
	End Method

	Method Recognize(fil$)
		Local BT:TStream = OpenFile(fil)
		If Not BT Return
		Local chk$ = Trim(Upper(ReadLine(BT)))
		CloseFile BT
		Return chk = chkline
	End Method
	
	Method Dir:TJCRDir(fil$)
		Local ret:TJCRDir = New TJCRDir
		Local BT:TStream = OpenFile(fil)
		If Not BT Return
		Local chk$ = Trim(Upper(ReadLine(BT)))	
		If chk<>chkline 
			CloseFile BT
			Return
		EndIf	
		Local ln=1
		While Not Eof(BT)
			ln:+1
			Local l$ = Trim(ReadLine(BT))
			If l And Chr(l[0])=":" 
				Local p = l.find(" ")
				Local c$,a$
				If p>-1
					c = l[..p]
					a = l[p+1..]
				Else
					c = l
					a = ""
				EndIf
				Select Upper(c)
					Case ":J",":JCR"
						If (Not ExtractDir(a)) And ExtractDir(fil) a=ExtractDir(fil)+"/"+a
						JCR_AddPatch ret,JCR_Dir(a)
					Case ":P",":PRINT"
						Print a
					Case ":C",":COMMENT"
						Local i=0
						Local h$
						Repeat
							h=Upper("QS"+Hex(i))
							i:+1
						Until Not MapContains(ret.Comments,h)
						MapInsert ret.comments,h,Replace(a,"\n","~n")
					Default
						Print "Unknown command "+c+" in line #"+ln+" of quick script "+fil						
				End Select
			EndIf
		Wend
		CloseFile BT
		Return ret:TJCRDir
	End Method

    End Type

New DRV_QuickScript
