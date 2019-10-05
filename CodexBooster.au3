;#include <ButtonConstants.au3>
#include <GWA2.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
;#include <StaticConstants.au3>
;#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
;#include <Misc.au3>
;#include <EditConstants.au3>
#include <GuiEdit.au3>
#include "GWA2_Headers.au3"
#include "Map.au3"
#NoTrayIcon

;TODO: disable start if main/leecher not selected
; turn main/leecher to radio
; disable zkey/zquest for leecher

#Region Constants
Global $CODEX_ARENA = 796
Global $CURRENT_MAP
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

Func Suicide()
	Out("Let's Die")
	Do
		RndSleep(1250)
	Until GetMapLoading() = 0 And GetAgentExists(-2)
EndFunc ;Suicide
#EndRegion Leecher

#Region Main
Func FarmerRole()
	Out("Current points: " & GetCodexTitle())
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
	While GetMapLoading() == 1 And GetMapId() == $CODEX_ARENA
		DefineMap()
		CheckIsTeamWiped()
		$agent = GetNearestEnemyToAgent()
		$distance = GetDistance($agent, -2)
		If $WON == 0 Then $WON = GetCodexTitle()
		Do
			If $distance > 1300 And $distance < 8000  Then
				If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
					Attack($agent)
					Out("Looking enemy")
					ChangeTarget($agent)
					RndSleep(1000)
				EndIf
			EndIf
			If $distance < 1500 Then
				If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
					KillEnemy()
				EndIf
			EndIf
			If GetNearestEnemyToAgent() = 0 Then
				If $WON == GetCodexTitle() And GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CODEX_ARENA Then
					Out("looking for enemy")
					GotoCenter()
				EndIf
			EndIf

		Until $WON < GetCodexTitle()

		Out("Victory")
		WaitMapLoading()
		DefineMap()
		Out("Total points earned: " & GetCodexTitle() - $STARTING_POINTS)
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