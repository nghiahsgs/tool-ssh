;Kết nối 1 SSH đơn giản với autoit
Global $sshtimeout = 7000 ; thời gian tối đa connect 1 ssh là 7s
 While 1
			$session_connect = _ChangeSSH("156.156.123.123", "admin", "admin")
		If $session_connect = "LIVE" Then
			   ;_ClearTrayIcon() ; hàm clear tray icon (áp dụng cho connect list ssh, làm đầy tray icon, xem bên code mã nguồn tool chính
			   MsgBox(0,"", "SSH LIVE")
			   ExitLoop
			ElseIf $session_connect = "DIE" Then
			   MsgBox(0,"", "SSH DIE")
			   ExitLoop
			EndIf
Sleep(20)

WEnd

Func _ChangeSSH($s_ip, $s_user, $s_pass)
   ;Nếu Bitvise đang chạy thì close
   If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
	  EndIf
   ;Khởi chạy Bitvise với các tham số ip, user, pass
   Run('"' & @ScriptDir & '\BvSsh\BvSsh.exe" -noRegistry -profile="' & @ScriptDir & '\BvSsh\1080.bscp" -host=' & $s_ip & ' -port=22 -username=' & $s_user & ' -password=' & $s_pass & ' -loginOnStartup -hide=main,banner,auth,popups,trayLog,trayWRC,trayTerm,traySFTP,trayRDP,trayPopups')

Local $sshtimestart = TimerInit() ;Bắt đầu tính thời gian từ lúc connect
While CheckSSH(1080) <> 0 ; Vòng lặp kiểm tra nếu cổng 127.0.0.1:port chưa LIVE thì làm các bước trong vòng lặp
   If ControlCommand("Host Key Verification", "Accept and &Save", "[CLASS:Button; INSTANCE:1]", "IsVisible", "") Then
	  ControlClick("Host Key Verification", "Accept and &Save", "[CLASS:Button; INSTANCE:1]")
   EndIf
   If TimerDiff($sshtimestart) <= $sshtimeout Then ;nếu thời gian connect dài hơn thời gian timeout thì close bitvise và trả về ssh "DIE"
	  Sleep(100)
   Else
	  If ProcessExists("BvSsh.exe") Then
		 ProcessClose("BvSsh.exe")
	  EndIf
	  Return "DIE"
   EndIf
WEnd
EndFunc

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
EndFunc ; Check cổng 127.0.0.1:port xem có có kết nối ko, giá trị trả lại = 0 thì ssh đã kết nối LIVE