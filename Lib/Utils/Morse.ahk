#Include <Utils\Hot>
#Include <Tools\Tippy>

class Morse {

	static Tp   => A_TimeSincePriorHotkey
	static PH   => A_PriorHotkey
	static TH   => A_ThisHotkey
	static Msg(Text?, Timeout?) => Tool.Track(Text?, Timeout?)

	static Call(input_Key := A_ThisHotkey, PressTimeOut := 300, HoldTimeOut := 3000, Tips := true) {

		; Convert Any Type Of Hotkey to One Specific Key
		Key := Hot.Raw(input_Key)

		PTout := Round(Abs(PressTimeOut) / 1000, 2)
		HTout := Round(Abs(HoldTimeOut) / 1000)
		Hold := Press := 0, Pattern := ""

		if (input_Key ~= "(?i:LButton|MButton|RButton)")
		{
			(Tips) ? this.Msg(this.TH " : Press " key " Please") : ""

			;Doesnt Block key & And Doesnt Support Sign Shift Number
			if not KeyWait(key, "D T" 1) { 
				this.Msg()
				return
			}
		}

		;Bug For F1 F2 ,,,, Fn And Sth Like F Or Numpad IDK
		Else if not InStr(this.TH, key, true) 
			return this.Input(key, PressTimeOut, HoldTimeOut, Tips)

		Loop
		{
			Tc := A_TickCount
			KeyWait(Key, "T" HTout)

			if (A_TickCount - Tc > PressTimeOut)
				Pattern .= "1", Hold++, Pattern_Tip .= "▬"
			else
				Pattern .= "0", Press++, Pattern_Tip .= "●"

			if Tips
			{
				if (Key = this.TH)
					this.Msg(this.TH " : " Hold Press " " Pattern_Tip)
				else
					this.Msg(this.TH " ―> " Key " : " Hold Press " " Pattern_Tip)
			}

			if KeyWait(Key, "D T" PTout) 
				continue
			
			this.Msg()
			return (Pattern)
		}
	}

	static Press(input_Key := A_ThisHotkey, Timeout := 300, Tips := True) {

		Tout := Round(Abs(Timeout) / 1000, 2), Press := 0
		Key := Hot.Raw(input_Key)

		Loop
		{
			KeyWait(Key)
			Press += (this.PH != this.TH) || (this.Tp > Timeout)

			(Tips) ? Track(input_Key " ―> " Press) : ""

			if KeyWait(Key, "D T" Tout) 
				continue
			
			Track()
			return Press
		}
	}

	static Input(key, PressTimeOut := 200, HoldTimeOut := 3000, Tips := true)
	{   
		PTout := Round(Abs(PressTimeOut) / 1000, 2)
		HTout := Round(Abs(HoldTimeOut) / 1000)
		Hold := Press := 0, Pattern := ""

		(Tips) ? Track(this.TH " : Press " key " Please"): ""

		if (key ~= "^(?i:Win|Shift|Ctrl|Alt)$")
			key4input := "{L " key "}" "{R " key "}"

		ih := InputHook("L1 T1", "{" key "}" (key4input ?? ""))
		ih.Start()
		ih.Wait()

		switch (ih.EndReason) {

			case "Max":
				Track()
				; (Tips) ? (Tippy("Wrong Key")) : ""
				return

			case "Timeout":
				Track()
				; (Tips) ? (Tippy("The Input Timed Out.")) : ""
				return

			default:
				Track()
				if !InStr(ih.EndReason, "EndKey")
					return
		}

		Loop 
		{ 
			Tc := A_TickCount
			KeyWait(key, "T" HTout)

			if (A_TickCount - Tc > PressTimeOut) 
				Hold++, Pattern .= "1", Pattern_Tip .= "▬" 
			else 
				Press++, Pattern .= "0", Pattern_Tip .= "●"
			
			if Tips
			{
	 
				if (key = this.TH)
					Track(this.TH " : " Hold Press " " Pattern_Tip)
				Else
					Track(this.TH " ―> " key " : " Hold Press " " Pattern_Tip)
			
			}

			ih := InputHook("T" PTout " L1", "{" key "}")
			ih.Start()
			ih.Wait()

			if (ih.EndKey != key) {
				Track()
				return (Pattern)
			}
		}
	}
}
