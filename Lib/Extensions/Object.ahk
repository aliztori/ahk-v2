class Object2 {

    static __New() {
        for Prop in this.OwnProps()
		    if HasMethod(this, Prop)
				if !(Prop ~= "__Init|__New") 
					Object.Prototype.DefineProp(Prop, {Call: this.%Prop%})
    }
    
	static Join(separators := [':', ', ']) {

		result := ""

		for Key, Value in this
			result .= Key separators[1] Value separators[2]

		return RTrim(result, separators[2])
	}
    static ToMap()
    {
        result := Map()

        for key, value in this.OwnProps()
            result[key] := value is Object ? value.ToMap() : value

        return result
    }
}