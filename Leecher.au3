#include-once

Func Leecher()
	If GetMapId() <> $CODEX_ARENA Then TravelTo($CODEX_ARENA)
	AddHench(False)
	Enter()
	Suicide()
EndFunc ;Leecher

Func Suicide()
	Out("Let's Die")
	Do
		RndSleep(1250)
	Until GetMapLoading() = 0 And GetAgentExists(-2)
EndFunc ;Suicide
