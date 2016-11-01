Strict
Import brl.retro
Global lossen$[] = ["nul","een","twee","drie","vier", "vijf","zes","zeven","acht","negen"]
Global tientallen$[] = ["nul","tien","twintig","dertig","veertig","vijftig","zestig","zeventig","tachtig","negentig"]
Global tientottwintig$[]=["tien","elf","twaalf","dertien","veertien","vijftien","zestien","zeventien","achtien","negentien","twintig"]


Rem
bbdoc: Returns a number from 0 till 1000 in its Dutch name.
End Rem
Function NL_Cijfer$(a,trema=0)
	Local as$ = Right("00"+a,3)
	Local tr$[]=["en","en"]
	Local dg$[] = [Chr(as[0]),Chr(as[1]),Chr(as[2])]
	Local dgi[] = [as[0]-48,as[1]-48,as[2]-48]
	If a=1000 Return "duizend"
	If a=0 Return "nul"
	Local ret$
	If a<10 Return lossen[a]
	If a<20 Return tientottwintig[a-10]
	If dg[2] 'Lossen 
		ret = lossen[dgi[2]]
		If dgi[1] ret:+tr[trema And Right(lossen[dgi[2]],1)="e"]
		If dgi[2]=0 ret="" 
	EndIf
	If dgi[1] 'tiennen
		ret:+tientallen[dgi[1]]
	EndIf
	If dgi[0] 'honderden
		If dgi[0]=1 ret="honderd"+ret Else ret=lossen[dgi[0]]+"honderd"+ret
	EndIf	
	Return ret
End Function

Rem
bbdoc: Prints all numbers from 0 to 1000 to stdout as a stest
End Rem
Function NL_CijferTest()
	For Local i=0 To 1000
		Print i+"~t"+NL_Cijfer(i)
	Next
End Function

'NL_CijferTest