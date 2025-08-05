function Get-DnsRecords {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Domain,

        [Parameter(Mandatory = $false)]
        [ValidateSet("A", "MX", "NS", "CNAME", "TXT", "PTR", "SOA", "SRV", "AAAA")]
        [string[]]$Type = @("A", "MX", "NS", "CNAME", "TXT")
    )

    Write-Host "[🧙‍♂️] Gathering DNS Records" -foregroundColor Green
    $exists = $false

    foreach ($T in $Type) {
        try {
            Write-Verbose "Resolving $T records for $Domain"
            $result = Resolve-DnsName -Name $Domain -Type $T -ErrorAction Stop
            if ($result) {
                Write-Host "`n[ 🖥️ $T RECORDS]" -foregroundColor Red
                $result | Format-Table -Autosize
                $exists = $true
            }
        } catch {
            if ($_.Exception.Message -notmatch "DNS name does not exist") {
                Write-Verbose "`n[!] Error: $($_.Exception.Message)" 
            }
        }
    }

    if ($exists -eq $false) {
        Write-Host "`n[😡]: Domain Does Not Exist" -foregroundColor Red
    } else {
        Write-Host "`n[😎]: DNS Recon Completed" -foregroundColor Green
    }

}

function Get-IpInfo{
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    ) 

    Write-Host "[O.O] Gathering IP Information" -foregroundColor Green

    $ipInfo = Invoke-WebRequest -Uri "https://ipinfo.io/$IPAddress" | Select-Object -ExpandProperty Content

    Write-Host $ipInfo
    
}

Export-ModuleMember -Function Get-DnsRecords, Get-IpInfo










header = @{
            "Authorization" = "Bearer $($jwt)"
        }


        # Auth endpoint
        writeLog 4 "Generating Endpoint URL"
        if ($this.FQDN -notmatch "^https://"){
            $this.FQDN = "https://$($this.FQDN)"
        }
        $authEP = "$($this.FQDN)/api/auth/authenticate"

        Write-Host "Connecting to $($authEP)"

        # Attempt to authenticate
        try {
            writeLog 3 "Attempting connection to $($authEP)"
            $authResponse = Invoke-RestMethod -Method POST -Uri $authEP -Headers $header

            # Clear the header after the request to remove it from Memory
            $header = $null

            if($authResponse.tokens.access.token){
                writeLog 3 "Authentication successful. Token acquired"

                # Set the Auth Toke, Refresh Token, and Expiry Time
                $this.AuthToken = $authResponse.tokens.access.token 
                $this.RefreshToken = $authResponse.tokens.refresh.token
                $this.TokenExpiry = (Get-Date).AddSeconds($authResponse.tokens.refresh.expirySeconds)
                writeLog 3 "Token will expire at: $($this.TokenExpiry)"
                
                # Set the auth header to be used in subsequent API calls
                $this.authHeader = @{
                    "Authorization" = "Bearer $($this.AuthToken)"
                }

            } else {
                writeLog 1 "Response recieved but no Auth Token generated: $($authResponse.Status)" 
                
            }
        }
        catch {
             writeLog 1 "Error during authentication: $($_.Exception.Message)" 
             if($_.ErrorDetails){
                writeLog 1 "Error Details: $($_.ErrorDetails.Message)"
             }

        }

















