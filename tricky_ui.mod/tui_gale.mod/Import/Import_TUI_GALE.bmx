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
 * -
 *
 * ***** END LICENSE BLOCK ***** */



Version: 15.02.14

End Rem
Strict

Import GALE.Main
Import Gale.MultiScript
Import gale.image
Import jcr6.jcr6main
Import brl.map

Import Tricky_UI.TUI_Core


Rem
bbdoc: work type
End Rem
Type TUI_GALE
	Rem
	bbodc: The Script
	End Rem
	Field Lua:TLua
	Rem
	bbdoc: The Screen gadget
	End Rem
	Field Screen:TUI_Gadget = TUI_CreateScreen()
	Field ChildrenByKey:TMap = New Tmap
	Field ChildrenByGad:TMap = New Tmap		
	End Type
	
Global TUIGALEMAP:TMap = New TMap	

Rem
bbdoc: Executes TUI_UnLoad() in the TUI_GALE object before releasing the object itself in order to be called by the garbage collector.
about: Please make sure that the Lua script tied to this object is not running at the time this feature is called.
End Rem
Function TUI_GALE_Free(Tag$) 'TUIG:TUI_Gale Var)
Local TUIG:TUI_GALE = tui_GALE_O(Tag)
If Not tuig 
	Print "WARNING! Cannot destroy TUI_GALE object ~q"+Tag+"~q. It doesn't seem to exist!!"
	Return
	EndIf
TUIG.Lua.Run("TUI_UnLoad",Null)
GALE_MS.destroy("TUI_"+Tag)
TUI_Free TUIG.Screen
For Local G:TUI_Gadget = EachIn MapKeys(globalgadgetmap)
	If g.freed MapRemove globalgadgetmap,g
	Next
'TUIG = Null
End Function	


Rem
bbdoc: Loads a Lua Script and ties the gadgets to it. In the MultiScripter you can find this one also back with the used tag prefixed by "TUI_". The object is also returned, however I'm not quite sure if you actually NEED that object.
End Rem
Function TUI_GALE_Load:TUI_GALE(Tag$,JCR:TJCRDir,Script$)
Local ret:TUI_GALE = New TUI_GALE
ret.lua = GALE_LoadScript(TUIG_JCR,script)
If Not ret Return
MapInsert tuigalemap,Upper(tag),ret
GALE_AddScript "TUI_"+Tag,ret.lua
ret.lua.run "TUI_OnLoad",Null
Return ret
End Function


Function TUI_GALE_O:TUI_GALE(Tag$)
Return TUI_GALE(MapValueForKey(TUIGALEMAP,Upper(Tag)))
End Function

Rem
bbdoc: Returns the gadget tied to a script set. If "kid" is set the child gadget will be returned, if not set the screen gadget is returned.
End Rem
Function TUI_GALE_Gadget:TUI_Gadget(STag$,kid$="")
Local G:TUI_GALE = TUI_GALE_O(STag)
If Not G Return Null
If kid
	Return TUI_Gadget(MapValueForKey(G.Childrenbykey,Upper(kid)))
	Else
	Return G.screen
	EndIf
End Function		


Rem
bbdoc: This variable should contain the JCR dir list if the API is to load scripts.
End Rem
Global TUIG_JCR:TJCRDir

Function TUI_GALE_BindGadget(STag$,GTag$,Gadget:TUI_Gadget)
If Not GTag GALE_Error("Gadget tag is required!",["Script-Tag,"+STag,"Gadget-Tag,"+GTag])
Local G:TUI_GALE = TUI_GALE_O(STag)
If Not G GALE_Error("Cannot bind to a non-existent script!",["Script-Tag,"+STag,"Gadget-Tag,"+GTag])
If Not gadget GALE_Error("Tried to tie a non-existent gadget!",["Script-Tag,"+STag,"Gadget-Tag,"+GTag])
MapInsert G.ChildrenByKey,Upper(GTag),Gadget
MapInsert G.Childrenbygad,Gadget,Upper(GTag)
MapInsert globalgadgetmap,gadget,[STag,GTag]
Gadget.TB_Action = TUI_GALE_ACTION
End Function

Rem
This type will make sure the call-back will work
End Rem
Private
Global GlobalGadgetMap:TMap = New TMap
Type TUI_GALE_ActionCallBack Extends TUI_CallBack
	Method CallFunc(G:TUI_Gadget,x,y,Extra:Object)
	Local Tags$[] = String[](MapValueForKey(globalgadgetmap,g))
	Local STag$=Tags[0]
	Local GTag$=Tags[1]
	Local TG:TUI_GALE = tui_gale_o(STAG)
	Local P$[]=[x+"",y+"",String(Extra)]
	If Not TG GALE_Error("No callback data found for this routine")
	TG.Lua.Run "TUI_ACTION_"+Upper(GTag),P
	End Method
	End Type
Global TUI_GALE_Action:TUI_GALE_ActionCALLBACK = New TUI_GALE_ActionCallBack	
Public

Function TUIG_Image:TImage(Image$)
Local I:TImage
Local IFL$ = Upper(Image)
If Not Image Return Null
If Left(IFL,6)="ITAG::"
	IFL = Right(IFL,Len(IFL)-6)
	I = TImage(MapValueForKey(MJBC_Lua_Image,IFL))
Else
	I = LoadImage(JCR_B(TUIG_JCR,Image))
	EndIf
If Not I GALE_Error("Could not retrieve image",["API,TUI_GALE","Image,"+Image])
Return I
End Function

Type TGD_LuaGadgetDriver Extends TUI_GadgetDriver 
	
	Method Run(G:TUI_Gadget, Enabled) 
	Local T$[] = G.Text.Split(";")
	Local O:TUI_GALE = TUI_GALE_O(T[0])
	If Not O GALE_Error "Lua driven object has no valid script: "+T[0]
	O.Lua.Run "TUI_RUN_"+T[1],Null
	End Method
	
	End Type

RegTUIDriver("GALELUA",New TGD_LuaGadgetDriver)	



Rem 
This is the Lua API provding Lua the possibility to communicate with these gadgets and they in their turn with the script.
End Rem
Type TUI_Lua_Api ' BLD: Object TUI\nThe object containing the TUI commands.
	
	Method Load(STag$,Script$) ' BLD: Load a script with TUI callback features.
	TUI_GALE_Load(STag,TUIG_JCR,Script)
	End Method
	
	Method Free(STag$) ' BLD: Unload a script with TUI callback features.
	TUI_GALE_Free(STag) 
	End Method
	
	
	Method Gadget:TUI_Gadget(STag$,GTag$="") ' BLD: This object contains several fields which can be edited or read. Best is to only use this if you know what you are doing.	
	Local ret:TUI_Gadget 
	ret = TUI_GALE_Gadget(STag,GTag)
	If Not ret	GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE"]; Return
	Return ret
	End Method
	
	
	Method NewScreen(STag$,GTag$,Parent$="") ' BLD: Create a new screen. I doubt you'll ever need this, but it was added, just in case.
	Local Ret:TUI_Gadget = TUI_CreateScreen(Null,TUI_GALE_Gadget(STag,Parent))
	tui_Gale_bindgadget	STag,gtag,Ret
	End Method
	
	Method SetGadgetIdlePicture(STag$,GTag$,Image$) ' BLD: Set an idle image to a gadget. Image should basically be an image file stored inside the JCR file, however if you prefix this string with "ITAG::" the system will automatically tie an image loaded with the Image object to this. 
	Local I:TImage = TUIG_Image(Image)
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,SetGadgetIdlePicture"]; Return
	G.IdleImage = I
	End Method

	Method SetGadgetActionPicture(STag$,GTag$,Image$) ' BLD: Set an action image to a gadget. Image should basically be an image file stored inside the JCR file, however if you prefix this string with "ITAG::" the system will automatically tie an image loaded with the Image object to this. 
	Local I:TImage = TUIG_Image(Image)
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	G.ActionImage = I
	End Method

	Method SetGadgetPicture(STag$,GTag$,Image$) ' BLD: Set an image for both idle as action usage to a gadget. Image should basically be an image file stored inside the JCR file, however if you prefix this string with "ITAG::" the system will automatically tie an image loaded with the Image object to this. If you want the idle and action image to be the same, please use this feature as it takes less memory than setting both pictures separately.
	Local I:TImage = TUIG_Image(Image)
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,SetGadgetPicture"]; Return
	G.IdleImage = I
	G.ActionImage = I
	End Method
	
	Method CopyImage(OSTag$,OGTag$,TSTag$,TGTag$) ' BLD: Copies both the idle and action images from another gadget to this one. Handy most of all when you want multiple gadgets with the same picture. This routine is a lot friendlier on your memory than setting this gadget by gadget.
	Local G1:TUI_Gadget = TUI_GALE_Gadget(ostag,ogtag)
	Local G2:TUI_Gadget = TUI_GALE_Gadget(tstag,tgtag)
	Local errorarray$[] = ["OBJECT,TUI for GALE","Function,CopyImage","Original,"+OStag+"|"+OGTag,"Target,"+TSTAG+"|"+TGTAG]
	If Not G1 GALE_Error("Original gadget not found",errorarray)
	If Not g2 GALE_Error("Target gadget not found",errorarray)
	G2.idleimage = g1.idleimage
	g2.actionimage = g1.actionimage
	End Method
	
	Method GetText$(STag$,GTag$) ' BLD: Returns the text tied to a gadget
	Return Gadget(Stag,GTag).Text
	End Method
	
	Method SetText(STag$,GTag$,Text$) ' BLD: Defines the text tied to a gadget
	gadget(Stag,GTag).Text = Text
	End Method
	
	Method NewUserInput(Stag$,GTag$,x,y,w,parent$="") ' BLD: Creates a user input textfield.
	tui_gale_bindgadget Stag,gtag,TUI_CreateUserInput(x,y,w,Gadget(STag,Parent))	
	End Method
	
	Method CreateButton(STag$,GTag$,Caption$,x,y,parent$) ' BLD: Creates a button. The way the button looks in graphics will have to be assigned manually due to the limited amount of arguments Lua can send to a button.
	tui_Gale_bindgadget sTag,gTag,TUI_CreateButton(caption,x,y,gadget(sTag,parent)) ',TUIG_Image(IdleButton),TUIG_Image(ActionButton))
	End Method
	
	Method Reform(STag$,GTag$,x,y,w,h) ' BLD: Move and resize a gadget
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,Reform"]; Return
	G.x = x
	G.y = y
	G.w = w
	G.h = h
	End Method
	
	Method BindKeys(STag$,GTag$,KeyString$) ' BLD: Bind the keys with the key codes given up in the string. With this routine you can bind multiple keys, typed in one big string in which the codes have to be separated by semi-colons. Like this "65; 77; 122"
	Local V$[] = KeyString.split(";")
	Local VC[]
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,Reform"]; Return
	VC = New Int[Len(V)]
	Local ak
	For ak=0 Until Len(V)
		vc[ak]=v[ak].toInt()
		Next
	g.altkeys=vc
	End Method
	
	Method Exists(STag$) ' BLD: Does a UI exist? 1 = yes, 0 = no
	Return MapContains(TUIGALEMAP,Upper(sTag))
	End Method
	
	Method TagLessLabel(Stag$,Text$,x,y,parent$,alignment) ' BLD: Creates a label inside a UI without any subtag involved.
	TUI_CreateLabel text,x,y,Gadget(Stag,parent),Null,alignment ' Null = font. Will have to be defined by the scripter if needed.
	End Method
	
	Method NewLabel(Stag$,GTag$,Text$,x,y,parent$) ' BLD: Creates a label inside a UI 
	Local r:TUI_Gadget = TUI_CreateLabel(text,x,y,Gadget(Stag,parent))
	TUI_gale_bindgadget stag,gtag,r
	End Method
	
	Method SetFont(STag$,GTag$,Font$,Size) ' BLD: Assigns a font to a gadget.
	Local F:TImagefont = LoadImageFont(JCR_E(TUIG_JCR,Font),Size)
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,SetFont"]; Return
	G.Font = F
	JCR_E_Clear	
	End Method

	Method NoFont(STag$,GTag$) ' BLD: Assigns the default font to a gadget
	Local G:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	If Not G GALE_Error "Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["OBJECT,TUI FOR GALE","Func,SetFont"]; Return
	G.Font = Null
	End Method


	Method TrueX(STag$,GTag$) ' BLD: Contains the true X position of the gadget with coordinates of parents taken into account
	Local px,py
	Local G:TUI_Gadget = gadget(STag,GTag)
	tui_parentcoords G,px,py
	Return px+G.x
	End Method

	Method TrueY(STag$,GTag$) ' BLD: Contains the true Y position of the gadget with coordinates of parents taken into account
	Local px,py
	Local G:TUI_Gadget = gadget(STag,GTag)
	tui_parentcoords G,px,py
	Return py+G.Y
	End Method
	
	Method CreateCustom(STag$,GTag$,x,y,parent$) ' BLD: Creates a custom UI object. Every time the gadget is run it will call in the script for a function named "TUI_RUN_<GADGET-TAG>()"
	Local g:TUI_Gadget = New TUI_Gadget
	g.kind = "GALELUA"
	g.text = STag+";"+GTag
	G.x = x
	g.y = y
	g.w = 0
	g.h = 0
	Local gparent:TUI_Gadget = TUI_GALE_Gadget(STag,parent)
	If Not gparent	GALE_Error "Parent Gadget does not appear to exist ~q"+STag+":"+GTag+"~q!",["F,Fake3D","Parent,"+parent]; Return
	setparent gparent,g
	tui_gale_bindgadget Stag,gtag,g
	End Method
	
	Method Color(STag$,GTag$,R,G,B) ' BLD: Turn the base for an enabled gadget into the requested color.
	Local Gd:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	Gd.EnabledColor(R,G,B)		
	End Method

	Method DColor(STag$,GTag$,R,G,B) ' BLD: Turn the base for a disabled gadget into the requested color.
	Local Gd:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	Gd.DisabledColor(R,G,B)		
	End Method

	Method TxtColor(STag$,GTag$,R,G,B) ' BLD: Turn the base for an enabled gadget into the requested color.
	Local Gd:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	Gd.TextEnabledColor(R,G,B)		
	End Method

	Method TxtDColor(STag$,GTag$,R,G,B) ' BLD: Turn the base for a disabled gadget into the requested color.
	Local Gd:TUI_Gadget = TUI_GALE_Gadget(STag,GTag)
	Gd.TextDisabledColor(R,G,B)		
	EndMethod
	
	Method KeyDown(value:Byte) ' BLD: Returns 1 if the key is held down and 0 if the key is not held down. Please note, DON'T use Key.Down() when dealing with a TUI
	Return TUI_CID.KeyDown[value]
	End Method

	Method KeyHit(value:Byte) ' BLD: Returns 1 if the key is held down and 0 if the key is not held down. Please note, DON'T use Key.Hit() when dealing with a TUI
	Return TUI_CID.KeyHit[value]
	End Method
	
	Method MouseHit(value:Byte) ' BLD: Returns 1 if the mouse button is hit. Please note, DON'T use Mouse.Hit() when deaing with a TUI
	Return TUI_CID.MouseHit[value]
	End Method
	
	Method MouseX() ' BLD: Returns the actual mouse X
	Return TUI_CID.MouseX
	End Method
	
	Method MouseY() ' BLD: returns the actual mouse Y
	Return TUI_CID.MouseY
	End Method
	
	End Type

GALE_Register New TUI_Lua_Api,"TUI"
