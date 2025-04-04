# CICD - GitHub Action
# Script to delete existing VM template and replace with new built template

param (
    [string]$oldTemplateName,
    [string]$newTemplateName
)

function Get-VaultSecret {
    param (
        $vaultAddress,
        $secretPath,
        $secret,
        $vaultToken
    )

    # Construct the API request
    $uri = "$vaultAddress/v1/$secretPath"
    $headers = @{
        "X-Vault-Token" = $vaultToken
    }

    try {
        # Retrieve the secret
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        # Extract the secret data
        $secretData = $response.data.$secret

        # Return the secret value
        return $secretData

    } catch {
        # Handle errors
        Write-Error "Error retrieving secret: $($_.Exception.Message)"
    }
}

function Delete-OldTemplate ($oldTemplateName) {
    Remove-Template -Template $oldTemplateName -DeletePermanently -Confirm:$false
}

# Start Script
$vaultToken = $env:VAULT_TOKEN
$vaultAddress = "http://vault.local.lan:8200"
$username = Get-VaultSecret $vaultAddress "secret/vsphere/vcsa" "vsphere_username" $vaultToken
$password = Get-VaultSecret $vaultAddress "secret/vsphere/vcsa" "vsphere_password" $vaultToken 
$cred = New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString $password -AsPlainText -Force))
Connect-VIServer -Server vcsa-1.local.lan -Credential $cred
