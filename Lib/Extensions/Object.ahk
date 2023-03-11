class Object2 {

    static __New() {
        for Prop in this.OwnProps()
		    if HasMethod(this, Prop)
				if !(Prop ~= "__Init|__New") 
					Object.Prototype.DefineProp(Prop, {Call: this.%Prop%})
    }

    static ToMap()
    {
        result := Map()

        for key, value in this.OwnProps()
            result[key] := value is Object ? value.ToMap() : value

        return result
    }
}