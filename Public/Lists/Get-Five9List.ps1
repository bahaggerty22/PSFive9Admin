function Get-Five9List
{
    <#
    .SYNOPSIS
    
        Function used to get list(s) from Five9

    .EXAMPLE
    
        Get-Five9List
    
        # Returns all agent groups
    
    .EXAMPLE
    
        Get-Five9List -NamePattern "Cold-Call-List"
    
        # Returns list that matches the name "Cold-Call-List"
    #>
    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Optional. Returns lists matching a given regex string
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'

    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        Write-Verbose "$($MyInvocation.MyCommand.Name): Returning lists matching pattern '$NamePattern'" 
        $response = $global:DefaultFive9AdminClient.getListsInfo($NamePattern) | sort name

        return $response
    }
    catch
    {
        throw $_
    }
}

