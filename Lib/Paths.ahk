;No dependencies

Class Paths {

	;general
	static Ahk				:= A_ProgramFiles 	"\AutoHotkey"
	static Lib				:= A_ScriptDir 		"\Lib"	
	static Adobe			:= A_ProgramFiles 	"\Adobe"	

	static RootDir			:= "T:"
	static Prog				:= this.RootDir 	"\Programming"
	static Ahkv2			:= this.Prog 		"\AutoHotkey\v2"
	static SupportFiles		:= this.Ahkv2 		"\Support Files"
	
	;System
	; static LocalAppData      := "C:\Users\" A_UserName "\AppData\Local"
	static LocalAppData		:= "C:\Users\Aliztory.Aliz-Pc\AppData\Local"
	static ProgFi			:= "C:\Program Files"
	static ProgFi32			:= "C:\Program Files (x86)"

	;ImageSearch
	static ImgSearch		:= this.SupportFiles 	"\ImageSearch"
	static Premiere[item]	=> this.ImgSearch 		"\Premiere\" item ".png"
	static Telegram[item] 	=> this.ImgSearch	 	"\Telegram\" item ".png"

	static Shortcuts		:= this.SupportFiles 	"\shortcuts"
	static KSA				:= this.SupportFiles 	"\KSA"
	static Reg				:= this.SupportFiles 	"\Reg"

	; My Stuff
	static RootMedia		:= "M:"
	static EditingStuff		:= this.RootMedia 		"\Editing Stuff"
	static ForeignMemes		:= this.EditingStuff 	"\Foreign Memes"
	static PersianMemes		:= this.EditingStuff 	"\Persian Memes"
	static SFX         		:= this.EditingStuff 	"\SFX"
	static PIC         		:= this.EditingStuff 	"\PIC"

	static Icons[item]		=> this.SupportFiles 	"\Icons\" item ".png"

	static Ptf := Map(

		"Premiere",    		this.Shortcuts		"\Adobe Premiere Pro.exe.Ink", 
		"Photoshop",   		this.Shortcuts		"\Photoshop.exe.Ink", 
		"AE",       		this.Shortcuts		"\AfterFX.exe.Ink",
		"Tel",       		this.Shortcuts		"\Telegram.exe.lnk",
		"Chrome",      		this.Shortcuts		"\Chrome.exe.lnk",
		"VsCode",      		this.Shortcuts		"\Code.exe.lnk",
		"Discord",     		this.Shortcuts		"\Discord.lnk",
		"Resonic",     		this.Shortcuts		"\Resonic.exe.lnk",
		"PRini",    		this.KSA 			"\Premiere.ini", 

		"Timer",       		this.SupportFiles 	"\Reg\Timer.ini",
		"CrossLayouts", 	this.SupportFiles 	"\CrossLayouts.json",

		"SecretInfo",		this.RootDir 		"\PV\Pass.txt", 
		"WinSpy",    		this.Ahk 			"\UX\WindowSpy.ahk", 
		"StartupScr",		this.Ahkv2 			"\PC Startup.ahk", 
		"Ahk2Help",  		this.Ahk 			"\v2\AutoHotkey.chm"
	)
}
