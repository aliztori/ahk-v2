#Include <Utils\Win>
#Include <Utils\Monitor>
#Include <Utils\Coord>
#Include <Abstractions\Image>


class Mouse {

	static Coord(Coord?) => IsSet(Coord) ? CoordMode("Mouse", Coord) : ""

	static X[Coord?]	 => (this.Coord(Coord?), MouseGetPos(&X), X)
	static Y[Coord?]	 => (this.Coord(Coord?), MouseGetPos(, &Y), Y)
	static Win 			 => (MouseGetPos(,, &Win), Win)
	static Ctrl[Flag?] 	 => (MouseGetPos(,,, &Ctrl, Flag?), Ctrl)

	static Pixel[Mode?] => (M := this.GetPos("Screen"), PixelGetColor(M.X, M.Y, Mode?))

	static __Item[Coord?, Flag?] {
		get {
			this.Coord(Coord?)
			MouseGetPos(&X, &Y, &Win, &Ctrl, Flag?)
			return {X: X, Y: Y, Win: Win, Ctrl: Ctrl}
		}
	}

	static Call(Coord?, Flag?) {
		this.Coord(Coord?)
		MouseGetPos(&X, &Y, &Win, &Ctrl, Flag?)
		return {X: X, Y: Y, Win: Win, Ctrl: Ctrl}
	}

	static WinObj => Win({WinTitle: "ahk_id " Mouse.Win})
	static __Call(Method, Params) => this.WinObj.%Method%(Params*)
	
	static IsOverCtrl(ID, Flag?)
	{	
		if IsSet(Flag)
			return (ID = this.Ctrl[Flag])

		return (ID = this.Ctrl[0] || ID = this.Ctrl[1] || ID = this.Ctrl[2])
	}

	static IsOverWin(WinTitle, WinText?, ExcludeTitle?, ExcludeText?) {
		WinTitle := WinTitle " ahk_id " this.Win
		return WinExist(WinTitle, WinText?, ExcludeTitle?, ExcludeText?)
	}

	static GetPos(Coord?, X := "X", Y := "Y")
	{
		if (isSet(Coord) ? (Coord = "Monitor") : false)
		{
			this.Coord("Screen")
			MouseGetPos(&XX, &YY)

			MM := Monitor.Mouse()
			XX -= MM.X
			YY -= MM.Y
			return {%X%: XX, %Y%: YY}
		}

		this.Coord(Coord?)
		MouseGetPos(&XX, &YY)
		return {%X%: XX, %Y%: YY}
	}

	static GetID(Win := "Win", Ctrl := "Ctrl", Flag?) {
		MouseGetPos(, , &WinID, &CtrlID, Flag?)
		return {%Win%: WinID, %Ctrl%: CtrlID}
	}

	static SavePos() {

		Coord.SaveMode("Mouse")	
		this.Coord("Screen")

		MouseGetPos(&X, &Y)
		this.SavedX := X
		this.SavedY := Y

		Coord.RestoreMode("Mouse")
	}

	static RestorePos() {
		
		Coord.SaveMode("Mouse")
		this.Coord("Screen")

		MouseMove(this.SavedX, this.SavedY, 0)
		
		Coord.RestoreMode("Mouse")
	}

	static Click(WhichButton?, X?, Y?, ClickCount?, Speed?, DownOrUp?, Relative?) {

		this.SavePos()
		Sleep(16)

		MouseClick(WhichButton?, X?, Y?, ClickCount?, Speed?, DownOrUp?, Relative?)

		Sleep(16)
		this.RestorePos()
	}

	static ClickDrag(WhichButton, X1, Y1, Speed?, Relative?) {
		this.SavePos()
		Sleep(16)
		MouseClickDrag(WhichButton, X1, Y1, this.SavedX, this.SavedY, Speed?, Relative?)
	}

	static ImageSearch(&X, &Y, xCorner?, yCorner?, lowerRight := true, ImageFiles*) {

		if lowerRight
		{
			xCorner := xCorner ?? Monitor.Virtual.W
			yCorner := yCorner ?? Monitor.Virtual.H
		}
		else
		{
			xCorner := xCorner ?? 0
			yCorner := yCorner ?? 0
		}
		
		MousePos := this.GetPos("Screen")
		
		if lowerRight
			return Image.Search(&X, &Y, MousePos.X, MousePos.Y, xCorner, yCorner, ImageFiles*)

		return Image.Search(&X, &Y, xCorner, yCorner, MousePos.X, MousePos.Y, ImageFiles*)
	}

	static ImageWaitSearch(&X, &Y, xCorner?, yCorner?, lowerRight := true, timeOut := 5000, ImageFiles*) {

		flag := true
		SetTimer(() => flag := false, -timeOut)

		while flag {

			ToolTip("Searching... " A_Index)
			if this.ImageSearch(&X, &Y, xCorner?, yCorner?, lowerRight, ImageFiles*)
				return (ToolTip(), true)
		}

		return (ToolTip(), false)
	}

	class Move {

		; static Call() {
		; 	; MouseMove()
		; }

		static Left(howMuch)  => MouseMove(-Abs(howMuch) , 0, 0, "R")
		static Up(howMuch)    => MouseMove(0, -Abs(howMuch), 0, "R")
		static Down(howMuch)  => MouseMove(0, Abs(howMuch), 0, "R")
		static Right(howMuch) => MouseMove(Abs(howMuch), 0, 0, "R")
	}
}

