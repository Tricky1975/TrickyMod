Rem
        GALE_DirGetter.bmx
	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.07.12

End Rem
Import tricky_units.tree
Import tricky_units.ListDir
Import gale.Main

Private
Global rdir:TList

Type lua_dirgetter ' BLD: Object Dir\nContains some functions to read directories.

	Method GetTree(dir$) ' BLD: Gets a full directory tree from the chosen path
	rdir = CreateTree(dir)
	SortList rdir
	End Method	
	
	Method GetDir(dir$,OnlyFileType=0,auh=0) ' BLD: Gets all files in the specified directory.<p>The OnlyFileType parameter may contain 0 for all files and directories, 1 for only files and 2 for directories only.<p>When auh is set to any value greater than 0 the hidden files (by unix standards, so all files starting with a ".") will be taken as well.
	rdir = ListDir(dir,onlyfiletype,auh)
	End Method
	
	Method DirLen() ' BLD: Will return the number of files found by the last GetTree() or GetDir() call. If both of them were never done, it will return 0.
	If Not rdir Return
	Return CountList(rdir)
	End Method
	
	Method DirEntry$(i) ' BLD: Will return the file on the specified index number. 1 is the lowest number. Either GetTree() or GetDir() must be called before using this function or else it will throw an error.
	If Not rdir GALE_Error "No dir was called prior to DirEntry"
	If i<1 GALE_Error "Minimal index for DirEntry is 1 not "+i
	If i>CountList(rdir) GALE_Error "DirEntry index out of bounds (index="+i+", max="+CountList(rdir)+")"
	Return String(rdir.valueatindex(i-1))
	End Method
	
	Method DirExists(dir$) ' BLD: Returns 1 if a directory was succefully found and 0 if not. It might be an idea to call this function prior to using GetTree() or GetDir() as the system will crash if the requested path does not exist.
	Return FileType(dir)=2
	End Method
	
	End Type
	
GALE_Register New lua_dirgetter	,"Dir"
