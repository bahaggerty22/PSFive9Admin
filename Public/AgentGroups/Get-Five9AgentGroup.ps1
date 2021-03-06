function Get-Five9AgentGroup
{
    <#
    .SYNOPSIS
    
        Function used to get agent group(s) from Five9
 
    .EXAMPLE
    
        Get-Five9AgentGroup
    
        # Returns all agent groups
    
    .EXAMPLE
    
        Get-Five9AgentGroup -NamePattern "Team Joe"
    
        # Returns agent group matching the string "Team Joe"
    
    #>

    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Regex sring matching agent groups to be returned
        [Parameter(Mandatory=$false)][string]$NamePattern = '.*'
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop
        
        Write-Verbose "$($MyInvocation.MyCommand.Name): Returning Five9 agent groups using pattern '$($NamePattern)'" 
        return $global:DefaultFive9AdminClient.getAgentGroups($NamePattern) | sort name

    }
    catch
    {
        throw $_
    }

}
