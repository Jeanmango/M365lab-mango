<#
    SUBJECT : Add Users
    DESC : Create users from a CSV file in Entra ID, referenced the following site. (https://www.alitajran.com/create-microsoft-entra-id-users/)
    Comment : If you run this script after the first release date, it might not work due to the Graph Powershell version. 
              I strongly recommend always checking the Graph PowerShell version before running the script.
    CHANGELOG :
    V1.00, 05/30/2025
#>

#
Install-Module Microsoft.Graph -scope CurrentUser 
Disconnect-MgGraph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Create Password
$Passwordinfo = @{
    Password = "P@ssw@rd!"
    ForceChangePasswordNextSignIn = $true
    ForceChangePasswordNextSigninWithMFA = $true
}

$CSV = "Your file path"
$Users = Import-Csv -Path $CSV

#Loop through each row containing user details in the CSV file
foreach ($User in $Users) {
    $UserParams = @{
        DisplayName = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        Department = $User.Department
        JobTitle = $User.JobTitle
        MobilePhone = $User.Mobile
        UsageLocation = $User.UsageLocation
        MailNickName = $User.MailNickName
        AccountEnabled = $true
        PasswordProfile = $Passwordinfo
    }

    try {
        $null = NEW-MGUser @UserParams -ErrorAction Stop
        Write-Host ("Successfully created the account for {0}" -f $User.DisplayName) -ForegroundColor Green
    }

    catch {
        Write-Host ("Failed to create the account for {0}. Error: {1}" -f $User.DisplayName, $_.Exception.InnerException.Message) -ForegroundColor Red
        <#

        ##When you need a more specific error message, replace the code as shown below.##
        
        Write-Host "Failed to create account for $($User.DisplayName)" -ForegroundColor Red
        Write-Host "Error details:" -ForegroundColor DarkGray
        $_ | Format-List * -Force
        
        #>
    }

}

