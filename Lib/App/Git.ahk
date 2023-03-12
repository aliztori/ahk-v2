#Include <Abstractions\Text>
#Include <System\Web>
#Include <Paths>
#Include <Alert>

class Git {

	static InstallAhkLibrary(link, fileName?) {

		static libFolder := Paths.Lib "\"
		link := RegExReplace(link, "blob\/|^https:\/\/github\.com\/",,,, 1)
		file_html := GetHtml("https://raw.githubusercontent.com/" link)

		if IsSet(fileName) 
			newFile := fileName

		else {
			RegExMatch(link, "\/([^.\/]+\.\w+)$", &match)
			newFile := match[1]
		}

		WriteFile(libFolder newFile, file_html)
		alert(newFile " library installed in: " libFolder)
	}
}