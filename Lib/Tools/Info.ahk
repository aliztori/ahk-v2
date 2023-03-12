#Include <Abstractions\Registers>
#Include <Abstractions\Input>
#Include <Extensions\Gui>

;Made by @Axlefublr, rewritten and Modified into my style
; https://github.com/Axlefublr/lib-v2/blob/main/Tools/Info.ahk


Info(Text, Timeout := 0) => Infos(Text, Timeout).Hwnd

Class Infos {

	static RanOnce := false
	static GuiWidthModifier := 6
	Hwnd => this.gInfo.Hwnd

	static Toggle(Text, Timeout := 3000) {

		GTi := Gui("AlwaysOnTop -Caption +ToolWindow").DarkMode().MakeFontNicer()
		GTi.Add("Text", 0x80, Text)
		GTi.Show("NA x1600 y640")
		SetTimer(() => GTi.Destroy(), -Timeout)
	}


	/**
	 * To use Info, you just need to create an instance of it, no need to call any method after
	 * @param text *String*
	 * @param AutocloseTimeout *Integer* in milliseconds. Doesn't close automatically
	 */
	__New(Text, Timeout := 0) {

		this.Text := Text
		this.Timeout := Timeout

		this.__CreatGui()
		this.__DoOnce()

		if !this.__GetAvailableSpace()
				this.__StopDueToNoSpace()

		this.__SetupHotkeysAndEvents()
		this.__SetupAutoclose()
		this.__Show()
	}

	__CreatGui() {

		this.gInfo := Gui("AlwaysOnTop -Caption +ToolWindow")
		this.gInfo.DarkMode().MakeFontNicer()
		this.gtext := this.gInfo.AddText(0x80, this.Text)
	}

	__DoOnce() {

		if Infos.RanOnce
			return

		Infos.GuiWidth := this.gInfo.MarginY * Infos.GuiWidthModifier
		Infos.maximumInfo  := Floor(A_ScreenHeight / Infos.GuiWidth)

		Infos.AvailablePlaces := Map()

		loop Infos.maximumInfo
			Infos.AvailablePlaces.Set(A_index * Infos.GuiWidth - Infos.GuiWidth, false)

		Infos.RanOnce := true
	}

	__GetAvailableSpace() {

		for key, value in Infos.AvailablePlaces {
			if value = false {
				this.CurrYCoord := key
				Infos.AvailablePlaces[this.CurrYCoord] := true
				return true
			}
		}
		Exit()
	}

	__SetupHotkeysAndEvents() {

		HotIfWinExist("ahk_id " this.gInfo.Hwnd)
		Hotkey("Escape", this.__bfDestroy, "On")
		
		this.gInfo.OnEvent("Close", this.__bfDestroy)

		this.Gtext.OnEvent("Click", this.__bfDestroy)
		this.Gtext.OnEvent("ContextMenu", OnRClick)

		OnRClick(*) {

			this.__bfDestroy()
			ToolTip("input key")

			key :=  Input.GetKey()

			if key = "Escape" 
				alert "action Cancelled"

			else if key = "Enter"
				Clip(this.Text)
			
			else
				Registers(key).Write(this.Text)
		
			ToolTip()
		}
	}

	__bfDestroy := this.__Destroy.Bind(this)
	__Destroy(*) {

		try HotIfWinExist("ahk_id " this.gInfo.Hwnd)
		catch Any
			return false

		Hotkey("Escape", "Off")
		this.gInfo.Destroy()
		Infos.AvailablePlaces[this.CurrYCoord] := false
		return true
	}
    
	__StopDueToNoSpace() => this.gInfo.Destroy()

	__SetupAutoclose() => SetTimer((*) => this.__Destroy(), -this.Timeout)
	__Show() => this.gInfo.Show("AutoSize NA X10 Y" this.CurrYCoord + 10)
}

