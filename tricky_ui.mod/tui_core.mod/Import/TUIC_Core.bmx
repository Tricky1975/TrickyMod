Rem
        TUIC_Core.bmx
	(c) 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.02.28
End Rem ' Lic block below is old. Will be removed automatically
Rem
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is (c) Jeroen P. Broks.
 *
 * The Initial Developer of the Original Code is
 * Jeroen P. Broks.
 * Portions created by the Initial Developer are Copyright (C) 2015
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * 
 *
 * ***** END LICENSE BLOCK ***** */



Version: 15.02.14

End Rem

' 15.02.14 - Initial
' 16.02.28 - Items support
'Strict

'Import brl.max2d
'Import tricky_units.MKL_Version

MKL_Version "Tricky's User Interface - TUIC_Core.bmx","16.02.28"
MKL_Lic     "Tricky's User Interface - TUIC_Core.bmx","Mozilla Public License 2.0"

' Main Types

Rem
bbdoc: This type has to be extended to create a call-back effect from anything that happens from the gadgetaction. It should contain one method  CallFunc(Source:TUI_Gadget,x,y,Extra:Object).<br>When a certain action happens (for example clicking a button), this function will be called and source will contain the source and 'Extra' will contain any further data if it's available, or Null when the action requires no futher data.
End Rem
Type TUI_CallBack

	Rem
	bbdoc: This function is called from the gadget when you use the callback features at the appropriate time. The "Source" is the gadget which calls the callback. x and y will contain coordinates if they are applicable and Extra contains extra data if such data is needed.
	End Rem
	Method CallFunc(Source:TUI_Gadget,x=0,y=0,Extra:Object=Null) Abstract
	End Type
	
	
	
Rem
bbdoc: Returned when creating a gadget of any kind. Some fields are important to note.	
End Rem
Type TUI_Gadget	
	Field Kind$
	Field Freed ' This variable is used by the GALE driver in order to use its own "garbage collector". The Gadget runner also checks this value to make sure any freed children are removed.
	
	Field Parent:TUI_Gadget
	Field Children:TList = New TList
	
	Field Items:TList
	
	Field FSelectedItem
	
	Rem
	bbdoc: Contains the index number of the currently selected gadgetitem. If the gadget in question has no gadget items (only list type gadgets have), this variable will always contain the value -2. If no gadget item is selected it contains -1
	End Rem
	Method SelectedItem()
	If Not items Return -2
	If fselecteditem<-1 Or fselecteditem>CountItems() Return -1
	Return FSelectedItem
	End Method
	
	Rem
	bbdoc: Contains the number of items tied to a gadget. If the gadget does not support items, it returns -1
	End Rem
	Method CountItems()
	If Not items Return -1
	Return CountList(Items)
	End Method
	
	Rem
	bbdoc: Adds a gadget item
	End Rem
	Method AddItem(Txt$)
	If Not items Return
	ListAddLast items,txt
	End Method
	
	Rem
	bbdoc: Reads out an item
	about: If no items exist it returns an empty string
	returns: Text of the selected gadget item. If you provide an index number yourself, it will give you that text in stead
	End Rem
	Method ItemText$(idx=-1)
	Local i = idx
	If i<0 i=SelectedItem()
	If i<0 Return
	Return String(items.valueatindex(i))
	End Method
	
	Rem
	bbdoc: Removes an item
	End Rem
	Method RemoveItem(I)
	If Not items Return
	ListRemove items,I
	End Method
	
	Rem 
	bbdoc:Sort items
	End Rem
	Method SortItems()
	If Not items Return
	SortList Items
	End Method
	
	Rem 
	bbdoc: Clear items
	End Rem
	Method ClearItems()
	If Not items Return
	ClearList items
	End Method
	

	
	Rem
	bbdoc: Contains the text of a text based gadget. Altering this value will alter the text inside the gadget. Text input based gadgets will have their text here as well.
	End Rem
	Field Text$
	
	Rem
	bbdoc: This button can be assigned as an alternate way to access a gadget. If you assign KEY_Y to a button this way for example you can click the button to activate it, but pressing Y should have the same effect.
	End Rem
	Field AltKey
	
	Rem
	bbdoc: If you want multiple keys like above, just define them all in this array. If this array is Null, this will be ignored. Please note the more keys you assign to this, the slower the performance can get.
	End Rem
	Field AltKeys[]
	
	Rem
	bbdoc: Adjusting this value will change the font inside text-based gadgets such as buttons and labels.
	End Rem
	Field Font:TImageFont
	
	
	Rem 
	bbdoc: X coordinate of the gadget
	End Rem
	Field X
	
	Rem
	bbdoc: Y coordinate of the gadget
	End Rem
	Field Y
	
	Rem
	bbdoc: Width of the gadget if applicable
	End Rem
	Field W
	
	Rem
	bbdoc: Height of the gadget if applicable
	End Rem
	Field H
	
	Rem
	bbdoc: When set to True the gadget can be seen
	End Rem
	Field Visible = True
	
	Rem
	bbdoc: When set to True the gadget is enabled
	End Rem
	Field Enabled = True
	
	
	Field colors[4,3]
	Rem 
	bbdoc: Set the colors for enabled (by default 255,255,255)
	End Rem
	Method EnabledColor(R,G,B)
	colors[1,0]=r
	colors[1,1]=g
	colors[1,2]=b
	End Method
	

	Rem 
	bbdoc: Set the colors for enabled (by default 100,100,100)
	End Rem
	Method DisabledColor(R,G,B)
	colors[0,0]=r
	colors[0,1]=g
	colors[0,2]=b
	End Method
	
	Rem 
	bbdoc:Set the text-color for enabled gadgets (by default 255,255,255)
	End Rem
	Method TextEnabledColor(R,G,B)
	colors[3,0]=r
	colors[3,1]=g
	colors[3,2]=b
	End Method
	

	Rem 
	bbdoc: Set the colors for enabled (by default 100,100,100)
	End Rem
	Method TextDisabledColor(R,G,B)
	colors[2,0]=r
	colors[2,1]=g
	colors[2,2]=b
	End Method
	
	
	Rem
	bbdoc: Contains the picture for the "IDLE" setting. 
	about: Most gadgets only use this picture. Buttons for example have an "Action" image. Same goes for checkboxes/radio buttons.
	End Rem
	Field idleImage:TImage
	
	Rem 
	bbdoc: Contains the picture for the "ACTION" setting
	about: Most gadgets only use the "IDLE" picture. Buttons for example have an "Action" image. Same goes for checkboxes/radio buttons.
	End Rem
	Field actionImage:TImage
	
	Rem
	bbdoc: If true image might be tiled by the gadgets that support it.
	End Rem
	Field TiledImage
	
	
	' Events
	
	Rem
	bbdoc: Is true if an action took place, otherwise it's false
	End Rem
	Field Action 
	
	Rem
	bbdoc: Is #True if the user did make a selection, otherwise it's #False
	End Rem
	Field DidSelect
	
	' Callbacks
	
	Rem
	bbdoc: This is used to call a function when an action takes place. See the functions themselves for more proper information. If you don't wish to go in callback you can also rely on the #Action field.
	End Rem
	Field TB_Action:TUI_CallBack
	
	Rem
	bbdoc: This is used to call a unton whe a selection takes place.
	End Rem
	Field TB_Select:TUI_CallBack
	
	Rem
	bbdoc: This variable should contain all keys allowed for the user to use during user input. 
	about: By default this is all roman letters the underscore and numbers. This string is case IN-Sensitive, so when it contains "a" then "A" will be allowed as well. Needless to say that gadgets not allowing keyboard input will ignore this variable. If 
	End Rem
	Field AllowedChars$ = "QWERTYUIOPASDFGHJKLZXCVBNM_ 1234567890"
	
	Rem
	bbdoc: When the gadget supports it, this value will set the alpha value.
	End Rem
	Field Alpha:Double = 1
	
	Rem
	bbdoc: This variable contains the maximum size of a text. This variable is only used by gadgets allowing text input. When set to 0 any size is taken as long as it fits inside the gadget.
	End Rem
	Field MaxLen
	
	Rem
	bbdoc: Alignment. 0 = Left, 1 = right, 2 = center. Any other value = Error!
	End Rem
	Field Alignment
	
	Rem
	bbdoc: True if the button is checked, false if it's not.
	about: This value is used by checkable gadgets such as radio buttons and checkboxes
	End Rem
	Field Checked
	
	Method New()
	colors[3,0]=255
	colors[3,1]=255
	colors[3,2]=255
	colors[1,0]=255
	colors[1,1]=255
	colors[1,2]=255
	colors[0,0]=100
	colors[0,1]=100
	colors[0,2]=100
	colors[2,0]=100
	colors[2,1]=100
	colors[2,2]=100
	fselecteditem=-2
	End Method
	
	Method DText(A$,X,Y,PEnabled=True)
	Local VEnabled = Enabled And PEnabled
	SetColor colors[VEnabled+2,0],colors[VEnabled+2,1],colors[Venabled+2,2]
	DrawText a,x,y
	End Method
		
	End Type
	
' This function is solely to be used by the functions creating gadgets in order to set the parent and its child right	
Function setparent(parent:TUI_Gadget,kid:TUI_Gadget)
kid.parent = parent
If Not parent Return
ListAddLast kid.parent.children,kid
End Function

Global TUI_ActiveGadget:TUI_Gadget

Rem
bbdoc: Activate a gadget. When 'Null' is given as a parameter no gadget will be activated.
about: This most of all affects user input gadgets so that the system knows to which textfield keystrokes will have to be applied. Please note that buttons having a quick button will still activate when the user-input contains the requested shortkey. So always try to find a way around that.
End Rem
Function TUI_ActivateGadget(G:TUI_Gadget)
tui_Activegadget = G
End Function

Rem
bbdoc: Free a gadget
End Rem    
Function TUI_Free(G:TUI_Gadget)
Print "Free request for a: "+G.kind
For Local kid:TUI_Gadget = EachIn G.Children
	TUI_Free kid:TUI_Gadget
	Next
ClearList G.Children
If G.parent ListRemove G.parent.children,G
G.Freed = True	
Print "Released a "+G.Kind
End Function

Function TUI_ParentCoords(G:TUI_Gadget,px:Int Var,py:Int Var, Force=False)
Local TG:TUI_Gadget = G
Local timeout
If Not G.parent
	px=0
	py=0
	Else
	While TG.parent
		px:+TG.parent.x
		py:+TG.parent.y
		timeout:+1
		TG = TG.parent
		If timeout>=20000 
			EndGraphics
			Notify "Parent scanning timed out!"
			End
			EndIf
		Wend
	EndIf
End Function

Function TUI_DrawImage(G:TUI_Gadget,Action=False,Enabled=True)
Local img:TImage[] = [G.IdleImage,G.ActionImage]
Local px,py
TUI_ParentCoords G,px,py	
If Not img[1] img[1]=img[0]
If img[G.Action<>0]
	SetColor G.colors[(G.Enabled And enabled),0],G.colors[(G.Enabled And enabled),1],G.colors[(G.Enabled And enabled),2]
	DrawImage img[action<>0],px+g.x,py+g.y
	EndIf
End Function

Function TUI_TileImage(G:TUI_Gadget,Action=False,Enabled=True)
Local img:TImage[] = [G.IdleImage,G.ActionImage]
Local px,py
TUI_ParentCoords G,px,py	
If Not img[1] img[1]=img[0]
If img[G.Action<>0]
	SetColor G.colors[(G.Enabled And enabled),0],G.colors[(G.Enabled And enabled),1],G.colors[(G.Enabled And enabled),2]
	TileImage img[action<>0],px+g.x,py+g.y
	EndIf
End Function
	
	
' Run it all
Private
Function TrueRun(G:TUI_Gadget,Enabled=True) ' This may only be run by the module itself as running it directly can result into undesirable behavior.
Local Kid:TUI_Gadget
If G.Freed 
	TUI_Free G
	Return
	EndIf
TUIDr(G.Kind).Run(G,Enabled)
For kid = EachIn G.Children
	If kid.visible TrueRun kid
	Next
End Function
Public

Rem
bbdoc: Runs the gadget and all of its children
End Rem
Function TUI_Run(G:TUI_Gadget)
Assert TUI_CID Else "Input Driver not set, please load an input driver"
If TUI_CID TUI_CID.getinput
Local blend = GetBlend()
SetBlend alphablend
TrueRun G:TUI_Gadget
SetBlend blend
End Function



' Gadget driver

Type TUI_GadgetDriver
	
	Method Run(G:TUI_Gadget, Enabled) Abstract
	
	End Type

Global TUI_GadgetDrivers:TMap = New TMap
Function RegTUIDriver(Name$,Driver:TUI_GadgetDriver)
MapInsert tui_GadgetDrivers,Name,Driver
End Function

Function TUIDr:TUI_GadgetDriver(name$)
Assert MapContains(TUI_GadgetDrivers,name) Else "TUI Gadget Driver for Gadget type ~q"+name+"~q does not exist"
Local ret:TUI_Gadgetdriver = TUI_GadgetDriver(MapValueForKey(TUI_GadgetDrivers,name))
Assert ret Else "TUI Gadget Driver type ~q"+name+"~q does not appear to be a valid driver!"
Return ret
End Function


' Input Driver


Type TUI_InputDriver

	Field KeyHit[256],KeyDown[256]
	Field MouseHit[4]
	Field MouseX,MouseY

	Method getinput() Abstract
	
	End Type

Global TUI_CID:TUI_InputDriver
