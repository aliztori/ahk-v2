; No dependencies

GetHtml(link) => WebRequest().Fetch(link)

class Api {

	static PrayerTimes(cityCode, value?) {

		static APILINK := 'https://prayer.aviny.com/api/prayertimes/'
		link :=  APILINK . citycode
		Respons := WebRequest().Fetch(link, 'GET')
		prayer := JSON.parse(Respons)
		return IsSet(value) ? prayer[value] : prayer
	}

	/**
	 * 
	 * 	{
	 *		"Currency": "usd",
	 *		"Price": "253690",
	 *		"Changes": "0.87",
	 *		"Ok": true,
	 *		"Source": "tgju.org"
	 *	}
	 * 
	 */
	static DolorPrice(Currency := "usd", value?) {

		static apiLink := 'https://dapi.p3p.repl.co/api/?currency='
		link :=  apiLink . Currency

		Respons := WebRequest().Fetch(link, 'GET')
		Price := JSON.parse(Respons)

		return IsSet(value) ? Price[value] : Price
	}


}

class WebRequest
{
    __New() {
        this.whr := ComObject('WinHttp.WinHttpRequest.5.1')
    }

    __Delete() {
        this.whr := ''
    }

    Fetch(url, method := 'GET', HeadersMap := '', body := '', getRawData := false) {
        this.whr.Open(method, url, true)
        for name, value in HeadersMap
            this.whr.SetRequestHeader(name, value)

        this.error := ''
        this.whr.Send(body)
        this.whr.WaitForResponse()
        status := this.whr.status
        if (status != 200)
            this.error := 'HttpRequest error, status: ' . status . ' — ' . this.whr.StatusText
		
        SafeArray := this.whr.responseBody
        pData := NumGet(ComObjValue(SafeArray) + 8 + A_PtrSize, 'Ptr')
        length := SafeArray.MaxIndex() + 1
        if !getRawData
            res := StrGet(pData, length, 'UTF-8')
        else {
            outData := Buffer(length, 0)
            DllCall('RtlMoveMemory', 'Ptr', outData, 'Ptr', pData, 'Ptr', length)
            res := outData
        }
        return res
    }
}
