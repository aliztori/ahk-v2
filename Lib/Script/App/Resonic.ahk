#Include <App\Resonic>

#HotIf WinActive(Resonic.WinTitle)

	`::{

		if !Ctrl.IsActive(Resonic.Panel["Find"])
			Send("{F2}")
		Resonic.FindBox.Find("")
	}

	MButton::{

		if Mouse.IsOverCtrl(Resonic.Panel["Find"]) {
			Resonic.FindBox.Find("")
		} else Send("{F2}")

	}

#HotIf
