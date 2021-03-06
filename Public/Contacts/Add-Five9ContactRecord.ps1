function Add-Five9ContactRecord
{
    <#
    .SYNOPSIS
    
        Function used to add a record(s) to the Five9 contact record database

        Using the function you are able to add records 3 ways:
            1. Specifying a single object using -InputObject
            2. Specifying an arrary of objects using -InputObject
            3. Specifying the path of a local CSV file using -CsvPath
 
    .EXAMPLE
    
        Add-Five9ContactRecord -InputObject $dataToBeImported

        # Records in $dataToBeImported will be imported into the contact record database

    .EXAMPLE

        Add-Five9ContactRecord -CsvPath 'C:\files\contact-records.csv'

        # Records in CSV file 'C:\files\contact-records.csv'  will be imported into the contact record database

    .EXAMPLE

        Add-Five9ContactRecord -CsvPath 'C:\files\contact-records.csv' `
                               -CrmAddMode: ADD_NEW -CrmUpdateMode: UPDATE_FIRST -Key @('number1', 'first_name') `
                               -FailOnFieldParseError $true -ReportEmail 'jdoe@domain.com'

        # Imports records from CSV file to contact record database, specifying additional optional parameters
    #>

    [CmdletBinding(DefaultParametersetName='InputObject', PositionalBinding=$false)]
    param
    ( 
        # Single object or array of objects to be added to contact record database. Note: Parameter not needed when specifying a CsvPath
        [Parameter(ParameterSetName='InputObject', Mandatory=$true)][psobject[]]$InputObject,

        # Local file path to CSV file containing records to be added to contact record database. Note: Parameter not needed when specifying an InputObject
        [Parameter(ParameterSetName='CsvPath', Mandatory=$true)][string]$CsvPath,

        <#
        Specifies whether a contact record is added to the contact database

        Options are:
            • ADD_NEW (Default) - New contact records are created in the contact database
            • DONT_ADD - New contact records are not created in the contact database
        #>
        [Parameter(Mandatory=$false)][string][ValidateSet("ADD_NEW", "DONT_ADD")]$CrmAddMode = "ADD_NEW",

        <#
        Specifies how contact records should be updated

        Options are:
            • UPDATE_FIRST (Default) - Update the first matched record
            • UPDATE_SOLE_MATCHES - Update only if one matched record is found
            • UPDATE_ALL - Update all matched records
            • DONT_UPDATE - Do not update any record
        #>
        [Parameter(Mandatory=$false)][string][ValidateSet("UPDATE_FIRST", "UPDATE_ALL", "UPDATE_SOLE_MATCHES", "DONT_UPDATE")]$CrmUpdateMode = "UPDATE_FIRST",

        # Single string, or array of strings which designate key(s). Used when a record needs to be updated, it is used to find the record to update in the contact database.
        # If omitted, 'number1' will be used
        [Parameter(Mandatory=$false)][string[]]$Key = @("number1"),

        <#
        Whether to stop the import if incorrect data is found
        For example, if set to True and you have a column named hair_color in your data, but that field has not been created as a contact field, the import will fail

        Options are:
            • True: The record is rejected when at least one field fails validation
            • False: Default. The record is accepted. However, changes to the fields that fail validation are rejected
        #>
        [Parameter(Mandatory=$false)][bool]$FailOnFieldParseError,

        # Notification about import results is sent to the email addresses that you set for your application
        [Parameter(Mandatory=$false)][string]$ReportEmail
    )

    try
    {
        Test-Five9Connection -ErrorAction: Stop


        if ($PSCmdlet.ParameterSetName -eq 'InputObject')
        {
            $csv = $InputObject | ConvertTo-Csv -NoTypeInformation
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'CsvPath')
        {
            # try to import csv file so that if it throw an error, we know the data is bad
            $csv = Import-Csv $CsvPath | ConvertTo-Csv -NoTypeInformation
        }
        else
        {
            # should never reach this point becasue user should use either InputObject or CsvPath
            return
        }

    

        $headers = $csv[0] -replace '"' -split ','

        # verify that key(s) passed are present in $Inputobject
        foreach ($k in $Key)
        {
            if ($headers -notcontains $k)
            {
                throw "Specified key ""$k"" is not a property name found in data being imported."
                return
            }
        }


        $crmUpdateSettings = New-Object PSFive9Admin.crmUpdateSettings

        # prepare "fieldMapping" per Five9's documentation
        $counter = 1
        foreach ($header in $headers)
        {
            $isKey = $false
            if ($Key -contains $header)
            {
                $isKey = $true
            }

            $crmUpdateSettings.fieldsMapping += @{
                columnNumber = $counter
                fieldName = $header
                key = $isKey
            }

            $counter++

        }


        $csvData = ($csv | select -Skip 1) | Out-String


        $crmUpdateSettings.crmAddModeSpecified = $true
        $crmUpdateSettings.crmAddMode = $CrmAddMode
    
        $crmUpdateSettings.crmUpdateModeSpecified = $true
        $crmUpdateSettings.crmUpdateMode = $CrmUpdateMode
    
        if ($PSBoundParameters.Keys -contains "FailOnFieldParseError")
        {
            $crmUpdateSettings.failOnFieldParseErrorSpecified = $true
            $crmUpdateSettings.failOnFieldParseError = $FailOnFieldParseError
        }

        if ($PSBoundParameters.Keys -contains "ReportEmail")
        {
            $crmUpdateSettings.reportEmail = $ReportEmail
        }
    
        
        Write-Verbose "$($MyInvocation.MyCommand.Name): Adding contact records to database." 


        $response = $global:DefaultFive9AdminClient.updateContactsCsv($crmUpdateSettings, $csvData)


        return $response

    }
    catch
    {
        throw $_
    }
}
