#Include <Abstractions\Mouse>
#Include <Abstractions\ini>
#Include <App\Browser>
#Include <Utils\Hot>
#Include <Utils\Win>
#Include <Alert>


infoTranslate() {
	input := CleanInputBox()
	if input != ""
		Info Google.Translate(input, 'auto', input ~= "\w" ? "fa" : "en")
}

Prayer() {

	Prayers := api.PrayerTimes(310)
	Newitems := Map(
		'Imsaak', 'Azun Sobh',
		'Maghreb', 'Azun Maghreb',
		'Noon', 'Azun Zohr',
		'Sunrise', 'Toluh',
		'Sunset', 'Qorub',
		'Today', 'Emruz',
	)

	New := Map()

	for key, value in Newitems
		New.Set(value, Prayers[key])
	
	return New
}
class Environment {

    static VimMode := false

}
class Range {

	__New(start, end?, step:=1) {
		if !step
			throw TypeError("Invalid 'step' parameter")

		if !IsSet(end)
			end := start, start := 1

		if (end < start) && (step > 0)
			step := -step

		this.start := start, this.end := end, this.step := step
	}

	__Enum(varCount) {
		start := this.start - this.step, end := this.end, step := this.step, counter := 0
		EnumElements(&element) {
			start := start + step
			if ((step > 0) && (start > end)) || ((step < 0) && (start < end))
				return false
			element := start
			return true
		}
		
		EnumIndexAndElements(&index, &element) {
			start := start + step
			if ((step > 0) && (start > end)) || ((step < 0) && (start < end))
				return false
			index := ++counter
			element := start
			return true
		}
		return (varCount = 1) ? EnumElements : EnumIndexAndElements
	}
}

isDown() {
    
    Hot.KeyWait(A_ThisHotkey)
    keys := ""
    loop 128 {

        which := Format("sc{:x}", A_Index)
        key := GetKeyName(which)
        if key != "" && GetKeyState(key)
            keys .= key "`n"
    }

    loop 256 {

        which := Format("vk{:x}", A_Index)
        key := GetKeyName(which)
        if key != "" && GetKeyState(key)
            keys .= key "`n"
    }

    alert keys
}

class Symbol {

	static Call(Name) => Chr(this.GetUnicode(name))

	static GetUnicode(Name) {

		static Unicodes := Map(
			
			"joy", 0x1F602,
			"neutral_face", 0x1F610,
			"expressionless_face", 0x1F611,
			"pensive_face", 0x1F614,
			"zwnj", 0x200C, ;ZERO WIDTH NON-JOINER
		)
		return Unicodes[name]
	}
}

class UnderMouse {
	static __Call(Method, Params) => Win({WinTitle: "ahk_id " Mouse.Win}).%Method%(Params*)
}

SwitchPlayBack()
{
	Sound := SoundGetName()

	Run("Mmsys.cpl")
	WinWait("Sound")

	loop 
	{
		Sleep(50)
		Send("{Down}")
		ControlClick("Set Default")

	} until Sound != SoundGetName()
	
	ControlClick("button4")
}

ToggleHiddenFiles()
{
	HiddenFiles_Status := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")

	if (HiddenFiles_Status = 2)
		RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
	Else
		RegWrite(2, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")

	Send "{F5}"
}

CloseAllExplorer()
{
	GroupAdd("ExplorerGroup", "ahk_class CabinetWClass")
	GroupAdd("ExplorerGroup", "ahk_class ExploreWClass")

	if WinExist("ahk_group ExplorerGroup")
		WinClose("ahk_group ExplorerGroup")
}

CloseAllAhk_Gui() {

	GroupAdd("Ahk_Gui", "ahk_class AutoHotkeyGUI")
	
	if WinExist("ahk_group Ahk_Gui")
		WinClose("ahk_group Ahk_Gui")
}


HotStrMenu(TextList*) {

	MyMenu := Menu()

	for Text in TextList
		MyMenu.Add(Text, Action)

	MyMenu.Show()
	MyMenu.Delete()

	Action(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
		Clip.Send(A_ThisMenuItem)
	} 
}

ToHex(Int) => Format("0x{:x}", Int)

MonOff() => SendMessage(0x112, 0xF170, 2,, "Program Manager")
screensaver() => SendMessage(0x112, 0xF140, 0,, "Program Manager")


class System {
	
	static Lang {

		get {
			return SubStr(ToHex(DllCall("GetKeyboardLayout", "int", 0)), -4)
		}

		set {
			
			static WM_INPUTLANGCHANGEREQUEST := 0x0050
			static langs := Map(
				"ja", 0x0411,
				"fr", 0x0c0c,
				"en", 0x0409
			)
			try PostMessage(WM_INPUTLANGCHANGEREQUEST,, langs[Value],, "A")
		}
	}

	/**
	 * Checks if the user has an internet connection.
	 * @returns {Boolean} returns 1 for true, 0 for false
	 */
	IsNet(flag := 0x40) {
		return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0)
	}

	static MonOff() => SendMessage(0x112, 0xF170, 2,, "Program Manager")
	static screensaver() => SendMessage(0x112, 0xF140, 0, , "Program Manager")

}

/**
 * Checks if the user has an internet connection.
 * @returns {Boolean} returns 1 for true, 0 for false
 */
IsNet(flag := 0x40) {
	return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag, "Int", 0)
}

Class Lang {

	static langs := Map(
		"ja", 0x0411,
		"fr", 0x0c0c,
		"en", 0x0409
	)

	; Get Current Input Language
	static Get() => SubStr(format("{:x}", DllCall("GetKeyboardLayout", "int", 0)), -4)

	/**
	 * this function uses a `PostMessage()` call which may cause some programs to crash
	 *
	 * @Param lang
	 *
	 * programs may ignore the WM_INPUTLANGCHANGEREQUEST message, in which case it will not work
	 *
	 * set input language via WM_INPUTLANGCHANGEREQUEST message
	 */
	static Set(lang := "en") {
		try PostMessage(0x0050,, this.langs[lang],, "A")
	}
}

/**
 * Run("https://link.com") will run the link, but the browser might not get focused.
 * This function makes sure it does
 * @param link *String*
 * @param browserWinTitle *String*
 */
RunLink(link, browserWinTitle := Browser.winTitle) => (
	Run(link)
	WinWait(browserWinTitle)
	WinActivate(browserWinTitle)
)


LockHint(WhatLock, Change := true) {

	State := GetKeyState(WhatLock, "T")

	if (Change)
		(State := !State, Set%WhatLock%State(State))

	Infos.Toggle(WhatLock " " VarState(State))
}




class Call {
    
    static Toggle(BoundFuncs*) {

        static Counter := 0

        if ++Counter > BoundFuncs.Length
            Counter := 1
    
        return BoundFuncs[Counter].Call()
    }

    static Rand(BoundFuncs*) {

        Rand := Random(1, BoundFuncs.Length)
        BoundFuncs[Rand].Call()
    }
}


RegExMatchAll(Haystack, NeedleRegEx, StartingPosition := 1) {
	
	Matches := Array()
    totalMatch := StrLen(Haystack)

    loop {

        RegExMatch(Haystack, NeedleRegEx, &Match, StartingPosition)

		if Match is String
			break

        ; MsgBox "match: '" match[] "'`nmath len: " match.Len "`nmatchpos:" match.Pos
		
        if  Match.Len > totalMatch || Match[] = ""
            break

        Matches.Push(Match)
        startingposition := Match.Len + Match.Pos
    }

	return Matches
}

VarState(Var) => (Var ? "On" : "Off")

SendCount(Keys, Count := 1, Delay := -1) {
	loop Count 
		Send(Keys), Sleep(Delay)
}



InputLock() {

    Hot.KeyWait(A_ThisHotkey)
    BlockInput(true)

    GuiObj := Gui("AlwaysOnTop -Caption +Owner", "Keyboard And Mouse Locked")
    GuiObj.Add("Picture", "w16 h16 Icon55", "imageres.dll")
    GuiObj.BackColor := "808080"
	
	MousePos := Mouse.GetPos("Screen")
    GuiObj.Show("x" MousePos.X " y" MousePos.Y ) ;" NoActivate"
    WinSetTransColor("808080  255", "ahk_id " GuiObj.HWnd)
   
    KeyboardHook := InputHook("*",, "Unlock") 
    KeyboardHook.Start()
    KeyboardHook.Wait()

    GuiObj.Destroy()
    
    BlockInput(false)
}


Border(Thickness := 50, Offset := 0, Color := "ffae00", TFade := 4)
{
	static 
	Thickness := 50, Offset := 0, Color := "ffae00", TFade := 4, Fade := 0

	W := SysGet(78)
	H := SysGet(79)

	oX1 := oY1 := Offset

	oX2 := W - Offset
	oY2 := H - Offset

	iX1 := iY1 := Thickness + Offset

	iX2 := (W - Thickness) - Offset
	iY2 := (H - Thickness) - Offset

	myGui := Gui()
	myGui.Opt("+Lastfound +AlwaysOnTop +Toolwindow -Caption")
	myGui.BackColor := Color

	WinSetRegion(oX1 "-" oY1 " " oX2 "-" oY1 " " oX2 "-" oY2 " " oX1 "-" oY2 " " oX1 "-" oY1 "  " iX1 "-" iY1 " " iX2 "-" iY1 " " iX2 "-" iY2 " " iX1 "-" iY2 " " iX1 "-" iY1)
	myGui.Show("X" . oX1 . " Y" . oY1 . " W" . W . " H" . H . " NoActivate")


	SetTimer(Fun, -1)
	Fun() {
		
		Loop 25
		{
			Fade += TFade
			if (Fade >= 0 && Fade <= 255)
				WinSetTransparent(Fade, "ahk_id " myGui.Hwnd)
			Sleep(15)
			ToolTip(Fade)
		}

		Loop 25
		{
			Fade -= TFade
			if (Fade >= 0 && Fade <= 255)
				WinSetTransparent(Fade, "ahk_id " myGui.Hwnd)
			Sleep(15)
			ToolTip(Fade)
		}		
	}

}

