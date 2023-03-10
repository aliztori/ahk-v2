#Include <Abstractions\Mouse>
#Include <App\Premiere>
#Include <Utils\Morse>
#Include <Alert>



#HotIf WinActive(PR.WinTitle)


RButton:: PR.TimePlayhead()
^MButton::PR.ClassPanel()
MButton:: {

	static Runner := Map(
		PR.Panel["Project"], () => PR.FindBox.Project(""),
		PR.Panel["Effects"], () => PR.FindBox.Effects(""),
	)

	try Runner[Mouse.Ctrl].Call()
	
	catch UnsetItemError 
		Send(PR.KS["Shuttle_Right"])

	catch Any as Err 
		alert.Err(Err)
}


F13:: {	;Mouse Button 1

	Switch Mouse.Ctrl {

		case PR.Panel["EffectsControls"]:
			PR.Keyframe.EasyEase()

		case PR.Panel["Timeline"]:

		case PR.Panel["Project"]:
			PR.ColapsAll()
	}
}

F14:: {	;Mouse Button 2
	if Mouse.Ctrl = PR.Panel["EffectsControls"]
		Click("Middle")
	PR.Instanter.Delete()
}

^F14:: Send("{Del}")


F15:: {	;Mouse Button 3

	if Mouse.Ctrl =  PR.Panel["Timeline"]
		PR.Instanter.RipplePlay()
	else
		Send("{BackSpace}")
}

;Mouse Button 5
F17:: PR.ValHold("Scale")

;Mouse Button 7
F19:: Send(PR.KS["Remove_Att"] "{Space}")

;Mouse Button 8
F20:: PR.ValHold("Rotation")

;Mouse Button 9
F21:: Send(PR.KS["Paste_Att"] "{Space}")


Volume_Down:: {	;Wheel Left

	switch Mouse.Ctrl {

		case PR.Panel["Timeline"]:
			Send(PR.KS["Prev_EditPoint"])

		case PR.Panel["EffectsControls"]:
			Send(PR.KS["Select_PrevKf"])

			; default:

	}
}

Volume_Up:: {	;Wheel Right

	switch Mouse.Ctrl {

		case PR.Panel["Timeline"]:
			Send(PR.KS["Next_EditPoint"])

		case PR.Panel["EffectsControls"]:
			Send(PR.KS["Select_NextKf"])

			; default:
	}
}


+WheelDown:: Send(PR.KS["NudgeVol_M3"])
+WheelUp::   Send(PR.KS["NudgeVol_P3"])


;-----------------------------------------------------|
;			  		Keyboard keys				      |
;-----------------------------------------------------|


F4:: PR.PanClose()


NumpadMult:: {

	switch Morse() {

		case "0":
			PR.Anchor.Motion()

		case "00":
			PR.Anchor.Transform()
	}
}

~+a:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		PR.Put("Adjustment Layer")
}

~b:: {

	static MorseCode := Map(
		"1",	() => PR.Put("Bleep", false),
		"0", 	() => PR.Preset("02 - B & W (Fade)"),
		"00",	() => PR.Preset("10 - Big Camera"),
		"000",	() => PR.Preset("01 - B & W"),
	)
	if Mouse.Ctrl ~= PR.Panel["Timeline"] "|" PR.Panel["EffectsControls"]
		try MorseCode[Morse()].Call()
}

~+b:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		PR.Put("Black & White")
}

~c:: {

	if Mouse.IsOverCtrl(PR.Panel["EffectsControls"]) {
		Send Pr.KS["Selection_Tool"]
		PR.Preset("02 - Crop")
	}
}


~d:: {
	switch Mouse.Ctrl {

		case PR.Panel["Timeline"]:
			switch Morse() {
				case "0": PR.Put()
				case "00": PR.Preset()
			}
		case PR.Panel["EffectsControls"]: PR.Preset()

			; default:
	}
}

^d:: PR.Preset("03 - Drop Shadow")

^e:: {
	switch Morse() {

		case "0":
			PR.Preset("02 - Echo (Medium)")

		case "00":
			PR.Preset("01 - Echo (Larg)")

		case "000":
			PR.Preset("03 - Echo (Small)")
	}
}

^f:: {
	switch Morse() {

		case "0":
			PR.Preset("05 - Flash")

		case "00":
			PR.Preset("04 - Flanger")

		case "000":
			PR.Preset("04 - Flanger")
	}
}

~+f:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		PR.Put("Flash")
}


^g::
{
	switch Morse.Press() {

		case 1: PR.Preset("03 - Blur")
		case 2: PR.Preset("04 - Blur (Fade)")
	}
}

~h:: {
	switch Mouse.Ctrl {

		case PR.Panel["Timeline"], PR.Panel["EffectsControls"]:
			PR.Preset("04 - Horizontal Flip")
	}
}


^i:: PR.Preset("IN | Opacity")

~l:: {
	switch Mouse.Ctrl {

		case PR.Panel["Timeline"], PR.Panel["EffectsControls"]:
			switch Morse.Press() {

				case 1: PR.Preset("09 - Lowpass")
				case 2: PR.Preset("05 - Lumetri Color")
				case 3: PR.Preset("Color Correcton")
			}
	}
}


~n:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		Send(PR.KS["Nest"] "{Tab}{Enter}{Click Middle}")
}

^o:: PR.Preset("OUT | Opacity")

~p:: {
	switch Mouse.Ctrl {

		case PR.Panel["Timeline"], PR.Panel["EffectsControls"]:
			switch Morse.Press() {

				case 1: PR.Preset("10 - Pitch")
				case 2: PR.Preset("06 - Pixelate")
				case 3: PR.Preset("07 - Sharp")
			}
	}
}

^r:: Pr.Revers()

~t:: {
	switch Mouse.Ctrl {

		case PR.Panel["Timeline"], PR.Panel["EffectsControls"]:
			switch Morse.Press() {

				case 1: PR.Preset("01 - Transform")
				case 2: PR.Preset("Turbulent Displace")
				case 3: PR.Preset("Twirl")
			}
	}
}


~+t:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		PR.Put("Text - Aviny")
}

^u:: PR.Preset("08 - Ultra Key")


~+w:: {
	if Mouse.IsOverCtrl(PR.Panel["Timeline"])
		PR.Put("ES_Whip Whoosh Large 2")
}

^w:: PR.Preset("Wave Warp")


~1:: {
	switch Mouse.Ctrl {

		case PR.Panel["EffectsControls"]:
			PR.Keyframe.EaseOut()

		case PR.Panel["Timeline"]:
			PR.Instanter.Track_Forward()
	}
}

~2:: {
	switch Mouse.Ctrl {

		case PR.Panel["EffectsControls"]:
			PR.Keyframe.EaseIn()

		case PR.Panel["Timeline"]:
			PR.Instanter.Track_Backward()
	}
}

~3::{
	if Mouse.Ctrl = PR.Panel["Timeline"]
		PR.Instanter.Slip()
}

~4::{
	if Mouse.Ctrl = PR.Panel["Timeline"]
		PR.Instanter.RateStretch()
}

#HotIf