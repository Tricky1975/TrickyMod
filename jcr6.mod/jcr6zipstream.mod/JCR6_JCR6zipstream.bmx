Strict

Import jcr6.jcr6main
Import koriolis.zipstream

Private

copycompdriver "Store","zipped"


Type DRV_ZIPSTREAM Extends DRV_JCRDIR

	Method Recognize(fil$)
		Local Test:TStream = ReadFile("zip::"+fil+"//JCR6/index")
		Local ret = test<>null
		CloseFile test
		Return ret
	End Method
		
	Method Dir:TJCRDir(fil$)
		Local ret:TJCRDir = New TJCRDir
		JCR6_ReadIndex ret,"zip::"+fil+"//JCR6/index",fil,True,True,"PKZIP",fil
	End Method
	
	Method Name$() 
		Return "PKZIP"
	End Method
	
	Method INE$(N$,r$)
		Return "zip::"+r+"//"+N
	End Method

     End Type

New DRV_ZIPSTREAM