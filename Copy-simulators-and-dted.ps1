# Basad #




## Global variables

$user = "aeronautics"
$pass = ConvertTo-SecureString "1234" -AsPlainText -Force
$creds = New-Object PSCredential ($user, $pass)





## Create net drive to copy simulators folder

$net_path_simulators = "\\192.121.99.5\sim_opt"
New-PSDrive -Name "A" -PSProvider FileSystem -Root $net_path_simulators -Credential $creds -Persist > $null


## Copy "simulators" folder to SIMSRV

Write-Output "simulators folder in transfer..."
Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\simulators\*" -Destination "\\192.121.99.5\sim_opt\simulators" -Recurse -Force
Write-Output "Done"


## Delete net drive

Remove-PSDrive -Name "A"





## Create net drive to copy DTED folders

$net_path_dted = "\\192.121.99.5\sim_opt\common\DTED"
New-PSDrive -Name "A" -PSProvider FileSystem -Root $net_path_dted -Credential $creds -Persist > $null


## Copy dted level 0 to SIMSRV

Write-Output "DTED level 0 folder in transfer..."
Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\DTED\LEVEL 0" -Destination "\\192.121.99.5\sim_opt\common\DTED" -Recurse -Force
Write-Output "Done"



Start-Sleep -Milliseconds 1000
Remove-PSDrive -Name "A"
Start-Sleep -Milliseconds 1000
New-PSDrive -Name "A" -PSProvider FileSystem -Root $net_path_dted -Credential $creds -Persist > $null
Start-Sleep -Milliseconds 1000


## Copy dted level 1 to SIMSRV

Write-Output "DTED level 1 folder in transfer..."
Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\DTED\LEVEL 1" -Destination "\\192.121.99.5\sim_opt\common\DTED" -Recurse -Force
Write-Output "Done"
Write-Output " "


## Delete net drive

Remove-PSDrive -Name "A"





## "Script finished" flag

Start-Sleep -Milliseconds 50
Write-Output "Post installation files copying completed."
Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "