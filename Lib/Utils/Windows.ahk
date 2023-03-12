#Include <Tools\Tippy>
#Include <Utils\Hot>


class Windows {

	static Drag() {
	
		CoordMode("Mouse", "Screen")
		MouseGetPos(&Cx1, &Cy1, &WinID)
		WinTitle := "Ahk_id " WinID

		try {
			if WinGetMinMax(WinTitle) {
				Tippy("The window is Maximized.")
				return
			}
		} catch TargetError {
			alert('window could not be found.')
			return
		}


		WinGetPos(&WinX1, &WinY1,,, WinTitle)

		while Hot.KeyState(A_ThisHotkey)
		{
			MouseGetPos(&Cx2, &Cy2)

			Cx2 -= Cx1
			Cy2 -= Cy1

			WinX2 := (WinX1 + Cx2)
			WinY2 := (WinY1 + Cy2)

			WinMove(WinX2, WinY2,,, WinTitle)
		}
	}

	static Resize() {
	
		CoordMode("Mouse", "Screen")

		MouseGetPos(&Cx1, &Cy1, &WinID)
		WinTitle := "Ahk_id " WinID

		try {
			if WinGetMinMax(WinTitle) {
				Tippy("The window is Maximized.")
				return
			}
		} catch TargetError {
			alert('window could not be found.')
			return
		}

		WinGetPos(&WinX1, &WinY1, &WinW, &WinH, WinTitle)

		WinLeft := (Cx1 < WinX1 + WinW / 2) ? 1 : (-1)
		WinUp 	:= (Cy1 < WinY1 + WinH / 2) ? 1 : (-1)

		while Hot.KeyState(A_ThisHotkey)
		{
			MouseGetPos(&Cx2, &Cy2)
			WinGetPos(&WinX1, &WinY1, &WinW, &WinH, WinTitle)

			Cx2 -= Cx1
			Cy2 -= Cy1

			X := WinX1 + (WinLeft + 1) / 2 * Cx2
			Y := WinY1 + (WinUp + 1) / 2 * Cy2
			W := WinW  - WinLeft * Cx2
			H := WinH  - WinUp * Cy2

			Cx1 += Cx2
			Cy1 += Cy2

			WinMove(X, Y, W, H, WinTitle)
		}
	}
}