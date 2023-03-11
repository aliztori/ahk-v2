/**
 * This class is designed for standard inies like
 * A standard ini file looks like:
 * 
 * [SectionName]
 * Key=Value
*/

class Ini {

	Section := unset
	Default := unset

	__New(Filename, Section?, Default?) {	
		this.File := Filename
		this.Section := Section ?? unset
		this.Default := Default ?? unset
	}

	__Item[Key, Section?, Default?] 
	{
		Get {
			Default := Default ?? (this.HasOwnProp('Default') ? this.Default : unset)
			Section := Section ?? this.Section

			return IniRead(this.File, Section, Key, Default?)
		}

		Set {
			Section := Section ?? this.Section
			IniWrite(Value, this.File, Section, Key)
		} 
	}

	DelKey(Key, Section?) {
		Section := Section ?? this.Section
		IniDelete(this.File, Section, Key)
	}
	
	DelSec(Section?) {
		Section := Section ?? this.Section
		IniDelete(this.File, Section)
	}

	ReadKey(Key, Section?, Default?)
	{
		Default := Default ?? (this.HasOwnProp('Default') ? this.Default : unset)
		Section := Section ?? this.Section

		return IniRead(this.File, Section?, Key?, Default?)
	}

	; Converts a Ini Specific Section into an object Or Map.
	ReadSec(Section?, as_map := true) {

		Section := Section ?? this.Section

		Result := as_map ? Map() : Object()
		Sec := StrSplit(IniRead(this.File, Section), "`n")

		for Line in Sec
		{
			if !RegExMatch(Line, "(.+)=(.+)", &Split)
				continue
			
			Key := Split[1]
			Value := Split[2]

			if as_map
				Result[Key] := Value
			else
				Result.%Key% := Value
		}

		return Result
	}

	; Converts a Ini File into an object Or Map.
	Read(as_map := true) {

		Result := as_map ? Map() : Object()
		SectionNames := StrSplit(IniRead(this.File), "`n")
		
		for Section in SectionNames {

			if as_map
				Result[Section] := Map()
			else
				Result.%Section% := Object()

			KeyValues := IniRead(this.File, Section)

			for Line in StrSplit(KeyValues, "`n")
			{
				if !RegExMatch(Line, "(.+)=(.+)", &Split)
					continue

				Key := Split[1]
				Value := Split[2]

				if as_map
					Result[Section][Key] :=  Value
				else
					Result.%Section%.%Key% := Value
				
			} 
		}

		return Result
	}
}
