#Include <Tools\Info>

class alert {
	static Call(Msg, Timeout := 3000) => info(Msg, Timeout)
	static Err(ErrorObj) => this(Type(ErrorObj) ": " ErrorObj.Message)
}