#Include <Tools\CleanInputBox>
#Include <Tools\Info>
#Include <Utils\Clip>

+Space::{

	static dataPath := 'T:\Programming\AutoHotkey\v2\Support Files\info.ini'
	data := Ini(dataPath)

	static Hotstrings := Map(

		"a", data['adress', 'info'],
		"c", data['postcode', 'info'] ,
		"m", data['id', 'Meli'] ,
		"i", data['nameid', 'Meli'] ,
	) 

	hwnd := info(Print(Hotstrings))
	key := input.GetKey()

	if Hotstrings.Has(Key) 
		Clip.Send(Hotstrings[key])
	else
		alert("input is Not Valid")

	try WinClose(hwnd)
}


:X:sc::Clip.Send("static ")
:X:thh::Clip.Send("this.")
:X:rtn::Clip.Send("return ")


#Hotstring ?*
::;=:::= `
:::=:::= `
::/.::=> `

