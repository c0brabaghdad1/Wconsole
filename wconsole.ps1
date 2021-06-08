# I wrote the code a little differently and you might have trouble reading it because I don't use switch
# anyway, your as end user, it will not be a problem for you 
# by Mustafa - @c0brabaghdad1

$myArray = @(
"","
Windows Console v 0.1

[+] 0 : About                                  [+] 7 : Processes,Services,Drivers   
[+] 1 : OS Version and Configuration           [+] 8 : Unquoted Service Paths  
[+] 2 : User Information and Enumeration       [+] 9 : Credentials   
[+] 3 : Powershell History                     [+] 10: File/Folder    
[+] 4 : Firewalls and Antivirus (AV)           [+] 11: Always Elevated Install
[+] 5 : Patches                                [+] 12: Check if you are running with admin privileges
[+] 6 : Network Section                        [+] 13: Scheduled Tasks                                                                                                                     
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"

if ($option -eq 0){Write-Host "Windows Console v 0.1  - Coded By : @c0brabaghdad1" -ForegroundColor DarkGray }

elseif ($option -eq 1){
$myArray = @(
"","
[+] 0 : Displays OS Configuration information [All]    
[+] 1 : Get only OS Name/Version information           
[+] 2 : List all env variables                                                               
[+] 3 : HostName
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if($option -eq 0 )
 {systeminfo}
elseif ($option -eq 1)
 {systeminfo | findstr /B /C:"OS Name" /C:"OS Version"}
elseif ($option -eq 2)
 {Get-ChildItem Env: | ft Key,Value}
elseif ($option -eq 3)
 {hostname} 
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 2)
{
$myArray = @(
"","
[+] 0 : Get Current Username  
[+] 1 : List all users          
[+] 2 : Get SID of the current user                                                               
[+] 3 : List user privilege and groups
[+] 4 : Get details about groups
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0)
 {$env:username}
elseif ($option -eq 1)
 {net user 
Write-Host "==== More Information ====" 
 Get-LocalUser | ft Name,Enabled,LastLogon}
elseif ($option -eq 2)
 {([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value}
elseif ($option -eq 3)
 {whoami /groups /priv}
elseif ($option -eq 4)
 {Write-Host "==== All groups ====" 
 Get-LocalGroup | ft Name
Write-Host "==== Members of Administrators ===="
 Get-LocalGroupMember Administrators | ft Name, PrincipalSource}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 3){cat (Get-PSReadlineOption).HistorySavePath}

elseif ($option -eq 4){
$myArray = @(
"","
[+] 0 : Check status of Windows Defender
[+] 1 : Windows Firewall status and Config    
[+] 2 : List Installed Antivirus Products 
[+] 3 : Check if There is Any Antivirus running                                                               
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0)
 {Get-MpComputerStatus}
elseif ($option -eq 1)
 {write-host "== Firewall  State =="
 netsh firewall show state
 write-host "== Firewall  Configrate =="
 netsh firewall show config}
elseif ($option -eq 2)
 {Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct}
elseif ($option -eq 3)
 {WMIC /Node:localhost /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct Get displayName /Format:List | more}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 5){wmic qfe get Caption,Description,HotFixID,InstalledOn}

elseif ($option -eq 6){
$myArray = @(
"","
[+] 0 : Get Stored Wi-Fi Passwords            [+] 3 : List all Network interfaces,IP,DNS
[+] 1 : List of Saved Network Profiles        [+] 4 : Get ARP Cache 
[+] 2 : List Open Connection                                                                                
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0)
 {(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize
 }
elseif ($option -eq 1)
 {netsh wlan show profiles}
elseif ($option -eq 2)
 {netstat -anto}
elseif ($option -eq 3)
 {Get-NetIPConfiguration | ft InterfaceAlias,InterfaceDescription,IPv4Address}
elseif ($option -eq 4)
 {Get-NetNeighbor -AddressFamily IPv4 | ft ifIndex,IPAddress,LinkLayerAddress,State}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 7){
$myArray = @(
"","
[+] 0 : Get list of Processes Running on machine      [+] 2 : Running Processes + Process owner
[+] 1 : Displays all running applications,services    [+] 3 : List all drivers                                                                                
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0)
 {Get-Process | where {$_.ProcessName -notlike "svchost*"} | ft ProcessName, Id}
elseif ($option -eq 1)
 {tasklist /SVC}
elseif ($option -eq 2)
 {Get-WmiObject -Query "Select * from Win32_Process" | where {$_.Name -notlike "svchost*"} | Select Name, Handle, @{Label="Owner";Expression={$_.GetOwner().User}} | ft -AutoSize}
elseif ($option -eq 3){driverquery}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 8){cmd /c 'wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "c:windows\" |findstr /i /v """'}

elseif ($option -eq 9){
$myArray = @(
"","
[+] 0 : Stored Credentials        
[+] 1 : Credential Manager                                                                                          
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0){start-process "cmdkey" -ArgumentList "/list" -NoNewWindow -Wait | ft}
elseif ($option -eq 1){start-process "whoami" -ArgumentList "/priv" -NoNewWindow -Wait | ft}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 10){
$myArray = @(
"","
[+] 0 : Read Hosts File 
[+] 1 : Insecure Permissions                                                                                          
","")
$myArray
[int]$option = Read-Host -Prompt "Please Enter Your Option"
if ($option -eq 0)
{type C:\Windows\System32\drivers\etc\hosts}
elseif ($option -eq 1)
{BAT\perms}
else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}}

elseif ($option -eq 11){Test-Path -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Installer" | ft}

elseif ($option -eq 12){
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { echo "yes"; } else { echo "no"; }}

elseif ($option -eq 13){schtasks /query /fo LIST /v}

else {Write-Warning "Make sure your input Less-Than or Equal 32-bit or not a string.";}