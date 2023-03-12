class Ctrl {

	/**
	 * If there is, get the control that has the input focus in the target window.
	 */
	static Active(WinTitle := "A", WinText?, ExcludeTitle?, ExcludeText?) 
	{
		return ControlGetFocus(WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
	}
	
	static IsActive(ID)
	{
		Control := this.Active()
		return ID = this.GetClassNN(Control) || ID = this.GetHwnd(Control)
	}

	/**
	 * Set the input focus to the specified control of the window.
	 */
	static Activate(Control, WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) 
	{
		ControlFocus(Control, WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
	}

	/**
	 * Return the ClassNN (class name and number) of the specified control.
	 */
	static GetClassNN(Control := this.Active(), WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
	{
		return ControlGetClassNN(Control, WinText?, ExcludeTitle?, ExcludeText?)
	}

	/**
	 * Returns the unique ID of the specified control.
	 */
	static GetHwnd(Control := this.Active(), WinTitle?, WinText?, ExcludeTitle?, ExcludeText?) 
	{
		return ControlGetHwnd(Control, WinText?, ExcludeTitle?, ExcludeText?)
	}

	/**
	 * Get the position and size of the control.
	 */
	static GetPos(&X?, &Y?, &Width?, &Height?, Control := this.Active(), WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
	{
		ControlGetPos(&X?, &Y?, &Width?, &Height?, Control?, WinTitle?, WinText?, ExcludeTitle?, ExcludeText?)
	}
}
