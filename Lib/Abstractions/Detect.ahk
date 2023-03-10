class Detect {

	static Call(windows := true, title := 2) => (
		DetectHiddenWindows(windows)
		SetTitleMatchMode(title)
	)

	static Save() => (
		this.SavedWindows := A_DetectHiddenWindows
		this.SavedTitle := A_TitleMatchMode
	)

	static Restore() => (
		DetectHiddenWindows(this.savedWindows)
		SetTitleMatchMode(this.savedTitle)
	)
}