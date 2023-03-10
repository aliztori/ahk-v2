#Include <Abstractions\\Scripts>

#SuspendExempt true
{
	+Esc::Suspend()
	^Esc::Reload()
	!Esc::Pause()
	#Esc::ExitApp()
}
#SuspendExempt false