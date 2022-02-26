<#
    .SYNOPSIS
        Grabs the location of a user logged into the firewall
    .DESCRIPTION
        Iterates through a list of firewalls and 
#>

function Get-FwUser {
    param(
        #The Username to search for
        [Parameter(Mandatory = $true)]
        [string]$filter)
    
    ## curl 'https://$firewall/api/?type=keygen&user=apiuser&password=PASSWORDHERE' and insert your
    
    $firewalls = 'firewall1.local','firewall2.local'
    $key = 'insert your key here'
    $response = $null
    $return = $null
    
    foreach ($firewall in $firewalls) {
        #$request = Invoke-RestMethod "https://$firewall/api/?type=keygen&user=apiuser&password=PASSWORDHERE"
        $response = Invoke-RestMethod "https://$firewall/?key=$key&type=op&cmd=%3Cshow%3E%3Cglobal-protect-gateway%3E%3Ccurrent-user%3E%3Cuser%3E$filter%3C%2Fuser%3E%3C%2Fcurrent-user%3E%3C%2Fglobal-protect-gateway%3E%3C%2Fshow%3E"
        try {
            if ($response.response.result.HasChildNodes -eq $true) {
                $return += $response.response.result.entry | select username,primary-username,login-time,client,virtual-ip,public-ip,@{n='connected';e={[string]$firewall}}
            }
        } catch {
            #donothing
        }
    }
    
    #return $users | Where-Object -FilterScript { $_.username -like "*$($filter)*"}
    return $return 
    }