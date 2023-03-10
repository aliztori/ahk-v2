
class Map2 {
	
	static __New() => Map.Prototype.base := this

   	 /**
     * Joins all the elements to a string using the provided delimiter.
     * @param delimiter Optional: the delimiter to use. Default is comma.
     * @returns {String}
     */
	static Join(separators := [':', ', ']) {

		result := ""

		for Key, Value in this
			result .= Key separators[1] Value separators[2]

		return RTrim(result, separators[2])
	}

	static ToObj() {
    
        result := Object()

        for key, value in this
            result.%key% := value is Map ? value.ToObj() : value

        return result
    }

    static Merge(mapObjs*) {

        mp := this
        
        for mapObj in mapObjs 
            for key, value in mapObj
                mp.Set(key, value)

        return mp
    }
}


