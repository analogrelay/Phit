param($ParsedArgs)

# If ArgumentStart is not valid, carry on
if(($ParsedArgs.ArgumentStart -lt 0) -or ($ParsedArgs.ArgumentStart -ge $ParsedArgs.Raw.Length)) {
    return $ParsedArgs.Raw
}

$Branch = $ParsedArgs.Raw[$ParsedArgs.ArgumentStart]

if($Branch -match "bug:(?<num>\d+)") {
    $bug = $matches["num"]
    
    $localCandidates = @((git branch) | 
        where { $b = $_.Trim(); ($b -like "*/$bug-*")})
    $remoteCandidates = @((git branch -r) | 
        where { $b = $_.Trim(); ($b -like "origin/*/$bug-*")})

    if($localCandidates.Length -eq 1) {
        $ParsedArgs.Raw[$ParsedArgs.ArgumentStart] = $localCandidates[0].Trim()
    } elseif($remoteCandidates.Length -eq 1) {
        $ParsedArgs.Raw[$ParsedArgs.ArgumentStart] = $remoteCandidates[0].Trim().Substring("origin/".Length)
    } else {
        Write-Host "Multiple branches exist for bug $($bug):"
        Write-Host ($localCandidates + $remoteCandidates)
        $ParsedArgs.Cancel = $true;
    }
}