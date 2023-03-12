#Include <App\VsCode>

#HotIf WinActive(VsCode.WinTitle)

	CapsLock:: Send(";")	

	; WheelRight:
	Volume_Up::VsCode.IndentRight()

	; WheelLeft:
	Volume_Down::VsCode.IndentLeft()


	F13:: VsCode.Undo()
	F16:: VsCode.Redo()

	F20::VsCode.Comment()

	F22::
	^r:: {
		Send("^s")
		Reload
	}


#HotIf