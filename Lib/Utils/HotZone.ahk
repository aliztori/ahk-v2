#Include <Abstractions\Mouse> 
#Include <Utils\Monitor> 

class HotEdge {

	__New(Margin := 50, Mode := "Monitor") {

		this.Margin := Margin
		this.Mouse := Mouse.GetPos(Mode, X := "X", Y := "Y")
	 
		switch Mode {
			case "Screen":
				this.Coord := Monitor.Virtual

			case "Monitor":
				this.Coord := Monitor.Mouse()
		}
	}

	Top      => this.Mouse.Y <= this.Margin
	Left     => this.Mouse.X <= this.Margin
	Bottom   => this.Mouse.Y >= this.Coord.H - this.Margin
	Right    => this.Mouse.X >= this.Coord.W - this.Margin

	TopLeft  => this.Top     && this.Left
	TopRight => this.Top     && this.Right
	BotLeft  => this.Bottom  && this.Left
	BotRight => this.Bottom  && this.Right

	static All(Margin, Mode := "Monitor", Except*) => this(Margin, Mode).All(Except*)
	All(Except*) {

		IsIn := (this.Top || this.Bottom || this.Left || this.Right)
		
		for Edge in Except 
			if !(IsIn && !this.%Edge%)
				return false
		
		return IsIn
	}	   

	static Edges(Margin, Mode := "Monitor", Except*) => this(Margin, Mode).Edges(Except*)
	Edges(Edges*) {
		
		if Edges.Length = 0
			return (this.Top || this.Bottom || this.Left || this.Right) 
		
		for Edge in Edges
			if !(true && this.%Edge%)
				return false

		return true
	}

	static Corners(Margin, Mode := "Monitor", Except*) => this(Margin, Mode).Corners(Except*)
	Corners(Corners*) {
	 
		if Corners.Length = 0
			return (this.TopLeft || this.TopRight || this.BotLeft || this.BotRight) 

		for Corner in Corners
			if !(true && this.%Corner%)
				return false
		
		return true
	}
}

class HotZone {

	__New(Mode) {
		
		this.Mouse := Mouse.GetPos(Mode, X := "X", Y := "Y")

		switch Mode, false {

			case "Screen":
				this.Coord := Monitor.Virtual
				
			case "Monitor":
				this.Coord := Monitor.Mouse()
		}
	}

	CenterX  => (this.Coord.W // 2) + this.Coord.X
	CenterY  => (this.Coord.H // 2) + this.Coord.Y

	Top		 => this.Mouse.Y <= this.CenterY
	Left	 => this.Mouse.X <= this.CenterX
	Bottom	 => this.Mouse.Y >= this.CenterY
	Right	 => this.Mouse.X >= this.CenterX

	TopLeft  => this.Top && this.Left
	TopRight => this.Top && this.Right
	BotRight => this.Bot && this.Right
	BotLeft  => this.Bot && this.Left 

	static All(Mode, Except*) => HotZone(Mode).All(Except*)
	All(Except*) {

		IsIn := (this.Top || this.Bottom || this.Left || this.Right)

		for Edge in Except 
			if !(IsIn && !this.%Edge%)
				return false
		
		return IsIn
	}

	static Area(Mode, Sides*) => HotZone(Mode).Area(Sides*)
	Area(Areas*) {

		for Area in Areas 	
			if !(true && this.%Area%)
				return false
		return true
	}
}
