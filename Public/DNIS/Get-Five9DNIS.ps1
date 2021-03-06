function Get-Five9DNIS
{
    <#
    .SYNOPSIS
    
        Function to returns the list of DNIS for the domain
 
    .EXAMPLE
    
        Get-Five9DNIS

        # Returns all DNIS which are currently assigned to a campaign

    .EXAMPLE
    
        Get-Five9DNIS -SelectUnassigned: $true

        # Returns all DNIS which are not assigned to a campaign
    
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param
    ( 
        <#
        Options are
            • True: only DNIS not assigned to a campaign are returned
            • False (Default): only DNIS which are not assigned to a campaign
        #>
        [Parameter(Mandatory=$false)][switch]$SelectUnassigned = $false
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        if ($SelectUnassigned -eq $true)
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Returning only DNIS which are not assigned to a campaign." 
        }
        else
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Returning all DNIS provisioned to domain." 
        }

        return $global:DefaultFive9AdminClient.getDNISList($SelectUnassigned, $true)

    }
    catch
    {
        throw $_
    }
}
