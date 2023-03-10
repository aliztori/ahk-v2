#Include <Paths>
#Include <Utils\Win>

Class Explorer {

	static WinTitleRegex := "^[A-Z]: ahk_exe explorer\.exe"

	Class WinObj {

	   static EditStuff := Win({WinTitle: "Editing Stuff",exePath: Paths.EditingStuff})
	   static Media := Win({WinTitle: "Media", exePath: Paths.RootMedia})
	   static Root := Win({WinTitle: "Tool's", exePath: Paths.RootDir})
	}
}
