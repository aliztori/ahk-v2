#Include <Extensions\JSON>
;Made by @thqby (https://github.com/thqby), rewritten slightly into my style

Print(toPrint) {

    toPrint_string := ""

    switch ValuType := Type(toPrint) {

        case "Map", "Array", "Object":
            toPrint_string := JSON.stringify(toPrint)

        default:
            try toPrint_string := String(toPrint)
            catch Any 
                toPrint_string := ValuType
    }

    return toPrint_string
}