#Include <Paths>
#Include <Utils\Win>

Class VsCode {

	static exeTitle  := "ahk_exe Code.exe"
	static WinTitle  := "Visual Studio Code " this.exeTitle
	static Path      := Paths.Ptf["VsCode"]

	static Exception := "VsCodeIntegratedTerminal"

	static WinObj := Win({
		WinTitle: this.WinTitle,
		exePath:  this.Path
	})

	static IndentRight()   => Send("{Tab}")
    static IndentLeft()    => Send("+{Tab}")
	static Comment()       => Send("^q")

	static Undo() => Send("^z")
	static Redo() => Send("^+z")

	static __Call(Method, Params) => this.WinObj.%Method%(Params*)

}