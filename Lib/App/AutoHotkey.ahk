
Class Autohotkey {

   static path        := Paths.Ahk
   static processExe  := A_AhkPath

   ; static currVersion := this.path "\v" A_AhkVersion
   static currVersion := this.path "\v2"
   static v1Version   := this.path "\v1.1.36.01"
   static exeTitle    := "ahk_exe " this.processExe

   Class Docs extends Autohotkey {

      static exeTitle := "ahk_exe hh.exe"

      Class v2 extends Autohotkey.Docs {

         static winTitle := "AutoHotkey v2 Help " super.exeTitle
         static path := super.currVersion "\AutoHotkey.chm"

         static winObj := Win({
            winTitle: this.winTitle,
            exePath: this.path
         })
         static __Call(Method, Params) => this.winObj.%Method%(Params*)
            
      }
      Class v1 extends Autohotkey.Docs {

         static winTitle := "AutoHotkey Help " super.exeTitle
         static path := super.v1Version "\AutoHotkey.chm"

         static winObj := Win({
            winTitle: this.winTitle,
            exePath:  this.path
         })
         static __Call(Method, Params) => this.winObj.%Method%(Params*)
      }
   }
}