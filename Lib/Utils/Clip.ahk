#Include <Alert>


class Clip {

	static Call(Data) => A_Clipboard := Data

	static Data := Map()

	static __Item[Key] {
		Set => this.Data.Set(Key, Value)
		Get => this.Data.Get(Key)
	}
	
	static Save() {
		this.ClipSaved := ClipboardAll()
		A_Clipboard := ""
	}	

	static Restore() {
		A_Clipboard := this.ClipSaved
	}

	static Cut(All := false) {

		this.Save()
		data := ''
	
		Cut()
		if ClipWait(0.1, 0) 
			data := A_Clipboard	

		else if All {

			SelectAll()
			Cut()
			if ClipWait(0.1, 0) 
				data := A_Clipboard
			
		} else
			alert("Nothing Found to Copy")

		this.Restore()
		return data
	}

	static Copy(All := false)
	{
		this.Save()
		data := ''
	
		Copy()
		if ClipWait(0.1, 0) 
			data := A_Clipboard	

		else if All {

			SelectAll()
			Copy()
			if ClipWait(0.1, 0) 
				data := A_Clipboard
			
		} else
			alert("Nothing Found to Copy")

		this.Restore()
		return data
	}

	static AppendCut(All?)  => A_Clipboard .= "`n" . this.Cut(All?)
	static AppendCopy(All?) => A_Clipboard .= "`n" . this.Copy(All?)

	static Paste(toSend) => this.Send(toSend)
	static Send(toSend) {

		this.Save()
		
		A_Clipboard := ToSend
		if ClipWait(1, 0) 
			Paste()
		else 
			alert("Clipboard Can't Receive Data")
		
		; Sleep(500)
		
		SetTimer(() => this.Restore, -500)
	}
}

Cut() => Send("^x")
Copy() => Send("^c")
Paste() => Send("^v")
SelectAll() => Send("^a")