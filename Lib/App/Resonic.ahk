#Include <Paths>
#Include <Utils\Win>


Class Resonic {

	static exeTitle  := "ahk_exe Resonic.exe"
	static WinTitle  := "Resonic " this.exeTitle
	static Path      := Paths.Ptf["Resonic"]

	static WinObj := Win({
		WinTitle: this.WinTitle,
		exePath: this.Path
	})
	
	static __Call(Method, Params) => this.WinObj.%Method%(Params*)

	static Panel := Map(
		"Find",	"TLiqubeEdit1"
	)

	static Focus(Panel) {
		Ctrl.Activate(this.Panel[Panel])
	}

	class FindBox extends Resonic {

		static __Call(Panel, item) {
			
			this.Focus(Panel)
			Sleep(100)
			if item.Has(1)
				Send("^a+{BS}{Raw}" item[1])

		}
	} 
}