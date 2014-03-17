<#
.SYNOPSIS
    Lists files marked as assume-unchanged
#>
param()

git ls-files -v | where {$_ -cmatch "^[a-z].*$"} | foreach { $_.Substring(2) }