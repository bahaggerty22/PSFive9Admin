function New-Five9List
{
    <#
    .SYNOPSIS
    
        Function used to create a new Five9 list

    .EXAMPLE
    
        New-Five9List -Name "Cold-Call-List"

        # Creates a new list
    #>
    [CmdletBinding(PositionalBinding=$true)]
    param
    ( 
        # Name of new list
        [Parameter(Mandatory=$true)][string]$Name
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        $response = $global:DefaultFive9AdminClient.createList($Name)

        return $response

    }
    catch
    {
        throw $_
    }
}

