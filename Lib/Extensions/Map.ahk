
class Map2 {
	
	static __New() => Map.Prototype.base := this

   	 /**
     * Joins all the elements to a string using the provided delimiter.
     * @param delimiter Optional: the delimiter to use. Default is comma.
     * @returns {String}
     */

	static ToObj() {
    
        result := Object()

        for key, value in this
            result.%key% := value is Map ? value.ToObj() : value

        return result
    }
}


