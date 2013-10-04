<#
.SYNOPSIS
    Submits a Pull Request To GitHub
.PARAMETER ToBranch
    The branch to submit a pull request to. Uses the "pr.defaultBranch" setting in the ".phit" config file in the root of the repo if not present
.PARAMETER FromBranch
    The branch to submit a pull request from. Uses the current branch if not present.
.PARAMETER Remote
    The remote name of the GitHub repository to submit the Pull Request to. Uses "origin" if not present.
#>
param(
        [Parameter(Mandatory=$false, Position = 0)][string]$ToBranch,
        [Parameter(Mandatory=$false, Position = 1)][string]$FromBranch,
        [Parameter(Mandatory=$false)][string]$Remote = "origin")
if(!$ToBranch) {
    $ToBranch = Get-DefaultPullRequestBranch
}
if(!$FromBranch) {
    $FromBranch = Get-GitCurrentBranch
}
Write-Host "Opening browser to create Pull Request from $FromBranch to $ToBranch"

$uri = New-Object Uri (Get-GitRemoteUrl $Remote)
if($uri.Host -notmatch "(www\.)?github\.com") {
    throw "Only supports GitHub remotes right now..."
}

$prUrl = New-Object UriBuilder $uri
if($prUrl.Path.EndsWith(".git")) {
    $prUrl.Path = $prUrl.Path.Substring(0, $prUrl.Path.Length - ".git".Length)
}
$prUrl.Path += "/pull/new/$ToBranch...$FromBranch";

Start-Process $prUrl.Uri