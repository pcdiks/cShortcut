enum Ensure
{
    Absent
    Present
}

[DscResource()]
class Shortcut
{
    [DscProperty(Key)]
    [string]$ShortCutName
    
    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(Mandatory)]
    [String]$Executable

    [DscProperty()]
    [String]$Description

    [DscProperty()]
    [String]$IconLocation

    [void] Set()
    {
        $fileExists = $this.TestFilePath($this.ShortCutName)
        
        if ($this.ensure -eq [Ensure]::Present)
        {
            if (-not $fileExists)
            {
                Write-Verbose -Message "Shortcut does not exist but should be present -> make it so"
                Write-Verbose -Message "Creating the Shortcut $($this.ShortCutName)"
                $WshShell = New-Object -comObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut($this.ShortCutName)
                $Shortcut.TargetPath = $this.Executable
                $Shortcut.Description=$this.Description
                $Shortcut.IconLocation=$this.IconLocation
                $Shortcut.Save()            
            }
        }
        else
        {
            if ($fileExists)
            {
                Write-Verbose -Message "Shortcut exists but should not be present -> make it so"
                Write-Verbose -Message "Deleting the Shortcut $($this.ShortCutName)"
                Remove-Item -Path $this.ShortCutName -Force
            }
        }
        
    }
    
    [bool] Test()
    {
        $present = $this.TestFilePath($this.ShortCutName)

        if ($this.Ensure -eq [Ensure]::Present)
        {
            return $present
        }
        else
        {
            return -not $present
        }
        
    }
    
    [Shortcut] Get()
    {
        $present = $this.TestFilePath($this.ShortCutName)

        if ($present)
        {
            $this.Ensure = [Ensure]::Present
        }
        else
        {
            $this.Ensure = [Ensure]::Absent
        }

        return $this        
    }
    
    [bool] TestFilePath([string] $location)
    {
        $present = $true

        $item = Get-ChildItem -LiteralPath $location -ErrorAction Ignore
        if ($item -eq $null)
        {
            $present = $false
        }
        elseif ($item.PSProvider.Name -ne "FileSystem")
        {
            throw "Path $($location) is not a file path."
        }
        elseif ($item.PSIsContainer)
        {
            throw "Path $($location) is a directory path."
        }

        return $present
    }

}