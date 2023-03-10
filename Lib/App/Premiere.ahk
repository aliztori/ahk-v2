#Include <Paths>
#Include <Utils\Hot>
#Include <Tools\Tippy>
#Include <Utils\Coord>
#Include <Abstractions\Mouse>
#Include <Abstractions\Ini>
#Include <Abstractions\Ctrl>
#Include <Abstractions\Image>

Class PR {
	
	; static __New() {
	; 	PR.Remove_Existing_keyframe()
	; }
	
	static exeTitle := "ahk_exe Adobe Premiere Pro.exe"
	static WinTitle := "Premiere " this.exeTitle
	static Path     := Paths.Ptf["Premiere"]

	static Panels 	=> Ini(Paths.Ptf["PRini"], "Panel")
	static Panel  	=> this.Panels.ReadSec()

	static ClassPanel() {
		for Pan, ClassNN in this.Panel {
			this.Focus(Pan)
			Sleep(1000)
			this.Panels[Pan] := Ctrl.GetClassNN()
		}
	}

	; static _KS := (this, args*) => IniRead.Bind(Paths.Ptf["PRini"], "Premiere")(args*)
	
	static _KS := Ini(Paths.Ptf["PRini"], "KSA")

	static KS := Map(

		"Project", 				this._KS["Project"],
		"Effects", 				this._KS["Effects"],
		"Timeline", 			this._KS["Timeline"],
		"EffectsControls",		this._KS["EffectsControls"],
		
		"Prev_EditPoint", 		this._KS["Goto Previous Edit Point on Any Track"],
		"Next_EditPoint", 		this._KS["Goto Next Edit Point on Any Track"],
		"DS_Assignment", 		this._KS["Default Source Assignment"],
		"Kf_EaseOut", 			this._KS["Keyframe Temporal interpolation - Ease Out"],
		"Kf_EaseIn",  			this._KS["Keyframe Temporal interpolation - Ease In"],
		"Kf_Linear",  			this._KS["Keyframe Temporal interpolation - Linear"],
	
		"Select_PrevKf",		this._KS["Select Previous Keyframe"],
		"Select_NextKf",		this._KS["Select Next Keyframe"],
		"Select_Follows_PH",	this._KS["Selection Follows Playhead"],
		"Select_ClipAt_PH",		this._KS["Select Clip at Playhead"],
		"Move_PH_toCurser",		this._KS["Move Playhead to Cursor"],
		
		"Remove_Att",			this._KS["Remove Attributes"],
		"Paste_Att",			this._KS["Paste Attributes"], 

		"NudgeVol_P3",			this._KS["Nudge Volume +3dB"],
		"NudgeVol_M3",			this._KS["Nudge Volume -3dB"],

		"Select_FindBox",		this._KS["Select Find Box"],
		"Add_FrameHold",		this._KS["Add Frame Hold"],
		"Speed_Duration",		this._KS["Speed Duration"],
		"Shuttle_Right",		this._KS["Shuttle Right"],

		"DeSelect_All",  		this._KS["DeSelect All"],
		"Ripple_Delete", 		this._KS["Ripple Delete"],
		"Audio_Gain", 			this._KS["Audio Gain"],
		"Nest",  				this._KS["Nest"],

		"Overwrite",  			this._KS["Overwrite"],
		"Insert",  				this._KS["Insert"],
		
		"Pen_Tool",  			this._KS["Pen Tool"],
		"Slip_Tool",  			this._KS["Slip Tool"],
		"Razer_Tool",  			this._KS["Razer Tool"],
		"Selection_Tool",  		this._KS["Selection Tool"],
		"RateStretch_Tool", 	this._KS["RateStretch Tool"],
		"Track_Forward_Tool",  	this._KS["Track Select Forward Tool"],
		"Track_Backward_Tool",  this._KS["Track Select Backward Tool"]
	)

	static img[item] =>  Paths.Premiere[item]
	static Key 		 =>  Raw()

	class FindBox extends PR {
		
		static __Call(Panel, items) {

			item := items.Has(1) ? items[1] : unset

			this.Focus(Panel)
			Send
			(
				this.KS["DeSelect_All"]
				this.KS["Select_FindBox"]
				(IsSet(item) ?  ("+{BS}{Raw}" item) : "")
			)
		}
	}

	class ImgInPanel extends PR {
		
		static __Call(Panel, Images) {
			
			Ctrl.GetPos(&PX, &PY, &PW, &PH, this.Panel[Panel])
		
			if Image.Search(&X, &Y, PX, PY, PW + PX, PH + PY, this.img[Images[1]])
				return {X: X, Y: Y}

			return false
		}
	}

	class Instanter extends PR {
		
		static RipplePlay() => 
		Send(
			this.KS["Select_ClipAt_PH"] 
			this.KS["Ripple_Delete"]
		)
		
		static Delete() => 
		Send(
			this.KS["DeSelect_All"]
			this.KS["Selection_Tool"] 
			"{Alt Down}{Click}{Alt Up}{Delete}"
		)

		static Cut() {

			Send(this.KS["Razer_Tool"] "{Shift Down}")
			KeyWait(this.Key)
			Send("{Click}{Shift Up}" this.KS["Selection_Tool"])

		}

		static __Call(Name, Params) {

			Send(this.KS[Name "_Tool"] "{Click Down}")
			KeyWait(this.Key)

			Send("{Click Up}")

			Sleep(100)
			send(this.KS["Selection_Tool"])
		}
	}
	
	class Keyframe extends PR {

		static Linear() => Send(this.KS["Kf_Linear"])
		static EasyEase() => Send(this.KS["Kf_EaseIn"] this.KS["Kf_EaseOut"])

		static __Call(Event, Params) {

			CoordMode("Mouse", "Screen")
			Mouse.SavePos()
			Sleep(50)
			Click("Down")
			switch Event, false {
				case "EaseIn":
					MouseMove(+100, 0, 0, "R")
				case "EaseOut":
					MouseMove(-100, 0, 0, "R")
			}
			Click("Up")
			Sleep(50)
			Mouse.RestorePos()
		}
	}

	class Anchor extends PR {
		
		static Anch := [

			0 	 "{Tab}" 1080, 
			960  "{Tab}" 1080, 
			1920 "{Tab}" 1080, 
			0 	 "{Tab}" 540, 
			960  "{Tab}" 540, 
			1920 "{Tab}" 540, 
			0 	 "{Tab}"  0, 
			960  "{Tab}"  0, 
			1920 "{Tab}"  0
		]

		static __Call(Effect, Params) {

			dontRestart := true
			Tool.Track("Insert Your Direction To Change AnchorPoint", 3000)

			Anchor := Input.GetKey()
			if Type(Anchor) != Number {

				alert("input isnt Number")
				return		
			}
			
			switch Effect {

				case "Motion":
					this.Focus("EffectsControls")
					Send
					(
						"{Tab 2}" 
						this.Anch[Anchor]
						"{Tab 4}" 
						this.Anch[Anchor]
						"{Enter}"
					)
				
				case "Transform":
					Research:
					if i := this.ImgInPanel.EffectsControls("Transform")
					{
						if PixelSearch(&Px, &Py, i.X, i.Y, i.X + 200, i.Y + 50 , 0x2d8ceb, 30)
						{
							Mouse.Click("L", Px + 5, Py + 5, 1, 0)
							Send
							(
								this.Anch[Anchor] 
								"{Tab}" 
								this.Anch[Anchor] 
								"{Enter}"
							)
						
						} else alert("Transform Parameters are Not Visible")

					}

					else if dontRestart 
					{
						dontRestart := false
						Send(this.KS["DeSel_All"])
						goto Research

					} else alert("Transform Effect Not Find")
					
			}
		}
	}


	static Remove_Existing_keyframe() {

		SetTimer(ali, 1)
		ali() {
			DetectHiddenText(true)
			WinWait("Warning " this.exeTitle)
			Send("{Enter}")
		}
	}
	
	static Focus(Panel) => Ctrl.Activate(this.Panel[Panel])

	static Preset(item?) {

		KeyWait(Hot.Raw(A_ThisHotkey))
		Coord.Screen("Mouse", "Pixel")
		
		this.FindBox.Effects(item?)
		Ctrl.GetPos(&Ex, &Ey, &Ew, &Eh)
	
		Mouse.Click("Left", Ex + (Ew/2), Ey + (3/4 * Eh), 1, 0)

		imgs := [	
			this.img["VideoPreset"],
			this.img["AudioPreset"],
			this.img["VideoEffect"],
			this.img["AudioEffect"]
		]

		coordObj := {
			x1: Ex,
			y1: Ey,
			x2: Ew + Ex,
			y2: Eh + Ey
		}

		if img := Image.WaitSearch(coordObj, 1000, imgs*)
			MouseClickDrag("L", img.X + 7, img.Y + 10, Mouse.SavedX, Mouse.SavedY, 0)
	}

	static Put(item?, OverWrite := true) {

		KeyWait(Hot.Raw(A_ThisHotkey))

		; Mouse.SavePos()
		Coord.Screen("Mouse", "Pixel")

		this.FindBox.Project(item?)
		Ctrl.GetPos(&Px, &Py, &Pw, &Ph)

		if IsSet(item)
			Sleep(500)

		this.NestSource()

		imgs := [
			this.img["Sequence"],
			this.img["Audio"]
		]
		
		coordObj := {
			x1: Px,
			y1: Py,
			x2: Pw + Px,
			y2: Ph + Py
		}

		if Not img := Image.WaitSearch(coordObj, 1000, imgs*)
			return 

		if overWrite {
			Mouse.ClickDrag("L", img.X + 7, img.Y + 10, 0)

		} else {

			Mouse.Click("L", img.X + 7, img.Y + 10, 1, 0)
			Send(this.KS["DS_Assignment"] "{Click}" this.KS["Insert"])
		}
		
	}

	static TimePlayhead() {

		static TimeColor := [

			0x414141,	;timeline color inside the in/out points ON a targeted track
			0x313131,	;timeline color of the separating LINES between targeted AND non targeted tracks inside the in/out points
			0x1b1b1b,	;the timeline color inside in/out points on a NON targeted track
			0x202020,	;the color of the bare timeline NOT inside the in out points
			0xDFDFDF,	;the color of a SELECTED blank space on the timeline, NOT in the in/out points
			0xE4E4E4,	;the color of a SELECTED blank space on the timeline, IN the in/out points, on a TARGETED track
			0xBEBEBE	;the color of a SELECTED blank space on the timeline, IN the in/out points, on an UNTARGETED track		
		]

		if TimeColor.HasVal(Mouse.Pixel)
		{
			Click("Middle")

			while GetKeyState(this.Key, "P")
				Send(PR.KS["Move_PH_toCurser"]), Sleep(16)

		} else Send("{" A_ThisHotkey "}")
	}

	static IsClipSelect(Triangle := false) {

		Ctrl.GetPos(&X, &Y, &W, &H, this.Panel["EffectsControls"])
		
		if Image.Search(&iX, &iY, X, Y, W + X, H + Y, this.img["MultipleClip"])
		{
			this.Focus("Timeline")
			Send(this.KS["DeSel_All"])
			Check()
		}

		else if Image.Search(&iX, &iY, X, Y, W + X, H + Y, this.img["NoClip"])
			Check()

		if Triangle
		{
			switch PixelGetColor(X + 13, Y + 66) {
				
				; case 0x1D1D1D, 0x232323: ;NO CLIP has been selected

				case 0x7A7A7A: ;OPENED triangle 
					return true

				case 0x222222: ;CLOSED triangle
					Mouse.Click("L", X + 13, Y + 66, 1, 0)
					Sleep(100)
					return true

				default:
					alert("No Clip Selected"), Exit()
			}

		} else return true

		Check() {

			Send(this.KS["Select_Follows_PH"])
			Sleep(100)
			Send(this.KS["Select_Follows_PH"])
			
			if Image.Search(&iX, &iY, X, Y, W + X, H + Y, this.Img["NoClip"])
				alert("No Clip Selected"), Exit()
		}
	}

	static ValHold(Foobar, Params?) {

		this.IsClipSelect(true)
		Mouse.SavePos()

		Ctrl.GetPos(&X, &Y, &W, &H, this.Panel["EffectsControls"])
		Sleep(16)

		Foobars := [		
			this.img[Foobar], 
			this.img[Foobar 2]
		]

		if Not Image.Search(&iX, &iY, X, Y, W + X, H + Y, Foobars*)
		{
			alert("Image Of " Foobar " Not Found")
			return 
		}

		if Not PixelSearch(&PX, &PY, iX, iY, iX + 250, iY + 11, 0x2d8ceb, 30)
		{
			alert("Pixel Of " Foobar " Not Found")
			return
		}

		MouseClick("L", X + 50, Y + 70, 1, 0) ;Click Motion

		if GetKeyState(A_ThisHotkey, "P")
		{
			MouseClick("L", PX + 5, PY + 5, 1, 0, "D")
			KeyWait(this.Key)
			Click("Up")
			
			Sleep(200)
			Mouse.RestorePos()

			Click("Middle")
						
		} else {

			MouseClick("L", PX + 5, PY + 5, 1, 0)
			Sleep(200)
			Mouse.RestorePos()
		}
	}

	static PanClose() {
		Ctrl.GetPos(&X, &Y,,, this.Panel["Timeline"])
		Mouse.Click("R", X + 2, Y - 15, 1, 0)
		Send("{Down 3}{Enter}")
	}

	static ResetMotion() {
		if img := this.ImgInPanel.EffectsControls("Reset")
			Mouse.Click("L", img.X + 7, img.y + 7, 1, 0)
	}

	static NestSource() {
		if img := this.ImgInPanel.Timeline("NestSourceOff")
			Mouse.Click("L", img.X + 7, img.y + 7, 1, 0)
	}

	static ColapsAll() {

		if img := this.ImgInPanel.Project("Fold") {

			Mouse.SavePos()
			Send("!{Click " img.X " " img.y "}")
			Mouse.RestorePos()
		}
	}

	
	static Revers() => Send(PR.KS["Speed_Duration"] "{Tab 2}{Space}{Enter}")

}