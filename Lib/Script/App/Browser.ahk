#Include <App\Browser>

#HotIf WinActive(Browser.WinTitle)

	F18:: Browser.ReOpenClosedTab()
	F21:: Browser.CloseTab()
	F20:: Send("{f}")

	; WheelLeft
	Volume_Down:: Browser.PrevTab()

	; WheelRight
	Volume_Up:: Browser.NextTab()

#HotIf 