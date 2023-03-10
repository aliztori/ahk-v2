#Include <Paths>
#Include <Utils\Win>


Class Browser {

	static exeTitle := "ahk_exe chrome.exe"
	static WinTitle := "Google Chrome " this.exeTitle
	static Path     := Paths.Ptf["Chrome"]

	static WinObj := Win({
	   WinTitle: this.WinTitle,
	   exePath: this.Path
	})
	
	static __Call(Method, Params) => this.WinObj.%Method%(Params*)

	static FullScreen()		 => Send("{f}")

	static Reload()          => Send("^r")
	static NewTab()          => Send("^t")
	static CloseTab()        => Send("^w")
	static ReopenClosedTab() => Send("^+t")

	static NextTab() 		 => Send("^{tab}")
	static PrevTab() 		 => Send("^+{tab}")
}