#include-once

Func Farmer()
	If $ZQUEST_ENABLED And DllStructGetData(GetQuestByID($ZQUEST_ID), 'MapTo') == $GREAT_TEMPLE_OF_BALTHAZAR Then ZaishenQuest()
    If GetMapId() <> $CODEX_ARENA Then TravelTo($CODEX_ARENA)
	AddHench()
	Enter()
	Farm()
EndFunc ;Farmer


Func Farm()
	Local $mapPoints = GetCodexTitle()

    While Not GetPartyDefeated()
        If $WON == 0 Then $WON = GetCodexTitle()
        While GetMapLoading() <> 1 
            Out("waiting load")
            RndSleep(1000)
        WEnd
        $mapPoints = GetCodexTitle()
        DefineMap()
        
        While $mapPoints == GetCodexTitle() And Not GetPartyDefeated()
            $agent = GetNearestEnemyToAgent()

            ;Move
            If $agent = 0 Then
                Out("Looking for enemy")
                GotoCenter()
                RndSleep(2000)
            EndIf

            $distance = GetDistance($agent)
            If $agent <> 0 And $distance > 1300 And $distance < 8000  Then
                ChangeTarget($agent)
                Attack($agent)
                Out("Attacking enemy")
                RndSleep(1000)
            EndIf
            If $agent <> 0 And $distance < 1500 Then KillEnemy()
        WEnd

        Out("Victory")
        Out("Total points earned: " & GetCodexTitle() - $STARTING_POINTS)

        If GetMissionStartDelay() Then
            If $ZQUEST_ENABLED And DllStructGetData(GetQuestByID($ZQUEST_ID), 'MapTo') == $GREAT_TEMPLE_OF_BALTHAZAR Then ZaishenQuest()
        EndIf

        While GetMissionStartDelay() <> 0
            Out("waiting start " & GetMissionStartDelay())
            RndSleep(1000)
        WEnd
    WEnd

    ;If we lost, exit to be faster
    Out("We lost")
    RndSleep(5000)
    TravelTo($CODEX_ARENA)
    Return
EndFunc ;Farm


Func SkillUseRange($skillnumber, $agent)
	$distance = GetDistance($agent, -2)
	If $distance < 1250 Then
		While True
			UseSkill($skillnumber, -1)
			RndSleep(1500)
			ExitLoop
		WEnd
	EndIf
EndFunc ;SkillUseRange

Func KillEnemy()
	If GetDistance(GetNearestEnemyToAgent()) < 1250 Then
		For $i = 1 to 7
			If GetIsDead() Then ExitLoop
			$agent = GetNearestEnemyToAgent()
			Out("Kill Enemies")
			Attack($agent)
			RndSleep(300)
			SkillUseRange($i, $agent)
			RndSleep(300)
			ChangeTarget($agent)
		Next
	EndIf
EndFunc ;KillEnemy
