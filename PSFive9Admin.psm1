try
{
    $public  = Get-ChildItem -Path "$PSScriptRoot\Public\" -Filter "*.ps1" -Recurse -ErrorAction: SilentlyContinue | ? {$_.Name -notmatch '\.Tests\.ps1'} | sort FullName
}
catch
{
}

try
{
    $private = Get-ChildItem -Path "$PSScriptRoot\Private\" -Filter "*.ps1" -Recurse -ErrorAction: SilentlyContinue | ? {$_.Name -notmatch '\.Tests\.ps1'}  | sort FullName
}
catch
{
}

$toImport = @()
$toImport += $public
$toImport += $private

#Dot source the files
foreach ($file in $toImport)
{
    try
    {
        . $file.FullName
        Write-Verbose $file.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function ""$($file.Name)"" Message: $($_.Exception.Message)"
        continue
    }
}

Export-ModuleMember -Function $public.Basename

