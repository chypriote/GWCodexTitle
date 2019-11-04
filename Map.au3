#include-once

#Region Constants
Global $CURRENT_MAP
Global $CURRENT_SIDE
Global $SIDE_BLUE = 1
Global $SIDE_RED = 2

Global $CODEX_ARENA = 796
Global $THE_CRAG = 14
Global $DELDRIMOR_ARENA = 13
Global $SEABED_ARENA = 12
Global $BRAWLERS_PIT = 11
Global $HEROES_CRYPT = 10
Global $CHURRANU_ISLAND_ARENA = 9
Global $SUNSPEAR_ARENA = 8
Global $PETRIFIED_ARENA = 7
Global $SHING_JEA_ARENA = 6
Global $SHIVERPEAK_ARENA = 5
Global $AMNOON_ARENA = 4
Global $FORT_KOGA = 3
Global $DALESSIO_ARENA = 2
Global $ASCALON_ARENA = 1
#EndRegion Constants

Func GetCurrentMap()
    Local $me = getagentbyid(-2)
    Local $x = DllStructGetData($me, "X")
    Local $y = DllStructGetData($me, "Y")

    Switch(True)
        Case ComputeDistance($x, $y, 6559, 4454) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $THE_CRAG
            Return "The Crag"
        Case ComputeDistance($x, $y, -2271, -2317) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $THE_CRAG
            Return "The Crag"
        Case ComputeDistance($x, $y, -9219, 2700) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $DELDRIMOR_ARENA
            Return "Deldrimor Arena"
        Case ComputeDistance($x, $y, -8969, 7426) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $DELDRIMOR_ARENA
            Return "Deldrimor Arena"
        Case ComputeDistance($x, $y, 9852, 4274) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $SEABED_ARENA
            Return "Seabed Arena"
        Case ComputeDistance($x, $y, 4399, 6730) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $SEABED_ARENA
            Return "Seabed Arena"
        Case ComputeDistance($x, $y, 1093, 5074) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $BRAWLERS_PIT
            Return "Brawlers Pit"
        Case ComputeDistance($x, $y, 4965, 5070) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $BRAWLERS_PIT
            Return "Brawlers Pit"
        Case ComputeDistance($x, $y, -3341, -5154) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $HEROES_CRYPT
            Return "Heroes Crypt"   
        Case ComputeDistance($x, $y, 3186, -5171) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $HEROES_CRYPT
            Return "Heroes Crypt"       
        Case ComputeDistance($x, $y, 4063, -101) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $CHURRANU_ISLAND_ARENA
            Return "Churranu Island Arena"  
        Case ComputeDistance($x, $y, -886, -478) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $CHURRANU_ISLAND_ARENA
            Return "Churranu Island Arena"    
        Case ComputeDistance($x, $y, 436, 2517) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $SUNSPEAR_ARENA
            Return "Sunspear Arena"  
        Case ComputeDistance($x, $y, 3865, -2254) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $SUNSPEAR_ARENA
            Return "Sunspear Arena"
        Case ComputeDistance($x, $y, 1909, 946) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $PETRIFIED_ARENA
            Return "Petrified Arena"
        Case ComputeDistance($x, $y, 7188, -3999) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $PETRIFIED_ARENA
            Return "Petrified Arena"
        Case ComputeDistance($x, $y, -2375, -1583) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $SHING_JEA_ARENA
            Return "Shing Jea Arena"
        Case ComputeDistance($x, $y, 2308, 2879) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $SHING_JEA_ARENA
            Return "Shing Jea Arena"
        Case ComputeDistance($x, $y, 9210, 12369) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $SHIVERPEAK_ARENA
            Return "Shiverpeak Arena"
        Case ComputeDistance($x, $y, 4379, 16264) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $SHIVERPEAK_ARENA
            Return "Shiverpeak Arena"
        Case ComputeDistance($x, $y, 3131, 10093) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $AMNOON_ARENA
            Return "Amnoon Arena"
        Case ComputeDistance($x, $y, -1892, 5201) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $AMNOON_ARENA
            Return "Amnoon Arena"
        Case ComputeDistance($x, $y, 6240, 255) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $FORT_KOGA
            Return "Fort Koga"
        Case ComputeDistance($x, $y, 179, -3365) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $FORT_KOGA
            Return "Fort Koga"
        Case ComputeDistance($x, $y, 4986, -2499) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $DALESSIO_ARENA
            Return "D'Alessio Arena"
        Case ComputeDistance($x, $y, 4735, 3830) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $DALESSIO_ARENA
            Return "D'Alessio Arena"
        Case ComputeDistance($x, $y, 8072, -2017) < 400:
            $CURRENT_SIDE = $SIDE_BLUE
            $CURRENT_MAP = $ASCALON_ARENA
            Return "Ascalon Arena"
        Case ComputeDistance($x, $y, 4815, -6436) < 400:
            $CURRENT_SIDE = $SIDE_RED
            $CURRENT_MAP = $ASCALON_ARENA
            Return "Ascalon Arena"
    EndSwitch

    Return "Unknown"
EndFunc


Func DefineMap()
    If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
        Local $mapName = GetCurrentMap()
        Out("I am on " & $mapName)
        $WON = GetCodexTitle()
        $DefineMap = False
    EndIf
 EndFunc ;DefineMap

Func GotoCenter()
    Switch($CURRENT_MAP)
        Case $THE_CRAG:
            $CURRENT_SIDE == $SIDE_BLUE ? MoveTo(1046, 74) : MoveTo(3585, 2023)
        Case $DELDRIMOR_ARENA:
            MoveTo(-11687, 5025)
        Case $SEABED_ARENA:
            MoveTo(7944, 6803)
        Case $BRAWLERS_PIT:
            MoveTo(3035, 5173)
        Case $HEROES_CRYPT:
            MoveTo(-8, -5258)
        Case $CHURRANU_ISLAND_ARENA:
            MoveTo(1834, -42)
        Case $SUNSPEAR_ARENA:
            MoveTo(2168, 221)
        Case $PETRIFIED_ARENA:
            MoveTo(4529, -1069)
        Case $SHING_JEA_ARENA:
            MoveTo(-13, 776)
        Case $SHIVERPEAK_ARENA:
            MoveTo(6718, 14307)
        Case $AMNOON_ARENA:
            MoveTo(872, 7728)
        Case $FORT_KOGA:
            MoveTo(3158, -1101)
        Case $DALESSIO_ARENA:
            MoveTo(3117, 439)
        Case $ASCALON_ARENA:
            MoveTo(5598, -4091)
    EndSwitch
EndFunc

 Func KillEnemy()
	If GetDistance(GetNearestEnemyToAgent(), -2) < 1250 Then
		For $i = 1 to 7
			If GetIsDead() Then ExitLoop
			If GetMapLoading() == 0 Then ExitLoop
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
