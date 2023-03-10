#Include <Abstractions\Scripts>
#Include <Tools\CleanInputBox>
#Include <App\AutoHotkey>
#Include <App\Explorer>
#Include <Tools\Timer>
#Include <Utils\Clip>
#Include <Utils\Eval>
#Include <Utils\Win>
#Include <App\Git>
#Include <Alert>
#Include <Paths>

^Space::{

	input := CleanInputBox()
	if input = ""
		return 

	static runner_regex := Map(

		"g",  		(input) => RunLink("https://www.google.com/search?q=" input),
		"e", 		(input) => alert(Eval(input)),
		"i",  		(input) => Info(input),
		"win", 		(input) => %input%.winobj.App(),
		"install",  (input) => Git.InstallAhkLibrary(input),
		"t",        (input) => Timer(input).Start(),
		"pclose",   (input) => (SetTitleMatchMode("RegEx") ,Detect(), Win.ProcessClose(input)), 
		"close",    (input) => (SetTitleMatchMode("RegEx") ,Detect(), Win.Close(input)), 
	)

	RegExMatch(input, "^(g|e|i|win|install|t|close|pclose) (.+)", &result)
		try runner_regex[result[1]].Call(result[2])
		catch Any as e
			alert.Err(e)
}