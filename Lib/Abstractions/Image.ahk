
class Image {
	
	static Search(&OutputVarX, &OutputVarY, X1, Y1, X2, Y2, ImageFiles*)
	{
		; for image in ImageFiles
			; if Not FileExist(image)
				; throw TypeError(image " isnt exist", image, -1)

		for image in ImageFiles
			if ImageSearch(&OutputVarX, &OutputVarY, X1, Y1, X2, Y2, image)
				return true
		
		return false
	}

	;Made by @Axlefublrm rewritten and mofified into my style
	; (https://github.com/Axlefublr/lib-v2/blob/main/Utils/Image.ahk)
	/**
	 * Keeps searching for an image until it finds it
	 * @param imageFiles *Array* The paths of the images
	 * @param timeOut *String* TimeOut
	 * @param coordObj *Object* An optional object with x1, y1, x2, y2 properties to search for the image in
	 * @returns {Object} with found X and Y coordinates
	 */
	static WaitSearch(coordObj?, timeOut := 5000, imageFiles*)
	{
		if !IsSet(coordObj) {
			coordObj := {
				x1: 0,
				y1: 0,
				x2: A_ScreenWidth,
				y2: A_ScreenHeight
			}
		}

		flag := true
		SetTimer(() => flag := false, -timeOut)

		while flag {

			ToolTip("Searching... " A_Index)
			if this.Search(&X, &Y, coordObj.X1, coordObj.Y1, coordObj.X2, coordObj.Y2, imageFiles*) 
				return (ToolTip(), {X: X, Y: Y})
		}

		return (ToolTip(), false)
	}
}


class Pixel {

	static WaitSearch(coordObj, ColorID, Variation?, timeout := 5000) {

		CoordMode("Pixel", "Screen")

		flag := true
		SetTimer(() => flag := false, -timeOut)

		while flag {

			if PixelSearch(&X, &Y, coordObj.X1, coordObj.Y1, coordObj.X2, coordObj.Y2, ColorID, Variation := 0) 
				return (ToolTip(), {X: X, Y: Y})
			
			ToolTip("Searching... " A_Index)
		}

		ToolTip()
		return false
	}
	
}

