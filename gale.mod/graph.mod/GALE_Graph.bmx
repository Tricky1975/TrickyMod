Rem
        GALE_Graph.bmx
	(c) 2012, 2015 2012.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem
/* 
  Quick Functions for Lua regarding Graphics settings

  Copyright (C) 2012 Jeroen P. Broks

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



Version: 13.12.26

End Rem
Import GALE.Main
Import brl.Graphics 

Rem
bbdoc: When set to true you can allow lua scripts to change the graphics mode. When set to false any requests from the Lua scripts will be ignored.
end Rem
Global AllowLuaSetGraph = True

Type LuaGraph  ' BLD: Object Graph\nThis object contains a few graph functions
	
	Method Set(Width,Height,Depth,Hz) ' BLD: Sets the graphics mode. Please note that the coder of the underlying engine may have blocked this feature for you. If so, this command will simply be ignored.
	If AllowLuaSetGraph Graphics Width,Height,Depth,Hz
	End Method
	
	Method Width() ' BLD: Current Screen Width
		Return GraphicsWidth()
		End Method
		
	Method Height() ' BLD: Current Screen Height
		Return GraphicsHeight()
		End Method
		
	Method CenterX() ' BLD: X position of the center of the screen
		Return GraphicsWidth()/2
		End Method
	
	Method CenterY() ' BLD: Y position of the center of the screen
		Return GraphicsHeight()/2
		End Method
		
	Method Close() ' BLD: End the graphics mode. Please note that this feature can be blocked to you by the underlying engine.
		If AllowLuaSetGraph EndGraphics
		End Method
		
	End Type
	
GALE_Register New LuaGraph,"Graph"
