Rem
  CallBack.bmx
  CallBack
  version: 17.10.14
  Copyright (C) 2017 Jeroen P. Broks
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
End Rem
Strict


Rem

	This is just a quick setup to quickly set up a callback sequence.
	It's originally designed for usage with MaxGUI, but I guess you can use it with any kind of engine.
	
End Rem

Import tricky_units.StringMap

MKL_Version "Tricky's Units - CallBack.bmx","17.10.14"
MKL_Lic     "Tricky's Units - CallBack.bmx","ZLib License"

Private
Type TCallBackFunction
	Field Cfg:StringMap = New StringMap
	Field f(p:StringMap)
End Type

Public

Rem
bbdoc: Type used for callback functions
End Rem
Type TCallBack
	Field M:Tmap = New tmap
End Type


Rem
bbdoc: function to add a callback
about: From can be the gadget calling this function, func is the function being called, a stringmap is used for parameters that may be needed. The parameters object can be either a stringmap containing all parameters or a string containing the parameters like "name=Jeroen;gender=male;DOB=1975"
returns: Nothing
End Rem
Function AddCallBack(CB:TCallBack,From:Object,func(p:StringMap),parameters:Object=Null)
	Local CBF:Tcallbackfunction = New tcallbackfunction
	cbf.f=func
	If String(parameters)
		Local uc=0
		For Local a$=EachIn String(parameters).split(";")
			Local p = a.find("=")
			Local k$,v$
			If P<=0 
				k="?"+uc; uc:+1
				v=a[p+1..]
			Else
				k=a[..p]
				v=a[p+1..]
			EndIf
			MapInsert cbf.cfg,k,v
		Next
	ElseIf StringMap(parameters)
		cbf.cfg = StringMap(parameters)
	EndIf	
	MapInsert cb.M,from,cbf
End Function

Rem 
bbdoc: Same as AddCallBack, but now for integer numbers as from. This can be handy when you work with pull down menus
End Rem
Function NumAddCallBack(CB:Tcallback,from,func(p:StringMap),parameters:Object=Null)
	addcallback CB,"$"+Hex(from),func,parameters
End Function


Rem
bbdoc: Perform the callback
returns: Nothing if succesful, when an error occurs the error message is returned.
End Rem
Function CallBack$(CB,from:Object)
	Local cbf:tcallbackfunction = tcallbackfunction(mapvalueforkey(cb.m,from))
	If Not cbf Return "Requested callback function not found!"
	cbf.f cbf.cfg
End Function

Rem
bbdoc: Same as CallBack, but now with the numberic variant
End Rem
Function NumCallBack$(CB,From)
	Return CallBack(CB,"$"+Hex(from))
End Function	
	
			
	
	

	

