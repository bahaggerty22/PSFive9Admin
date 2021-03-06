﻿function Get-Five9ReportResult
{
    <#
    .SYNOPSIS
    
        Function returns the data from a report generated by Start-Five9Report

    .EXAMPLE
    
        $id = Start-Five9Report -FolderName "Call Log Reports" -ReportName 'Call Log'
        $result = Get-Five9ReportResult -Identifier $id

        # Starts the Call Log report and using the returned identifier, gets the data from the report using Get-Five9ReportResult

    #>
    [CmdletBinding(PositionalBinding=$true)]
    param
    (
        # Unique identifier returned by Start-Five9Report
        [Parameter(Mandatory=$true)][string]$Identifier
    )

    try
    {

        Test-Five9Connection -ErrorAction: Stop

        $data = $global:DefaultFive9AdminClient.getReportResultCsv($Identifier)

        $objects = $data | ConvertFrom-Csv -ErrorAction: SilentlyContinue

        if ($objects.Count -gt 0)
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Returning report with $($objects.Count) rows."
            return $objects
        }
        else
        {
            Write-Verbose "$($MyInvocation.MyCommand.Name): Report did not return any data."
            return $objects
        }


    }
    catch
    {
        if ($_.Exception.Message -match 'Result is not ready due to process is not complete')
        {
            throw "Report is not yet finishing running. Please wait and try again."
        }
        else
        {
            throw $_
        }

        
    }
}
