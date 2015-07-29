Rem
/* 
  Path Finder

  Copyright (C) 2013, 2015 Jeroen P. Broks (based on the code by Patrick Lester)

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



Version: 15.05.20

End Rem

' 13.06.26 - First official Release
' 15.04.17 - Converted to the JCR6 units bundle (though it doesn't need JCR6) :)



Strict
'If you solely want to use this module, you may turn the import to the MKL_Version module, and the two lines starting with MKL_ into comments, as the module only uses it for version referrence other modules (or games written by me) can call on.
Import tricky_units.MKL_Version

MKL_Version "Units - PathFinder/PathFinder.bmx","15.05.20"
MKL_Lic     "Units - PathFinder/PathFinder.bmx","zLIB License"

Include "include/aStarLibrary.bmx"


'A Star Walk Engine Vars
Rem
bbdoc: This type should be used with the pathfinder commands
End Rem
Type PathFinderUnit 'Extends TBBType

	'Method New()
	'	Add(unit_list)
	'End Method

	'Method After:bbunit()
	'	Local t:TLink
	'	t=_link.NextLink()
	'	If t Return bbunit(t.Value())
	'End Method

	'Method Before:bbunit()
	'	Local t:TLink
	'	t=_link.PrevLink()
	'	If t Return bbunit(t.Value())
	'End Method

	Field ID, xLoc#, yLoc#, speed#, sprite
	Field pathAI, pathStatus, pathLength, pathLocation, pathBank:TBank = New TBank, xPath, yPath
	Field targetX, targetY, target:PathFinderUnit
	
	Field Success
End Type


Rem
bbdoc: BEFORE using ANY routine within this module at all this function variable must be set which tells PathFinder which areas are blocked and which are not. If you have multiple routines defining that it simply means you gotta redefine this variable. Simply create a function using X,Y for variables and define it to this var (without the () and parameters).
about: Pathfinder is used by the Kthura map system and sets this function automatically whenever an actor is required to walk. So if you use the Kthura system in your games, you should keep that in mind, if you are not a Kthura user, then don't bother and set this variable with your own blocking routines.
End Rem
Global PF_Block(X,Y)
Rem -- Kept for backwards setback possibilities if they would be required.
Private
Global PF:TPathFinder
Function walkability(X,Y)
	Return PF.Block(X,Y)
	End Function
Public
End Rem



Rem
bbdoc: Find the way.
End Rem
Function FindTheWay:PathFinderUnit(StartX#,StartY#,TargetX,TargetY,Speed=1)
Local Ret:PathFinderUnit = New PathFinderUnit
ret.xLoc = StartX
ret.yLoc = StartY
ret.speed = Speed
If FindPath(ret,TargetX,TargetY)<>1 Then 
	DebugLog "Warning! Finding the path has failed"
	Ret.Success=False
	Return Ret
	EndIf
Ret.Success=True
Return ret
End Function

Rem
bbdoc: Will put in the next coordinates into the the X# and Y# coordinates
End Rem
Function ReadWay(PFU:PathFinderUnit,X Var,Y Var)
CheckPathStepAdvance(PFU)
X = PFU.xPath
Y = PFU.yPath
End Function

Rem
bbdoc: How long is the path?
End Rem
Function LengthWay(PFU:PathFinderUnit)
Return PFU.PathLength
End Function

Rem
bbdoc: Will adjust X and Y in accordance of the current path position. When a path location is given that is wrong these values won't be altered
End Rem
Function ReadWaySpot(PFU:PathFinderUnit,Spot,X Var,Y Var)
If Spot>PFU.pathLength Return
If Spot<0 Return
X = ReadPathX(PFU:PathFinderUnit,Spot)
Y = ReadPathY(PFU:PathFinderUnit,Spot)
End Function
