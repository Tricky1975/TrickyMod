Rem
  SpecialChars.bmx
  
  version: 16.05.14
  Copyright (C) 2015, 2016 Jeroen P. Broks
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
Rem
/* 
  Special Characters

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



Version: 15.07.27

End Rem
Import tricky_units.gamevars

Rem
bbdoc: Sets all special tags to chars in the GameVars. These vars must of course be registered before this function can be used.
about: The list of characters is not yet complete. More characters will be added over time.
End Rem
Function DefineSpecialChars()
' -- e
VarDef "<eecu>" ,Chr(233)
VarDef "<euml>" ,Chr(235)
VarDef "<egrv>" ,Chr(232)
VarDef "<ecir>" ,Chr(234)
VarDef "<ecirc>",Chr(234)
' -- a
VarDef "<agrv>" ,Chr(224)
VarDef "<aecu>" ,Chr(225)
VarDef "<acir>" ,Chr(226)
VarDef "<acirc>",Chr(226)
VarDef "<auml>" ,Chr(227)
VarDef "<aswe>" ,Chr(229)
VarDef "<ae>"   ,Chr(230)
' -- c cedille
VarDef "<cced>",Chr(231)
' -- i
VarDef "<igrv>" ,Chr(236)
VarDef "<iecu>" ,Chr(237)
VarDef "<icir>" ,Chr(238)
VarDef "<icirc>",Chr(238)
VarDef "<iuml>" ,Chr(239)
' -- n with ~
VarDef "<nesp>",Chr(241)
' -- o
VarDef "<ogrv>" ,Chr(242)
VarDef "<oecu>" ,Chr(243)
VarDef "<ocir>" ,Chr(244)
VarDef "<ocirc>",Chr(244)
VarDef "<ouml>" ,Chr(246)
VarDef "<oe>  " ,Chr(156)
' -- u
VarDef "<ugrv>" ,Chr(249)
VarDef "<uecu>" ,Chr(250)
VarDef "<ucir>" ,Chr(251)
VarDef "<ucirc>",Chr(251)
VarDef "<uuml>" ,Chr(252)
' -- Capital A
VarDef "<Agrv>",Chr(192)
VarDef "<Aecu>",Chr(193)
VarDef "<Acir>",Chr(194)
VarDef "<Auml>",Chr(196)
VarDef "<Aswe>",Chr(197)
VarDef "<AE>"  ,Chr(198)
' -- Captial C Cedille
VarDef "<Cced>",Chr(199)
' -- Capital E
VarDef "<Egrv>",Chr(200)
VarDef "<Eecu>",Chr(201)
VarDef "<Ecir>",Chr(202)
VarDef "<Euml>",Chr(203)
' -- Capital I
VarDef "<Igrv>",Chr(204)
VarDef "<Iecu>",Chr(205)
VarDef "<Icir>",Chr(206)
VarDef "<Iuml>",Chr(207)
' -- Capital N with ~
VarDef "<Nesp>",Chr(209)
' -- Capital O
VarDef "<Ogrv>",Chr(210)
VarDef "<Oecu>",Chr(211)
VarDef "<Ocir>",Chr(212)
VarDef "<Ouml>",Chr(214)
VarDef "<Odan>",Chr(216)
VarDef "<OE>"  ,Chr(140)
VarDef "<Ugrv>",Chr(217)
VarDef "<Uecu>",Chr(218)
VarDef "<Ucir>",Chr(219)
VarDef "<Uuml>",Chr(220)
' -- beta or german "ringel s"
VarDef "<beta>",Chr(223)
End Function

MKL_Version "Tricky's Units - SpecialChars.bmx","16.05.14"
MKL_Lic     "Tricky's Units - SpecialChars.bmx","ZLib License"
