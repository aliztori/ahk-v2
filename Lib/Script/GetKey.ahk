#Include <Abstractions\Input>
#Include <Utils\Highlight>
#Include <Utils\Print>
#Include <Paths>
#Include <Misc>
#Include <Alert>

F1::{

	static keyActions := Map(
		
		"u",	 () => RunLink("https://stdn.iau.ir/Student/Pages/acmstd/loginPage.jsp"), 
		"g",	 () => RunLink("https://translate.google.com/"),
		"t",	 () => RunLink("https://www.time.ir/"),
		
		"v",	 () => Run("T:\VPN\v2rayN-Core\v2rayN-Core\v2rayN.exe"),
		"w",	 () => Run(Paths.Ptf["WinSpy"]),
		
		"s",	 () => HighLight.SongName(),
		"Space", () => HighLight.CompSpace(),

		"p",	 () => SwitchPlayBack(),
		"a", 	 () => CloseAllAhk_Gui(),
		"c", 	 () => CloseAllExplorer(),
		"t", 	 () => infoTranslate(),
		"z", 	 () => info(print(Prayer())),
	)

	Key := Input.GetKey()
	if keyActions.Has(Key)
		keyActions[Key].Call()
	else
		alert("input is Not Valid")
}