#Include <App\Browser>
#Include <App\Youtube>


#HotIf WinActive(YouTube.Wintitle) && !Mouse.IsOverWin(Browser.WinTitle)


   ; WheelLeft	
   Volume_Down:: Youtube.SpeedpDown()

   ; WheelRight
   Volume_Up:: Youtube.SpeedpUp()


#HotIf