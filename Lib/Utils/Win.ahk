#Include <Abstractions\WinGet>
#Include <Alert>

;Made by @Axlefublr, rewritten, Modified into my style
; https://github.com/Axlefublr/lib-v2/blob/main/Utils/Win.ahk

Class Win {

	;Defaults
	WinTitle    	:= "A"
	WinText     	:= ""
	ExcludeTitle	:= ""
	ExcludeText 	:= ""
	; WinArgs			=> [
	; 	this.WinTitle,
	; 	this.WinText,
	; 	this.ExcludeTitle,
	; 	this.ExcludeText
	; ]
	WinTitles   	:= []
	Exception   	:= ""
	exePath     	:= unset
	startIn     	:= ""
	RunOpt      	:= "Max"
	ToClose     	:= ""
	Direction   	:= "left"


	/**
     * @param {Object} paramsObject Key value pairs for properties of the class you want to set. Essentially, this is an initializer
     * @extends {Initializable}
     * @throws {TypeError} If you didn't pass an object
     * @example <caption>Create a Win object for the Spotify window and activate it, even if the window doesn't exist yet</caption>
     * Win({
	 * 	exePath: A_AppData "\Spotify\Spotify.exe",
	 * 	winTitle: "ahk_exe Spotify.exe"
	 * }).RunAct()
	 */
	__New(ParamsObject) {

		if Type(paramsObject) != "Object"
			throw TypeError("Specify an object.`nYou specified: " Type(paramsObject), -1, "paramsObject in __New() of the Win class")
	   
		for key, value in paramsObject.OwnProps()
			this.%key% := value

		this.WinArgs := [
			this.WinTitle,
			this.WinText,
			this.ExcludeTitle,
			this.ExcludeText
		]
	}

	SetExplorerWintitle() => this.WinTitle := this.exePath " ahk_exe explorer.exe"

	Close() {
	   try PostMessage(0x0010,,,, this.WinArgs*)
	}
 
	RestoreDown() {
		try PostMessage(0x112, 0xF120,,, this.WinArgs*)
	}
 
	Maximize() {
		try PostMessage(0x112, 0xF030,,, this.WinArgs*)
	}
 
	Minimize() {
		try PostMessage(0x112, 0xF020,,, this.WinArgs*)
	}

	Activate() {

		try {		
			WinActivate(this.WinArgs*)
			WinWaitActive(this.WinTitle, this.WinText,, this.ExcludeTitle, this.ExcludeText)
			return true
		} catch Any
			return false	
	}
	
	/**
	 * What if there a multiple windows that match the same WinTitle?
	 * This method is an option to activate the second one if the first one is active, and the other way around
	 * Supports as many same windows as you want. The time complexity is O(n)
	 * If this concerns you, consider having less windows
	 * @returns {Boolean} False if there were less than 2 windows that matched (there could be zero); True if the operation completed successfully
	 */
	ActivateAnother() {

		Winlist := WinGetList(this.WinArgs*)
		if Winlist.Length < 2
			return false

		id := WinGetID("A")

		for index, value in Winlist
			if Winlist[-index] != id {
				newWin := Winlist[-index]
				break
			}

		prevWin := this.WinTitle

		this.WinArgs.Replace(1, newWin)
		result := this.Activate()
		this.WinArgs.Replace(1, prevWin)

		return result
	}

	ResMax() {

		if WinGet.MinMax(this.WinArgs*)
			this.RestoreDown()
		else
			this.Maximize()
	}

	MinMax() {

		if Not WinExist(this.WinArgs*)
			return false

		if WinActive(this.WinArgs*)
		{
			if Not this.ActivateAnother()
				this.Minimize()
		}

		else
			this.Activate()

	   return true
	}
 
	Run() {

		; if WinExist(this.WinArgs*)
		; 	return false

		Run(this.exePath, this.startIn, this.runOpt)
		return true
	}

	RunAct() {
		this.Run()
		this.Activate()     
	}
 
	RunAct_Folders() {
	   this.SetExplorerWintitle()
	   this.RunAct()
	}

	App() {

	   if this.MinMax()
		  return true

	   this.RunAct()
	   return false

	}
 
	App_Folders() {
	   this.SetExplorerWintitle()
	   this.App()
	}
 
	/**
     * Specify an array of winTitles, will return 1 if one of them is active
     * Specify a map if you want to have a "excludeTitle" for one, some, or all of your winTitles
     * @param winTitles *Array/Map*
     * @returns {Integer}
     */
    AreActive() {
        i := 0
        for key, value in this.winTitles {
            if Type(this.winTitles) = "Map" {
                if WinActive(key,, value)
                    i++
            } else if Type(this.winTitles) = "Array" {
                if WinActive(value)
                    i++
            }
        }
        return i
    }

 
	ActiveRegex() {
		SetTitleMatchMode("RegEx")
		return WinActive(this.WinArgs*)
	}
 

	RestoreLeftRight() {
 
	   _WinMove() {
		static halfScreen := A_ScreenWidth // 2
			Switch this.direction {
				Case "right": this.direction := halfScreen
				Case "left": this.direction := 0
			}
			WinMove(this.direction, 0, halfScreen, A_ScreenHeight, this.WinTitle)
	   }
 
	   _WinMoveWhenMin() {
		  if WinGetMinMax(this.WinTitle)
			 return
		  _WinMove(), SetTimer(, 0)
	   }
 
	   if !WinGetMinMax(this.WinTitle) {
		  _WinMove()
		  return
	   }
 
	   this.RestoreDown() ;Unmaximize it
	   SetTimer(_WinMoveWhenMin, 20)
 
	}


	AlwaysOnTop(ChangeTitle, Value := -1)
	{
		if Not ChangeTitle
			return WinSetAlwaysOnTop(Value, this.WinArgs*)

		Title := WinGetTitle(this.WinArgs*)
		SetAlways(Value, Title)

		
		SetAlways(Value, Title) {

			WinSetAlwaysOnTop(Value, Title)

			if IsAlwaysOnTop(Title)
				WinSetTitle(Title " - AlwaysOnTop", Title)
			else
				WinSetTitle(StrReplace(Title," - AlwaysOnTop"), Title)	
		}
		
		IsAlwaysOnTop(WinTitle) {
			ExStyle := WinGet.ExStyle(WinTitle)
			return ExStyle & 0x8
		}
	}

	ProcessClose() {

		DetectHiddenWindows(true)
		
		PID := WinGetPID(this.WinArgs*)
		ProcessClose(PID)
		ProcessWaitClose(PID)  
	}

	ShowHide()
	{
		static WindowID
		
		if IsSet(WindowID) {

			WinShow(WindowID)
			WindowID := unset

		} else {

			WindowID := this.WinTitle
			WinHide(WindowID)      
		}

		; if WinExist(this.WinTitle)
		; 	WinHide(this.WinTitle)
		; else 
		; 	WinShow(this.WinTitle)
	}

}