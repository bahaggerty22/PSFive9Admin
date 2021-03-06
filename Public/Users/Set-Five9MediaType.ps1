function Set-Five9MediaType
{
    <#
    .SYNOPSIS
    
        Function used to add, remove, or modify the media type of a user or user profile

    .EXAMPLE
    
        Set-Five9MediaType -Username 'jdoe@domain.com' -MediaType: CHAT -Enabled $true -MaxAllowed 3 -IntelligentRouting $true

        # Adds chat media type to user jdoe@domain.com

    .EXAMPLE
    
        Set-Five9MediaType -UserProfileName 'Sales-User-Profile' -MediaType: EMAIL -Enabled $true -MaxAllowed 9 -IntelligentRouting $false

        # Adds email media type to user profile Sales-User-Profile

    .EXAMPLE
    
        Set-Five9MediaType -Username 'jdoe@domain.com' -MediaType: CHAT -Enabled $false

        # Removes chat media type from user jdoe@domain.com

    #>
    [CmdletBinding(DefaultParametersetName='Username',PositionalBinding=$false)]
    param
    (
        # Username of the user being modified
        # This parameter is not used when -UserProfileName is passed
        [Parameter(ParameterSetName='Username',Mandatory=$true)][string]$Username,

        # Profile name being modified
        # This parameter is not used when -Username is passed
        [Parameter(ParameterSetName='UserProfileName',Mandatory=$true)][string]$UserProfileName,

        
        <#
        Media type being modified

        Options are:
            • VOICE
            • CHAT
            • SOCIAL
            • EMAIL
            • VIDEO
            • CASE
        #>
        [Parameter(Mandatory=$true, Position=1)][ValidateSet('VOICE', 'CHAT', 'SOCIAL', 'EMAIL', 'VIDEO', 'CASE')][string]$MediaType,

        # Whether the media type is enabled
        [Parameter(Mandatory=$false)][bool]$Enabled,

        # Maximum number of items allowed for the type
        [Parameter(Mandatory=$false)][byte]$MaxAllowed,

        # Whether Intelligent Routing is enabled
        [Parameter(Mandatory=$false)][bool]$IntelligentRouting

    )

    try
    {

        Test-Five9Connection -ErrorAction: Stop

        $objToModify = $null
        try
        {
            if ($PsCmdLet.ParameterSetName -eq "Username")
            {
                $objToModify = $global:DefaultFive9AdminClient.getUsersGeneralInfo($Username)
            }
            elseif ($PsCmdLet.ParameterSetName -eq "UserProfileName")
            {
                $objToModify = $global:DefaultFive9AdminClient.getUserProfile($UserProfileName)
            }
            else
            {
                throw "Error setting media type. ParameterSetName not set."
            }
            
        }
        catch
        {

        }

        if ($objToModify.Count -gt 1)
        {
            throw "Multiple matches were found using query: ""$($Username)$($UserProfileName)"". Please try using the exact name of the user or profile you're trying to modify."
            return
        }

        if ($objToModify -eq $null)
        {
            throw "Cannot find a Five9 user or profile with name: ""$($Username)$($UserProfileName)"". Remember that this value is case sensitive."
            return
        }


        $objToModify = $objToModify | Select-Object -First 1



        $mediaTypeItem = New-Object PSFive9Admin.mediaTypeItem

        $mediaTypeItem.type = $MediaType
        $mediaTypeItem.typeSpecified = $true

        if ($PSBoundParameters.Keys -contains "Enabled")
        {
            $mediaTypeItem.enabled = $Enabled
            $mediaTypeItem.enabledSpecified = $true
        }

        if ($PSBoundParameters.Keys -contains "IntelligentRouting")
        {
            # note: this is spelled wrong on the API devs
            #       powershell param is spelled correctly
            $mediaTypeItem.intlligentRouting = $IntelligentRouting
            $mediaTypeItem.intlligentRoutingSpecified = $true
        }

        if ($PSBoundParameters.Keys -contains "MaxAllowed")
        {
            # note: this is spelled wrong on the API devs
            #       powershell param is spelled correctly
            $mediaTypeItem.maxAlowed = $MaxAllowed
            $mediaTypeItem.maxAlowedSpecified = $true
        }


        $objToModify.mediaTypeConfig = @()
        $objToModify.mediaTypeConfig += $mediaTypeItem


        if ($PsCmdLet.ParameterSetName -eq "Username")
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Modifying media type '$MediaType' for user '$Username'." 
            $response = $global:DefaultFive9AdminClient.modifyUser($objToModify, $null, $null)
        }
        elseif ($PsCmdLet.ParameterSetName -eq "UserProfileName")
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Modifying media type '$MediaType' for profile '$UserProfileName'." 
            $response = $global:DefaultFive9AdminClient.modifyUserProfile($objToModify)
        }

    }
    catch
    {
        throw $_
    }
}
