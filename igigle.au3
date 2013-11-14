#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=igigle.ico
#AutoIt3Wrapper_outfile=..\igigle.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=http://www.hiddensoft.com/autoit3/compiled.html
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start
	Code By Irongeek from http://irongeek.com
	Code is GPLed, but please email me if you make a better version: irongeek@irongeek.com
	For a WiGLE account go to http://WiGLE.net/
	For more info on the API see http://www5.musatcha.com/musatcha/computers/wigleapi.htm
#comments-end
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#Include <String.au3>
$zipini = IniRead("igigle.ini", "settings", "zip", "47150")
$latini = IniRead("igigle.ini", "settings", "lat", "38.22000000")
$longini = IniRead("igigle.ini", "settings", "long", "-85.75000000")
$varini = IniRead("igigle.ini", "settings", "var", "0.02")
$slicesini = IniRead("igigle.ini", "settings", "slices", "2")
$founddateini = IniRead("igigle.ini", "settings", "founddate", "20050101000000")
$slicesini = IniRead("igigle.ini", "settings", "slices", "2")
$startatini = IniRead("igigle.ini", "settings", "startat", "0")
$userini = IniRead("igigle.ini", "settings", "user", "Irongeek")
$passini = IniRead("igigle.ini", "settings", "pass", "")
$VersionString = "IG WiGLE Client 0.96"
$MainForm = GUICreate($VersionString, 222, 550, 307, 290)
GUISetFont(7, 400, "Times New Roman")
GUISetBkColor(0xA0FFA0)
GUICtrlCreateLabel("ZIP:", 26, 16, 24, 17)
$ZIPTXT = GUICtrlCreateInput($zipini, 60, 16, 129, 21, -1, $WS_EX_CLIENTEDGE)


GUICtrlCreateLabel("LAT:", 24, 40, 35, 17)
$LatTXT = GUICtrlCreateInput($latini, 60, 40, 129, 21, -1, $WS_EX_CLIENTEDGE)

GUICtrlCreateLabel("LONG:", 16, 64, 37, 17)
$LongTXT = GUICtrlCreateInput($longini, 60, 64, 129, 21, -1, $WS_EX_CLIENTEDGE)

GUICtrlCreateLabel("Variance:", 4, 88, 60, 17)
GUICtrlCreateLabel("(0.01 to 0.2)", 0, 100, 60, 17)
$VarTXT = GUICtrlCreateInput($varini, 60, 88, 129, 21, $WS_EX_CLIENTEDGE)

GUICtrlCreateLabel("Date:", 22, 115, 60, 17)
$FoundDate = GUICtrlCreateInput($founddateini, 60, 112, 129, 21, $WS_EX_CLIENTEDGE)
GUICtrlCreateLabel("YYYYMMDDHHMMSS", 60, 135, 120, 17)

GUICtrlCreateLabel("Slices:", 16, 145, 37, 17)
$SlicesTXT = GUICtrlCreateInput($slicesini, 60, 145, 129, 21, -1, $WS_EX_CLIENTEDGE)

GUICtrlCreateLabel("Start at:", 16, 169, 37, 17)
$StartatTXT = GUICtrlCreateInput($startatini, 60, 169, 129, 21, -1, $WS_EX_CLIENTEDGE)

$status = GUICtrlCreateLabel("Warning! Wigle-API only returns 10000 entries per download. Choose slice count wisely! " &  _
    @CRLF & "Warning! Wigle-API only allows about 30 downloads per day per IP (exact limitation not documented). After error is" & _
    " reported, close IG WiGLE Client" & _
    " and continue tomorrow.", 10, 193, 200, 85)

GUICtrlCreateLabel("WiGLE User:", 0, 272, 70, 17)
$UserTXT = GUICtrlCreateInput($userini, 63, 272, 129, 21, -1, $WS_EX_CLIENTEDGE)

GUICtrlCreateLabel("WiGLE Pass:", 0, 296, 70, 17)
$PassTXT = GUICtrlCreateInput($passini, 63, 296, 129, 21, $ES_PASSWORD, $WS_EX_CLIENTEDGE)

$OnlyMyPointsCHK = GUICtrlCreateCheckbox("Show Only My Points", 64, 320, 161, 17)

GUICtrlCreateLabel("Make KML File By Which Method?", 32, 337, 169, 17)
$ByZipBut = GUICtrlCreateButton("By ZIP", 8, 355, 81, 25)
$BylatLongBUT = GUICtrlCreateButton("By Lat/Long", 128, 355, 81, 25)
;$BySSIDStalkBUT = GUICtrlCreateButton("SSID Stalk", 65, 390, 81, 25)
$iglink = GUICtrlCreateButton("http://irongeek.com", 0, 520, 222, 22)
GUICtrlSetFont($iglink, 12, 400, 4, "MS Sans Serif")
GUICtrlSetColor($iglink, 0x008000)

$status = GUICtrlCreateLabel($VersionString & @CRLF & "Choose what you want to do.", 32, 385, 150, 85)

ConsoleWrite("Startet: " & $VersionString)

GUISetState(@SW_SHOW)


While 1
	Dim $extraprams = ""
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			SaveSettings()
			ExitLoop
		Case $msg = $ByZipBut
			$zip = StringStripWS(GUICtrlRead($ZIPTXT), 8)
			$var = StringStripWS(GUICtrlRead($VarTXT), 8)
			$lastupdt = StringStripWS(GUICtrlRead($FoundDate), 8)
			$user = StringStripWS(GUICtrlRead($UserTXT), 8)
			$pass = StringStripWS(GUICtrlRead($PassTXT), 8)
			$fn = $zip
			;Begin Part to fix ZIP query falure by using US ziptolatlon site
			InetGet("http://www.nearby.org.uk/coord.cgi?p=" & $zip, "zip.txt")
			$ziptolatlon = FileOpen("zip.txt", 0)
			$ziptolatlonfullcontents = FileRead($ziptolatlon)
			$temp =_StringBetween($ziptolatlonfullcontents, "lat=", "&long=")
			$lat = $temp[0]
			$temp =_StringBetween($ziptolatlonfullcontents, "&long=", "&p")
			$long = $temp[0]
			;msgbox(0,"",$lat & $long)
			;exit
			; End Part to fix ZIP query falure by using US ziptolatlon site
			If GUICtrlRead($OnlyMyPointsCHK) = 1 Then $extraprams = "&onlymine=true"
			;$qurl = "http://WiGLE.net/gps/gps/GPSDB/confirmquery/?zipcode=" & $zip & "&variance=" & $var & "&lastupdt=" & $lastupdt & "&credential_0=" & $user & "&credential_1=" & $pass & $extraprams & "&simple=true"
			$qurl = "http://wigle.net/gpsopen/gps/GPSDB/confirmquery/?latrange1=" & $lat + $var & "&latrange2=" & $lat - $var & "&longrange1=" & $long + $var & "&longrange2=" & $long - $var & "&lastupdt=" & $lastupdt & "&credential_0=" & $user & "&credential_1=" & $pass & $extraprams & "&simple=true"
			ConsoleWrite(@CRLF & $qurl)
			MakeWiGLEQuery($fn, $qurl)
			SaveSettings()
		Case $msg = $BylatLongBUT
			$lat = StringStripWS(GUICtrlRead($LatTXT), 8)
			$long = StringStripWS(GUICtrlRead($LongTXT), 8)
			$slices = StringStripWS(GUICtrlRead($SlicesTXT), 8) ; e.g. 2 means we have to download 4 pieces
			$startat = StringStripWS(GUICtrlRead($StartatTXT), 8)

			$var = StringStripWS(GUICtrlRead($VarTXT), 8)
			$lastupdt = StringStripWS(GUICtrlRead($FoundDate), 8)
			$user = StringStripWS(GUICtrlRead($UserTXT), 8)
			$pass = StringStripWS(GUICtrlRead($PassTXT), 8)

			$top = $lat + $var
			$bottom = $lat - $var
			$left = $long - $var
			$right = $long + $var
			;ConsoleWrite(@CRLF & "$left: " & $left)
			;ConsoleWrite(@CRLF & "$right: " & $right)
			;ConsoleWrite(@CRLF & "$top: " & $top)
			;ConsoleWrite(@CRLF & "$bottom: " & $bottom)

			$stepSize = ( $top - $bottom ) / $slices
			ConsoleWrite(@CRLF & "stepSize: " & $stepSize)

			$progress = 0
			$sleepLength = 10000
			$sleepCycle = 500
			$success =  True
			$doneAnything = False
			For $horStep = 0 To $slices - 1
				If $success == False Then
					ExitLoop
				EndIf

				$currentLeft = $left + ( $stepSize * $horStep )
				$currentRight = $left + ( $stepSize * ( $horStep + 1 ) )
				For $vertStep = 0 To $slices - 1

					GUICtrlSetData($StartatTXT, $progress)

					If $startat > $progress Then
						$progress = $progress + 1
						ContinueLoop
					EndIf

					$currentTop = $top - ( $stepSize * $vertStep )
					$currentBottom = $top - ( $stepSize * ( $vertStep + 1 ) )

					$fn = $lat & "_" & $long & "_" & $var & "_" & $slices & "_" & $horStep & "_" & $vertStep

					if FileExists ( $fn & ".kml" ) Then
						ConsoleWrite(@CRLF & "Skipping " & $fn & ".kml because already exists")
						ContinueLoop
					EndIf

					$doneAnything = True

					If GUICtrlRead($OnlyMyPointsCHK) = 1 Then $extraprams = "&onlymine=true"
					$qurl = "http://wigle.net/gpsopen/gps/GPSDB/confirmquery/?latrange1=" & Round($currentTop,6) & "&latrange2=" & Round($currentBottom,6) & "&longrange1=" & Round($currentRight,6) & "&longrange2=" & Round($currentLeft,6) & "&lastupdt=" & $lastupdt & "&credential_0=" & $user & "&credential_1=" & $pass & $extraprams & "&simple=true"
					ConsoleWrite(@CRLF & $qurl)
					$success = MakeWiGLEQuery($fn, $qurl)

					If $success == False Then
						GUICtrlSetData($StartatTXT, $progress)
						ExitLoop
					EndIf

					$progress = $progress + 1
					GUICtrlSetData($StartatTXT, $progress)

					If Mod($progress, $sleepCycle) = 0 Then
						GUICtrlSetData($status, "Sleeping " & $sleepLength & " ms...")
						Sleep ( $sleepLength )
					EndIf

				Next
			Next

			If $doneAnything == False Then
				GUICtrlSetData($status, "Nothing to do! Either already all files loaded or too large 'Start at' value specified. Enter 0 to start from beginning.")
			EndIf

			GUICtrlSetData($StartatTXT, $progress)
			SaveSettings()
#cs
		Case $msg = $BySSIDStalkBUT
			$var = StringStripWS(GUICtrlRead($VarTXT), 8)
			$lastupdt = StringStripWS(GUICtrlRead($FoundDate), 8)
			$user = StringStripWS(GUICtrlRead($UserTXT), 8)
			$pass = StringStripWS(GUICtrlRead($PassTXT), 8)
			If GUICtrlRead($OnlyMyPointsCHK) = 1 Then $extraprams = "&onlymine=true"
			$SSIDInput = InputBox("Give me a SSID to look for","Enter the SSID you would like me to look for, I will ignore the lat/long but honor the other input fields.","")
			$fn = $SSIDInput
			$qurl = "http://wigle.net/gpsopen/gps/GPSDB/confirmquery/?ssid=" & $SSIDInput & "&lastupdt=" & $lastupdt & "&credential_0=" & $user & "&credential_1=" & $pass & $extraprams & "&simple=true"
			ConsoleWrite(@CRLF & $qurl)
			MakeWiGLEQuery($fn, $qurl)
			SaveSettings()
#ce
		Case $msg = $iglink
			ShellExecute("http://irongeek.com")
		Case Else
			;;;;;;;
	EndSelect
WEnd

Exit
Func SaveSettings()

	IniWrite("igigle.ini", "settings", "zip", StringStripWS(GUICtrlRead($ZIPTXT), 8))
	IniWrite("igigle.ini", "settings", "lat", GUICtrlRead($LatTXT))
	IniWrite("igigle.ini", "settings", "long", GUICtrlRead($LongTXT))
	IniWrite("igigle.ini", "settings", "var", GUICtrlRead($VarTXT))
	IniWrite("igigle.ini", "settings", "founddate", GUICtrlRead($FoundDate))
	IniWrite("igigle.ini", "settings", "user", GUICtrlRead($UserTXT))
	IniWrite("igigle.ini", "settings", "pass", GUICtrlRead($PassTXT))
	IniWrite("igigle.ini", "settings", "slices", GUICtrlRead($SlicesTXT))
	IniWrite("igigle.ini", "settings", "startat", GUICtrlRead($StartatTXT))


EndFunc   ;==>SaveSettings

Func MakeWiGLEQuery($fn, $qurl)
	GUICtrlSetData($status, "Getting file " & $fn & ".txt")
	If InetGet($qurl, $fn & ".txt", 1) Then
		If ValidFile($fn & ".txt") Then
			MakeKMLFile($fn & ".txt", $fn & ".kml")
			GUICtrlSetData($status, "Done. Open " & $fn & ".kml in Google Earth")
			Return True
		Else
			GUICtrlSetData($status, "Bad Input File! Check that your WiGLE user name and password are correct, and that the WiGLE web server is up.")
			Return False
		EndIf
	Else
		GUICtrlSetData($status, "Could not get data from server. Check that your WiGLE user name and password are correct, and that the WiGLE web server is up.")
		Return False
	EndIf
EndFunc   ;==>MakeWiGLEQuery


Func MakeKMLFile($inputfilename, $kmlfilename)
	Dim $kmlfile

	$kmlfile = FileOpen($kmlfilename, 2)
	; Check if file opened for reading OK
	If $kmlfile = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	FileWrite($kmlfile, '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Folder><name>WiGLE Data</name><open>1</open>' & @CRLF)
	PrintKMLFolder("Y", "WEPed", $inputfilename, $kmlfile)
	PrintKMLFolder("N", "No WEP", $inputfilename, $kmlfile)
	FileWrite($kmlfile, '</Folder></kml>')
	FileClose($kmlfile)
EndFunc   ;==>MakeKMLFile


Func ValidFile($inputfilename)
	$returnvalue = False
	$inputfile = FileOpen($inputfilename, 0)
	; Check if file opened for reading OK
	If $inputfile = -1 Then
		GUICtrlSetData($status, "Bad Input File! Check that your WiGLE user name as password is correct, and that the WiGLE web server is up.")
		$returnvalue = False
	EndIf
	If StringLeft(FileReadLine($inputfile), 5) == "netid" Then
		GUICtrlSetData($status, "Bad file")
		$returnvalue = True
	Else
		$returnvalue = False
	EndIf
	FileClose($inputfile)
	return $returnvalue
EndFunc   ;==>ValidFile

Func PrintKMLFolder($weptype, $FolderName, $inputfilename, $kmlfile)
	Dim $placemark
	Dim $wap
	Dim $line
	$inputfile = FileOpen($inputfilename, 0)
	; Check if file opened for reading OK
	;If $inputfile = -1 Then
	;	MsgBox(0, "Error", "Unable to open file.")
	;	Exit
	;EndIf
	If $weptype == "Y" Then
		$iconwep = "http://irongeek.com/images/wapwep.png"
	Else
		$iconwep = "http://irongeek.com/images/wap.png"
	EndIf

	FileWrite($kmlfile, "<Folder><name>" & $FolderName & "</name><open>1</open>" & @CRLF)
	$i = 0
	While 1
		$i = $i + 1
		$line = FileReadLine($inputfile)
		If @error = -1 Then ExitLoop
		;ConsoleWrite($line & @CRLF)
		$line = StringRegExpReplace($line, "[^\x20-\x7E\x09\x0A\x0D]", " ")
		;ConsoleWrite($line & @CRLF)
		$wap = StringSplit($line, "~")
		;MsgBox(0,"",$wap[0])
		;ConsoleWrite($wap[0] & @CRLF)
		If $wap[0] == 19 And $wap[11] == $weptype Then
			$placemark = "<Placemark>" & @CRLF & _
					"<description>" & @CRLF & _
					"<![CDATA[" & @CRLF & _
					"SSID: " & $wap[2] & "<BR>" & @CRLF & _
					"BSSID: " & $wap[1] & "<BR>" & @CRLF & _
					"TYPE: " & $wap[5] & "<BR>" & @CRLF & _
					"WEP: " & $wap[11] & "<BR>" & @CRLF & _
					"CHANNEL: " & $wap[16] & "<BR>" & @CRLF & _
					"QOS: " & $wap[19] & "<BR>" & @CRLF & _
					"Last Seen: " & $wap[15] & "" & @CRLF & _
					"]]>" & @CRLF & _
					"</description>" & @CRLF & _
					"<name><![CDATA[" & $wap[2] & "]]></name>" & @CRLF & _
					"<Style>" & @CRLF & _
					"<IconStyle>" & @CRLF & _
					"<Icon>;" & @CRLF & _
					"<href>" & $iconwep & "</href>" & @CRLF & _
					"</Icon>" & @CRLF & _
					"</IconStyle>" & @CRLF & _
					"</Style>" & @CRLF & _
					'<Point id="' & $FolderName & $i & '">' & @CRLF & _
					"<coordinates>" & $wap[13] & "," & $wap[12] & ",0</coordinates>" & @CRLF & _
					"</Point>" & @CRLF & _
					"</Placemark>" & @CRLF
					;ConsoleWrite($placemark & @CRLF)
			FileWrite($kmlfile, $placemark)
		EndIf
		GUICtrlSetData($status, "Making " & $FolderName & $i)
	WEnd
	FileWrite($kmlfile, '</Folder>')
	FileClose($inputfile)
EndFunc   ;==>PrintKMLFolder
