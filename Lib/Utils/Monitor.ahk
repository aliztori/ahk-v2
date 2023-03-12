#Include <Abstractions\Mouse>

class Monitor {

	static Call(N?) {
		MonitorGet(N?, &Left?, &Top?, &Right?, &Bottom?)
		return {Left: Left, Top: Top, Right: Right, Bottom: Bottom}
	}
	static WorkArea(N?) {
		MonitorGetWorkArea(N?, &Left?, &Top?, &Right?, &Bottom?)
		return {Left: Left, Top: Top, Right: Right, Bottom: Bottom}
	}
	
	static Name[N?] => MonitorGetName(N?)
	static Primary 	=> MonitorGetPrimary()
	static Count 	=> MonitorGetCount()
	
	class Virtual {

		static X => SysGet(76)
		static Y => SysGet(77)
		static W => SysGet(78)
		static H => SysGet(79)

		static Call() => {
			X: this.X,
			Y: this.Y,
			W: this.W,
			H: this.H
		}
	}

	static Real[N?] {
		get {
		
			M := Monitor(N?)
			return {
				X: M.Left,
				Y: M.Top,
				W: M.Right - M.Left,
				H: M.Bottom - M.Top
			}
		}
	}

	Class Mouse extends Monitor {
		
		/**
		 * @returns {Object} With Monitor X, Y, Width And Height Coordinates That Mouse is in
		 */
		static Call() => super.Real[this.Which]

		/**
		 * @returns {Number} The Monitor That Mouse is In.
		 */
		static Which {

			get {

				C := Mouse.GetPos("Screen", "X", "Y")
				Count := super.Count
				loop Count {

					M := super(A_Index)
					if (C.X >= M.Left && C.X <= M.Right && C.Y >= M.Top && C.Y <= M.Bottom)
						return A_Index

					else if (A_Index >= Count) {
						alert("Failed to Get the Monitor That the Mouse is Within")
						Exit()
					}
				}
			}
		}
	}

	; static Mouse() {

	; 	M := Mouse.GetPos()
	; 	Count := this.Count

	; 	loop Count
	; 	{
	; 		Monitor := this(A_Index)

	; 		Top     := Monitor.Top
	; 		Left    := Monitor.Left
	; 		Right   := Monitor.Right
	; 		Bottom  := Monitor.Bottom

	; 		if (M.X >= Left && M.Y >= Top && M.X <= Right && M.Y <= Bottom)
	; 			return {
	; 							Monitor: A_Index,
	; 							X: Left,
	; 							Y: Top,
	; 							W: Right - Left,
	; 							H: Bottom - Top
	; 						}

	; 		if (A_Index >= Count) {
	; 			Tippy("Failed to Get the Monitor That the Mouse is Within")
	; 			Exit()
	; 		}
	; 	}
	; }
}