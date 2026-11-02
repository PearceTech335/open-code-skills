---
name: remote-retry-invoke
language: powershell
tags: [powershell, remote, invoke, retry, backoff, reliability]
use-case: Invoke a command on a remote machine with retry and timeout
created: 2026-07-31
---

## Description

Invokes a script block on a remote machine using `Invoke-Command` with
retry logic (exponential backoff), per-attempt timeout, and error handling.

## Usage

Call `Invoke-RemoteWithRetry -ComputerName "srv01" -ScriptBlock { ... }`.
Adjust `-MaxRetries` and `-TimeoutSeconds` as needed.

## Code

```powershell
function Invoke-RemoteWithRetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ComputerName,
        [Parameter(Mandatory)] [scriptblock] $ScriptBlock,
        [int] $MaxRetries = 3,
        [int] $TimeoutSeconds = 120,
        [int] $BaseDelaySeconds = 5
    )

    $lastError = $null
    for ($attempt = 0; $attempt -lt $MaxRetries; $attempt++) {
        try {
            return Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ErrorAction Stop
        } catch {
            $lastError = $_
            if ($attempt -lt $MaxRetries - 1) {
                $delay = [math]::Pow(2, $attempt) * $BaseDelaySeconds
                Write-Warning "Attempt $($attempt+1) failed. Retrying in ${delay}s..."
                Start-Sleep -Seconds $delay
            }
        }
    }
    throw $lastError
}
```

## Notes

- Requires PowerShell remoting (WinRM) enabled on the target.
- Use `-Session` parameter for connection pooling if calling multiple times.
- On PowerShell 7, consider `Invoke-Command -AsJob` for non-blocking.
