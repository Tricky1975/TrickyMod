Rem
        advFileRequest.bmx
	(c) 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.08.11
End Rem
Strict


Import maxgui.drivers
Import brl.linkedlist
Import tricky_units.initfile2
Import tricky_units.Dirry
Import tricky_units.StringMap
Import tricky_units.ListDir




Private

Global wingad:TList = New TList
Global contgad:TList = New TList

Global NoDir:TList = New TList
Global NoFile:TList = New TList


Global afr_win:TGadget = CreateWindow("---",0,0,ClientWidth(Desktop())*.60,ClientHeight(Desktop())*.60,Null,window_titlebar | window_clientcoords | window_center | Window_hidden )
Global afr_pan:TGadget = CreatePanel(0,0,ClientWidth(afr_win),ClientHeight(afr_win),afr_win); ListAddLast wingad,afr_pan
Global ph              = ClientHeight(afr_pan)
Global pw              = ClientWidth (afr_pan)
Global afr_fav:TGadget = CreateListBox(5,  5,90,    90,afr_pan); ListAddLast contgad,afr_fav ' Favorites
Global afr_rec:TGadget = CreateListBox(5,100,90,    90,afr_pan); ListAddLast contgad,afr_rec ' Recent
Global afr_vol:TGadget = CreateListBox(5,195,90,ph-200,afr_pan); ListAddLast contgad,afr_vol ' Volumes
Global afr_fod:TGadget = CreateLabel("--",100,ph-25,100,25,afr_pan); ListAddLast wingad,afr_fod ' file or dir?
Global afr_nme:TGadget = CreateTextField(125,ph-25,pw-400,25,afr_pan);ListAddLast contgad,afr_nme ' file name
Global afr_ok :TGadget = CreateButton("Ok",pw-100,ph-25,100,25,afr_pan,button_ok); 
Global afr_can:TGadget = CreateButton("Cancel",pw-200,ph-25,100,25,afr_pan,button_cancel); 
Global afr_adf:TGadget = CreateButton("Add Fav" ,pw-100, 5,95,25,afr_pan); 
Global afr_rmf:TGadget = CreateButton("Rem Fav" ,pw-100,30,95,25,afr_pan); 
Global afr_clr:TGadget = CreateButton("Clr Rcnt",pw-100,55,95,25,afr_pan);
Global afr_sdr:TGadget = CreateLabel ("--",100,5,pw-210,25,afr_pan); ListAddLast wingad,afr_sdr
Global afr_fls:TGadget = CreateListBox(100,30,pw-210,ph-60,afr_pan); ListAddLast contgad,afr_fls
Global afr_par:TGadget = CreateListBox(pw-100, 80,95,100,afr_pan); ListAddLast contgad,afr_par; ListAddLast nodir,afr_par
Global afr_flt:TGadget = CreateListBox(pw-100,185,95,100,afr_pan); ListAddLast contgad,afr_flt; ListAddLast nodir,afr_flt
?win32
ListAddLast wingad,afr_ok
ListAddLast wingad,afr_can
ListAddLast wingad,afr_adf
?


Function RecCol(List:TList,FR,FG,FB,BR,BG,BB)
	For Local g:TGadget = EachIn list
		SetGadgetColor g,FR,FG,FB,False
		SetGadgetColor g,BR,BG,BB,True
	Next
End Function


Global Ini:TIni
Global IniDir$  = Dirry("$AppSupport$/$LinuxDot$Phantasar Productions/AdvFileRequest/"); CreateDir inidir,1
Global InisFi$  = Replace(AppFile,"/","_"); Inisfi = Replace(inisfi,":","-"); Inisfi = Replace(inisfi,"\","_")
Global iniFile$ = inidir + "/" + inisfi + ".ini"
?win32
  inifile = Replace(inifile,"/","\")
  Const slash$ = "\"
?Not win32
  inifile = Replace(inifile,"\","/")
  Const slash$ = "/"
?

Global mfavs:StringMap = New StringMap
Global mrecs:StringMap = New StringMap
Global mparn:StringMap = New StringMap
Global mcont:StringMap = New StringMap
Global mvol :StringMap = New StringMap

Function SetupList(g:TGadget,List:TList,sm:StringMap)
	ClearMap sm
	ClearGadgetItems g
	For Local f$=EachIn list
		AddGadgetItem g,StripDir(f)
		MapInsert sm,StripDir(f),f
	Next
End Function
	

Function DataFromIni()
	If Not ini
		ini = New TIni
		If FileType(inifile) 
			LoadIni inifile,ini
		Else	
			Ini.CList("Rec")
			Ini.CList("Fav")
		EndIf	
	EndIf	
	SetupList afr_rec,Ini.List("Rec"),mrecs
	setuplist afr_fav,ini.list("Fav"),mfavs
End Function

Function SetDir(d$,AllowUnixHidden,filter$="*")
	Local ft$[] = ["?","F","D"]
	?win32
		d = Replace(d,"/","\")
		If Mid(d,2,1)=":"
		ElseIf Left(d,1)<>"\" 
			d = CurrentDir()+"/"+d
		EndIf	
			
	?Not win32
		d = Replace(d,"\","/")
		If Left(d,1)<>"/" d = CurrentDir()+"/"+d
	?
	SetGadgetText afr_sdr,d
	ClearGadgetItems afr_par
	Local tl:TList = New TList
	Local sda$[] = d.split(slash)
	Local sd$,i,td$
	For i=0 Until (Len sda)
		sd = sda[i]
		ListAddFirst tl,sd
		td=""
		For Local i2=0 To i
			If td td:+slash			
			?Not win32
			If Not td td=slash
			?
			td:+sda[i2]
		Next
		While td.find("//")>=0 	td = Replace(td,slash+slash,slash) Wend
		MapInsert mparn,sd,td
	Next
	For sd=EachIn tl
		If sd AddGadgetItem afr_par,sd
	Next	
	?Not win32
	MapInsert mparn,"*ROOT*","/"
	'ListAddLast tl,"/"
	AddGadgetItem afr_par,"*ROOT*"
	'Print "Hoi???"
	?
	Local allow
	Local ext$
'	Local TmList:TList = New TList
	ClearMap mcont
	ClearGadgetItems afr_fls
	For Local file$=EachIn ListDir(d,AllowUnixHidden)
		ext = Upper(ExtractExt(file))
		If filter.tolower()="*dir*" 
			allow = FileType(d+slash+file)=2
		ElseIf filter="*" Or filter.tolower()="*all*"
			allow = True
		Else
			allow = True
			For Local e$ = EachIn filter.split(",")
				
				allow = allow And Upper(e)=ext
			Next
		EndIf	
		If allow 
			MapInsert mcont,ft[FileType(D+"/"+file)]+"> "+file,file
		EndIf
	Next	
	'SortList tmlist
	For Local af$=EachIn MapKeys(mcont)
		AddGadgetItem afr_fls,af
	Next
	If ListContains(ini.list("Rec"),d) Then ListRemove ini.list("Rec"),d
	ListAddFirst ini.list("Rec"),d
	SetupList afr_rec,Ini.List("Rec"),mrecs
	
	' Code below is adapted code from Bruce A. Henderson
	ClearMap mvol
	MapInsert mvol,"User "+StripDir(Dirry("$Home$")),Dirry("$Home$")
	Local list:TList = ListVolumes()
	If list Then
		'Print "Volumes :"
		For Local v:TVolume = EachIn list
			'If v.available Then
			'	Print "~t" + v.volumeName + "  -  " + v.volumeDevice + " (" +  v.volumeType +  ") -  " + ((v.volumeFree / 1024) / 1024) + "mb"
			?Not win32
			' Windows will need a different approach due to these stupid drive letters
			Local vvn$ = StripDir(v.volumename)
			If Not vvn vvn="/"
			MapInsert mvol,"Vol "+vvn+" ("+v.volumetype+")",v.volumeName
			?
			'End If	
		Next
	End If	
	'End of adapted code
	ClearGadgetItems afr_vol
	For Local vn$=EachIn MapKeys(mvol) 
		AddGadgetItem afr_vol,vn
	Next
	For Local fd$=EachIn ini.list("Fav")
		If FileType(fd)=2 MapInsert mfavs,StripDir(fd),fd
	Next
	ClearGadgetItems afr_fav
	For Local fdp$=EachIn MapKeys(mfavs)
		AddGadgetItem afr_fav,fdp
	Next
	ini.d("lastdir",d)
End Function

Global E_ID,E_Source:TGadget

Public

Rem
bbdoc: Sets the color of the file requesting window
EndRem
Function afr_WinCol(FR=0,FG=0,FB=0,BR=255,BG=255,BB=255)
	reccol wingad,fr,fg,fb,br,bg,bb
End Function

Rem
bbdoc: Sets the color of the file requesting input boxes
EndRem
Function afr_InpCol(FR=0,FG=0,FB=0,BR=255,BG=255,BB=255)
	reccol contgad,fr,fg,fb,br,bg,bb
End Function

Rem
bbdoc: Requests a file from the user
returns: Requested file if the user gave one or an empty string if cancelled.
End Rem
Function afr_RequestFile:String(caption$,dir$="",filter$="",save=False,AllowUnixHidden=False)
	SetGadgetText afr_win,caption
	SetGadgetText afr_fod,"File:"
	ShowGadget afr_win
	Local G:TGadget 
	For G = EachIn nofile	HideGadget G	Next
	For G = EachIn nodir	ShowGadget g	Next
	DataFromIni
	Local wdir$ = dir
	If Not wdir
		If ini.C("lastdir") wdir = ini.c("lastdir") Else wdir = AppDir
	EndIf
	SetDir wdir,AllowUnixHidden
	Repeat
		afr_ok.setenabled Trim(TextFieldText(afr_nme))<>"" 'SelectedGadgetItem(afr_fls)>=0
		WaitEvent
		E_ID = EventID()
		E_Source = TGadget(EventSource())
		Select E_id
			Case event_windowclose
				If e_source=afr_win HideGadget afr_win; SaveIni inifile,ini; Return
			Case event_gadgetselect
				Select e_source
					Case afr_fls
						If SelectedGadgetItem(afr_fls)=-1
							SetGadgetText afr_nme,""
						Else	
							Local sf$=GadgetItemText(afr_fls,SelectedGadgetItem(afr_fls))	
							Select Chr(sf[0])
								Case "F" SetGadgetText afr_nme,wdir+slash+mcont.value(sf)
								'Case "D" wdir = wdir+slash+mcont.value(f)
								'         SetUpDir wdir
							End Select	
						EndIf	
					Case afr_par
						Local p=SelectedGadgetItem(afr_par)
						If p>=0
							wdir = mparn.value(GadgetItemText(afr_par,p))
							setdir wdir,AllowUnixHidden
						EndIf	
					Case afr_vol
						Local p=SelectedGadgetItem(afr_vol)
						If p>=0
							wdir = mvol.value(GadgetItemText(afr_vol,p))
							setdir wdir,AllowUnixHidden
						EndIf	
					Case afr_fav
						Local p=SelectedGadgetItem(afr_fav)
						If p>=0
							wdir = mfavs.value(GadgetItemText(afr_fav,p))
							setdir wdir,AllowUnixHidden
						EndIf														
					Case afr_rec
						Local p=SelectedGadgetItem(afr_rec)
						If p>=0
							wdir = mrecs.value(GadgetItemText(afr_rec,p))
							setdir wdir,AllowUnixHidden
						EndIf														
				End Select
			Case event_gadgetaction
				Select e_source
					Case afr_ok
					Case afr_fls,afr_ok
						If SelectedGadgetItem(afr_fls)=-1
							SetGadgetText afr_nme,""
						Else	
							Local sf$=GadgetItemText(afr_fls,SelectedGadgetItem(afr_fls))
							Select Chr(sf[0])
								Case "F" 
									SetGadgetText afr_nme,wdir+slash+mcont.value(sf); 
									HideGadget afr_win
									SaveIni inifile,ini
									Return TextFieldText(afr_nme)
								Case "D" wdir = wdir+slash+mcont.value(sf)
								         SetDir wdir,AllowUnixHidden
							End Select							
						EndIf	
					Case afr_adf
						If ListContains(ini.list("Fav"),wdir)
							Notify "This directory is already in your favorites"
						Else	
							ini.add "Fav",wdir
							SaveIni inifile,ini
							setdir wdir,AllowUnixHidden	
						EndIf
					Case afr_rmf
						If Not ListContains(Ini.List("Fav"),wdir)
							Notify "Cannot execute this command, as this directory is not a favorite. In order to remove a favorite, go to the specific directory and click this button"
						Else
							If Proceed("Do you really wish to remove~n~n"+wdir+"~n~nfrom your favorite list?")=1 
								ListRemove ini.list("Fav"),wdir
								setdir wdir,AllowUnixHidden
								Notify wdir+" has been removed"
							EndIf
						EndIf	
				End Select
		End Select	
	Forever
End Function
