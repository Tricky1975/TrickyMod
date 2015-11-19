Rem
  MaxGUI_InitFile.bmx
  
  version: 15.11.19
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
End Rem

Import brl.map
Import tricky_units.MKL_Version
Import maxgui.drivers
Import tricky_units.initfile2

MKL_Version "Tricky's Units - MaxGUI_InitFile.bmx","15.11.19"
MKL_Lic     "Tricky's Units - MaxGUI_InitFile.bmx","ZLib License"

Private
Global gadgetmap:TMap = New TMap
Public


Rem
bbdoc: Registers a gadget to be taken into the config file.
about: This only handles values and selected items. Not the items listed inside a listbox or tabber etc. Tags are CASE INSENSITIVE!
End Rem
Function MGIF_RegisterGadget(Tag$,Gadget:TGadget)
MapInsert gadgetmap,Upper(tag),gadget
End Function


Function MGIF_GetFromIni(Ini:TIni)
Local K$,G:TGadget
Local V$,c
For K=EachIn MapKeys(gadgetmap)
	G = tgadget(MapValueForKey(gadgetmap,k))
	Select GadgetClass(G)
		Case gadget_button
			SetButtonState G,Ini.C(K).toint()
		Case gadget_TextField,Gadget_TextArea,Gadget_Label
			SetGadgetText G,Ini.C(K)
		Case Gadget_ComboBox,Gadget_ListBox,Gadget_Tabber
			If CountGadgetItems(G)>0 
				For c=0 Until CountGadgetItems(G)
					V = GadgetItemText(G,c)
					If V=Ini.C(K) SelectGadgetItem(G,c)
					Next
				EndIf
		Case gadget_slider
			SetSliderValue G,ini.C(K).todouble()
		Case gadget_progbar
			UpdateProgBar G,ini.C(K).todouble()		
		Default
			Print "Warning! Cannot handle gadgetclass "+GadgetClass(G)
		End Select
	Next
End Function	


Rem
bbdoc: Sets all values according to the requested configuration.
about: Config accepts three types. TIni for an already loaded configuration. String to load the config from a file. TBank to load the config from a memory bank (this was done to allow JCR6 compatibility).
End Rem
Function MGIF_GetConfig(Config:Object)
Local C:TIni = TIni(Config)
If String(Config) Or TBank(config) LoadIni config,c
Assert C Else "No valid config data"
MGIF_GetFromIni C
End Function

Function MGIF_PutConfigInIni:TIni()
Local ret:TIni = New TIni
Local K$,G:TGadget
Local V$,c
For K=EachIn MapKeys(gadgetmap)
	G = tgadget(MapValueForKey(gadgetmap,k))
	Select GadgetClass(G)
		Case gadget_button
			ret.d K,ButtonState(G)
		Case gadget_TextField,Gadget_TextArea,Gadget_Label
			ret.d K,GadgetText(G)	
		Case Gadget_ComboBox,Gadget_ListBox,Gadget_Tabber
			c = SelectedGadgetItem(G)
			If c>=0 ret.d K,GadgetItemText(G,c)
		Case gadget_slider
			ret.d K,SliderValue(G)
		Default
			Print "Warning! Cannot handle gadgetclass "+GadgetClass(G)
		End Select
	Next
Return ret	
End Function

Rem
bbdoc: Saves all values into a file
End Rem
Function MGIF_Save(File$)
Local I:TIni = MGIF_PutConfigInIni()
SaveIni file,I
End Function		




