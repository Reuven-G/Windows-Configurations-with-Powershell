# Basad #





## Updated moav "Settings" file in C:\Moav\ checking

if (Test-Path "C:\Moav\Settings_old.json"){
        
        Write-Output "The Settings.json file already updated."

} else {
        
        # Outdate old moav "Settings" file in C:\Moav\
        Rename-Item -Path "C:\Moav\Settings.json" -NewName "Settings_old.json"

        Write-Output "Outdated old moav Settings file"

        # Bring new moav "Settings" file to C:\Moav\
        Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\Settings.json" -Destination "C:\Moav\Settings.json"

        Write-Output "Configured new moav Settings file."

}





## simsrv_ssh_key file existence checking

if (Test-Path "C:\simsrv_ssh_key"){
        
        Write-Output "simsrv_ssh_key already in place"

} else {
        
        # Bring "simsrv_ssh_key" file to C:\
        Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\simsrv_ssh_key" -Destination "C:\simsrv_ssh_key"

        Write-Output "Brought simsrv_ssh_key file."



        # Add permissions for local user
        $permissions = Get-Acl -Path "C:\simsrv_ssh_key"
        $new_permissions = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:USERDNSDOMAIN\$env:USERNAME","Read,Write","Allow")
        $permissions.SetAccessRule($new_permissions)
        $permissions | Set-Acl -Path "C:\simsrv_ssh_key"
        (Get-Acl -Path "C:\simsrv_ssh_key").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInheritanceFlags -AutoSize  > $null

        Write-Output "Added permissions for local user to run docker files."



        # Disable inheritance on the "simsrv_ssh_key" file
        $file_permissions = Get-Acl -Path "C:\simsrv_ssh_key"
        $file_permissions.SetAccessRuleProtection($true,$false)
        $file_permissions | Set-Acl -Path "C:\simsrv_ssh_key"

        Write-Output "Disabled unneccesary permissions."



}





## "Sim4dev commands" folder checking / creating

if (Test-Path "C:\Sim4dev commands"){
        
        Write-Output "Sim4dev commands folder already existing."

} else {
        
        # Bring "Sim4dev commands" folder to C:\
        Copy-Item -Path "\\storage\Deployment\simulator_installation\files to copy\Sim4dev commands" -Destination "C:\Sim4dev commands" -Recurse -Force

        Write-Output "Brought Sim4dev commands folder"


        # Make shortcut for Sim4dev application on Desktop
        $create_shortcut_command = New-Object -ComObject wscript.Shell
        $shortcut = $create_shortcut_command.CreateShortcut("C:\Users\$env:USERNAME\Desktop\simulator Operator.lnk")
        $shortcut.TargetPath = "C:\Sim4dev commands\GUI commands\SIMSRV-Operator\SimsrvOperator_MVVM.exe"
        $shortcut.IconLocation = "\\storage\deployment\simulator_installation\files to copy\icons\airplane-simulator-logo.ico"
        $shortcut.Save()

        Write-Output "Made shortcut for Sim4dev application."


        # Make shortcut for Sim4dev updater on Desktop
        $create_shortcut_command = New-Object -ComObject wscript.Shell
        $shortcut = $create_shortcut_command.CreateShortcut("C:\Users\$env:USERNAME\Desktop\simulator updater.lnk")
        $shortcut.TargetPath = "C:\Sim4dev commands\simulator update\simulator_updater.bat"
        $shortcut.IconLocation = "\\storage\deployment\simulator_installation\files to copy\icons\simulator-update-logo.ico"
        $shortcut.Save()

        Write-Output "Made shortcut for Sim4dev updater."

}





## "Script finished" flag

Write-Output " "
Start-Sleep -Milliseconds 50
Write-Output "Environment configuration for MOAV proccess completed."
Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "

