class Coord {

	static __Call(RelativeTo, TargetTypes) {
		
		if (TargetTypes.Length = 0)
			TargetTypes := ["ToolTip", "Pixel", "Mouse", "Caret", "Menu"]

		for Target in TargetTypes
			CoordMode(Target, RelativeTo)			
	}

	static SaveMode(TargetTypes*) {
		for Target in TargetTypes
			this.SavedMode%Target% := A_CoordMode%Target%
	}

	static RestoreMode(TargetTypes*) {
		for Target in TargetTypes
			CoordMode(Target, this.SavedMode%Target%)
	}
}
