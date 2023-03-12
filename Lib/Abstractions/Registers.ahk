#Include <Abstractions\Text>
#Include <Utils\Clip>
#Include <Alert>

; Made by @Axlefublr https://github.com/Axlefublr/lib-v2/blob/main/Abstractions/Registers.ahk
; rewritten and modified into my style

class Registers {
	
	__New(Key) {
		this.Key := Registers.__ValidateKey(Key)
	}

	/**
     * A string of characters that are accepted as register names.
     * Every register is just a file that has the character in its name.
     * Consider whether a character you want to add to this string would be allowed in a filename.
     * Case sensitive.
     * @type {String}
     */
	static ValidRegisters := "1234567890qwertyuiopasdfghjklzxcvbnm"
    /**
     * @param {Char} key
     * @private
     * @throws {ValueError} If the key passed isn't in Registers.ValidRegisters
     * @throws {UnsetItemError} If you pass an empty string as the key
     */
    static __ValidateKey(key) {

		if key = ""
			throw UnsetItemError("You didn't pass any key", -1)

        else if !InStr(Registers.ValidRegisters, key, false) {
            throw ValueError("
            (
                The key you passed isn't supported by Registers.
                Add it to the Registers.ValidRegisters string if you want to use it.
                Some keys aren't going to work even if you do.
            )", -1, key)
        }

        return key
    }

	static MsgTimeout := 3000
	/**
	 * Commands executed will note you of their completion.
	 * Set up how long they should stay.
	 * In milliseconds.
	 * @type {Integer}
	 * @type {Timeout}
	 */
	Msg(Text, Timeout := Registers.MsgTimeout) => Info(Text, Timeout)
	

	/**
	 * The maximum amount of characters shown when Peeking a register
	 * @type {Integer}
	 */
	static MaxPeekCharacters := 100

	/**
	 * The directory where you keep all of your register files.
	 * Format: C:\Programming\registers
	 * @type {String}
	 */
	static RegDir := Paths.Reg

	/**
	 * @param path ***String*** — To the register
	 * @private
	 * @returns {String} Text in the register. Empty string if the register doesn't exist.
	 */
	__TryGetRegisterText(path) => FileExist(path) ? ReadFile(path) : ""

	/**
	 * @param text ***String***
	 * @private
	 * @returns {String} Up to first 100 characters in a file, where newlines are replaced by `\n`
	 */
	static __FormatRegister(text) {
		registerContentsNoNewlines := text.RegExReplace("\r?\n", "\n")
		return registerContentsNoNewlines[1, Registers.MaxPeekCharacters]
	}
	
	/**
	 * @param fileName ***String*** — Format: "reg_k.txt"
	 * @private
	 * @returns {String} The character of a register file. "reg_k.txt" => "k"
	 */
	static __FormatRegisterName(fileName) {	
		; return RegExReplace(fileName, "r^eg_(.+)\.txt&", "$1")
		return RegExReplace(fileName, "^reg_|\.txt$")
	}

    /**
     * @returns {String} The path of the register of entered key
     */
	GetPath() => Registers.RegDir "\reg_" this.key ".txt"


    /**
     * @returns {String} Text inside of the register file
     */
	Read() {
		path := this.GetPath()
		return this.__TryGetRegisterText(path)
	}

    /**
     * Remove the contents of a register
     */
	Truncate() {
		WriteFile(this.GetPath())
		this.Msg(this.key " cleared")
	}


    /**
     * Append the contents of your clipboard to a register
     */
	Write(Text?) {
		path := this.GetPath()
		WriteFile(path, Text ?? A_Clipboard)
		this.Msg(this.key " " (Text ?? A_Clipboard) " Written")
	}

	Cut() {
		path := this.GetPath()
		WriteFile(path, Clip.Cut())
		this.Msg(this.key " Cuted")
	}


	Copy() {
		path := this.GetPath()
		WriteFile(path, Clip.Copy())
		this.Msg(this.key " Copied")
	}


	/**
	 * Append the contents of your clipboard to a register
	 * @param key ***Char*** — Register key
	 */
	Append() {
		path := this.GetPath()
		AppendFile(path, "`n" A_Clipboard)
		this.Msg(this.key " Clipboard Appended")
	}

	AppendCut() {
		path := this.GetPath()
		AppendFile(path, "`n" Clip.Cut())
		this.Msg(this.key " Clipboard Cuted and Appended")
	}

	AppendCopy() {
		path := this.GetPath()
		AppendFile(path, "`n" Clip.Copy())
		this.Msg(this.key " Clipboard Copied and Appended")
	}


    /**
     * Paste the contents of a register
     */
	Paste() {
		content := this.Read()
		Clip.Paste(Content)
		this.Msg(this.key " pasted")
	}

	/**
     * Show the contents of a register in an info.
     * In the contents shown, newlines will be replaced by "\n" and only up to 100 characters are shown for each one.
     * (configurable by modifying Registers.MaxPeekCharacters)
     */
	Peek() {
		text := this.Read()
		shorterText := this.__FormatRegister(text)
		this.Msg(this.key ": " shorterText)
	}

    /**
     * Get an info for every register that is not empty.
     * Each info will display the name of the register and its contents.
     * In the contents shown, newlines will be replaced by "\n" and only up to 100 characters are shown for each one.
     * (configurable by modifying Registers.MaxPeekCharacters)
     */
	static PeekNonEmpty() {
		loop files Registers.RegDir "\*.txt" {
			text := ReadFile(A_LoopFileFullPath)
			if text = "" 
				continue
			
			shorterText := Registers.__FormatRegister(text)
			Info(Registers.__FormatRegisterName(A_LoopFileName) ": " shorterText, 0)
		}
	}


	/**
	 * Show the full contents of a register in an info.
	 * If you call this function multiple times without destroying the infos, they will overlap.
	 * @throws {ValueError} If you pass an unsupported key
	 */
	Look() => this.Msg(this.Read(), 0)

    /**
     * Move the contents of one register into another register
     * @param {Char} key2 Register to move to
     */
	Move(key2) {

		Key1 := this.Key

		path1 := this.GetPath(key1)
		path2 := this.GetPath(key2)

		WriteFile(path2, this.__TryGetRegisterText(path1))
		WriteFile(path1)

		this.Msg(key1 " moved to " key2)
	}	
}
