Rem

The source code of this module is ONLY available in order to get some modules and games of mine using Anna compiled.
It is not allowed to use Anna yourself, and any attempts to do so can lead to Anna blocking your from further access.

End Rem


Strict

	Import tricky_units.StringMap
	Import tricky_units.Listfile

Private
	Const site$ = "http::utbbs.tbbs.nl/Game.php"
Public

	Function Anna_Request:StringMap(query)
		Local l:TList =  Listfile(site+"?"+query)
		Local reading,closed
		Local ret = New StringMap
		Local prev$,dta$[]
		For ln = EachIn l
			If reading 
				dta=ln.split(":")
				If Len(dta)>2
					If dta[0]="BYEBYE" And dta[1]="SEEYA"
						reading = False
						closed  = True
					Else
						MapInsert ret,dta[0],dta[1]
					EndIf	
				Else
					Print "WARNING! Invalid instruction given by Anna! >> "+ln	
				EndIf
			EndIf
			If ln="HANDSHAKE" And prev="GREET:ANNA"
				reading=True
			EndIf
			prev = ln
		Next	
		Return ret
	End Function
	
