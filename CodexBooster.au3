#include <ButtonConstants.au3>
#include <GWA2.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include "GWA2_Headers.au3"
#NoTrayIcon

#Region Constants
Global $CODEX_ARENA = 796
Global $CURRENT_MAP
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
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
#EndRegion Constants

#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

Global $BOT_RUNNING = False
Global $BOT_INITIALIZED = False
Global $FIRST_RUN = True
Global $TOTAL_SECONDS = 0
Global $SECONDS = 0
Global $MINUTES = 0
Global $HOURS = 0
Global $HWND
Global $WON = False
Global $STARTING_POINTS = 0
Global $TOTAL_CODEX = 0
#EndRegion Declarations

#Region GUI
Func GUI()
    Global $GUI = GUICreate("Codex Tool", 299, 204, -1, -1)
    Global $CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
        GUICtrlSetData(-1, GetLoggedCharNames())
    Global $StartButton = GUICtrlCreateButton("Start", 5, 40, 105, 23)
        GUICtrlSetOnEvent(-1, "GUIButtonHandler")
    Global $Stats = GUICtrlCreateGroup("Select Bot", 120, 6, 170, 70) ;
    Global $Leecher= GUICtrlCreateCheckbox("Suicide Bot", 130, 25)
    Global $Farmer = GUICtrlCreateCheckbox("Main Bot", 130, 45)
    Global $ZKey = GUICtrlCreateCheckbox("ZKey", 220, 25)
    Global $StatusLabel = GUICtrlCreateEdit("", 10, 80, 280, 80, 2097220)
    Global $RenderingBox = GUICtrlCreateCheckbox("Render", 220, 45, 103, 17)
        GUICtrlSetOnEvent(-1, "ToggleRendering")
        GUICtrlSetState($RenderingBox, $GUI_DISABLE)
    Global $EnableZQuest = GUICtrlCreateCheckbox("Enable Zaishen Quest", 8, 165, 140, 20)
    GUICtrlCreateLabel("Quest ID:", 150, 167, 50, 20)
    Global $QuestIDInput = GUICtrlCreateInput("", 205, 165, 50, 20)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
    GUISetState(@SW_SHOW)
EndFunc
#EndRegion GUI

#Region Loops
GUI()
Out("Ready.")
While Not $BOT_RUNNING
    RndSleep(500)
WEnd

While 1
    If Not $BOT_RUNNING Then
    Out("Bot is paused.")
    GUICtrlSetState($StartButton, $GUI_ENABLE)
    GUICtrlSetData($StartButton, "Start")
    GUICtrlSetOnEvent($StartButton, "GUIButtonHandler")
    AdlibUnRegister("VerifyConnection")
    $FIRST_RUN = True
    RndSleep(500)
    ContinueLoop
    EndIf

    If $FIRST_RUN Then
        AdlibRegister("VerifyConnection", 5000)
        $FIRST_RUN = False
    EndIf

    If GUICtrlRead($Leecher) == $GUI_CHECKED Then LeecherRole()
    If GUICtrlRead($Farmer) == $GUI_CHECKED Then FarmerRole()
    If GUICtrlRead($ZKey) == $GUI_CHECKED Then TradeKey()
WEnd
#EndRegion Loops

#Region GUI
Func GUIButtonHandler()
    If $BOT_RUNNING Then
    Out("Will pause after this run.")
    GUICtrlSetData($StartButton, "Force Pause")
    GUICtrlSetOnEvent($StartButton, "Resign")
    $BOT_RUNNING = False
    ElseIf $BOT_INITIALIZED Then
    GUICtrlSetData($StartButton, "Pause")
    $BOT_RUNNING = True
    Else
    Out("Initializing...")
    Local $CharName = GUICtrlRead($CharInput)
    If $CharName == "" Then
        If Initialize(ProcessExists("gw.exe"), True, True) = False Then
                MsgBox(0, "Error", "GUIld Wars is not running.")
                Exit
        EndIf
    Else
        If Initialize($CharName, True, True) = False Then
                MsgBox(0, "Error", "Could not find a GUIld Wars client with a character named '" & $CharName & "'")
                Exit
        EndIf
    EndIf
    $HWND = GetWindowHandle()
    GUICtrlSetState($RenderingBox, $GUI_ENABLE)
    GUICtrlSetState($CharInput, $GUI_DISABLE)
    GUICtrlSetState($Leecher, $GUI_DISABLE)
    GUICtrlSetState($Farmer, $GUI_DISABLE)
    GUICtrlSetState($ZKey, $GUI_DISABLE)
    GUICtrlSetState($EnableZQuest, $GUI_DISABLE)
    GUICtrlSetState($QuestIDInput, $GUI_DISABLE)
	  
    Local $CharName = GetCharName()
    GUICtrlSetData($CharInput, $CharName, $CharName)
    GUICtrlSetData($StartButton, "Pause")
    WinSetTitle($GUI, "", $CharName & " - Codex Tool")
    $BOT_RUNNING = True
    $BOT_INITIALIZED = True
    $STARTING_POINTS = GetCodexTitle()
    SetMaxMemory()
    EndIf
EndFunc
#EndRegion ;GUI

#Region Leecher
Func LeecherRole()
    Out("❃❃ Suicide Selected ❃❃")
    TravelTo($CODEX_ARENA)
    Enter()
    Suicide()
EndFunc ;LeecherRole

Func AddHench()
    Out("Adding Hench")
    AddNpc(1)
    RndSleep(300)
    AddNpc(2)
    RndSleep(300)
    AddNpc(4)
    RndSleep(300)
EndFunc ;AddHench

Func Suicide()
    Out("Let's Die")
    Do
        RndSleep(1250)
    Until GetMapLoading() = 0 And GetAgentExists(-2)
EndFunc ;Suicide
#EndRegion Leecher

#Region Main
Func FarmerRole()
    TravelTo($CODEX_ARENA)
    ZaishenQuest()
    AddHench2()
    Enter()
    Farm()
EndFunc ;FarmerRole

Func AddHench2()
    Out("Adding Hench")
    AddNpc(3)
    RndSleep(300)
    AddNpc(4)
    RndSleep(300)
    AddNpc(5)
    RndSleep(300)
EndFunc

Func Farm()
    Out("Waiting Win")
    Out("Current points: " & GetCodexTitle())
    While GetMapLoading() == 1 And GetMapId() == $CODEX_ARENA
        DefineMap()
        CheckIsTeamWiped()
        $agent = GetNearestEnemyToAgent()
        $distance = GetDistance($agent, -2)
        If $WON == 0 Then $WON = GetCodexTitle()
        If $WON == GetCodexTitle() And $distance > 1300 And $distance < 8000  Then
            If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
                Attack($agent)
                Out("Looking enemy")
                ChangeTarget($agent)
                RndSleep(1000)
            EndIf
        EndIf
        If $WON == GetCodexTitle() And $distance < 1500 Then
            If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
                KillEnemy()
            EndIf
        EndIf
        If GetNearestEnemyToAgent() = 0 Then
            If $WON == GetCodexTitle() And GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
                Out("looking for enemy")
                If $WON == GetCodexTitle() And $CURRENT_MAP == $The_Crag Then
                    If $WON == GetCodexTitle() And GetNearestEnemyToAgent() = 0 Then
                        MoveTo(1046, 74)
                    EndIf
                    If $WON == GetCodexTitle() And GetNearestEnemyToAgent() = 0 Then
                        MoveTo(3585, 2023)
                    EndIf
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Deldrimor_Arena Then
                    Moveto(-11687, 5025)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Seabed_Arena Then
                    Move(7944, 6803)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Brawlers_Pit Then
                    Move(3035, 5173)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP ==  $Heroes_Crypt Then
                    Move(-8, -5258)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Churranu_Island_Arena Then
                    Move(1834, -42)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Sunspear_Arena Then
                    Move(2168, 221)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Petrified_Arena Then
                    Move(4529, -1069)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Shing_Jea_Arena Then
                    Move(-13, 776)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Shiverpeak_Arena Then
                    Move(6718, 14307)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Amnoon_Arena Then
                    Move(872, 7728)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Fort_Koga Then
                    Move(3158, -1101)
                    RndSleep(2000)
                EndIf
                If $WON == GetCodexTitle() And $CURRENT_MAP == $DAlessio_Arena Then
                    Move(3117, 439)
                    RndSleep(2000)
                EndIf
                If  $WON == GetCodexTitle() And $CURRENT_MAP == $Ascalon_Arena Then
                    Move(5598, -4091)
                    RndSleep(2000)
                EndIf
            EndIf
        EndIf
        If  $WON < GetCodexTitle() Then
            Out("Victory")
            WaitMapLoading()
            DefineMap()
            Out("Total points earned: " & GetCodexTitle() - $STARTING_POINTS)
        EndIf
    WEnd
EndFunc ;Farm
#EndRegion ;Main


#Region General
Func Out($msg)
    GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
    _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
    _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc ;Out

Func Enter()
    Out("Entering Battle")
    EnterChallenge()
    Out("Map Loading")
    Do
        RndSleep(1250)
    Until GetMapLoading() = 1 And GetAgentExists(-2)
EndFunc ;Enter

Func _exit()
    If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
        EnableRendering()
        WinSetState($HWND, "", @SW_SHOW)
        RndSleep(500)
    EndIf
    Exit
EndFunc ;_exit

Func DefineMap()
    Local $lme = getagentbyid(-2)
    If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then

    ;~ 		---------Ascalon Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 8072, -2017) < 400 Then ;Blue
            Out("I am blue in Ascalon Arena")
            $CURRENT_MAP = $Ascalon_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4815, -6436) < 400 Then ;Red
            Out("I am red in Ascalon Arena")
            $CURRENT_MAP = $Ascalon_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------D'Alessio_Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4986, -2499) < 400 Then ;Blue
            Out("I am blue in D'Alessio Arena")
            $CURRENT_MAP = $DAlessio_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4735, 3830) < 400 Then ;Red
            Out("I am red in D'Alessio Arena")
            $CURRENT_MAP = $DAlessio_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Fort Koga---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 6240, 255) < 400 Then ;Blue
            Out("I am blue in Fort Koga")
            $CURRENT_MAP = $Fort_Koga
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 179, -3365) < 400 Then ;Red
            Out("I am red in Fort Koga")
            $CURRENT_MAP = $Fort_Koga
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Amnoon Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3131, 10093) < 400 Then ;Blue
            Out("I am blue in Amnoon Arena")
            $CURRENT_MAP = $Amnoon_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -1892, 5201) < 400 Then ;Red
            Out("I am red in Amnoon Arena")
            $CURRENT_MAP = $Amnoon_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Shiverpeak Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 9210, 12369) < 400 Then ;Blue
            Out("I am blue in Shiverpeak Arena")
            $CURRENT_MAP = $Shiverpeak_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4379, 16264) < 400 Then ;Red
            Out("I am red in Shiverpeak Arena")
            $CURRENT_MAP = $Shiverpeak_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Shing Jea Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -2375, -1583) < 400 Then ;Blue
            Out("I am blue in Shing Jea Arena")
            $CURRENT_MAP = $Shing_Jea_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 2308, 2879) < 400 Then ;Red
            Out("I am red in Shing Jea Arena")
            $CURRENT_MAP = $Shing_Jea_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Petrified Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 1909, 946) < 400 Then ;Blue
            Out("I am blue in Petrified Arena")
            $CURRENT_MAP = $Petrified_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 7188, -3999) < 400 Then ;Red
            Out("I am red in Petrified Arena")
            $CURRENT_MAP = $Petrified_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Sunspear Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 436, 2517) < 400 Then ;Blue
            Out("I am blue in Sunspear Arena")
            $CURRENT_MAP = $Sunspear_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3865, -2254) < 400 Then ;Red
            Out("I am red in Sunspear Arena")
            $CURRENT_MAP = $Sunspear_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Churranu Island Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4063, -101) < 400 Then ;Blue
            Out("I am blue in Churranu Island Arena")
            $CURRENT_MAP = $Churranu_Island_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -886, -478) < 400 Then ;Red
            Out("I am red in Churranu Island Arena")
            $CURRENT_MAP = $Churranu_Island_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Heroes Crypt---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -3341, -5154) < 400 Then ;Blue
            Out("I am blue in Heroes Crypt")
            $CURRENT_MAP = $Heroes_Crypt
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3186, -5171) < 400 Then ;Red
            Out("I am red in Heroes Crypt")
            $CURRENT_MAP = $Heroes_Crypt
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Brawlers Pit---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 1093, 5074) < 400 Then ;Blue
            Out("I am blue in Brawlers Pit")
            $CURRENT_MAP = $Brawlers_Pit
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4965, 5070) < 400 Then ;Red
            Out("I am red in Brawlers Pit")
            $CURRENT_MAP = $Brawlers_Pit
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf

    ;~ 		---------Seabed Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 9852, 4274) < 400 Then ;Blue
            Out("I am blue in Seabed Arena")
            $CURRENT_MAP = $Seabed_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4399, 6730) < 400 Then ;Red
            Out("I am red in Seabed Arena")
            $CURRENT_MAP = $Seabed_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf


    ;      ---------Deldrimor Arena---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -9219, 2700) < 400 Then ;Blue
            Out("I am blue in Deldrimor Arena")
            $CURRENT_MAP = $Deldrimor_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -8969, 7426) < 400 Then ;Red
            Out("I am red in Deldrimor Arena")
            $CURRENT_MAP = $Deldrimor_Arena
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf


    ;~ 		---------The Crag---------
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 6559, 4454) < 400 Then ;Blue
            Out("I am blue in The Crag")
            $CURRENT_MAP = $The_Crag
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
        If ComputeDistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -2271, -2317) < 400 Then ;Red
            Out("I am red in The Crag")
            $CURRENT_MAP = $The_Crag
            $WON = GetCodexTitle()
            $DefineMap = False
        EndIf
    EndIf
 EndFunc ;DefineMap

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

Func CheckIsTeamWiped()
    Local $TeamMembersAlive = 0
    Local $lAgentArray = GetParty()
    For $i = 1 To $lAgentArray[0]
        $lAgent = $lAgentArray[$i]
        If DllStructGetData($lAgent, 'Allegiance') = 1 Then
            If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop ; summoned
            If GetIsDead($lAgent) = False Then ; if not dead
                $TeamMembersAlive += 1
            EndIf
        EndIf
    Next
    If $TeamMembersAlive > 1 Then
        Return False
    Else
        Out("Party is dead, Return.")
        RndSleep(15000)
    EndIf
EndFunc ;CheckIsTeamWiped

Func ZaishenQuest()
    Local $Zaishen = GUICtrlRead($QuestIDInput)
    If GetMapLoading() == $INSTANCETYPE_OUTPOST And GUICtrlRead($EnableZQuest) = 1 Then
        If GUICtrlRead($QuestIDInput) == "" Then
            MsgBox(1,"Error", "Type Quest ID")
            Return
        EndIf
        If DllStructGetData(GetQuestByID($Zaishen), 'ID') == 0 Or DllStructGetData(GetQuestByID($Zaishen), 'LogState') == 0x3 Then
            $GWA_CONST_GREATTEMPLEOFBALTHAZAR = 248
            If $Zaishen Then
                If GetMapID() <> $GWA_CONST_GREATTEMPLEOFBALTHAZAR Then
                    TravelTo($GWA_CONST_GREATTEMPLEOFBALTHAZAR)
                    RndSleep(1000)
                EndIf
                If DllStructGetData(GetQuestByID($Zaishen), 'ID') == 0 Then
                    Local $lBounty = GetNearestNPCToCoords(-5053, -5391)
                Else
                    Local $lBounty = GetNearestNPCToCoords(-5019, -5496)
                EndIf
                MoveTo(-5900, -5560, 125)
                MoveTo(-5175, -5473)
                GoNPC($lBounty)
                Do
                    RndSleep(200)
                    $lMe = GetAgentByID(-2)
                Until GetDistance($lMe, $lBounty) < 400
                RndSleep(5000)
                If DllStructGetData(GetQuestByID($Zaishen), 'ID') == 0 Then
                    $npc = GetNearestNPCToCoords(-5033, -5391)
                    GoToNPC($npc)
                    AcceptQuest($Zaishen)
                    RndSleep(5000)
                    TravelTo($CODEX_ARENA)
                    RndSleep(5000)
                ElseIf DllStructGetData(GetQuestByID($Zaishen), 'LogState') == 0x3 Then
                    QuestReward($Zaishen)
                    RndSleep(5000)
                    TravelTo($CODEX_ARENA)
                    RndSleep(5000)
                    Return ZaishenQuest()
                EndIf
            EndIf
        EndIf
    EndIf
EndFunc ;ZaishenQuest

Func VerifyConnection()
    If GetMapLoading() == 2 Then Disconnected()
EndFunc ;VerifyConneciton

Func Disconnected()
    Out("Disconnected!")
    Out("Attempting to reconnect.")
    ControlSend(GETWINDOWHANDLE(), "", "", "{Enter}")
    Local $LCHECK = False
    Local $LDEADLOCK = TimerInit()
    Do
        RndSleep(20)
        $LCHECK = GETMAPLOADING() <> 2 And GETAGENTEXISTS(-2)
    Until $LCHECK Or TimerDiff($LDEADLOCK) > 60000
    If $LCHECK = False Then
        Out("Failed to Reconnect!")
        Out("Retrying.")
        ControlSend(GETWINDOWHANDLE(), "", "", "{Enter}")
        $LDEADLOCK = TimerInit()
        Do
            RndSleep(20)
            $LCHECK = GETMAPLOADING() <> 2 And GETAGENTEXISTS(-2)
        Until $LCHECK Or TimerDiff($LDEADLOCK) > 60000
        If $LCHECK = False Then
            Out("Could not reconnect!")
            Out("Exiting.")
        EndIf
    EndIf
    Out("Reconnected!")
    RndSleep(5000)
EndFunc ;Disconnected
#EndRegion General


#Region ZKey
Func TradeKey()
    Out("❃❃ Trading Selected ❃❃")
    TravelTo($CODEX_ARENA)
    Out("Going To Trader")
    Key()
    Key()
    Key()
    Key()
    Key()
EndFunc ;TradeKey

Func Key()
    $ZKey = getnearestnpctocoords(1119,2502)
    GoToNPC($ZKey)
    Out("Trading ZKey")
    Dialog(0x87)
    RndSleep(300)
    Dialog(0x88)
    RndSleep(300)
    Dialog(0x87)
    RndSleep(300)
    Dialog(0x88)
    RndSleep(300)
EndFunc ;Key
#EndRegion ZKey
