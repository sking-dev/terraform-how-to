$ws = "https://endpoints.office.com"
$instance = "Worldwide"
$format = "CSV"
$clientRequestId = [GUID]::NewGuid().Guid

# Download the Microsoft published list of Office 365 endpoints worldwide.
$endpointSets = Invoke-RestMethod -Uri ($ws + "/endpoints/" + $instance + "?Format=" + $format + "&clientRequestId=" + $clientRequestId)

# Export the Microsoft published list to a CSV file.
Write-Output $endpointSets | Out-File office-365-endpoints-all.csv

# Extract the 'ids' and 'urls' columns.
$newFile = Import-Csv .\office-365-endpoints-all.csv | Select-Object id,urls

# Export the filtered comma-delimited values into a new CSV file.
$newFile | Export-Csv -Path .\office-365-endpoints-urls-only.csv -NoTypeInformation

# Part Deux: combine the comma-delimited values in each row into a single string array to use in the Terraform code.

# First, create an array and populate it with the values from the 'urls' column.
# https://www.spguides.com/powershell-create-array-from-csv/
# NOTE: There's an annoying empty value in the original Microsoft list, and this needs to be removed otherwise Terraform will grumble.
# https://www.powershelladmin.com/wiki/Remove_empty_elements_from_an_array_in_PowerShell.php

$urls=@()
Import-Csv .\office-365-endpoints-urls-only.csv | ForEach-Object {
    $urls += $_.urls  | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
}

# Next, split the values in each cell into separate rows so that each value will retain its quotation marks.
# https://stackoverflow.com/questions/60672095/powershell-convert-comma-separated-values-into-separate-objects

$urlsSplit = $urls.Split(",")
$urlsSplit
Write-Host("================")

# Finally join the values from the individual rows into a single string array.
# https://morgantechspace.com/2021/01/how-to-join-string-array-into-one-string-in-powershell.html

$urlsJoined = '"' + ($urlsSplit -join '","' ) + '"'

# Replace the unsupported placeholder value in this individual FQDN with the explicit name of the tenant directory.
$urlsJoined = $urlsJoined -replace "autodiscover.*.onmicrosoft.com", "autodiscover.yourtenantdirectory.onmicrosoft.com"

# Output the finalised joined string for use in the Terraform code.
Write-Host "Copy the output below and paste it into the Terraform code."
Write-Host "================"
$urlsJoined
