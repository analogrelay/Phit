<#
.SYNOPSIS
    Marks a file or path as assume-unchanged in the Git Index
.PARAMETER Path
    The path to mark as assume-unchanged
#>
param(
        [Parameter(Mandatory=$true, Position = 0)][string]$Path)

$fixed = Get-GitFilePaths $Path
exec git update-index --assume-unchanged @fixed