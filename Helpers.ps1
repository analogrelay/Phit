function Parse-Arguments {
    # Find the first option without a "-", OR the first option after the "--"
    begin {
        $argumentStart = 0;
        $arguments = @();
        $inOptions = $true;
    }
    process {
        $arguments += $_
        if(($_.Length -gt 0) -and ($_[0] -eq "-") -and $inOptions) {
            $argumentStart += 1
            if($_ -eq "--") {
                # End of options
                $inOptions = $false
            }
        } else {
            # Not in options
            $inOptions = $false
        }
    }
    end {
        $result = New-Object PSCustomObject
        Add-Member -InputObject $result -NotePropertyMembers @{
            "ArgumentStart"=$argumentStart;
            "Raw"=$arguments;
            "Cancel"=$false;
        }
        $result
    }
}

function Get-ConfigFilePath {
    $repoRoot = (git rev-parse --show-toplevel)
    return "$repoRoot/.phit"
}

function Get-PSGitConfig {
    param([Parameter(Mandatory=$true)][string]$Name)
    git config -f (Get-ConfigFilePath) $Name
}

function Set-PSGitConfig {
    param(
        [Parameter(Mandatory=$true, Position = 0)][string]$Name,
        [Parameter(Mandatory=$true, Position = 1)][string]$Value)
    git config -f (Get-ConfigFilePath) $Name $Value
}