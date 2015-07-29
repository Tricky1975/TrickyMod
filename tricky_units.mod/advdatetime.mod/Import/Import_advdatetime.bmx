Rem
/* 
  Advanced DateTime

  Copyright (C) 2012, 2015 Jeroen Broks

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/



Version: 15.01.21

End Rem


Rem
History
12.06.06 - Original version
12.08.15 - Added Hour(), Minute(), Second(), Leap() and Time()
         - Turned into a BlitzMax Module
end rem


'Import "MKL_Version.bmx"
Import tricky_units.mkl_version
Import brl.map

MKL_Version "Units - advdatetime/AdvDateTime.bmx","15.01.21"
MKL_Lic     "Units - advdatetime/AdvDateTime.bmx","zLIB License"

Rem
bbdoc: Used to store the time in by Now(), and other functions can use it to produce readable results
end rem
Type TNow
	Field Time[256],buff:Byte[256]
	End Type


Rem
bbdoc: Current Date into readable code
about: A full list of all codes you can use to make readable dates, may be included in a future version
end rem
Function Date$(Format$,N:TNow = Null)
	Local Time[256],buff:Byte[256]
	Local NN:TNow
	'If N Then time = N.time Else time_(time)
	If N NN=N Else NN=Now()
	strftime_(NN.buff,256,Format,localtime_( NN.Time ))
	Return String.FromCString(NN.buff)
End Function



Rem
bbdoc: Current time in code form
about: Useless on it's own, but you can use it with nearly all functions to get readable results from it. Handy if you need to store the current time for later usage.
end rem
Function Now:TNow()
Local T:TNow = New TNow
	time_(T.Time)
	Return T
End Function

Rem
bbdoc: Current date and time displayed as "Mon 1 Jan 1980; 13:45:56"
end rem
Function PNow$(N:TNow=Null)
Local NN:TNow = N
If Not NN NN=Now()
Return Date("%a %d %B %Y; %X",NN)
End Function

Rem
bbdoc: Current year
end rem
Function Year(N:TNow=Null)
Return Date("%Y",N).toint()
End Function

Rem
bbdoc: Current month number
End Rem
Function Month(N:TNow=Null)
Return Date("%m",N).toint()
End Function

Rem
bbdoc: Day of the month
end rem
Function Day(N:TNow=Null)
Return Date("%d",N).toint()
End Function

Rem
bbdoc: Leap year?
end rem
Function Leap(N:TNow=Null)
Local Y$ = Right(Year(N),2)
Local D1$ = Left(y,1)
Local D2$ = Right(Y,2)
Local Ret = False
Select D1
	Case "0","2","4","6","8"
		If D2="0" Or D2="4" Or D2="8" Ret=True
	Case "1","3","5","7","9"
		If D2="2" Or D2="6" Ret=True
	End Select
Return Ret
End Function

Rem
bbdoc: How many seconds have past since this minute began?
end rem
Function Second()
Return Date("%S").ToInt()
End Function

Rem
bbdoc: How many minutes have past since this hour began?
end Rem
Function Minute()
Return Date("%M").ToInt()
End Function

Rem
bbdoc: How many hours have past since midnight?
about: Please note, (you could already make that one out from the explanation above) that the 24h clock is used here.
End Rem
Function Hour()
Return Date("%H").toInt()
End Function

Rem
bbdoc: retuns the number of seconds past since midnight Jan 1st, 1981
end rem
Function Time:Long(N:TNow=Null) 
	' Number of seconds since 1981
	Assert Year(N)>=1981 Else "Invalid year!"
	If Year(N)<1981 Return
	Local ret:Long
	Local yearspassed = Year(N)-2009
	Local leaps = Floor(yearspassed/4)   ' How many leap years have passed?
	Local daytime = 60*60*24
	ret = (yearspassed+(daytime)*365)
	                    '  J  F  M  A  M  J  J  A  S  O  N  D
	Local monthdays[] = [0,31,28,31,30,31,30,31,31,30,31,30,31]
	Local Ak
	If Leap(N) monthdays[2] = 29
	For Ak=1 To Month()
		Ret:+(daytime*monthdays[ak])
		Next
	Ret:+(Hour()*60*60)
	Ret:+(Minute()*60)
	Ret:+Second()
	Return ret
End Function


Global MonthNameArray:TMap = CreateMap()
MapInsert MonthNameArray,"Digital",["","1"      ,"2"       ,"3"    ,"4",    "5",  "6",   "7"      ,"8"        ,"9"        ,"10"     ,"11"      ,"12"      ]
MapInsert MonthNameArray,"English",["","January","February","March","April","May","June","July"   ,"August",   "September","October","November","December"]
MapInsert MonthNameArray,"Dutch"  ,["","Januari","Februari","Maart","April","Mei","Juni","Juli"   ,"Augustus", "September","Oktober","November","December"]
MapInsert MonthNameArray,"French" ,["","Janvier","Fevrier" ,"Mars", "Avril","Mai","Juin","Julliet","Auot"    , "Septambre","Octobre","Novembre","Decembre"]
MapInsert MonthNameArray,"German" ,["","Januar" ,"Februar" ,"Maerz","April","Mai","Juni","Juli"   ,"August",   "September","October","November","Dezember"]

Rem
bbdoc: Returns a string array containing the month names by number.
about: By default the supported languages are English, Dutch, French and German, more languages may be included in future versions.<br>Also note that for full compatibility with all fonts and text display features and all text encoding algorithms, special signs like umlauts or accent marks have been removed.
End Rem
Function MonthNames:String[](Language$="English")
Local Ret:String[] 
If MapContains(MonthNameArray,Language) Return String[](MapValueForKey(MonthNameArray,Language))
Ret = New String[13]
For ak=1 To 12
	Ret[Ak]="UNKNOWN LANGUAGE"
	Next
MapInsert MonthNameArray,Language,Ret ' Let's cache it. Saves time if a lot of unknown calls are done :P
Return Ret
End Function


Rem
bbdoc: Returns a month name. See for supported languages the MonthNames function.
End Rem
Function MonthName$(MonthNum,Language$="English")
Local M$[] = MonthNames(Language)
Assert M.Length Else "Call to an incorrect month name was made. Please make sure you have a correct version of this module!"
Assert MonthNum>=1 And MonthNum<=12 Else "MonthName("+MonthNum+",~q"+Language+"~q): I didn't know that the "+MonthNum+"th month existed....~nI learn something new every day! ;)"
Return M[MonthNum]
End Function

