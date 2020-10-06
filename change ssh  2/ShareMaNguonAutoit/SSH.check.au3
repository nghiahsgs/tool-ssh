#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.1
 Author:         dinhtai92dn

 Script Function:
	Kiem tra neu ssh die khi dang su dung thi tu dong change ssh

#ce ----------------------------------------------------------------------------

If Not WinExists("SSHChanger by dinhtai92dn") Then
   MsgBox(0,"ERROR","Please run 'SSHCHANGER.exe'")
   Exit
EndIf
While 1
If CheckSSH(1080) <> 0 And ControlCommand("SSHChanger by dinhtai92dn", "CHANGE", "[CLASS:Button; INSTANCE:3]", "IsEnabled", "") = 1 Then
   ControlClick("SSHChanger by dinhtai92dn","CHANGE","[CLASS:Button; INSTANCE:3]")
   Sleep(1000)
   While ControlCommand("SSHChanger by dinhtai92dn", "CHANGE", "[CLASS:Button; INSTANCE:3]", "IsEnabled", "") <> 1
	  Sleep(2000)
   WEnd
EndIf
   Sleep(10000)
WEnd

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