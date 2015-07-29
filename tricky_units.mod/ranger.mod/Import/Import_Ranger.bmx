Rem
/* 
  Ranger

  Copyright (C) 2015 Jeroen P. Broks

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



Version: 15.04.19

End Rem
Import brl.math
Rem
bbdoc: Set up a range array for the For command. 
about: This command has been setup as BlitzMax only accepts constants For 'step' for reasons beyond my understanding, but it is highly annoying. You don't need to set up a negative step if the end value is lower than the start value.<p>I know this is very likely slower than doing this the regular way, however due to BlitzMax not accepting variables for steps, I was a bit forced to come up with this!
End Rem
Function ToRange[](start,eind,stap=1)
Local ret[]
Local steps = Ceil(Abs(eind-start)/Double(Abs(stap)))
ret = New Int[steps+1]
Local bs = Abs(stap)
Local value=start
If eind<start bs=-bs
Local ak
For ak=0 To steps
	ret[ak]=value
	value:+bs
	Next
Return ret
End Function

Rem
bbdoc: set up a range array for the For command in until style
End Rem
Function UntilRange[](start,eind,stap=1)
Local ret[]
Local steps = Floor(Abs(eind-start)/Double(Abs(stap)))
ret = New Int[steps]
Local bs = Abs(stap)
Local value=start
If eind<start bs=-bs
Local ak
For ak=0 Until steps
	ret[ak]=value
	value:+bs
	Next
Return ret
End Function
