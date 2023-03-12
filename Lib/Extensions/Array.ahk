
class Array2 extends Array {

	static __New() => Array.Prototype.base := this

	static HasVal(Needle)
	{
		for index, Value in this
			if Value = Needle
				Return index

		Return False
	}

	/**
	 * Joins all the elements to a string using the provided delimiter.
	 * @param delimiter Optional: the delimiter to use. Default is comma.
	 * @returns {String}
	 */
	static Join(delimiter := ", ") {
		
		result := ""

		for Value in this
			result .= (Value is Array ? '[' Value.Join(delimiter) ']' : Value) delimiter

		return RTrim(result, delimiter)
	}

	/**
	 * Swaps elements at indexes a and b
	 * @param a First elements index to swap
	 * @param b Second elements index to swap
	 * @returns {Array}
	 */
	static Swap(a, b) {

		temp := this[b]
		this[b] := this[a]
		this[a] := temp
	}

	/**
	 * Reverses the array.
	 * @example
	 * [1, 2, 3].Reverse() ; returns [3, 2, 1]
	 */
	static Reverse() {

		Arr := this
		len := Arr.Length + 1, Max := (len // 2), i := 0
		while ++i <= Max
			this.Swap(i, len - i)

		return this
	}

	static Replace(index, Value*) {

		Arr := this
		Arr.RemoveAt(index, Value.Length)
		Arr.InsertAt(index, Value*)

	}
}