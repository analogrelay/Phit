<#
.SYNOPSIS
    Unmarks a file or path as assume-unchanged in the Git Index
.PARAMETER Path
    The path to unmark as assume-unchanged
#>
param(
        [Parameter(Mandatory=$true, Position = 0)][string]$Path)

$fixed = Get-GitFilePaths $Path
exec git update-index --no-assume-unchanged @fixed