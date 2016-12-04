#SingleInstance, Force

altOnPic		:= A_ScriptDir "\img\AltOn.ico"
altOffPic		:= A_ScriptDir "\img\AltOff.ico"
toggle			:= 1
groupArray		:= []

FileInstall, img\AltOn.ico, % A_ScriptDir "\img\AltOn.ico", 1
FileInstall, img\AltOff.ico, % A_ScriptDir "\img\AltOff.ico", 1
Menu, Tray, NoStandard
Menu, Tray, Icon, % altOnPic
Menu, Tray, Add, Reset, Reset
Menu, Tray, Add, Disable Alt Toggle, AltToggle
Menu, Tray, Add
Menu, Tray, Add, Exit, Quit

SetTimer, altCheck, 200
GoSub, EnableAlt

return

^Numpad1::GoSub, AddWindow
^Numpad2::GoSub, RemoveWindow
^Numpad3::GoSub, Reset
^Numpad4::GoSub, AltToggle

Alt Up::return

AddWindow:
	WinGet, hwndVar, ID, A
	for addIndex, addValue in groupArray
		if (addValue = hwndVar)
			return
	groupArray.push(hwndVar)
return

RemoveWindow:
	WinGet, hwndVar, ID, A
	
	For index, value in groupArray
		If (hwndVar = value)
			groupArray.RemoveAt(index)
return

AltToggle:
	toggle	:= !toggle
	if (toggle = 1){
		backupArray	:= groupArray
		Menu, Tray, Uncheck, Disable Alt Toggle
		GoSub, EnableAlt
		SetTimer, altCheck, 200
	}Else{
		groupArray	:= backupArray
		Menu, Tray, Check, Disable Alt Toggle
		GoSub, DisableAlt
		SetTimer, altCheck, Off
	}
return

DisableAlt:
	Hotkey, Alt Up, On
	Menu, Tray, Icon, % altOffPic
return

EnableAlt:
	Hotkey, Alt Up, Off
	Menu, Tray, Icon, % altOnPic
return

altCheck:
	altCheckVar	:= 0
	WinGet, currentHwnd, ID, A
	for index, value in groupArray
		if (value = currentHwnd)
			altCheckVar	:= 1
		
	if (altCheckVar = 1)
		GoSub, DisableAlt
	Else
		GoSub, EnableAlt
return

Reset:
	groupArray	:= []
	altCheckVar	:= 1
	Menu, Tray, Uncheck, Disable Alt Toggle
	GoSub, EnableAlt
return

Quit:
ExitApp
