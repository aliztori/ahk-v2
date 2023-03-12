#Include <Extensions\String>
#Include <Utils\CrossLayouts>
#Include <Utils\Clip>
#Include <Misc>

SwitchLang() => Send("#{Space}")

Class HighLight extends Clip {

	static StrUpper() => super.Paste(StrUpper(super.Copy()))
	static StrLower() => super.Paste(StrLower(super.Copy()))
	static StrTitle() => super.Paste(StrTitle(super.Copy()))

	static ToEnglish() => (super.Paste(CrossLayouts.ConvertToEnglish(super.Copy(1))), SwitchLang())
	static ToPersian() => (super.Paste(CrossLayouts.ConvertToPersian(super.Copy(1))), SwitchLang())
	static ToOpposite() => (super.Paste(CrossLayouts.ConvertToOpposite(super.Copy(1))), SwitchLang())
	
	static UnderSpace() => super.Paste(super.Copy(1).Replace("_", A_Space))
	static SpaceLine()	=> super.Paste(super.Copy(1).Replace(A_Space, "_"))

	static AutoParent() => super.Paste("(" super.Copy() ")")
	static AutoQuote() 	=> super.Paste("'" super.Copy() "'")

	static CompSpace()  => super.Paste(super.Copy(1).RemoveDuplicates(A_Space))

	static SongName() 	=> 
	super.Paste(
		RegExReplace(super.Copy(1).Replace("_", A_Space), ".*\d -? ?| ?\(?\d{3}\)?")
	)
}
