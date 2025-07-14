# Basad #




## Restore "Settings_old" file

if (Test-Path "C:\Moav\Settings_old.json"){

        Write-Output "Restoring default Settings.json file..."
        Remove-Item "C:\Moav\Settings.json"
        Rename-Item -Path "C:\Moav\Settings_old.json" -NewName "Settings.json"

} else {

        Write-Output "There already default Settings.json file in use."

}





## Delete "simsrv_ssh_key" file

if (Test-Path "C:\simsrv_ssh_key"){

        Write-Output "Deleting simsrv_ssh_key file..."
        Remove-Item "C:\simsrv_ssh_key"

} else {

        Write-Output "The simsrv_ssh_key already missing."

}





## Delete Sim4dev application shortcut

if (Test-Path "C:\Users\$env:USERNAME\Desktop\simulator work buddy.lnk"){

        Write-Output "Deleting shortcut to simulator's work buddy..."
        Remove-Item "C:\Users\$env:USERNAME\Desktop\simulator work buddy.lnk"

} else {

        Write-Output "There is no shortcut on the desktop to delete."

}






## Delete "Sim4dev commands" folder

if (Test-Path "C:\Sim4dev commands"){

        Write-Output "Deleting Sim4dev commands folder..."
        Remove-Item "C:\Sim4dev commands" -Recurse

} else {

        Write-Output "There is no Sim4dev commands folder on the C: drive to delete."

}





## "Script finished" flag
Start-Sleep -Milliseconds 50
Write-Output "All cleaning tasks completed."
Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "
