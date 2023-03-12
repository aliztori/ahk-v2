#Include <Extensions\Gui>

;Made by @Axlefublr, rewritten and Modified into my style
; https://github.com/Axlefublr/lib-v2/blob/main/Tools/CleanInputBox.ahk



; CleanInputBox() => InpBox().WaitForInput()

; Class InpBox extends Gui {

; 	Width     := Round(A_ScreenWidth  / 1920 * 700)
; 	TopMargin := Round(A_ScreenHeight / 1080 * 50)


; 	/**
; 	 * Get a gui to type into.
; 	 * Close it by pressing Escape. (This exits the entire thread)
; 	 * Accept your input by pressing Enter.
; 	 * Call WaitForInput() after creating the class instance.
; 	 */
; 	__New() {

; 		super.__New("AlwaysOnTop -Caption")
; 		super.DarkMode().MakeFontNicer(30)
; 		; super.MarginX := 0

; 		super.InputField := super.AddEdit(

; 			"x0 Center -E0x200 Background"
; 			super.BackColor " w" this.Width

; 		)

; 		this.Input := ""
; 		this.isWaiting := true
; 		this.__RegisterHotkeys()
; 		this.__Show()
; 	}

; 	__Show() => super.Show("y" this.TopMargin " w" this.Width)

; 	/**
; 	 * Occupy the thread until you type in your input and press
; 	 * Enter, returns this input
; 	 * @returns {String}
; 	 */
; 	WaitForInput() {
; 		while this.isWaiting {
; 		}

; 		return this.Input
; 	}

; 	__SetInput() {

; 		this.Input := super.InputField.Text

; 		this.isWaiting := false
; 		this.__Finish()
; 	}

; 	__SetCancel() {

; 		this.isWaiting := false
; 		this.__Finish()
; 	}

; 	__RegisterHotkeys() {

; 		HotIfWinactive("ahk_id " super.Hwnd)
; 		Hotkey("Enter", (*) => this.__SetInput(), "On")
; 		Hotkey("NumpadEnter", (*) => this.__SetInput(), "On")

; 		super.OnEvent("Escape", (*) => this.__SetCancel())
; 		super.OnEvent("Close", (*) => this.__SetCancel())
; 	}

; 	__Finish() {
		
; 		HotIfWinactive("ahk_id " super.Hwnd)
; 		Hotkey("Enter", "Off")
; 		Hotkey("NumpadEnter", "Off")
		
; 		super.Minimize()
; 		super.Destroy()
; 	}
; }


Class CleanInputBox {

	static Width     := Round(A_ScreenWidth  / 1920 * 700)
	static TopMargin := Round(A_ScreenHeight / 1080 * 50)


	static Call() {

		this.InpGui := Gui("AlwaysOnTop -Caption")
		this.InpGui.DarkMode().MakeFontNicer(30)

		this.InpGui.InputField := this.InpGui.AddEdit(

			"x0 Center -E0x200 Background"
			this.InpGui.BackColor " w" this.Width

		)

		this.Input := ""
		this.isWaiting := true
		this.__RegisterHotkeys()
		this.__Show()


		return this.WaitForInput()
	}


	static __Show() => this.InpGui.Show("y" this.TopMargin " w" this.Width)

	/**
	 * Occupy the thread until you type in your input and press
	 * Enter, returns this input
	 * @returns {String}
	 */
	static WaitForInput() {

		while this.isWaiting {
		}

		return this.Input
	}

	static __SetInput() {

		this.Input := this.InpGui.InputField.Text

		this.isWaiting := false
		this.__Finish()
	}

	static __SetCancel() {

		this.isWaiting := false
		this.__Finish()
	}

	static __RegisterHotkeys() {
		HotIfWinactive("ahk_id " this.InpGui.Hwnd)
		Hotkey("Enter", (*) => this.__SetInput(), "On")
		Hotkey("NumpadEnter", (*) => this.__SetInput(), "On")

		this.InpGui.OnEvent("Escape", (*) => this.__SetCancel())
		this.InpGui.OnEvent("Close", (*) => this.__SetCancel())
	}

	static __Finish() {
		
		HotIfWinactive("ahk_id " this.InpGui.Hwnd)
		Hotkey("Enter", "Off")
		Hotkey("NumpadEnter", "Off")
		
		; this.InpGui.Minimize()
		this.InpGui.Destroy()
	}
}