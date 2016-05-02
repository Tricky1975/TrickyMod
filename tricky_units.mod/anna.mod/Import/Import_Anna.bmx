Rem

The source code of this module is ONLY available in order to get some modules and games of mine using Anna compiled.
It is not allowed to use Anna yourself, and any attempts to do so can lead to Anna blocking your from further access.

The licenses of the games themselves do not matter. The Anna Module may only be used in unmodified versions of the game.
If you are going to modify the original game, all references to Anna must be removed or must at least not be called to.

(c) Jeroen Petrus Broks, 2016, all rights reserved!

End Rem


Strict

	Import tricky_units.StringMap
	Import tricky_units.Listfile

Private
	Const site$ = "http::utbbs.tbbs.nl/Game.php"
	
Public
	Rem
	bbdoc: NoDesc
	End Rem

	Function Anna_Request:StringMap(query$)
		Local l:TList = Listfile(site+"?"+query)
		Local reading,closed
		Local ret:StringMap = New StringMap		
		Local prev$,dta$[],ln$
		For Local utln$ = EachIn l
			ln = Trim(utln)
			Print ln
			If reading 
				dta=ln.split(":")
				If Len(dta)>=2
					If dta[0]="BYEBYE" And dta[1]="SEEYA"
						reading = False
						closed  = True
					Else
						MapInsert ret,dta[0],dta[1]
					EndIf	
				Else
					Print "WARNING! Invalid instruction given by Anna! >> "+ln	+" ("+Len(dta)+")"
				EndIf
			EndIf
			If ln="HANDSHAKE" And prev="GREET:ANNA"
				reading=True
			EndIf
			prev = ln
		Next	
		Return ret
	End Function
	
