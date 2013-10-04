param($ParsedArgs)

function Get-GitHubCloneUrl {
    param($Path)
    $cloneUrl = (New-Object UriBuilder (New-Object Uri "https://github.com"))
    $cloneUrl.Path = $Path;
    return $cloneUrl.Uri.AbsoluteUri;
}

# If ArgumentStart is not valid, carry on
if(($ParsedArgs.ArgumentStart -lt 0) -or ($ParsedArgs.ArgumentStart -ge $ParsedArgs.Raw.Length)) {
    return $ParsedArgs.Raw
}

$Repo = $ParsedArgs.Raw[$ParsedArgs.ArgumentStart]

if($Repo -match "^[a-zA-Z0-9]*/[a-zA-Z0-9]*$") {
    $clone = (Get-GitHubCloneUrl $Repo)
    Write-Host "Rewriting to $clone"
    $ParsedArgs.Raw[$ParsedArgs.ArgumentStart] = $clone
} else {
    [Uri]$cloneUrl = $null;
    if([Uri]::TryCreate($Repo, "Absolute", [ref]$cloneUrl)) {
        if(($cloneUrl.Scheme -eq "gh") -or ($cloneUrl.Scheme -eq "github")) {
            $clone = (Get-GitHubCloneUrl "$($cloneUrl.Authority)$($cloneUrl.LocalPath)");
            Write-Host "Rewriting to $clone"
            $ParsedArgs.Raw[$ParsedArgs.ArgumentStart] = $clone
        }
    }
}