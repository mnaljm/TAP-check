# Azure AD TAP Report Script

This PowerShell script is designed to audit Azure Active Directory (Azure AD) users for Temporary Access Pass (TAP) usage. It retrieves users' authentication methods from Microsoft Graph and generates a report of any users utilizing TAP. The report is exported to a CSV file and optionally uploaded to a SharePoint folder.

## Features

- **Microsoft Graph Integration**: Connects to Microsoft Graph using certificate-based authentication.
- **User Authentication Audit**: Retrieves all users in Azure AD and checks their authentication methods for TAP.
- **CSV Report Generation**: Exports a detailed report of users with TAP, including creation and expiration timestamps.
- **SharePoint Upload**: Uploads the CSV report to a specified SharePoint folder for easy sharing and access.

## Prerequisites

1. **Azure AD App Registration**: You will need an Azure AD App with API permissions for Microsoft Graph to read user authentication methods.
2. **Certificate-Based Authentication**: Ensure that a valid certificate is installed locally for secure authentication with Microsoft Graph.
3. **Microsoft Graph PowerShell Module**: Install the Microsoft Graph module with:
    ```powershell
    Install-Module Microsoft.Graph -Scope CurrentUser
    ```
4. **PnP PowerShell Module**: Install the PnP PowerShell module for SharePoint integration with:
    ```powershell
    Install-Module PnP.PowerShell
    ```

## Usage

1. **Update the script with your organization's details**:
   - Replace `YOUR_CERTIFICATE_THUMBPRINT`, `YOUR_APP_ID`, `YOUR_TENANT_ID`, `YOUR_SHAREPOINT_URL`, and `YOUR_SHAREPOINT_FOLDER` in the script with actual values.
   
2. **Run the script**:
   - Execute the script in PowerShell to generate the TAP report and upload it to SharePoint.

## Script Parameters

- **$CertThumbPrint**: The thumbprint of the certificate used for authentication.
- **$AppID**: The Application (client) ID from your Azure AD App Registration.
- **$TenantID**: The Tenant ID of your Azure AD instance.
- **$OutputFile**: The path where the CSV report will be saved.
- **$SharePoint URL**: The URL of your SharePoint site where the report will be uploaded.
- **$SharePoint Folder**: The SharePoint folder path where the report will be stored.

## Example Output

The CSV report will contain the following fields for each user found with TAP:
- **UserPrincipalName**: The UPN of the user.
- **DisplayMethod**: Authentication method used (Temporary Access Pass).
- **P1**: Creation timestamp of the TAP.
- **P2**: Expiration or "Expired" status of the TAP.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributions

Feel free to fork this repository and submit pull requests if you'd like to add features or improvements.

## Contact

For any questions or issues, please contact:

- **Name**: Magnus Naasade
- **Email**: mna@ljm.dk
