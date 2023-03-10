#Include <Alert>
#Include <Abstractions\Detect>

class Script {
	
	static __New() {

		SetIcon.Main()
		
		this.isReloaded()
			? alert(A_ScriptName " Reloaded")
			: alert(A_ScriptName " Runing")
		
		
		Suspend.DefineProp("Call", {
			Call:(this, mode := -1) => ((Func.Prototype.Call)(this, mode), OnSuspend())
		})
		Pause.DefineProp("Call", {
			Call:(this, mode := -1) => ((Func.Prototype.Call)(this, mode), OnPause())
		})
		OnExit(ExitFunc, -1)

		OnSuspend() {

			if A_IsSuspended
			{
				if A_IsPaused
					SetIcon.PauseSuspend()
				else
					SetIcon.Suspend()

				alert(A_ScriptName " Suspended")			
			} 
			else 
			{
				if A_IsPaused
					SetIcon.Pause()
				else
					SetIcon.Main()

				alert(A_ScriptName " Unsuspended")
			}
		}

		OnPause() {

			if A_IsPaused
			{
				if A_IsSuspended
					SetIcon.PauseSuspend()
				else
					SetIcon.Pause()

				alert(A_ScriptName " Paused")
			} 
			else 
			{
				if A_IsSuspended
					SetIcon.Suspend()
				else
					SetIcon.Main()

				alert(A_ScriptName " UnPaused")	
			}
		}

		ExitFunc(ExitReason, ExitCode) {
			
			; switch ExitReason {

				; case "Reload":
				; 	Result := MsgBox("Are you sure you want to exit?", ExitReason, 4)
				; 	if Result = "No"
				; 		return true
				
				; case "Shutdown", "Logoff", "Close", "Error":
				; 	Result := MsgBox("Are you sure you want to exit?", ExitReason, 4)
				; 	if Result = "No"
				; 		return true

				; case "Exit":
				; 	alert("Script Closed...")
				; 	Sleep(3000)

				; case "Single":
				; 	alert("Replaced by a New Instance of Itself")
				; 	Sleep(3000)
					
				; case "Menu":
				; 	alert("Exit from the Main Window's Menu or from the Standard Tray Menu.")
				; 	Sleep(3000)
			; }

			return false
		}
	}

	static IsReloaded() => DllCall("GetCommandLine", "str") ~= "i) /r(estart)?(?!\S)"

	static Suspend(ScrNameorHwnd, Mode := -1) {

		Detect(true, 2)
		Detect.Save()

		ScrName := ScrNameorHwnd is String ? ScrNameorHwnd : Scr.Name(ScrNameorHwnd)

		try IsSuspended := Scr.Suspend(ScrName, Mode)
		catch Any as Err
			alert.Err(Err)
		else 
			alert(
				ScrName (IsSuspended ? " Suspended" : " UnSuspended")	
			)
		
		Detect.Restore()
	}

	static Pause(ScrNameorHwnd, Mode := -1) {

		Detect(true, 2)
		Detect.Save()

		ScrName := ScrNameorHwnd is String ? ScrNameorHwnd : Scr.Name(ScrNameorHwnd)

		try IsPaused := Scr.Pause(ScrName, Mode)
		catch Any as Err
			alert.Err(Err)
		else 
			alert(
				ScrName (IsPaused ? " Pauseed" : " UnPauseed")	
			)
		
		Detect.Restore()
	}

	static Reload(ScrNameorHwnd) {

		Detect(true, 2)
		Detect.Save()

		ScrName := ScrNameorHwnd is String ? ScrNameorHwnd : Scr.Name(ScrNameorHwnd)

		try Scr.Reload(ScrName)
		catch Any as Err
			alert.Err(Err)
		else
			alert(ScrName " Reloaded")

		Detect.Restore()
	}

	static Close(ScrNameorHwnd) {
	
		Detect(true, 2)
		Detect.Save()

		ScrName := ScrNameorHwnd is String ? ScrNameorHwnd : Scr.Name(ScrNameorHwnd)

		PID := WinGetPID(ScrName " ahk_class AutoHotkey")
		
		if ProcessClose(PID)
			alert(ScrName " Closed")
		else
			alert("A Matching Process is Not Found or Cannot be Manipulated")

		Detect.Restore()
	}

	static All(Event, Mode := -1) {

		Detect.Save()
		Detect()

		All := WinGetList("ahk_class AutoHotkey")
		
		for Hwnd in All {

			if Hwnd = A_ScriptHwnd
				continue
			
			ScrName := Scr.Name(Hwnd)
			switch Event {
				
				case "Suspend", "Pause":
					try _is := Scr.%Event%(Hwnd, Mode)
					catch Any as Error
						alert.Err(Error)
					else
						alert ScrName " "  (_is ?  Event "ed" : " Un" Event "ed")

				case "Close", "Reload":
					try Scr.%Event%(Hwnd)
					catch Any as Error
						alert.Err(Error)
					else
						alert(ScrName " " Event "ed")

			}
		}
			

		Detect.Restore()
	}
}

class Scr {

	static ID_FILE_SUSPEND := 65404
	static ID_FILE_RELOAD := 65303
	static ID_FILE_PAUSE := 65403
	static WM_COMMAND := 0x0111

	static IsSuspended(ScriptHwnd) {

		; Get the menu bar.
		mainMenu := DllCall("GetMenu", "ptr", ScriptHwnd)
		; Get the File menu.
		fileMenu := DllCall("GetSubMenu", "ptr", mainMenu, "int", 0)
		; Get the state of the menu item.
		state := DllCall("GetMenuState", "ptr", fileMenu, "uint", this.ID_FILE_SUSPEND, "uint", 0)
		; Get the checkmark flag.
		isSuspended := state >> 3 & 1
		; Clean up.
		DllCall("CloseHandle", "ptr", fileMenu)
		DllCall("CloseHandle", "ptr", mainMenu)

		return isSuspended
	}

	static IsPaused(ScriptHwnd) {

		static WM_ENTERMENULOOP := 0x211
		static WM_EXITMENULOOP := 0x212

		SendMessage WM_ENTERMENULOOP,,,, "ahk_id " ScriptHwnd
		SendMessage WM_EXITMENULOOP,,,, "ahk_id " ScriptHwnd

		hMenu := DllCall("GetMenu", "uint", ScriptHwnd)
		hMenu := DllCall("GetSubMenu", "uint", hMenu, "int", 0)
		return (DllCall("GetMenuState", "uint", hMenu, "uint", 4, "uint", 0x400) & 0x8) != 0
	}
	
	static Suspend(ScrCriteria, Mode := -1) {

		Hwnd := ScrCriteria is Number ? ScrCriteria : this.Exist(ScrCriteria)
		IsSuspended := Scr.IsSuspended(Hwnd)

		if Mode = -1 || (Mode ^ IsSuspended) {
			PostMessage(this.WM_COMMAND, this.ID_FILE_SUSPEND,,, ScrCriteria)
			return !IsSuspended
		}
		
		return IsSuspended
	}

	static Pause(ScrCriteria, Mode := -1) {

		Hwnd := ScrCriteria is Number ? ScrCriteria : this.Exist(ScrCriteria)
		isPaused := Scr.isPaused(Hwnd)
		
		if Mode = -1 || (Mode ^ isPaused) {
			PostMessage(this.WM_COMMAND, this.ID_FILE_PAUSE,,, ScrCriteria)
			return !isPaused
		}

		return isPaused
	}

	static Reload(ScrCriteria) {
		PostMessage(this.WM_COMMAND, this.ID_FILE_RELOAD,,, ScrCriteria)
	}

	static Close(ScrCriteria) {
		PostMessage(0x0010,,,, ScrCriteria)
	}

	static Exist(WinTitle) => WinExist(WinTitle " ahk_class AutoHotkey")
	static Name(hwnd) => RegExReplace(WinGetTitle("Ahk_id " hwnd), "( -.*$)|(^.*\\)")
}

class SetIcon {
	static __Call(Name, Params) => TraySetIcon(Paths.Icons[Name],, Name ~= "Suspend|Pause")
}

