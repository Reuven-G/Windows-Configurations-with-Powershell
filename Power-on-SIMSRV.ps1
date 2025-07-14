# Basad #





## Variables

$SIMSRV_folder = "\SIMSRV"
$SIMSRV_path = "not installed"
$vmrun_path = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"



## Get physical drivess info and put them into a list

$drives_list = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID



## Check where SIMSRV placed

foreach ($drive in $drives_list) {

    # Create full path to SIMSRV
    $drive_letter = $drive.DeviceID
    $full_path = $drive_letter + $SIMSRV_folder

    if (Test-Path -Path $full_path) {

        $SIMSRV_path = $full_path + "\SIMSRV.vmx"
    }
}





## Check if SIMSRV installed and running

if ($SIMSRV_path -ne "not installed") {

    #SIMSRV status
    $vm_status = & "$vmrun_path" list

    if ($vm_status -contains $SIMSRV_path) {
        
        Write-Output "SIMSRV already running."

    } else {

        Write-Output "Powering on SIMSRV..."
        & $vmrun_path start $SIMSRV_path
        Write-Output "Wait patiently couple more seconds."

    }

} else {

    Write-Output "SIMSRV not installed yet."

}






Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "
