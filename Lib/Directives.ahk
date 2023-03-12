#SingleInstance Force
#MaxThreadsPerHotkey 2
#ClipboardTimeout -1
#WinActivateForce
#MaxThreads 10
#InputLevel 1
#UseHook true
#HotIf
InstallKeybdHook
InstallMouseHook
SetWinDelay(0)
SetKeyDelay(0)
SetMouseDelay(0)
SetControlDelay(0)
SetDefaultMouseSpeed(0)
SetWorkingDir(A_ScriptDir)
; A_MenuMaskKey := "vkFF"
A_HotkeyInterval := 2000
A_MaxHotkeysPerInterval := 200