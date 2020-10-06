#RequireAdmin
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <Inet.au3>
#include <ColorConstants.au3>

HotKeySet("^q", "_Exit")
Func _Exit()
  If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
   EndIf
  If ProcessExists("SSH.check.exe") Then
		 ProcessClose("SSH.check.exe")
	  EndIf
	  If ProcessExists("QuickPHP.exe") Then
		 ProcessClose("QuickPHP.exe")
   EndIf
    Exit
 EndFunc
 if Not FileExists(@ScriptDir & "\SSH.check.exe") Then
	MsgBox(48,"ERROR","Thiếu File \SSH.check.exe")
	Exit
 EndIf
 If Not FileExists(@ScriptDir & "\BvSsh\cleartray.exe") Then
	MsgBox(48,"ERROR", "Thiếu file \BvSsh\cleartray.exe" & @CRLF & "File có tác dụng clear tray icon")
	Exit
EndIf
$MainGUI = GUICreate("SSHChanger by dinhtai92dn", 320, 260)
GUICtrlCreateLabel("Ctrl + Q = Exit All",220,10,90,20)
$HTabMain = GUICtrlCreateTab(5, 15, 310, 205)
$hTab1 = GUICtrlCreateTabItem("SSH LIST")
GUICtrlSetState(-1, $GUI_SHOW)
$LoadFileButton = GUICtrlCreateButton("Open", 15, 45, 60, 23)
$FileLoadedInput = GUICtrlCreateInput("", 80, 45, 220, 23)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("Welcome to SSHChanger", 7, 90, 303, 125)
$ButtonCHANGE = GUICtrlCreateButton("CHANGE", 10, 110, 60, 27, 0)
$ButtonSAVESSH = GUICtrlCreateButton("SAVE SSH UNUSED", 75, 110, 110, 27, 0)
GUICtrlCreateLabel("Status:",190,114, 75, 27,$SS_CENTER)
GUICtrlSetFont(-1, 14)
$StatusConnect = GUICtrlCreateButton("status", 270, 110, 32, 32, $BS_ICON)
GUICtrlSetTip ( $StatusConnect, "SSH connect status", "Tip" ,1)
GUICtrlSetImage($StatusConnect, @ScriptDir & "\BvSsh\sshdie.ico")
$SSHtotal = GUICtrlCreateInput("Total: ",10,147,105,27)
GUICtrlSetFont(-1, 10)
GUICtrlSetState(-1, $GUI_DISABLE)
$SSHlive = GUICtrlCreateInput("Live: ",120,147,90,27)
GUICtrlSetFont(-1, 10)
GUICtrlSetState(-1, $GUI_DISABLE)
$SSHdie = GUICtrlCreateInput("Die&BL: ",215,147,90,27)
GUICtrlSetFont(-1, 10)
GUICtrlSetState(-1, $GUI_DISABLE)
$Bar = GUICtrlCreateProgress(10,180,295,7)
GUICtrlSetColor($bar,0x3399FF)
$SSHcurrent = GUICtrlCreateLabel("Current SSH: ",10,193,300,15)
GUICtrlSetFont(-1, 10)
$hTab2 = GUICtrlCreateTabItem("SETTING")
$Random = GUICtrlCreateCheckbox("Random SSH", 15, 45, 280, 20)
GUICtrlSetFont(-1, 12)
$Autochange = GUICtrlCreateCheckbox("Auto change if SSH die (24/24)", 15, 70, 280, 20)
GUICtrlSetFont(-1, 12)
$Blacklist = GUICtrlCreateCheckbox("Check ip Blacklist", 15, 95, 280, 20)
GUICtrlSetFont(-1, 12)
GUICtrlCreateLabel("Time out (s):", 15, 120, 100, 20)
GUICtrlSetFont(-1, 12)
$Timeout = GUICtrlCreateInput("7",120,120,30,22, $ES_NUMBER)
GUICtrlSetLimit(-1,2)
GUICtrlSetFont(-1, 11)
$Autosavessh = GUICtrlCreateCheckbox("Auto save ssh unused", 15, 145, 280, 20)
GUICtrlSetFont(-1, 12)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("Country:", 15, 172, 60, 20)
GUICtrlSetFont(-1, 12)
$Country = GUICtrlCreateCombo("None", 80, 170, 215, 20)
GUICtrlSetFont(-1, 11)
GUICtrlSetData($Country, "Australia (AU)|Bahrain (BH)|Belgium (BE)|Brazil (BR)|Bulgaria (BG)|Chile (CL)|China (CN)|Denmark (DK)|Estonia (EE)|Fiji (FJ)|Finland (FI)|France (FR)|Germany (DE)|Ghana (GH)|Greece (GR)|Greenland (GL)|Hong Kong (HK)|Hungary (HU)|Iceland (IS)|India (IN)|Indonesia (ID)|Iran, Islamic Republic of (IR)|Iraq (IQ)|Ireland (IE)|Italy (IT)|Japan (JP)|Korea, Democratic People's Republic of (KP)|Korea, Republic of (KR)|Kuwait (KW)|Luxembourg (LU)|Malaysia (MY)|Mexico (MX)|Netherlands (NL)|New Zealand (NZ)|Norway (NO)|Oman (OM)|Paraguay (PY)|Peru (PE)|Philippines (PH)|Poland (PL)|Portugal (PT)|Qatar (QA)|Russian Federation (RU)|Saudi Arabia (SA)|Singapore (SG)|Slovakia (SK)|South Africa (ZA)|Spain (ES)|Sri Lanka (LK)|Sweden (SE)|Switzerland (CH)|Taiwan, Province of China (TW)|Thailand (TH)|Turkey (TR)|Ukraine (UA)|United Arab Emirates (AE)|United Kingdom (GB)|United States (US)|United States Minor Outlying Islands (UM)|Uruguay (UY)|Venezuela (VE)|Viet Nam (VN)|US Virgin Islands (VI)", "None")
GUICtrlCreateLabel("(Select the combobox or input: (US), (AU), (GB) ....)", 15, 198, 280, 20)
GUICtrlCreateTabItem("")
$mmo4me = GUICtrlCreateLabel("Topic mmo4me.com", 5, 240, 125, 20)
GUICtrlSetFont(-1, 11, 100, 4)
GUICtrlSetColor($mmo4me, $COLOR_BLUE)
$Proxifier = GUICtrlCreateButton("On/Off", 270, 225, 32, 32, $BS_ICON)
GUICtrlSetTip ( $Proxifier, "On/Off Proxifier", "Tip" ,1)
If ProcessExists("Proxifier.exe") Then
GUICtrlSetImage($Proxifier, @ScriptDir & "\BvSsh\ProxifierOn.ico")
Else
   GUICtrlSetImage($Proxifier, @ScriptDir & "\BvSsh\ProxifierOff.ico")
EndIf
GUISetState(@SW_SHOW)
Global $SSHARRAY,$iSSHtotal, $iSSHlive = 0, $iSSHdie = 0, $iRandom = 0, $iSSHused = 0, $iAutochange = 0, $iBlacklist = 0, $iAutosavessh = 1
Global $SSHunused_dir = @ScriptDir & "\SSHunused.txt"
While 1
   $nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
	   If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
	  EndIf
	  If ProcessExists("SSH.check.exe") Then
		 ProcessClose("SSH.check.exe")
	  EndIf
	   If ProcessExists("QuickPHP.exe") Then
		 ProcessClose("QuickPHP.exe")
   EndIf
			Exit
		 Case $LoadFileButton
			$Address = FileOpenDialog("Open SSH list", @WorkingDir, "Text (*.txt)")
			If @error <> 1 Then
			GUICtrlSetData($FileLoadedInput, $Address)
			_FileReadToArray($Address,$SSHARRAY, 0, "|")
			$iSSHtotal = UBound($SSHARRAY)
			For $i = 0 To $iSSHtotal - 1
   $format_country = StringRegExp($SSHARRAY[$i][3], "\((.*)\)", 3)
		 If Not @error Then
			$SSHARRAY[$i][3] = $format_country[0]
		 EndIf
   Next
			GUICtrlSetData($SSHtotal,"Total: " & $iSSHtotal)
		 EndIf
		 Case $Random
			$iRandom = _IsChecked($MainGUI, $Random)
		 Case $Blacklist
			$iBlacklist = _IsChecked($MainGUI, $Blacklist)
		 Case $Autochange
			$iAutochange = _IsChecked($MainGUI, $Autochange)
			Case $Autosavessh
			$iAutosavessh = _IsChecked($MainGUI, $Autosavessh)
		 Case $mmo4me
			ShellExecute("https://mmo4me.com/threads/share-tool-change-ssh-ma-nguo-n-by-autoit.292383/")
			Case $Proxifier
			If ProcessExists("Proxifier.exe") Then
			   ProcessClose("Proxifier.exe")
GUICtrlSetImage($Proxifier, @ScriptDir & "\BvSsh\ProxifierOff.ico")
Else
   Run(@ProgramFilesDir&"\Proxifier\Proxifier.exe")
   GUICtrlSetImage($Proxifier, @ScriptDir & "\BvSsh\ProxifierOn.ico")
EndIf
		 Case $ButtonCHANGE

			If $iAutochange = 1 And ProcessExists("SSH.check.exe") = 0 Then Run(@ScriptDir & "\SSH.check.exe")
			If $iBlacklist = 1 Then
			   If ProcessExists("QuickPHP.exe") Then
				  ProcessClose("QuickPHP.exe")
				  EndIf
			   Run('"' & @ScriptDir & '\BvSsh\Blacklist\QuickPHP.exe" /Bind="127.0.0.1" /Port=6699 /Root="'& @ScriptDir & '\BvSsh\Blacklist\" /Start',"",@SW_HIDE)
			   EndIf
		 If IsArray($SSHARRAY) Then
			If UBound($SSHARRAY) = 0 Then
			   MsgBox(0,"ERROR","Out of SSH !!!")
			Else
			   GUICtrlSetState($ButtonCHANGE, $GUI_DISABLE)
		 While 1
			$session_connect = _ChangeSSH()
			If $session_connect = "LIVE" Or $session_connect = "ERROR" Then
			   _ClearTrayIcon()
			   ExitLoop
			EndIf
Sleep(20)

		 WEnd
		 If $iAutosavessh = 1 Then
			If FileExists($SSHunused_dir) Then FileDelete($SSHunused_dir)
			_FileWriteFromArray($SSHunused_dir,$SSHARRAY)
			EndIf
		 GUICtrlSetState($ButtonCHANGE, $GUI_ENABLE)
		 EndIf
	     Else
		 MsgBox(0,"ERROR","Please select ssh file")
		 EndIf

	  Case $ButtonSAVESSH
			   If IsArray($SSHARRAY) Then
		$AddressSave = FileSaveDialog("Save SSH unused", @WorkingDir, "Text (*.txt)", 16)
		If @error = 0 Then
			If StringRight($AddressSave, 4) <> ".txt" Then $AddressSave &= ".txt"
		    FileDelete($AddressSave)
			_FileWriteFromArray($AddressSave,$SSHARRAY)
			EndIf
		 Else
	      MsgBox($MB_SYSTEMMODAL, "Error", "No Results")
	 EndIf
			EndSwitch
   Sleep(50)
WEnd
Func _ChangeSSH()
   Local $sshtimeout = GUICtrlRead($Timeout)
   If $sshtimeout = 0 Or $sshtimeout = "" Then
	  MsgBox(0,"ERROR","Please check TimeOut input")
	  Return "ERROR"
   EndIf

   GUICtrlSetImage($StatusConnect, @ScriptDir & "\BvSsh\sshdie.ico")
   If Not FileExists(@ScriptDir & "\BvSsh\1080.bscp") Then
	  MsgBox(0,"ERROR","Missing '\BvSsh\1080.bscp' file")
	  Exit
   EndIf
   $iSSHused += 1
   Local $PhanTram = $iSSHused/$iSSHtotal*100
   GUICtrlSetData($Bar, $PhanTram)
   Local $ssh_select, $ip, $usr, $pw, $ssh
   If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
	  EndIf
	  If GUICtrlRead($Country) = "None" Then
	  If $iRandom = 1 Then
			$ssh_select = Random(0,UBound($SSHARRAY))
		 Else
			$ssh_select = 0
		 EndIf
	  Else
		 Local $country_select_check = StringRegExp(GUICtrlRead($Country), "\((.*)\)", 3)
		 If @error Then
			MsgBox(0,"ERROR","ERROR! Please check Country input")
			Return "ERROR"
		 EndIf
		 $ssh_select = _ArraySearch($SSHARRAY, $country_select_check[0],0, 0, 0, 0, 1, 3)
		 If @error Then
			MsgBox(0,"ERROR","Out of SSH ("&$country_select_check[0]&") !!!")
			Return "ERROR"
		 EndIf
		 EndIf
			$ip = $SSHARRAY[$ssh_select][0]
			If _ValidIP($ip) <> "OK" Then Return "DIE"
			$usr = $SSHARRAY[$ssh_select][1]
			$pw = $SSHARRAY[$ssh_select][2]
			_ArrayDelete($SSHARRAY, $ssh_select)
GUICtrlSetData($SSHcurrent,"Current SSH: " & $ip & "|" & $usr & "|" & $pw)
;Run('"' & @ScriptDir & '\BvSsh\BvSsh.exe" -noRegistry -profile="' & @ScriptDir & '\BvSsh\1080.bscp" -host=' & $ip & ' -port=22 -username=' & $usr & ' -password=' & $pw & ' -loginOnStartup -hide=banner,auth,popups,trayLog,trayWRC,trayTerm,traySFTP,trayRDP,trayPopups')
Run('"' & @ScriptDir & '\BvSsh\BvSsh.exe" -noRegistry -profile="' & @ScriptDir & '\BvSsh\1080.bscp" -host=' & $ip & ' -port=22 -username=' & $usr & ' -password=' & $pw & ' -loginOnStartup -hide=main,banner,auth,popups,trayLog,trayWRC,trayTerm,traySFTP,trayRDP,trayPopups')

Local $sshtimestart = TimerInit()
While CheckSSH(1080) <> 0
   If ControlCommand("Host Key Verification", "Accept and &Save", "[CLASS:Button; INSTANCE:1]", "IsVisible", "") Then
	  ControlClick("Host Key Verification", "Accept and &Save", "[CLASS:Button; INSTANCE:1]")
   EndIf
   If TimerDiff($sshtimestart) <= $sshtimeout*1000 Then
	  Sleep(100)
   Else
	  If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
	  EndIf
	  $iSSHdie += 1
	  GUICtrlSetImage($StatusConnect, @ScriptDir & "\BvSsh\sshdie.ico")
      GUICtrlSetData($SSHdie, "Die & BL: " & $iSSHdie)
;~ 	  TrayTip("SSH status","[Die] " & $ip,1)
	  Return "DIE"
   EndIf
WEnd
If $iBlacklist = 1 Then
   If _SSHCHECKBLACKLIST($ip) <> 0 Then
	  $iSSHdie += 1
	  GUICtrlSetImage($StatusConnect, @ScriptDir & "\BvSsh\sshblacklist.ico")
      GUICtrlSetData($SSHdie, "Die & BL: " & $iSSHdie)
	  TrayTip("SSH status","[Blacklist] " & $ip,1)
	  Return "DIE"
	  EndIf
   EndIf
$iSSHlive += 1
GUICtrlSetImage($StatusConnect, @ScriptDir & "\BvSsh\sshlive.ico")
GUICtrlSetData($SSHlive, "Live: " & $iSSHlive)
;~ TrayTip("SSH status","[Live] " & $ip,1)
WinActivate("SSHChanger by dinhtai92dn")
Return "LIVE"
EndFunc   ;==>_ConnectSSH
Func CheckSSH($sshport)
TCPStartup()
Local Const $ip = "127.0.0.1" ; IP address
Local Const $port = $sshport ; Port
Local $connection
Local $errors = 0
$connection = TCPConnect($ip, $port)
If @error Then
$errors += 1
EndIf
Return $errors
TCPShutdown()
EndFunc
Func _ValidIP($sIP)
    Local $aArray = StringSplit($sIP, ".", 2)
    If Not IsArray($aArray) Or UBound($aArray) <> 4 Then Return "ERROR"
    If $aArray[0] <= 0 Or $aArray[0] > 239 Or $aArray[0] = 127 Or $aArray[0] = 169 Then
        Return "ERROR"
    EndIf
    For $I = 0 To 3
        If $I < 3 Then
            If $aArray[$I] < 0 Or $aArray[$I] > 255 Or Not StringIsDigit($aArray[$I]) Then
                Return "ERROR"
            EndIf
        Else
            If Not StringIsDigit($aArray[$I]) Then
                Return "ERROR"
            EndIf

            If $aArray[$I] < 1 Or $aArray[$I] > 254 Then
                Return "ERROR"
            EndIf
		 EndIf
	  Next
    Return "OK"
 EndFunc   ;==>_ValidIP
 Func _IsChecked($sTitle, $iCtrlID)
    Return ControlCommand($sTitle, "", $iCtrlID, "IsChecked")
 EndFunc
 Func _SSHCHECKBLACKLIST($ipcheck)
	Local $check = _INetGetSource("http://127.0.0.1:6699/dnsbllookup.php?ip=" & $ipcheck)
	Return $check
 EndFunc
 Func _ClearTrayIcon()
	Run(@ScriptDir & "\BvSsh\cleartray.exe",@ScriptDir & "\BvSsh",@SW_HIDE)
 EndFunc