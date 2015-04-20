$enc = [system.Text.Encoding]::UTF8
$APIKey = ""
$APISecret = ""

function Bitfinex-GetBalances {
Sleep -Seconds 1
$Time = (Get-Date).Ticks
$payloadraw = @{
    request = "/v1/balances"
    nonce = "$Time"
    options = "{}"
}

$jsonencodedpl = ConvertTo-Json $payloadraw

$byteencodedpl = $enc.GetBytes($jsonencodedpl)

$payload = [System.Convert]::ToBase64String($byteencodedpl)

#We have our payload (hopefully)

$payloadbe = $enc.GetBytes($payload)

$hmacsha = New-Object System.Security.Cryptography.HMACSHA384
$hmacsha.key = $Enc.GetBytes($APISecret)

$signature = $hmacsha.ComputeHash($payloadbe)

$signaturehex = $signature | ForEach-Object { $_.ToString("x2") }
$signaturehex = $signaturehex -join ""

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-BFX-APIKEY", $APIKey)
$headers.Add("X-BFX-PAYLOAD", $payload)
$headers.Add("X-BFX-SIGNATURE", $signaturehex)

Invoke-RestMethod -Method Post -Uri https://api.bitfinex.com/v1/balances -Headers $headers
}
#Run the function
Bitfinex-GetBalances
