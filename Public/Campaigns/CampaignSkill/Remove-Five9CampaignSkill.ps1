function Remove-Five9CampaignSkill
{
    <#
    .SYNOPSIS
    
        Function to remove skill(s) from a Five9 campaign

    .EXAMPLE
    
        Remove-Five9CampaignSkill -Name 'Hot-Leads' -Skill 'Skill-1'

        # Removes a single skill from a campaign

    .EXAMPLE

        $skillsToBeRemoved = @('Skill-1', 'Skill-2', 'Skill-3')
        Remove-Five9CampaignSkill -Name 'Hot-Leads' -Skill $skillsToBeRemoved
    
        # Eemoves array of multiple skills from a campaign
    
 
    #>
    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Campaign name that skill(s) will be removed from
        [Parameter(Mandatory=$true)][string]$Name,

        # Single skill name, or array of multiple skill names to be removed from a campaign
        [Parameter(Mandatory=$true)][string[]]$Skill
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        Write-Verbose "$($MyInvocation.MyCommand.Name): Removing skill(s) from campaign '$Name'." 
        return $global:DefaultFive9AdminClient.removeSkillsFromCampaign($Name, $Skill)

    }
    catch
    {
        throw $_
    }

}
