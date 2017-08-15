Rem
  UPB_Dir.bmx
  
  version: 17.08.15
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

Import tricky_units.Tree
Import "UPB_Core.bmx"

Rem

	Note, this file only serves to make it possible to use this module properly if you don't want JCR in it.
	But as this routine and JCR would only conflict together, this file has been secured NOT to be usable when
	JCR6 portion of this module is active.
	
End Rem

Type UPB_Dir Extends UPB_DRIVER

	Method recognize(O:Object)
		If jcr_active Return
		If Not String(O) Return
		Return FileType(String(O))=2
	End Method
	
	Method makelist:TList(O:Object,prefix$="")
		If Not String(O) Return
		Local tl:TList = CreateTree(String(O)); SortList(tl)
		Local rl:TList = New TList
		Local p:TPixmap
		For Local f$=EachIn tl
			p = LoadPixmap(String(O)+"/"+f)
			If p ListAddLast rl,p
		Next
		Return rl
	End Method
	
End Type

New upb_dir	
