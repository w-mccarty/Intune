### Program

Install command = %SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1

Uninstall command = %SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1

Installation time required (mins) = 60

Allow available uninstall = No

Install behavior = System

Device restart behavior = App install may force a device restart

### Requreiments

Operating system architecture = x64

Minimum operating system = Windows 10 1607

### Detection

Rules format = Use a custom detection script (Detection.ps1)

Run script as 32-bit process on 64-bit clients = No

Enforce script signature check and run script silently = No
