#Include <Utils\HotZone>

#HotIf HotEdge.Edges(50)

	WheelDown::Send("{Volume_Down}")
	WheelUp::Send("{Volume_Up}")

#HotIf HotEdge.All(50, "Monitor","Top") 

	MButton::Send "{Volume_Mute}"

#HotIf
