# Basad #




## Get physical drivess info

$physical_drives_existing = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }


## Put drives into a list

$drives_list = $physical_drives_existing | Select-Object DeviceID





## Check if SIMSRV installed

$SIMSRV_folder = "\SIMSRV"

foreach ($drive in $drives_list) {

    # Create full path to SIMSRV
    $drive_letter = $drive.DeviceID
    $temporary_path = $drive_letter + $SIMSRV_folder
    $full_path = "NO SIMSRV installed"

    # Check if the SIMSRV installed
    if (Test-Path -Path $temporary_path) {

        $full_path = $temporary_path
        break

    }
}





## Delete SIMSRV if installed

if ($full_path -ne "NO SIMSRV installed") {


    $SIMSRV_path = $full_path + "\SIMSRV.vmx"

    # SIMSRV status
    $vm_status = & "$vmrun_path" list

    # Shutdown the VM if turned on
    if ($vm_status -contains $SIMSRV_path) {

        & $vmrun_path stop $SIMSRV_path hard
        Start-Sleep -Seconds 10
    }

    # Close VMWare proccess
    Stop-Process -Name "vmware" -Force

    # Starting to removeng files
    Write-Output "SIMSRV saved on $drive_letter, starting to delete it..."
    Remove-Item "$full_path" -Recurse

    do {

        # Wait untill all files will be deleted
        if (Test-Path -Path $full_path) {

            Write-Output "deleting, wait patiently."
            Start-Sleep -Seconds 2
        }

    # Loop indication
    } while (Test-Path -Path $full_path)
    Write-Output "SIMSRV deleted."

} else {
    Write-Output "No SIMSRV installed on the computer."
}










Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "