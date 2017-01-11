Strict

Import jcr6.jcr6main
Import koriolis.zipstream

Private

copycompdriver "Store","zipped"


Type DRV_ZIPSTREAM Extends DRV_JCRDIR

	Method Recognize(fil$)
		DebugLog "Reading zip::"+fil+"//JCR6/index"
		Local Test:TStream = ReadFile("zip::"+fil+"//JCR6/index")
		Local ret = test<>Null
		If ret DebugLog "Zip succesfully read" Else DebugLog "This is not a zip, or it has no index. Either way, I must reject it"
		If ret CloseFile test		
		Return ret
	End Method
		
	Method Dir:TJCRDir(fil$)
		Local ret:TJCRDir = New TJCRDir
		JCR_ReadIndex ret,"zip::"+fil+"//JCR6/index",fil,True,True,"PKZIP",fil
		ret.neutralchangecheck = true
		Return ret
	End Method
	
	Method Name$() 
		Return "PKZIP"
	End Method
	
	Method INE$(N$,r$)
		Return "zip::"+r+"//"+N
	End Method
	
	Field NeutralizeChangeCheck = True

     End Type

New DRV_ZIPSTREAM