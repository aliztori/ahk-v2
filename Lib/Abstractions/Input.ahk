Class Input {
	
	static Call(Length := 1, Timeout?, EndKeys?) {

		Options := IsSet(Length) ? "L" Length : unset

		ih := InputHook(Options?, EndKeys?)
		ih.Start()
		ih.Wait(Timeout?)
		
		return ih.Input
	}

	static GetKey(Timeout?) {

		ih := InputHook("S")	
		ih.VisibleNonText := false
		ih.VisibleText := false

		ih.KeyOpt("{All}", "E")

		ih.Start()
		ih.Wait(Timeout?)

		return ih.EndKey
	}

	static GetKeyCombo(Options?, Timeout?)
	{
		ih := InputHook(Options?)
		ih.VisibleNonText := false
		ih.VisibleText := false

		ih.KeyOpt("{All}", "E")
		ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")

		ih.Start()
		ih.Wait(Timeout?)
		
		return ih.EndMods . ih.EndKey  ; Return a string like <^<+Esc
	}
}
