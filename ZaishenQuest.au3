
Func CheckQuest()
	If GUICtrlRead($EnableZQuest) <> 1 Then Return
	If GUICtrlRead($QuestIDInput) == "" Then
		MsgBox(1,"Error", "Type Quest ID")
		Return False
	EndIf
	$ZQUEST_ENABLED = True
	$ZQUEST_ID = GUICtrlRead($QuestIDInput)
	Return True
EndFunc

Func ZaishenQuest()
	Local $quest = GetQuestByID($ZQUEST_ID)
	If $quest <> 0 And DllStructGetData($quest, 'MapTo') <> $GREAT_TEMPLE_OF_BALTHAZAR Then 
		Out("Noquest")
		Return ;dont take the quest if we have it
	EndIf

	Out("Zaishen Quest")
	If GetMapID() <> $GREAT_TEMPLE_OF_BALTHAZAR Then TravelTo($GREAT_TEMPLE_OF_BALTHAZAR)
	Local $npc = DllStructGetData($quest, 'ID') == 0 ? GetNearestNPCToCoords(-5053, -5391) : GetNearestNPCToCoords(-5019, -5496)
	GoToNPC($npc)
	RndSleep(1000)

	If DllStructGetData($quest, 'ID') == 0 Then
		Out("Getting Quest")
		AcceptQuest($ZQUEST_ID)
	ElseIf DllStructGetData($quest, 'MapTo') == $GREAT_TEMPLE_OF_BALTHAZAR Then
		Out("Getting Reward")
		QuestReward($ZQUEST_ID)
		Return ZaishenQuest()
	EndIf
	RndSleep(1000)
	TravelTo($CODEX_ARENA)
EndFunc ;ZaishenQuest

#Region ZKey
Func TradeKey()
	If GetMapId() <> $CODEX_ARENA Then TravelTo($CODEX_ARENA)
	Out("Going To Tolkano")
	GoToNPC(GetNearestNPCToCoords(1119,2502))
	While GetBalthazarFaction() > 5000
		Key()
	WEnd
EndFunc ;TradeKey

Func Key()
	Out("Trading ZKey")
	Dialog(0x87)
	RndSleep(300)
	Dialog(0x88)
	RndSleep(300)
EndFunc ;Key
#EndRegion ZKey
