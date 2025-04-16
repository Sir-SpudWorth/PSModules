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