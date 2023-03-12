#Include <Misc>
#Include <Alert>
#Include <Utils\Hot>
#Include <App\VsCode>
#Include <Utils\Print>
#Include <App\Google>
#Include <App\Browser>
#Include <App\Resonic>
#Include <App\Discord>
#Include <App\Telegram>
#Include <App\Autohotkey>
#Include <Utils\Highlight>
#Include <Abstractions\Input>
#Include <Utils\CrossLayouts>
#Include <Abstractions\Registers>


ScreenSnip() => Send("#+s")
Luck() => DllCall("LockWorkStation")

SwitchRightVD() => Send("{Blind}^#{Right}")
SwitchLeftVD() => Send("{Blind}^#{Left}")
AddVirtualDesktop() => Send("{Blind}^#d")
MoveWintoNextMonitor() => Send("{Blind}+#{Right}")



F2::Send("{Volume_Down}")
F3::Send("{Volume_Up}")
F4::Send("{Volume_Mute}")
; F5::Refresh
F6::Send("{Media_Prev}") 
F7::Send("{Media_Play_Pause}")  
F8::Send("{Media_Next}")



F9::Telegram.Notif("Focus")

!F9::Telegram.Notif("Click")
+!F9::Telegram.WaitNotif("Click")

+F9::Telegram.Notif("Seen")

^F9::Telegram.Notif("Reply")
+^F9::Telegram.WaitNotif("Close")


F10::Run("Explorer.exe")
F11::Luck()
F12::Run("Calc")

#a::Mouse.AlwaysOnTop(1)
#c::VsCode.App()
#b::Browser.App()
#s::Discord.App()
#t::Telegram.App()
!#t::Telegram.Close()
#r::Resonic.App()

#p::Info(Print(Prayer()))

#h::Autohotkey.Docs.v2.winObj.RunAct()
!g::Info(Google.Translate(input := Clip.Copy(), 'auto', input ~= "\w" ? "fa" : "en"))

#Enter::InputLock()

!Space::return
CapsLock::LockHint('CapsLock', false)

; CapsLock & Space::Symbol("zwnj")

^CapsLock::HighLight.StrTitle()
+CapsLock::HighLight.StrUpper()
!CapsLock::Highlight.StrLower()

#CapsLock::
#NumLock::
#ScrollLock::LockHint(Raw())

Ins::  HighLight.ToOpposite()
^Ins:: HighLight.ToEnglish()
!Ins:: HighLight.ToPersian()

<!-::HighLight.SpaceLine()
>!-::HighLight.UnderSpace()

>!'::HighLight.AutoQuote()
>!9::HighLight.AutoParent()

GetKey() {

    Hot.KeyWait(A_ThisHotkey)

    key := Input.GetKey()
    if key = "Escape" {
        alert "Action Cancelled"
        Exit()
    }
    try Registers.__ValidateKey(key)
    catch ValueError {
        alert "Wrong Key`nAction Cancelled"
        Exit()
    } 
    return key
}

!a::Registers(GetKey()).Append()
!z::Registers(GetKey()).AppendCut()
!b::Registers(GetKey()).AppendCopy()
!w::Registers(GetKey()).Write()
!x::Registers(GetKey()).Cut()
!c::Registers(GetKey()).Copy()
!v::Registers(GetKey()).Paste()
!s::Registers(GetKey()).Look()
!e::Registers.PeekNonEmpty()
!d::Registers(GetKey()).Truncate()
!m::Registers(GetKey()).Move(GetKey())
