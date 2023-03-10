#Include <Alert>

class WinGet {

	static ClientPos(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) {

		try WinGetClientPos(&X, &Y, &W, &H, WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
		catch any as Err {

			alert.Err(Err)
			Exit()
		} 
		return {X: X, Y: Y, W: W, H: H}
	}

	static Pos(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) {

		try WinGetPos(&X, &Y, &W, &H, WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
		catch any as Err {

			alert.Err(Err)
			Exit()
		} 
		return {X: X, Y: Y, W: W, H: H}
	}

	static MinMax(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) {

		try MinMax := WinGetMinMax(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
		catch any as Err {

			alert.Err(Err)
			Exit()
		} 
		return MinMax
	}

	static ExStyle(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) {

		try ExStyle := WinGetExStyle(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
		catch Any as Err {

			alert.Err(Err)
			return false
		}
		return ExStyle
	}
}