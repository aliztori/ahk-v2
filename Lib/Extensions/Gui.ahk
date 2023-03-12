class Gui2 {

	static __New() => Gui.Prototype.Base := this		

	static DarkMode() => (this.BackColor := "171717", this)

	static MakeFontNicer(fontSize := 20) {

		gu := this
		gu.SetFont("S" fontSize " cc5c5c5", "Exo 2 ExtraBold")
		return gu 	  
	}
}
