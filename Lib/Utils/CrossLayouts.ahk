#Include <Extensions\JSON>
#Include <Paths>

class CrossLayouts {

	static JSONPath := Paths.Ptf["CrossLayouts"]
	static FaToEng 	:= JSON.parse(FileRead(this.JSONPath))["Persian"]
	static EngToFa 	:= JSON.parse(FileRead(this.JSONPath))["English"]
	static ALL 		:= JSON.parse(FileRead(this.JSONPath))["All"]

	static ConvertToOpposite(text) {

		newText := ""
		text := StrReplace(text, "ريال", "R")

		loop parse, text
			newText .= this.ALL.Get(A_LoopField, A_LoopField)

		return newText
	}

	/**
     * Convert text written in the russian layout to the same characters, but in the english layout
     * @param {String} text
     * @returns {String} 'شمه' = > 'ali'
     */
	static ConvertToEnglish(text) {

        newText := ""
		
		text := StrReplace(text, "ريال", "R")
		loop parse, text
			newText .= this.FaToEng.Get(A_LoopField, A_LoopField)

        return newText
    }

	/**
     * Convert text written in the english layout to the same characters, but in the Persian layout
     * @param {String} text
     * @returns {String} 'sghl' => 'سلام'
     */
	static ConvertToPersian(text) {

		newText := ""

		loop parse, text
			newText .= this.EngToFa.Get(A_LoopField, A_LoopField)

		return newText
	}
}