#Include <App\Browser>

Class Youtube extends Browser {

	static WinTitle := "YouTube " super.exeTitle

	static SpeedpUp()   => Send("+.")
	static SpeedpDown() => (System.Lang := 'en', Send("+{,}"))
}