Rem
        GALE_LuaAudio.bmx
	(c) 2012-2015, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 15.09.02
End Rem
Rem

	(c) 2012, 2013, 2014, 2015 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.


Version: 15.04.19

End Rem
' 15.02.07 - Fixed JCR6 incompatibility
' 15.04.15 - A channel value will now be returned.
Strict

Import Gale.Main
Import Brl.Map
Import Brl.OggLoader
Import brl.FreeAudioAudio
Import Brl.Graphics
Import brl.wavloader

MKL_Version "GALE - GALE_LuaAudio.bmx","15.09.02"
MKL_Lic     "GALE - GALE_LuaAudio.bmx","Mozilla Public License 2.0"


Rem
bbdoc: When using the GALE_Audio module to provide sounds in your lua scripting, this variable MUST contain the JCR file or the RealDir analysis that you will use.
end rem
Global AudioJCR:TJCRDir  


Private
Function AudioError(Err$)
	'EndGraphics
	Print "GALE_AUDIO ERROR~n"+Err
	GALE_Error Err
	End
	End Function
Public



Type LSounds Extends TMap   ' BLD: Object Audio\nThis object contains all kinds of neat audio features.
	
	Field Crash = True ' BLD: When set the system will crash on certain error. When set false the system will try to ignore such errors if possible.
	
	Field Channels:TMap = New TMap
	
	Method QuickSound(Sound$) ' BLD: Loads an audio file from a JCR file, plays it and forgets it immediately.
	If Not AudioJCR Throw "Audio.QuickSound('"+Sound+"'): Can't extract from empty JCR"
	PlaySound LoadSound(JCR_B(AudioJCR,Sound))
	End Method
	
	Method Load$(Sound$,Assign$="",OnlyNew=0)  ' BLD: Loads and audio file and stores it in slot 'Assign'. If the Assign value is not set the computer will assign it to a slot and return the slot name. When the load is not succesful "*ERROR*" is returned. OnlyNew only works if you made an actual assign. In that case the sound is only loaded if nothing was loaded on that address before.
	Local Ret$=Assign
	If Not AudioJCR Throw "Audio.QuickSound('"+Sound+"'): Can't extract from empty JCR"
	If ret And onlynew And MapContains(Self,ret) Return ret
	If Not Ret 
		Repeat
			Ret = "AU"+Rand(0,MilliSecs())
		Until Not MapContains(Self,Ret)
		EndIf
	If Not MapContains(AudioJCR.entries,Upper(sound)) GALE_Error("Audio file ~q"+Sound+"~q not found in the JCR resource map!")
	Local AU:TSound = LoadSound(JCR_B(AudioJCR,Sound))
	If AU
		MapInsert Self,Ret,AU
		Return Ret
		Else
		If Crash AudioError "Audio file ~q"+Sound+"~q could not be loaded properly"
		Return Ret = "*ERROR*"
		EndIf
	End Method
	
	Method Have(sound$) ' BLD: Returns 1 if a sound effect is loaded to that spot, and returns 0 if not
		Return MapContains(Self,sound)
	End Method
		
	Method LoadLoop$(Sound$,Assign$="")  ' BLD: Loads and audio file and stores it in slot 'Assign'. When played back the loaded sound will loop. If the Assign value is not set the computer will assign it to a slot and return the slot name.
	Local Ret$=Assign
	If Not AudioJCR Throw "Audio.QuickSound('"+Sound+"'): Can't extract from empty JCR"
	If Not Ret 
		Repeat
			Ret = "AU"+Rand(0,MilliSecs())
		Until Not MapContains(Self,Ret)
		EndIf
	If Not MapContains(AudioJCR.Entries,Upper(sound)) GALE_Error("Audio file ~q"+Sound+"~q not found in the JCR resource map!")
	Local AU:TSound = LoadSound(JCR_B(AudioJCR,Sound),Sound_Loop)
	If AU
		MapInsert Self,Ret,AU
		Return Ret
		Else
		If Crash GALE_Error "Audio file ~q"+Sound+"~q could not be loaded properly"
		Return Ret = "*ERROR*"
		EndIf
	Return Ret
	End Method
	
	Method LoadX$(Sound$,Loop,Hardware,Assign$="")  ' BLD: Loads and audio file and stores it in slot 'Assign'. If the Assign value is not set the computer will assign it to a slot and return the slot name. You can use this function for some specific configuration.
	Local Ret$=Assign
	Local Flag = 0
	If Not AudioJCR Throw "Audio.QuickSound('"+Sound+"'): Can't extract from empty JCR"
	If Not Ret 
		Repeat
			Ret = "AU"+Rand(0,MilliSecs())
		Until Not MapContains(Self,Ret)
		EndIf
	If Loop Flag:|Sound_Loop
	If Hardware Flag:|Sound_Hardware
	Local AU:TSound = LoadSound(JCR_B(AudioJCR,Sound),flag)
	If AU
		MapInsert Self,Ret,AU
		Return Ret
		Else
		If Crash AudioError "Audio file ~q"+Sound+"~q could not be loaded properly"
		Return Ret = "*ERROR*"
		EndIf
	Return Ret
	End Method

	Method Free(Slot$) ' BLD: Releases the audio buffer stored on this slot. The sound will be removed from the memory by the BlitzMax Garbage Collector eventually.
		If Not MapContains(Self,Slot) AudioError "Cannot free an non-existent slot" 
		MapRemove Self,Slot
	End Method
	
	
	Method Play(Slot$,Channel$="") ' BLD: Plays a sound. If Channel is set the system will store the channel there for you.
		Local CH:TChannel
		'If Channel And Not MapContains(Channels,Channel) 
			Ch = AllocChannel()
			If Not CH AudioError "Channel could not be allocated!"
			MapInsert Channels,Channel,Ch
			DebugLog "Created channel: "+Channel
		'ElseIf Channel
		'	DebugLog "Used channel: "+Channel
		'	Ch = TChannel(MapValueForKey(Channels,Channel))
		'	If Not Ch AudioError("Audio Channel ~q"+Channel+"~q was found in channel list but it appeared to be empty")
		'Else			
		'	DebugLog "No Channel used"
		'	Ch = Null
		'EndIf
		If Not MapContains(Self,Slot) AudioError("Audio.Play(~q"+Slot+"~q,~q"+Channel+"~q): Cannot play empty sound slot!")
		PlaySound TSound(MapValueForKey(Self,Slot)),Ch
		'Return ch
		End Method
	
	Method Stop(Channel$) ' BLD: Stop a channel from playing. If the channel is not properly set, this routine will be ignored.
		Local CH:TChannel = TChannel(MapValueForKey(Channels,Channel))
		If Not CH Return 'AudioError "Requested channel is empty"
		StopChannel Ch
		End Method
		
	Method FreeChannel(Channel$) ' BLD: Removes a channel from the memory.
		MapRemove Channels,Channel
		End Method
		
	Method Playing(Channel$) ' BLD: Returns 1 if a channel is playing otherwise 0. Please note that in Lua 0 counts as 'true' in boolean comparing.
		If Not MapContains(Channels,Channel) Return False 'AudioError("Channel ~q"+Channel+"~q doesn't exist!")
		Local CH:TChannel = TChannel(MapValueForKey(Channels,Channel))
		If Not CH AudioError "Requested channel is empty"
		Return ChannelPlaying(Ch)
		End Method
		
	End Type
	
	
Global Audio:LSounds = New LSounds

GALE_Register Audio,"Audio"
