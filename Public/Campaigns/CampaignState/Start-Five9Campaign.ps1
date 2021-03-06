function Start-Five9Campaign
{
    <#
    .SYNOPSIS
    
        Function to start a campaign
 
    .EXAMPLE
    
        Start-Five9Campaign -Name 'Hot-Leads'

        # starts campaign named 'Hot-Leads'
    #>
    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Campaign name to be started
        [Parameter(Mandatory=$true)][string]$Name
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        Write-Verbose "$($MyInvocation.MyCommand.Name): Starting campaign '$Name'." 
        return $global:DefaultFive9AdminClient.startCampaign($Name)

    }
    catch
    {
        throw $_
    }

}
