#Include <Abstractions\Ini>
#Include <Utils\Eval>
#Include <Misc>
#Include <Paths>

; by Axlefublr modified and rewriten by me

Class Timer {

	/**
	 * The Ini file path that timer writes and reads from
	 * @type {String}
	 */
	static FilePath := Paths.Ptf["Timer"]

	; This function is to show the warning to 
	; show us that the timer has finished and must return hwnd like ToolTip
	static Msg(Text, Timeout?) => Info(Text, Timeout?)

	static __New() {   
	
		Timer.Data := Ini(this.FilePath, "Timers")
		Times := Timer.Data.ReadSec()
			
		timersToRenew := []

		for key, value in Times {

			if Number(value) < A_Now {
				Timer.Data.DelKey(key)
				continue
			}

			Seconds := DateDiff(value, A_Now, "Seconds")
			timersToRenew.Push(Timer(Seconds))
		}
		
		for time, timerObj in timersToRenew 
			timerObj.Start(0)
	}


	__New(seconds) {

		seconds := eval(seconds)
		Timer.endTime := DateAdd(A_Now, seconds, "seconds")
		Timer.duration := seconds
		Timer.Hash := Random(1, 100000)
	}

	Start(save := true) {

		if save
			Timer.Data[Timer.Hash] := Timer.endTime

		SetTimer(() => this.Alarm(save), -Timer.duration * 1000)
		alert("Timer set for " Timer.duration)
	}
	
	
	/**
	 * The ringer. Will show you an info that displays the time you set that timer for
	 * Will continue to beep intermittently until you close the Msg
	 * @private
	 */
	Alarm(delete := true) {

		Send("{Media_Play_Pause}")
		
		if delete
			Timer.Data.DelKey(Timer.Hash)

		Hwnd := Timer.Msg("Your timer for " Timer.duration " is up!")
		while WinExist(Hwnd) {
			SoundBeep()
			Sleep(200)
		}
	}


}
