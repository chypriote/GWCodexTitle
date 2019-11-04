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
#include "ZaishenQuest.au3"
#include "Map.au3"
#include "Farmer.au3"
#include "Leecher.au3"
#NoTrayIcon

#Region Constants
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
Global $ZQUEST_ENABLED = False
Global $GREAT_TEMPLE_OF_BALTHAZAR = 248
Global $ZQUEST_ID = 0
#EndRegion Declarations

#Region GUI
Func GUI()
	Global $GUI = GUICreate("Codex Tool", 299, 204, -1, -1)
	Global $CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	   GUICtrlSetData(-1, GetLoggedCharNames())
	Global $StartButton = GUICtrlCreateButton("Start", 5, 40, 105, 23)
       GUICtrlSetOnEvent(-1, "_start")
       
    GUICtrlCreateGroup("Configure Bot", 120, 6, 170, 70)
	GUIStartGroup()
    Global $Leecher = GUICtrlCreateRadio("Suicide Bot", 130, 25)
    Global $Farmer = GUICtrlCreateRadio("Main Bot", 130, 45)
	    GUICtrlSetState($Farmer, $GUI_CHECKED)
    
	Global $ZKey = GUICtrlCreateCheckbox("ZKey", 220, 25)
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

#Region Loop
GUI()
While Not $BOT_RUNNING
   RndSleep(500)
WEnd

While 1
    If Not $BOT_RUNNING Then
        If Not $FIRST_RUN Then Out("Bot is paused.")
        GUICtrlSetState($StartButton, $GUI_ENABLE)
        GUICtrlSetData($StartButton, "Start")
        GUICtrlSetOnEvent($StartButton, "_start")
        AdlibUnRegister("VerifyConnection")
        $FIRST_RUN = True
        RndSleep(1000)
        ContinueLoop
    EndIf

    If $FIRST_RUN Then
        AdlibRegister("VerifyConnection", 5000)
        $FIRST_RUN = False
        If CheckQuest() Then ZaishenQuest()
    EndIf

    If GUICtrlRead($Leecher) == $GUI_CHECKED Then Leecher()
    If GUICtrlRead($Farmer) == $GUI_CHECKED Then Farmer()
    If GUICtrlRead($ZKey) == $GUI_CHECKED And GetBalthazarFaction() >= 10000 Then TradeKey()
WEnd
#EndRegion Loop

#Region GUI
Func LoadGame()
    Local $CharName = GUICtrlRead($CharInput)
    If $CharName == "" Then
       If Initialize(ProcessExists("gw.exe"), True, True) = False Then
             MsgBox(0, "Error", "Guild Wars is not running.")
             Exit
       EndIf
    Else
       If Initialize($CharName, True, True) = False Then
             MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '" & $CharName & "'")
             Exit
       EndIf
    EndIf
    Return GetWindowHandle()
EndFunc ;LoadGame
Func _start()
    If $BOT_INITIALIZED Then
        GUICtrlSetData($StartButton, "Pause")
        GUICtrlSetOnEvent($StartButton, "_pause")
        $BOT_RUNNING = True
        Return
    EndIf

    Out("Initializing...")
    $HWND = LoadGame()
    GUICtrlSetState($RenderingBox, $GUI_ENABLE)
    GUICtrlSetState($CharInput, $GUI_DISABLE)
    GUICtrlSetState($Leecher, $GUI_DISABLE)
    GUICtrlSetState($Farmer, $GUI_DISABLE)
    GUICtrlSetState($ZKey, $GUI_DISABLE)
    GUICtrlSetState($EnableZQuest, $GUI_DISABLE)
    GUICtrlSetState($QuestIDInput, $GUI_DISABLE)

    WinSetTitle($GUI, "", GetCharName() & " - Codex Tool")
    GUICtrlSetData($StartButton, "Pause")
    GUICtrlSetOnEvent($StartButton, "_pause")

    $BOT_RUNNING = True
    $BOT_INITIALIZED = True
    Out("Current points: " & GetCodexTitle())
    $STARTING_POINTS = GetCodexTitle()
    SetMaxMemory()
EndFunc ;_start
Func _pause()
    Out("Will pause after this run.")
    $BOT_RUNNING = False
    GUICtrlSetData($StartButton, "Force pause")
    GUICtrlSetOnEvent($StartButton, "_resign")
EndFunc ;_pause
Func _resign()
    Resign()
    RndSleep(8000)
    TravelTo($CODEX_ARENA)
    GUICtrlSetData($StartButton, "Start")
    GUICtrlSetOnEvent($StartButton, "_start")
EndFunc ;_resign
Func _exit()
	If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
		EnableRendering()
		WinSetState($HWND, "", @SW_SHOW)
		RndSleep(500)
	EndIf
	Exit
EndFunc ;_exit
#EndRegion ;GUI

#Region General
Func AddHench($withHealer = True)
	$withHealer ? AddNpc(3) : AddNpc(1)
	RndSleep(500)
	AddNpc(6)
	RndSleep(500)
	AddNpc(5)
	RndSleep(500)
EndFunc
Func Enter()
	Out("Entering Battle")
	EnterChallenge()
	Out("Map Loading")
	Do
		RndSleep(1250)
	Until GetMapLoading() = 1 And GetAgentExists(-2)
EndFunc ;Enter

Func Out($msg)
	GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
	_GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
	_GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc ;Out

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
