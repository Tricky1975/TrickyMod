Rem
        GALE_GameVar.bmx
	(c) 2012, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2012, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.07.12

End Rem

' History
' 11.11.16 - Initial Version
' 12.03.31 - Moved to GALE


Import Gale.maxlua4gale
ImPoRt Tricky_UNITS.GameVars

Private
Type LUA_GameVar  ' BLD: Object Var\n\nThis contains the variables of the game.\nThese variables are pretty important. While LUA has its own variable system, it must be noted that all variables only live inside the script they are declared in. They have no power whatsoever in other scripts. The variables here are able to communicate with all scripts in the entire game and even some system features respond to them (read for that the system documentation)\n

	Method D(K$,V$) ' BLD: Defines a variable.\n\n<pre>Var.D("$NAME","Jeroen")\na = Var.C("$NAME") -- will put "Jeroen" in lua variable a</pre>
	VarDef K,V
	End Method

	Method C$(K$) ' BLD: Retuns the value of a variable<br><b>NOTE:</b>The returned variable will always be a string. When you need it to be numeric you can do that with Sys.Val()
	Return VarCall(K)
	End Method

	Method S$(St$) ' BLD: Will automatically fill out all vars in a given string and return that.<pre>Var.D("$NAME","Jeroen")\na = Var.S("My name is $NAME") -- Lua variable a will now contain 'My name is Jeroen'</pre>\n\n<b>IMPORTANT NOTE:</b> It must be noted that the system sees no diffrence between text and variables. As soon as it recognizes a variable it will start replacing. That's why I prefer to start all my vars with $ (like in php). Sometimes I another char that put itself apart. This way you can prevent a lot of misery.\n\nOh yeah, and the variable names are CASE SENISTIVE!!
	Return VarStr(St)
	End Method
	
	Method Clear(K$) ' BLD: Deletes a variable
	VarClear K
	End Method
	
	Method ClearAll(K) ' BLD: Delets all variables
	VarClearAll
	End Method
	
	Method Count() ' BLD: Returns the number of variables
	Return VarCount()
	End Method
	
	Method Key$(i) ' BLD: Returns the key on a specific index (better not to use this function unless you know what you are doing, though it's not likely to cause any harm with this) :)
	Return varkey(i)
	End Method
	
	Method Got(k$) ' BLD: returns 1 if a var exists 0 if it doesn't.
	Return MapContains(VarMap(),k)
	End method

	End Type
	
Public

G_LuaRegisterObject New LUA_GameVar,"Var"
