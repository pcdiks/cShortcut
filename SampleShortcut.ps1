Configuration DesktopShortcut {
    Import-DscResource -ModuleName cShortcut
    
    Node "localhost" {
        Shortcut Logoff 
        {
            Ensure = "Present"
            ShortCutName = "C:\Users\Public\Desktop\Logoff.lnk"
            Executable = "C:\Windows\System32\Logoff.exe"
            Description = "Logoff from Windows"
            IconLocation = "%SystemRoot%\system32\SHELL32.dll,44"
        }
    }
}

DesktopShortcut