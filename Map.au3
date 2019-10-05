#include-once

#Region Constants
Global $The_Crag = 14
Global $Deldrimor_Arena = 13
Global $Seabed_Arena = 12
Global $Brawlers_Pit = 11
Global $Heroes_Crypt = 10
Global $Churranu_Island_Arena = 9
Global $Sunspear_Arena = 8
Global $Petrified_Arena = 7
Global $Shing_Jea_Arena = 6
Global $Shiverpeak_Arena = 5
Global $Amnoon_Arena = 4
Global $Fort_Koga = 3
Global $DAlessio_Arena = 2
Global $Ascalon_Arena = 1
#EndRegion

Func GetMapName()
    Switch(GetMapID())
        Case $The_Crag:
            Return "The Crag"
        Case $Deldrimor_Arena:
            Return "Deldrimor Arena"
        Case $Seabed_Arena:
            Return "Seabed Arena"
        Case $Brawlers_Pit:
            Return "Brawlers Pit"
        Case $Heroes_Crypt:
            Return "Heroes Crypt"
        Case $Churranu_Island_Arena:
            Return "Churranu Island Arena"
        Case $Sunspear_Arena:
            Return "Sunspear Arena"
        Case $Petrified_Arena:
            Return "Petrified Arena"
        Case $Shing_Jea_Arena:
            Return "Shing Jea Arena"
        Case $Shiverpeak_Arena:
            Return "Shiverpeak Arena"
        Case $Amnoon_Arena:
            Return "Amnoon Arena"
        Case $Fort_Koga:
            Return "Fort Koga"
        Case $DAlessio_Arena:
            Return "D'Alessio Arena"
        Case $Ascalon_Arena:
            Return "Ascalon Arena"
    EndSwitch
    Return "Unknown"
EndFunc

Func DefineMap()
    Out("I am on " & GetMapName())
	If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
        $CURRENT_MAP = GetMapID()
        $WON = GetCodexTitle()
        $DefineMap = False
    EndIf
 EndFunc ;DefineMap

 Func GotoCenter()
    Switch(GetMapID())
        Case $The_Crag:
            MoveTo(1046, 74)
            MoveTo(3585, 2023)
        Case $Deldrimor_Arena:
            MoveTo(-11687, 5025)
        Case $Seabed_Arena:
            MoveTo(7944, 6803)
        Case $Brawlers_Pit:
            MoveTo(3035, 5173)
        Case $Heroes_Crypt:
            MoveTo(-8, -5258)
        Case $Churranu_Island_Arena:
            MoveTo(1834, -42)
        Case $Sunspear_Arena:
            MoveTo(2168, 221)
        Case $Petrified_Arena:
            MoveTo(4529, -1069)
        Case $Shing_Jea_Arena:
            MoveTo(-13, 776)
        Case $Shiverpeak_Arena:
            MoveTo(6718, 14307)
        Case $Amnoon_Arena:
            MoveTo(872, 7728)
        Case $Fort_Koga:
            MoveTo(3158, -1101)
        Case $DAlessio_Arena:
            MoveTo(3117, 439)
        Case $Ascalon_Arena:
            MoveTo(5598, -4091)
    EndSwitch
EndFunc

 Func KillEnemy()
	If GetDistance(GetNearestEnemyToAgent(), -2) < 1250 Then
		For $i = 1 to 7
			If GetIsDead(GetMyID()) Then ExitLoop
			If GetMapLoading() == 0 Then ExitLoop
			$agent = GetNearestEnemyToAgent()
			Out("Kill Enemes")
			Attack($agent)
			RndSleep(300)
			SkillUseRange($i, $agent)
			RndSleep(300)
			ChangeTarget($agent)
		Next
	EndIf
EndFunc ;KillEnemy