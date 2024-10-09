# Parameters for Azure AD
$CertThumbPrint = "YOUR_CERTIFICATE_THUMBPRINT" # <--- Replace with the certificate thumbprint
$AppID = "YOUR_APP_ID" # <--- Replace with your Azure AD App ID
$TenantID = "YOUR_TENANT_ID" # <--- Replace with your Azure AD Tenant ID
$CurrentDateTime = Get-Date -Format "yyyy.MM.dd_HH.mm.ss"
$OutputFile = "C:\PATH\TO\OUTPUT\TapReport_$CurrentDateTime.csv" # <--- Specify the path where the report will be saved

# Connect to Microsoft Graph with certificate-based authentication
Connect-MgGraph -CertificateThumbprint $CertThumbPrint -ClientId $AppID -TenantId $TenantID

# Check if the connection to Microsoft Graph is successful
if ($?) {
    # Initialize an empty array for users with TAP
    $UsersWithTap = @()

    # Get all users (basic info)
    $Users = Get-MgUser -All -Property DisplayName, UserPrincipalName, Id

    # Loop through each user and retrieve their authentication methods
    foreach ($user in $Users) {
        Write-Host "Checking user: $($user.UserPrincipalName)"

        # Try to fetch authentication methods for the user
        try {
            $AuthMethods = Get-MgUserAuthenticationMethod -UserId $user.Id

            # Loop through the authentication methods for this user
            foreach ($AuthMethod in $AuthMethods) {
                $Method = $AuthMethod.AdditionalProperties['@odata.type']

                switch ($Method) {
                    "#microsoft.graph.temporaryAccessPassAuthenticationMethod" {
                        $DisplayMethod = "Temporary Access Pass"
                        $P1 = "Created: " + (Get-Date $AuthMethod.AdditionalProperties['createdDateTime'] -Format g)
                        
                        if ($AuthMethod.AdditionalProperties['expiresDateTime']) {
                            $expiryDate = Get-Date $AuthMethod.AdditionalProperties['expiresDateTime']
                            if ($expiryDate -gt (Get-Date)) {
                                $P2 = "Expires: " + ($expiryDate.ToString("g"))
                            } else {
                                $P2 = "Expired"
                            }
                        } else {
                            $P2 = "Expired"
                        }

                        # Add the user to the TAP report if TAP is found
                        $UsersWithTap += [pscustomobject]@{
                            UserPrincipalName = $user.UserPrincipalName
                            DisplayMethod = $DisplayMethod
                            P1 = $P1
                            P2 = $P2
                        }
                    }
                    # You can add other authentication methods here if needed
                }
            }
        }
        catch {
            Write-Host "Failed to retrieve authentication methods for $($user.UserPrincipalName)"
            Write-Host $_  # Output the error message to get more context
        }
    }

    # If any users with TAP were found, export to CSV
    if ($UsersWithTap.Count -gt 0) {
        $UsersWithTap | Export-Csv -Path $OutputFile -NoTypeInformation
        Write-Host "Report exported to $OutputFile"
    } else {
        Write-Host "No users found with Temporary Access Pass."
    }

    # Connect to SharePoint and upload the report
    Connect-PnPOnline -Url "YOUR_SHAREPOINT_URL" -ClientId $AppID -Tenant $TenantID -Thumbprint $CertThumbPrint # <--- Replace with your SharePoint URL

    # Upload file to SharePoint
    Add-PnPFile -Path $OutputFile -Folder "YOUR_SHAREPOINT_FOLDER" # <--- Replace with your SharePoint folder path
    Write-Output "DONE!"

} else {
    Write-Host "Failed to connect to Microsoft Graph"
}
