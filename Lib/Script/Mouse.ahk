#Include <System\Brightness>
#Include <Utils\Windows>
#Include <Alert>
; My Mouse:  https://www.razer.com/gaming-mice/razer-naga-trinity


#LButton:: Windows.Drag()
#RButton:: Windows.Resize()


~MButton Up:: Send("{F2}")
#MButton:: AddVirtualDesktop()

#WheelUp::Brightness.ChangeBrightnessRelative(10)
#WheelDown::Brightness.ChangeBrightnessRelative(-10)

; WheelRight:
Volume_Up::Right
^Volume_Up:: Send("{End}")
!Volume_Up:: Send("+{End}")
#Volume_Up:: SwitchRightVD()

; WheelLeft:
Volume_Down::Left
^Volume_Down:: Send("{Home}")
!Volume_Down:: Send("+{Home}")
#Volume_Down:: SwitchLeftVD()

; Sensitivity Stage Up:
Media_Next:: Mouse.Activate(), MoveWintoNextMonitor()

; Sensitivity Stage Down:
Media_Prev:: ScreenSnip()

; Button 1:
F13::Browser_Back

; Button 2:
F14::Del

; Button 3:
F15::BackSpace

; Button 4:
F16::Browser_Forward

; Button 5:
F17::Enter

; Button 6:
; F18::

; Button 7:
; F19::

; Button 8:
; F20::

; Button 9:
; F21::

; Button 10:
F22::KeyWait(A_ThisHotkey), UnderMouse.Minimize()
!F22::Mouse.AlwaysOnTop(true)

; Button 11:
F23::KeyWait(A_ThisHotkey), UnderMouse.ResMax()

; Button 12:
F24::KeyWait(A_ThisHotkey), UnderMouse.Close()
^F24::Mouse.ProcessClose()
+F24::Mouse.ShowHide()

