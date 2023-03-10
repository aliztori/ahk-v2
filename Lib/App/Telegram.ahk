#Include <Abstractions\Image>
#Include <Abstractions\Mouse>
#Include <Utils\Win>
#Include <Paths>
#Include <Misc>


Class Telegram {

	static processExe  	:= "Telegram.exe"
	static exeTitle 	:= "ahk_exe " this.processExe
	; static winTitle 	:= "Telegram " this.exeTitle
	static winTitle 	:= "ahk_class Qt5158QWindowIcon"
	static path 		:= Paths.Ptf["Tel"]

	static notifTitle	:= "ahk_class Qt5158QWindowToolSaveBits"

	static winObj := Win({
		WinTitle: this.winTitle,
		ExcludeTitle: this.notifTitle,
		exePath: this.path
	})

	static __Call(Method, Params) => this.winObj.%Method%(Params*)



	static img[item] => Paths.Telegram[item]

	static SwitchAcc(AccNumber) {

		Hot.KeyWait(A_ThisHotkey)
		
		BlockInput(true)
		Mouse.SavePos()
		Coord.Screen("Mouse", "Pixel")

		T := WinGet.ClientPos(this.winTitle,, this.NotifTitle)
		MouseClick("L", T.X + 45, T.Y + 35, 1, 0)
		
		coordObj := {
			x1: T.x,
			y1: T.y,
			x2: T.X + 500,
			y2: T.Y + 250
		}

		if !(img := Image.WaitSearch(coordObj, 300,	 this.img["Fold"])) {
			MouseClick("L", T.X + 300, T.Y + 150, 1, 0)
		}

		coordObj := {
			x1: T.x,
			y1: T.y,
			x2: (T.w + T.x),
			y2: (T.h + T.y)
		}
		
		static dist := [200, 250, 300]

		if Image.WaitSearch(coordObj, 300, this.img["AddAcount"])
			MouseClick("L", T.X + 45, T.Y + dist[AccNumber], 1, 0)

		Mouse.RestorePos()
		BlockInput(false)
	}

	static Notif(Mode) {

		SetTitleMatchMode("RegEx")
		Wins := WinGetList("ahk_class WindowToolSaveBits")

		if Wins.Length = 0 {
			alert("No Notif Win Found")
			return false
		}
		
		static Counter := 0
		
		loop {

			if ++Counter > Wins.Length
				Counter := 1

			notif := WinGet.ClientPos("ahk_id " Wins[Counter])

			
		} until notif.H > 70

		Mouse.SavePos()
		Coord.Screen("Mouse", "Pixel")
		
		MouseMove(notif.X + 50, notif.Y + 50, 0)
		
		coordObj := {
			x1: notif.X + (notif.W/4),
			y1: notif.Y + (notif.H/2),
			x2: notif.X + notif.W,
			y2: notif.Y + notif.H
		}

		switch Mode {
			case "Reply":
				Reply()

			case "Seen":
				Reply(), Send("{Enter}")
			
			case "Click":
				Click()
		}

		Reply() {
			if img := Image.WaitSearch(coordObj, 300, this.img["Reply"])
				Click(img.X + 10, img.Y + 10)
		}

		Mouse.RestorePos()
		return true
	}

	static WaitNotif(Mode) {
		
		static Toggle := false
		toggle := !toggle
		
		alert("Waiting to " Mode  " " VarState(toggle))

		while Toggle {

			WinWait(this.notifTitle)
			switch mode {
				case "Click":
					this.Notif("Click")
	
				case "Close":
					WinClose()
			}
		}
		
	}
}