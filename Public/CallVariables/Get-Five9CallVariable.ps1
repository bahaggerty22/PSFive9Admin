function Get-Five9CallVariable
{
    <#
    .SYNOPSIS
    
        Function used to get call variable(s) from Five9

    .EXAMPLE
    
        Get-Five9CallVariable -Name "ANI" -Group "Call"
    
        # Returns call variable "ANI" within group "Call"
    
    #>

    [CmdletBinding(PositionalBinding=$true)]
    param
    (
        # Name of existing call variable
        [Parameter(Mandatory=$true)][string]$Name,

        # Group Name of existing call variable
        [Parameter(Mandatory=$true)][string]$Group
    )
    
    try
    {
        Test-Five9Connection -ErrorAction: Stop

        try
        {
            $response = $global:DefaultFive9AdminClient.getCallVariables($Name, $Group)
        }
        catch
        {

        }

        if ($response -eq $null)
        {
            throw "Cannot find a Call Variable with name: ""$Name"" within the Group ""$Group"". Remember that Name and Group are case sensitive."
            return
        }

        Write-Verbose "$($MyInvocation.MyCommand.Name): Returning Five9 call variable '$Name' within group '$Group'." 
        return $response

    }
    catch
    {
        throw $_
    }
}



