#Include <Extensions\Array>
#Include <Extensions\String>
#Include <Misc>

class Hot {

	static First(HotKey)  => RegExReplace(HotKey, "&.*$|\s")
	static Second(HotKey) => RegExReplace(HotKey, "^.*&|\s|(?i:up$)")
	static Both(HotKey)   => [this.First(Hotkey), this.Second(Hotkey)]

	static Raw(HotKey := A_ThisHotkey, Which?) {

		Hotkey := RegExReplace(Hotkey, "i)\s+up$")
		Hotkey := RegExReplace(Hotkey, "^[#^!+<>~*$]+(.+)", "$1")
		; Hotkey := RegExReplace(Hotkey, "^[#^!+<>~*$]+(\w{0,}(?!\sup)?)", "$1")
		
		if InStr(Hotkey, " & ")
		{
			switch (Which ?? 2) 
			{		
				case 0: return this.Raw(HotKey, 1) " & " this.Raw(HotKey, 2)
				case 1: return this.First(Hotkey)
				case 2: return this.Second(Hotkey)				
				case 3: return this.Both(Hotkey)
			}	
		}

		return Hotkey 		
	}

	static Keys(Hotkey := A_ThisHotkey) {

		KeyNames := Array()

		Regex := RegExMatchAll(Hotkey, "i)(?:[*$~])?(?'LeftRight'[<>RL])?(?'Symbol'[#!^+])")

		loop Regex.Length
		{
			Key := ""
			Match := Regex[A_Index]
			; MsgBox Match[1]

			Switch Match['LeftRight'] {
				Case "<":Key .= "L"
				Case ">":Key .= "R"
			}
	
			Switch Match['Symbol'] {
				Case "#":Key .= "Win"
				Case "!":Key .= "Alt"
				Case "^":Key .= "Ctrl"
				Case "+":Key .= "Shift"
			}

			if key = "Win"
				key := "Lwin"

			if Key != "" && !KeyNames.HasVal(Key)
				KeyNames.Push(Key)
		}

		

		; Ctrl 
		; if Hotkey.Find("<^")
		; 	KeyNames.Push("LCtrl")

		; if Hotkey.Find(">^")
		; 	KeyNames.Push("RCtrl")

		; else {
		; 	RegExMatch(Hotkey, "([<>]?+\^)[^\s]?", &Match)
		; 	if Match[1] = "^"
		; 		KeyNames.Push("Ctrl")
		; }


		; ; Alt 
		; if Hotkey.Find("<!")
		; 	KeyNames.Push("LAlt")

		; if Hotkey.Find(">!")
		; 	KeyNames.Push("RAlt")

		; else {
		; 	RegExMatch(Hotkey, "([<>]?!)[^\s]?", &Match)
		; 	if Match[1] = "!"
		; 		KeyNames.Push("Alt")
		; } 
		
		; ; Shift 
		; if Hotkey.Find("<+")
		; 	KeyNames.Push("LShift")

		; if Hotkey.Find(">+")
		; 	KeyNames.Push("RShift")

		; else {
		; 	RegExMatch(Hotkey, "([<>]?\+)[^\s]?", &Match)
		; 	if Match[1] = "+"
		; 		KeyNames.Push("Shift")
		; } 

		; ; Win
		; if Hotkey.Find("<#")
		; 	KeyNames.Push("LWin")

		; if Hotkey.Find(">#")
		; 	KeyNames.Push("RWin")

		; else {
		; 	RegExMatch(Hotkey, "([<>]?#)[^\s]?", &Match)
		; 	if Match[1] = "#"
		; 		KeyNames.Push("LWin")
		; }

		
		Key := this.Raw(Hotkey, 3)

		if Key is Array
			KeyNames.Push(Key*)
		else
			KeyNames.Push(Key)

		return KeyNames
	}

	static KeyWait(Hotkey, Options?) {

		Timeout := ""
		do := "Release"

		if IsSet(Options)
		{
			if Options.RegExMatch("T(\d*\.?\d+)", &Time)
				Timeout := " in " Time[1] " Seconds:"

			if Options.Find("D")
				do := "Press"
		}

		Keys := this.Keys(Hotkey)

		if do = "Release"
			Keys.Reverse()

		KeyList := Keys.Join("`n")
		; KeyList := "`n".Join(Keys)

		for KeyName in Keys {

			ToolTip(do Timeout "`n" KeyList)
			KeyList := StrReplace(KeyList, KeyName "`n")

			if KeyWait(KeyName, Options?)
				continue
			
			ToolTip()
			return false
		}

		ToolTip()
		return true
	}

	static KeyState(Hotkey, Mode := "P") {
		
		for KeyName in this.Keys(Hotkey)
			if not Getkeystate(KeyName, Mode)
				return false	

		return true
	}

	; static KeyWait(Hotkey, Options?) {
		
	; 	for KeyName in this.Keys(Hotkey)
	; 		if not KeyWait(Hotkey, Options?)
	; 			return false	

	; 	return true
	; }
}

Raw(HotKey := A_ThisHotkey) => Hot.Raw(HotKey)


