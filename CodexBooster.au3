#Region About
;~  __________________________________________________________________
;~ #                                                                  #
;~ #              What's need?                                        #
;~ #   ❃ Suicide bot                                                  #
;~ #      70hp                                                        #
;~ #      vampiric wep ( not dual )                                   #
;~ #   ❃ Main Bot                                                     #
;~ #      Your Account                                                #
;~ #___Credit To Rusco95 / Koala95_Updated By $tRecky At Tequatel_____#

#EndRegion About

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



#Region (Global General)
;--------- general global ---------
; ---------------------
Global $Iam = 0
Global $Iamblue = 1
Global $Iamred = 2
;---------------------
Global  $CA = 796
Global  $CAMapid
Global  $The_Crag = 14
Global  $Deldrimor_Arena = 13
Global	$Seabed_Arena = 12
Global	$Brawlers_Pit = 11
Global	$Heroes_Crypt = 10
Global	$Churranu_Island_Arena = 9
Global	$Sunspear_Arena = 8
Global	$Petrified_Arena = 7
Global	$Shing_Jea_Arena = 6
Global	$Shiverpeak_Arena = 5
Global	$Amnoon_Arena = 4
Global	$Fort_Koga = 3
Global	$DAlessio_Arena = 2
Global	$Ascalon_Arena = 1
; ---------------------
Global $IamwonUW
Global $Iamwonfetid
Global $IamwonBurialMounds
Global $IamwonUnholyTemples
Global $IamwonForgottenShrines
Global $IamwonGoldenGates
Global $IamwonCourtyard
; ---------------------
Global $won
Global $firstrun = True
Global $updated = 1
Global $nbFails = 0
Global $nbRuns = 0
Global $bRunning = False
Global $bInitialized = False
Global $bCanContinue = True
Global $render = True
Global $GWPID = -1
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
#EndRegion



#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

Global $Runs = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $HWND
#EndRegion Declarations

#Region GUI
$Gui = GUICreate("Codex Tool", 299, 204, -1, -1)
$CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, GetLoggedCharNames())
$StartButton = GUICtrlCreateButton("Start", 5, 40, 105, 23)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
$gStats = GUICtrlCreateGroup("❃ Select Bot ❃", 120, 6, 170, 70) ; Statistic
$Leecher= GUICtrlCreateCheckbox("Suicide Bot", 130, 25)
$Farmer = GUICtrlCreateCheckbox("Main Bot", 130, 45)
$Zkey = GUICtrlCreateCheckbox("Z-Key", 220, 25)
$StatusLabel = GUICtrlCreateEdit("", 10, 80, 280, 80, 2097220)
$RenderingBox = GUICtrlCreateCheckbox("Render", 220, 45, 103, 17)
$eneblezquest = GUICtrlCreateCheckbox("Enable Zaishen Quest", 8, 165, 140, 20)
GUICtrlCreateLabel("Quest ID:", 150, 167, 50, 20)
$questidinput = GUICtrlCreateInput("", 205, 165, 50, 20)
   GUICtrlSetOnEvent(-1, "ToggleRendering")
   GUICtrlSetState($RenderingBox, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)
#EndRegion GUI

#Region Loops
logFile("Ready.")
While Not $BotRunning
   Sleep(500)
WEnd

;~ AdlibRegister("TimeUpdater", 1000)
While 1
   If Not $BotRunning Then
;~ 	  AdlibUnRegister("TimeUpdater")
	  logFile("Bot is paused.")
	  GUICtrlSetState($StartButton, $GUI_ENABLE)
	  GUICtrlSetData($StartButton, "Start")
	  GUICtrlSetOnEvent($StartButton, "GuiButtonHandler")
	  While Not $BotRunning
		 Sleep(500)
	  WEnd
;~ 	  AdlibRegister("TimeUpdater", 1000)
   EndIf
   DoJob()
WEnd
#EndRegion Loops

#Region Functions
Func GuiButtonHandler()
   If $BotRunning Then
	  logFile("Will pause after this run.")
	  GUICtrlSetData($StartButton, "Force Pause")
	  GUICtrlSetOnEvent($StartButton, "Resign")
	  ;GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($StartButton, "Pause")
	  $BotRunning = True
   Else
	  logFile("Initializing...")
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
	  $HWND = GetWindowHandle()
	  GUICtrlSetState($RenderingBox, $GUI_ENABLE)
	  GUICtrlSetState($CharInput, $GUI_DISABLE)
	  Local $charname = GetCharname()
	  GUICtrlSetData($CharInput, $charname, $charname)
	  GUICtrlSetData($StartButton, "Pause")
	  WinSetTitle($Gui, "", "Codex Tool - " & $charname)
	  $BotRunning = True
	  $BotInitialized = True
	  SetMaxMemory()
   EndIf
EndFunc

#EndRegion

Func DoJob()
	If GUICtrlRead($Leecher) = $GUI_CHECKED Then
		LeecherRole()
	    Return
	 EndIf
    If GUICtrlRead($Farmer) = $GUI_CHECKED Then
		FarmerRole()
	    Return
	 EndIf
	 If GUICtrlRead($Zkey) = $GUI_CHECKED Then
		Tradekey()
	    Return
	 EndIf
EndFunc   ;==>DoJob

#Region Z-key
Func Tradekey()
   logFile("❃❃ Trading Selected ❃❃")
   If GetMapId() <> 796 Then
		RndTravel(796)
		WaitMapLoading(796)
		AddHench2()
	 EndIf
    logFile ("Going To Trader")
	Key()
	Key()
	Key()
	Key()
	Key()


 EndFunc

 Func Key()
	$zkey = getnearestnpctocoords(1119,2502)
	gotonpc($zkey)
	sleep(100)
	logFile ("Trading Z-Key")
	Dialog(0x87)
	Sleep(300)
	Dialog(0x88)
	Sleep (300)
	Dialog(0x87)
	Sleep(300)
	Dialog(0x88)
	Sleep (300)
	EndFunc
#EndRegion

#Region Leecher
Func LeecherRole()
   logFile("❃❃ Suicide Selected ❃❃")
 If GetMapId() <> 796 Then
		RndTravel(796)
		WaitMapLoading(796)
		AddHench()
	 EndIf
 Enter()
 Farm()

EndFunc

Func AddHench()
   logFile("Adding Hench")
   AddNpc(1)
   sleep(300)
   AddNpc(2)
   sleep(300)
   AddNpc(4)
   sleep(300)
EndFunc

Func Enter()
    logFile("Entering Battle")
    EnterChallenge()
    logFile("Map Loading")
    Do
       Sleep(Random(750, 1250, 1))
    Until GetMapLoading() = 1 And GetAgentExists(-2)
EndFunc

Func Farm()
logFile("Let's Die")
Do
 Sleep(Random(750, 1250, 1))
Until GetMapLoading() = 0 And GetAgentExists(-2)
EndFunc


#EndRegion

#Region Main Farmer

Func FarmerRole()
;~    logFile("❃❃ Farmer Selected ❃❃")
	If GetMapId() <> 796 Then
		RndTravel(796)
		WaitMapLoading(796)
	EndIf
	ZaishenQuest()
	AddHench2()
	Enter()
	Farm2()
 EndFunc

Func AddHench2()
   logFile("Adding Hench")
   AddNpc(3)
   sleep(300)
   AddNpc(4)
   sleep(300)
   AddNpc(5)
   sleep(300)
EndFunc

#EndRegion


#Region (General)



Func logFile($msg)
    GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu-only, 8=eu+int, 11=all(excluding America)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	waitmaploading($aMapID)
 EndFunc   ;==>RndTravel

 Func _exit()
   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
	  Sleep(500)
   EndIf
   Exit
 EndFunc

 Func Farm2()
	logFile("Waiting Win")
	While GetMapLoading() = 1 And GetMapId() == 796
			Define_map()
			CheckIsTeamWiped()
		    $agent = GetNearestEnemyToAgent()
            $distance = getdistance($agent, -2)
			If $Won == 0 Then $Won = GetCodexTitle()
		    If $Won == GetCodexTitle() And $distance > 1300 And $distance < 8000  Then
			    If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CA Then
				    Attack($agent)
			        logFile("Looking enemy")
			        ChangeTarget($agent)
			        sleep(1000)
			    EndIf
		    EndIf
		    If $Won == GetCodexTitle() And $distance < 1500 Then
			    If GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CA Then
				    killenemy()
		        EndIf
		    EndIf
            If getnearestenemytoagent() = 0 Then
			    If $Won == GetCodexTitle() And GetMapLoading() == $INSTANCETYPE_EXPLORABLE And GetMapID() == $CA Then
					logFile("looking for enemy")
					If $Won == GetCodexTitle() And $CAMapid == $The_Crag Then
						If $Won == GetCodexTitle() And getnearestenemytoagent() = 0 Then
							MoveTo(1046, 74)
						EndIf
						If $Won == GetCodexTitle() And getnearestenemytoagent() = 0 Then
							MoveTo(3585, 2023)
						EndIf
					EndIf
					If  $Won == GetCodexTitle() And $CAMapid == $Deldrimor_Arena Then
						Moveto(-11687, 5025)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Seabed_Arena Then
						Move(7944, 6803)
					    RndSleep(2000)
					EndIf
					If  $Won == GetCodexTitle() And $CAMapid == $Brawlers_Pit Then
						Move(3035, 5173)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid ==  $Heroes_Crypt Then
						Move(-8, -5258)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Churranu_Island_Arena Then
						Move(1834, -42)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Sunspear_Arena Then
						Move(2168, 221)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Petrified_Arena Then
						Move(4529, -1069)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Shing_Jea_Arena Then
						Move(-13, 776)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Shiverpeak_Arena Then
						Move(6718, 14307)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Amnoon_Arena Then
						Move(872, 7728)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Fort_Koga Then
						Move(3158, -1101)
					    RndSleep(2000)
					EndIf
	                If $Won == GetCodexTitle() And $CAMapid == $DAlessio_Arena Then
						Move(3117, 439)
					    RndSleep(2000)
					EndIf
	                If  $Won == GetCodexTitle() And $CAMapid == $Ascalon_Arena Then
						Move(5598, -4091)
					    RndSleep(2000)
					EndIf
			    EndIf
            EndIf
		If  $Won < GetCodexTitle() Then
			logFile("im won")
			WaitMapLoading()
			Define_map()
		EndIf
	WEnd
EndFunc


 Func  Define_map()
	Local $lme = getagentbyid(-2)
	If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then


;~ 		---------Ascalon Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 8072, -2017) < 400 Then ;Blue
				logFile("I am blue in Ascalon Arena")
			    $CAMapid = $Ascalon_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4815, -6436) < 400 Then ;Red
				logFile("I am red in Ascalon Arena")
			    $CAMapid = $Ascalon_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~ 		EndIf
;~ 		---------Ascalon Arena-----------


;~ 		---------D'Alessio_Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4986, -2499) < 400 Then ;Blue
				logFile("I am blue in D'Alessio Arena")
			    $CAMapid = $DAlessio_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4735, 3830) < 400 Then ;Red
				logFile("I am red in D'Alessio Arena")
			    $CAMapid = $DAlessio_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------D'Alessio_Arena---------


;~ 		---------Fort Koga---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 6240, 255) < 400 Then ;Blue
				logFile("I am blue in Fort Koga")
			    $CAMapid = $Fort_Koga
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 179, -3365) < 400 Then ;Red
				logFile("I am red in Fort Koga")
			    $CAMapid = $Fort_Koga
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Fort Koga---------


;~ 		---------Amnoon Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3131, 10093) < 400 Then ;Blue
				logFile("I am blue in Amnoon Arena")
			    $CAMapid = $Amnoon_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -1892, 5201) < 400 Then ;Red
				logFile("I am red in Amnoon Arena")
			    $CAMapid = $Amnoon_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Amnoon Arena---------


;~ 		---------Shiverpeak Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 9210, 12369) < 400 Then ;Blue
				logFile("I am blue in Shiverpeak Arena")
			    $CAMapid = $Shiverpeak_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4379, 16264) < 400 Then ;Red
				logFile("I am red in Shiverpeak Arena")
			    $CAMapid = $Shiverpeak_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Shiverpeak Arena---------


;~ 		---------Shing Jea Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -2375, -1583) < 400 Then ;Blue
				logFile("I am blue in Shing Jea Arena")
			    $CAMapid = $Shing_Jea_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 2308, 2879) < 400 Then ;Red
				logFile("I am red in Shing Jea Arena")
			    $CAMapid = $Shing_Jea_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Shing Jea Arena---------


;~ 		---------Petrified Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 1909, 946) < 400 Then ;Blue
				logFile("I am blue in Petrified Arena")
			    $CAMapid = $Petrified_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 7188, -3999) < 400 Then ;Red
				logFile("I am red in Petrified Arena")
			    $CAMapid = $Petrified_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Petrified Arena---------


;~ 		---------Sunspear Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 436, 2517) < 400 Then ;Blue
				logFile("I am blue in Sunspear Arena")
			    $CAMapid = $Sunspear_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3865, -2254) < 400 Then ;Red
				logFile("I am red in Sunspear Arena")
			    $CAMapid = $Sunspear_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Sunspear Arena---------


;~ 		---------Churranu Island Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4063, -101) < 400 Then ;Blue
				logFile("I am blue in Churranu Island Arena")
			    $CAMapid = $Churranu_Island_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -886, -478) < 400 Then ;Red
				logFile("I am red in Churranu Island Arena")
			    $CAMapid = $Churranu_Island_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Churranu Island Arena---------


;~ 		---------Heroes Crypt---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -3341, -5154) < 400 Then ;Blue
				logFile("I am blue in Heroes Crypt")
			    $CAMapid = $Heroes_Crypt
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 3186, -5171) < 400 Then ;Red
				logFile("I am red in Heroes Crypt")
			    $CAMapid = $Heroes_Crypt
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Heroes Crypt---------


;~ 		---------Brawlers Pit---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 1093, 5074) < 400 Then ;Blue
				logFile("I am blue in Brawlers Pit")
			    $CAMapid = $Brawlers_Pit
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4965, 5070) < 400 Then ;Red
				logFile("I am red in Brawlers Pit")
			    $CAMapid = $Brawlers_Pit
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Brawlers Pit---------


;~ 		---------Seabed Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 9852, 4274) < 400 Then ;Blue
				logFile("I am blue in Seabed Arena")
			    $CAMapid = $Seabed_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 4399, 6730) < 400 Then ;Red
				logFile("I am red in Seabed Arena")
			    $CAMapid = $Seabed_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Seabed Arena---------


;      ---------Deldrimor Arena---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -9219, 2700) < 400 Then ;Blue
				logFile("I am blue in Deldrimor Arena")
			    $CAMapid = $Deldrimor_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -8969, 7426) < 400 Then ;Red
				logFile("I am red in Deldrimor Arena")
			    $CAMapid = $Deldrimor_Arena
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------Deldrimor Arena---------


;~ 		---------The Crag---------
;~         If $Define_map Then
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), 6559, 4454) < 400 Then ;Blue
				logFile("I am blue in The Crag")
			    $CAMapid = $The_Crag
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
		    If computedistance(DllStructGetData($lme, "X"), DllStructGetData($lme, "Y"), -2271, -2317) < 400 Then ;Red
				logFile("I am red in The Crag")
			    $CAMapid = $The_Crag
				$Won = GetCodexTitle()
				$Define_map = False
		    EndIf
;~         EndIf
;~ 		---------The Crag---------
    EndIf
 EndFunc ;==>Define_map

 Func killenemy()
	If getdistance(GetNearestEnemyToAgent(), -2) < 1250 Then
		For $i = 1 to 7
			If GetIsDead(GetMyID()) Then ExitLoop
			If GetMapLoading() == 0 Then ExitLoop
			$agent = GetNearestEnemyToAgent()
			logFile("Kill Enemes")
			Attack($agent)
			Sleep(300)
			skilluserange($i, $agent)
			Sleep(300)
			ChangeTarget($agent)
		Next
	EndIf
EndFunc


Func skilluserange($skillnumber, $agent)
	$distance = getdistance($agent, -2)
	If $distance < 1250 Then
		While True
			useskill($skillnumber, -1)
			Sleep(1500)
			ExitLoop
		WEnd
	EndIf
EndFunc


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
		logFile("Party is dead, Return.")
		Sleep(15000)
	EndIf
EndFunc   ;==>CheckTeamWiped

Func ZaishenQuest()
	Local $Zaishen = GUICtrlRead($questidinput)
	If GetMapLoading() == $INSTANCETYPE_OUTPOST And GUICtrlRead($eneblezquest) = 1 Then
		If GUICtrlRead($questidinput) == "" Then
			MsgBox(1,"Error", "Type Quest ID")
			Return
		EndIf
		If DllStructGetData(GetQuestByID($Zaishen), 'ID') == 0 Or DllStructGetData(GetQuestByID($Zaishen), 'LogState') == 0x3 Then
			$GWA_CONST_GREATTEMPLEOFBALTHAZAR = 248
			If $Zaishen Then
				If GetMapID() <> $GWA_CONST_GREATTEMPLEOFBALTHAZAR Then
					TravelTo($GWA_CONST_GREATTEMPLEOFBALTHAZAR)
					Sleep(Random(750, 1250, 1))
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
					Sleep(Random(50, 200, 1))
					$lMe = GetAgentByID(-2)
				Until GetDistance($lMe, $lBounty) < 400
				Sleep(Random(4500, 5500, 1))
				If DllStructGetData(GetQuestByID($Zaishen), 'ID') == 0 Then
					$npc = GetNearestNPCToCoords(-5033, -5391)
					GoToNPC($npc)
					AcceptQuest($Zaishen)
					Sleep(Random(4500, 5500, 1))
					TravelTo($CA)
					Sleep(Random(4500, 5500, 1))
				ElseIf DllStructGetData(GetQuestByID($Zaishen), 'LogState') == 0x3 Then
					QuestReward($Zaishen)
					Sleep(Random(4500, 5500, 1))
					TravelTo($CA)
					Sleep(Random(4500, 5500, 1))
					Return ZaishenQuest()
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc
 #EndRegion