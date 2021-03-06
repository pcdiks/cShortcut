# Powershell DSC Resource to create a shortcut #

My first attempt to create a DSC resource.

## Install ##
1. Create a directory cShortcut in "C:\Program Files\WindowsPowerShell\Modules"
2. Copy the files to this directory

## Example ##
Start Powershell and paste the following:
```
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
```

This will create a folder 'DesktopShortcut' in the current directory.

Next, use this command to start the actual configuration:
```
Start-DscConfiguration -Path .\DesktopShortcut\ -Wait -Verbose
```

Adding `-Wait` and `-Verbose` will make the config run immediatly and shows the output to determine if it worked.

It will create a logoff shortcut on your desktop.