function Remove-Five9Campaign
{
    <#
    .SYNOPSIS
    
        Function used to delete an existing campaign in Five9

    .EXAMPLE
    
        Remove-Five9InboundCampaign -Name "Cold-Calls"
    
        # Removes campaign named "Cold-Calls"

    #>

    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Name of existing campaign to be removed
        [Parameter(Mandatory=$true)][string]$Name
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop
       
        Write-Verbose "$($MyInvocation.MyCommand.Name): Removing campaign '$Name'" 
        $response = $global:DefaultFive9AdminClient.deleteCampaign($Name)
       
        return $response

    }
    catch
    {
        throw $_
    }
}

            
