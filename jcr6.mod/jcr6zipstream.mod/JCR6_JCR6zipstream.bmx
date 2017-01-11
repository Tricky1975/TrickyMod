Strict

Import jcr6.jcr6main
Import koriolis.zipstream



copycompdriver "Store","zipped"


Type DRV_ZIPSTREAM
	Method Recognize(fil$)
		Local Test:TStream = ReadFile("zip::"+fil+"//JCR6/index")
		Local ret = test<>nul
		CloseFile test
		Return ret
	End Method
		
	Method Dir:TJCRDir(fil$) Abstract
		Local ret:TJCRDir = New TJCRDir
		JCR6_ReadIndex ret,"zip::"+fil+"//JCR6/index",fil,True,True,"PKZIP"
	End Method
	
	Method Name$() 
		Return "PKZIP"
	End
	
	Method INE$(N$,r$)
		Return "zip::"+r+"//"+N
	End

     End Type

New ZIPSTREAM