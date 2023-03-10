
# Hot Library
-----------

### This library provides you with some very useful methods
### Including:

+ `First(HotKey)`
+ `Second(HotKey)`
+ `Both(HotKey)`



- `Hot.Keys(Hotkey)`
- `Hot.Raw(Hotkey, Which?)`
- `Hot.Keywait(Hotkey, Options?)`
- `Hot.KeyState(Hotkey, Mode := "P")`

-------------------------------------------

The first three methods are used for combined hotkeys
The first one and the second one return the string and the third one the array containing the first key and the second key


*example:*
------------

```Autohotkey
~g & h::MsgBox Hot.First(A_ThisHotkey)  => "~g"
~g & h Up::MsgBox Hot.Second(A_ThisHotkey) => "h Up"
g & h::MsgBox Hot.Both(A_ThisHotkey)   => ["g", "h"]
```

-------------------------------------------
### Hot.Raw()
The fourth method is the __Raw__ method, which can be said to be the most useful method in this library
It takes your Hotkey and returns it raw even if your hotkey is combinations

*example:*
------------


```Autohotkey
#!^g::MsgBox Hot.Raw(A_ThisHotkey) => "g"

$<#g::MsgBox Hot.Raw(A_ThisHotkey) => "g"
!n Up::MsgBox Hot.Raw(A_ThisHotkey) => "n"
g & h::MsgBox Hot.Raw(A_ThisHotkey, Which := 1) => "g"
g & h Up::MsgBox Hot.Raw(A_ThisHotkey, Which := 2) => "h"

#!::MsgBox Hot.Raw(A_ThisHotkey) => "!"
^#::MsgBox Hot.Raw(A_ThisHotkey) => "#"
```

-------------------------------------------

In fact, we do not use the __keys__ method outside the class
But its use is in the next two methods
This method takes a hotkey and separates its keys and returns it as an array


*example:*
------------
```Autohotkey
<!>^g::  Hot.Keys(A_ThisHotkey) => ["LAlt", "RCtrl", "g"]
!<#n Up::Hot.Keys(A_ThisHotkey) => ["Alt", "LWin", "n"]
^#:: 	 Hot.Keys(A_ThisHotkey) => ["Ctrl", "#"]
<+f::	 Hot.Keys(A_ThisHotkey) => ["LShift", "f"]
```
-------------------------------------

##### `GetKeyState(Key)` And `KeyWait(Key)` are already built in Funtions, but our methods can take a Hotkey instead of a key.


*example:*
------------

### Hot.KeyWait()

```Autohotkey
^g::{
	Hot.KeyWait(A_ThisHotkey)
	MsgBox "Hello, World"
}
```
In the example above, the **control** key and **G** key Must be Released to perform the following operation


*And you can also use the options*


```Autohotkey
^h::{
	Hot.KeyWait(A_ThisHotkey, "T3")
	MsgBox "Hello, World"
}

^g::{
	Hot.KeyWait("!n", "D")
	MsgBox "Hello, World"
}
```

>##### Also, for the convenience of working in this method, I considered a tool tip as low <br/> That is, for example, when you hold control and G, ToolTip will show you the number of keys you need to press/release.

------------------------------------------------------------
### Hot.KeyState()

```Autohotkey
^g::{
	while Hot.KeyState(A_ThisHotkey)
		ToolTip("Hello, Ali")
	ToolTip()
}
```

> In the Above Method, I Set the Mode to Physical (It is in Toggle Mode in the Main Function)


------------------------------------------------------------

> Finally, if you have any ideas for improving the code or developing the library, I would be happy to share them with me :)  
Discord: aliztori#1666



