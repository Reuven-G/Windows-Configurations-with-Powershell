# Basad #




Add-Type -AssemblyName System.windows.Forms
Add-Type -AssemblyName System.Drawing





## Window properties

$installer_gui_window = New-Object System.Windows.Forms.Form

$installer_gui_window.Text = "Simulator Installer"

$installer_gui_window.StartPosition = 'CenterScreen'

$installer_gui_window.Size = New-Object System.Drawing.Size(1000,525)





## Log box properties

$output_logs = New-Object System.Windows.Forms.TextBox

$output_logs.Multiline = $true

#Log box size
$output_logs.Size = New-Object System.Drawing.Size(400, 370)

#Log box location
$output_logs.Location = New-Object System.Drawing.Point(550, 25)

#Log box scrolling type
$output_logs.ScrollBars = 'Vertical'

$installer_gui_window.Controls.Add($output_logs)





## Check computer drives usage

$check_computer_drives_usage_button = New-Object System.Windows.Forms.Button

#Button text
$check_computer_drives_usage_button.Text = 'Check drives on the computer'

#Button size
$check_computer_drives_usage_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$check_computer_drives_usage_button.Location = New-Object System.Drawing.Point(25, 25)

#Button operations
$check_computer_drives_usage_button.Add_Click({

    #Get physical drivess info
    $physical_drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

    #Check total and free space on each drive
    $physical_drives | ForEach-Object {

        $drive_letter = $_.DeviceID

        $total_size_of_partition = [math]::round($_.Size / 1GB, 2)
        $free_size_of_partition = [math]::round($_.FreeSpace / 1GB, 2)

        #Logs
        $output_logs.AppendText("Drive ${drive_letter}`r`n")
        $output_logs.AppendText("Total size: $total_size_of_partition GB`r`n")
        $output_logs.AppendText("Free  size: $free_size_of_partition GB`r`n")
        $output_logs.AppendText(" `r`n")
    }

    #Variables
    $SIMSRV_not_installed = 0
    $SIMSRV_folder = "\SIMSRV"
    $drives_list = $physical_drives | Select-Object DeviceID

    #Check if SIMSRV installed
    foreach ($drive in $drives_list) {

        #Create full path to SIMSRV
        $drive_letter = $drive.DeviceID
        $full_path = $drive_letter + $SIMSRV_folder

        #Check if SIMSRV installed 
        if (Test-Path -Path $full_path) {
            
            $output_logs.AppendText("SIMSRV installed on drive $drive_letter`r`n")
            $SIMSRV_not_installed += 1
            break
        }
    }

    if ($SIMSRV_not_installed -eq 0) {
        
        $output_logs.AppendText("SIMSRV not installed`r`n")
    }

    $output_logs.AppendText(" `r`n")
    $output_logs.AppendText("##############################################`r`n")
    $output_logs.AppendText(" `r`n")
})





## Check NICs existence, status and IP

$check_nics_button = New-Object System.Windows.Forms.Button

#Button text
$check_nics_button.Text = 'Check NICs status and IP'

#Button size
$check_nics_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$check_nics_button.Location = New-Object System.Drawing.Point(275, 25)

#Button operations
$check_nics_button.Add_Click({
    
    #Get NICs info
    $VMW_NICs = Get-NetAdapter | Where-Object { $_.Name -like "1*_*" }





    #Extract only name, status and ip
    $NICs_status_and_ip = $VMW_NICs | ForEach-Object { 

        $nic = $_
        $ip = (Get-NetIPAddress -InterfaceIndex $nic.ifIndex | Select-Object -ExpandProperty IPAddress) -join ', '
        [PSCustomObject]@{
        
            Name =        $nic.Name
            Status =      $nic.Status
            IPAddress =   $ip
        }
    }

    #Show all data in a table form
    $NICs_status_and_ip = $NICs_status_and_ip | Format-Table -Property Name, Status, IPAddress | Out-String
    
    #Logs
    $output_logs.AppendText("$NICs_status_and_ip `r`n")
    $output_logs.AppendText("##############################################`r`n")
    $output_logs.AppendText(" `r`n")
})





## MOAV environment configuration

$moav_environment_configuration_button = New-Object System.Windows.Forms.Button

#Button text
$moav_environment_configuration_button.Text = 'Environment configuration for MOAV'

#Button size
$moav_environment_configuration_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$moav_environment_configuration_button.Location = New-Object System.Drawing.Point(25, 150)

#Button operations
$moav_environment_configuration_button.Add_Click({

    #Script path
    $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\MOAV-environment-configuration.ps1'

    #configuration of the proccess
    $proccess = New-Object System.Diagnostics.Process
    $proccess.StartInfo.FileName = "powershell.exe"
    $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
    $proccess.StartInfo.UseShellExecute = $false
    $proccess.StartInfo.RedirectStandardOutput = $true
    $proccess.StartInfo.RedirectStandardError = $true
    $proccess.StartInfo.CreateNoWindow = $true

    $proccess.Start()

    #print script output to the log box
    while (-not $proccess.HasExited) {

        $output = $proccess.StandardOutput.ReadLine()

        if ($output) {

            $output_logs.AppendText("$output`r`n")
            $output_logs.ScrollToCaret()
        }
    }
})





## Windows environment configuration

$windows_environment_configuration_button = New-Object System.Windows.Forms.Button

#Button text
$windows_environment_configuration_button.Text = 'Windows environment configuration'

#Button size
$windows_environment_configuration_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$windows_environment_configuration_button.Location = New-Object System.Drawing.Point(275, 150)

#Button operations
$windows_environment_configuration_button.Add_Click({

    #Script path
    $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\Windows-environment-configuration.ps1'

    #configuration of the proccess
    $proccess = New-Object System.Diagnostics.Process
    $proccess.StartInfo.FileName = "powershell.exe"
    $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
    $proccess.StartInfo.UseShellExecute = $false
    $proccess.StartInfo.RedirectStandardOutput = $true
    $proccess.StartInfo.RedirectStandardError = $true
    $proccess.StartInfo.CreateNoWindow = $true

    $proccess.Start()

    #print script output to the log box
    while (-not $proccess.HasExited) {

        $output = $proccess.StandardOutput.ReadLine()

        if ($output) {

            $output_logs.AppendText("$output`r`n")
            $output_logs.ScrollToCaret()
        }
    }
})





## Open AWX web page

$awx_web_button = New-Object System.Windows.Forms.Button

#Button text
$awx_web_button.Text = 'Open AWX web page'

#Button size
$awx_web_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$awx_web_button.Location = New-Object System.Drawing.Point(150, 235)

#Button operations
$awx_web_button.Add_Click({

    Start-Process "chrome.exe" "http://admin:pa`$`$Sw0rd@192.168.169.98/#/templates/job_template/28/details"
})





## Power on SIMSRV button 

$Power_on_SIMSRV_button = New-Object System.Windows.Forms.Button

#Button text
$power_on_SIMSRV_button.Text = 'Power on SIMSRV'

#Button size
$power_on_SIMSRV_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$power_on_SIMSRV_button.Location = New-Object System.Drawing.Point(25, 320)

#Button operations
$power_on_SIMSRV_button.Add_Click({

    #Script path
    $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\Power-on-SIMSRV.ps1'

    #configuration of the proccess
    $proccess = New-Object System.Diagnostics.Process
    $proccess.StartInfo.FileName = "powershell.exe"
    $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
    $proccess.StartInfo.UseShellExecute = $false
    $proccess.StartInfo.RedirectStandardOutput = $true
    $proccess.StartInfo.RedirectStandardError = $true
    $proccess.StartInfo.CreateNoWindow = $true

    $proccess.Start()

    #print script output to the log box
    while (-not $proccess.HasExited) {

        $output = $proccess.StandardOutput.ReadLine()

        if ($output) {

            $output_logs.AppendText("$output`r`n")
            $output_logs.ScrollToCaret()
        }
    }
})





## Copy DTED files to VM button

$copy_simulators_and_dted_button = New-Object System.Windows.Forms.Button

#Button text
$copy_simulators_and_dted_button.Text = 'Copy DTED and simulators'

#Button size
$copy_simulators_and_dted_button.Size = New-Object System.Drawing.Size(200, 75)

#Button location
$copy_simulators_and_dted_button.Location = New-Object System.Drawing.Point(275, 320)

#Button operations
$copy_simulators_and_dted_button.Add_Click({

    #Script path
    $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\Copy-simulators-and-dted.ps1'

    #configuration of the proccess
    $proccess = New-Object System.Diagnostics.Process
    $proccess.StartInfo.FileName = "powershell.exe"
    $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
    $proccess.StartInfo.UseShellExecute = $false
    $proccess.StartInfo.RedirectStandardOutput = $true
    $proccess.StartInfo.RedirectStandardError = $true
    $proccess.StartInfo.CreateNoWindow = $true

    $proccess.Start()

    #print script output to the log box
    while (-not $proccess.HasExited) {

        $output = $proccess.StandardOutput.ReadLine()

        if ($output) {

            $output_logs.AppendText("$output`r`n")
            $output_logs.ScrollToCaret()
        }
    }
})





## Delete configuration files button

$delete_configuration_files_button = New-Object System.Windows.Forms.Button

#Button text
$delete_configuration_files_button.Text = 'Delete configuration files'

#Button size
$delete_configuration_files_button.Size = New-Object System.Drawing.Size(300, 25)

#Button location
$delete_configuration_files_button.Location = New-Object System.Drawing.Point(100, 425)

#Button operations
$delete_configuration_files_button.Add_Click({

    #Script path
    $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\Delete-configuration-files.ps1'

    #configuration of the proccess
    $proccess = New-Object System.Diagnostics.Process
    $proccess.StartInfo.FileName = "powershell.exe"
    $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
    $proccess.StartInfo.UseShellExecute = $false
    $proccess.StartInfo.RedirectStandardOutput = $true
    $proccess.StartInfo.RedirectStandardError = $true
    $proccess.StartInfo.CreateNoWindow = $true

    $proccess.Start()

    #print script output to the log box
    while (-not $proccess.HasExited) {

        $output = $proccess.StandardOutput.ReadLine()

        if ($output) {

            $output_logs.AppendText("$output`r`n")
            $output_logs.ScrollToCaret()
        }
    }
})






## Delete SIMSRV folder button

$delete_simsrv_folder_button = New-Object System.Windows.Forms.Button

#Button text
$delete_simsrv_folder_button.Text = 'Delete SIMSRV folder'

#Button size
$delete_simsrv_folder_button.Size = New-Object System.Drawing.Size(300, 25)

#Button location
$delete_simsrv_folder_button.Location = New-Object System.Drawing.Point(600, 425)

#Button operations
$delete_simsrv_folder_button.Add_Click({

    $run_the_script = [System.Windows.Forms.MessageBox]::Show(

        "Are you sure you want to permentatly remove SIMSRV?
(Its an irreversible process)",
        "Confirmation",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question

    )

    if ($run_the_script -eq [System.Windows.Forms.DialogResult]::Yes) {

        #Script path
        $path_to_script = '\\storage\Deployment\simulator_installation\install scripts\Delete-SIMSRV.ps1'

        #configuration of the proccess
        $proccess = New-Object System.Diagnostics.Process
        $proccess.StartInfo.FileName = "powershell.exe"
        $proccess.StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$path_to_script`""
        $proccess.StartInfo.UseShellExecute = $false
        $proccess.StartInfo.RedirectStandardOutput = $true
        $proccess.StartInfo.RedirectStandardError = $true
        $proccess.StartInfo.CreateNoWindow = $true

        $proccess.Start()

        #print script output to the log box
        while (-not $proccess.HasExited) {

            $output = $proccess.StandardOutput.ReadLine()

            if ($output) {

                $output_logs.AppendText("$output`r`n")
                $output_logs.ScrollToCaret()
            }
        }
    }
})





## Buttons adding to the window

$installer_gui_window.Controls.Add($moav_environment_configuration_button)
$installer_gui_window.Controls.Add($windows_environment_configuration_button)
$installer_gui_window.Controls.Add($copy_simulators_and_dted_button)
$installer_gui_window.Controls.Add($delete_configuration_files_button)
$installer_gui_window.Controls.Add($awx_web_button)
$installer_gui_window.Controls.Add($check_nics_button)
$installer_gui_window.Controls.Add($delete_simsrv_folder_button)
$installer_gui_window.Controls.Add($check_computer_drives_usage_button)
$installer_gui_window.Controls.Add($power_on_SIMSRV_button)


[void]$installer_gui_window.ShowDialog()



