function Remove-Five9User
{
    <#
    .SYNOPSIS
    
        Function used to delete a Five9 user
   
    .EXAMPLE
    
        Remove-Five9User -Username 'jdoe@domain.com'
    
        # Deletes user with username 'jdoe@domain.com'
    #>

    [CmdletBinding(PositionalBinding=$true)]
    param
    (
        # Username of user to be removed
        [Parameter(Mandatory=$true)][string]$Username
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop

        Write-Verbose "$($MyInvocation.MyCommand.Name): Removing user '$Username'." 
        $response = $global:DefaultFive9AdminClient.deleteUser($Username)

        return $response
    }
    catch
    {
        throw $_
    }
}
