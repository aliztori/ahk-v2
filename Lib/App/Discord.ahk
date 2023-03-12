#Include <Paths>
#Include <Utils\Win>


Class Discord {

	static exeTitle  := "ahk_exe Discord.exe"
	static WinTitle  := " - Discord"
	static ExcludeTitle := "Updater" ;Don't consider the window to be discord if it has this in its title
	static Path      := Paths.Ptf["Discord"]

	static WinObj := Win({
	   winTitle:  this.WinTitle,
	   exePath:   this.path,
	   ExcludeTitle: this.ExcludeTitle
	})

	static __Call(Method, Params) => this.WinObj.%Method%(Params*)

}