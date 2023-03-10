;No dependencies

Tippy(Text?, Time := 1000, X?, Y?, Which?) => Tool.Tip(Text?, Time, X?, Y?, Which?)
Track(Text?, Time := 0) => Tool.Track(Text?, Time := 0)


Class Tool {

	static Stop := false

	static Tip(Text?, Time := 0, X?, Y?, Which?) {

		this.Stop := true
		SetTimer(() => ToolTip(,,, Which?), -Time)
		return ToolTip(Text?, X?, Y?, Which?)
	}

	static Track(Text?, Time := 0)
	{
		this.Text := Text ?? ""

		SetTimer(() => (ToolTip(), SetTimer(ali, 0)), -Time)
		
		SetTimer(ali, 1)
		ali()
		{
			if this.Text = "" || this.Stop
			{
				SetTimer(ali, 0)
				ToolTip()
				return false
			} 

			return ToolTip(this.Text)
		}
	}
}




