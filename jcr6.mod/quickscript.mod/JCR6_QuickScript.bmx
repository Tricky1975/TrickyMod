Strict
Import jcr6.jcr6main

MKL_Version "JCR6 - JCR6_QuakePak.bmx","15.09.23"
MKL_Lic     "JCR6 - JCR6_QuakePak.bmx","Mozilla Public License 2.0"

Const chkline:String = "::JCR6_QUICKSCRIPT::"


Type DRV_QuickScript Extends DRV_JCRDIR
	Method Name$()
		Return "QuickScript"
	End Method

	Method Recognize(fil$)
		Local BT:TStream = OpenFile(file)
		If Not BT Return
		Local chk$ = Trim(Upper(ReadLine(BT)))
		CloseFile BT
		Return chk = chkline
	End Method
	
	Method Dir:TJCRDir(fil$)
		Local ret:TJCRDir = New TJCRDir
		Local BT:TStream = OpenFile(file)
		If Not BT Return
		Local chk$ = Trim(Upper(ReadLine(BT)))
		If chk<>chkline
		Return ret:TJCRDir
	End Method

    End Type

New DRV_QuickScript
