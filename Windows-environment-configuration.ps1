# Basad #





## Check if rdp connection allowed

$winrm_status = (Get-Service -Name WinRM).Status.ToString()

if ($winrm_status -eq "Stopped"){

        winrm quickconfig /Force > $null
        Write-Output "WinRM status changed to: Running."
        Write-Output " "

} else {

        Write-Output "WinRM already was allowed"
        Write-Output " "

}




$notepad_path = "C:\Program Files\Notepad++\notepad++.exe"

if (Test-Path $notepad_path){
        
        $notepad_version = (Get-Item $notepad_path).VersionInfo.FileVersion

        if ($notepad_version -eq "8.54"){

            Write-Output "Notepad++ already installed."
            Write-Output " "

        } else {

            Remove-Item -Path "C:\Program Files\Notepad++" -Recurse -Force

            # Bring Notepad++ application folder to C:\Program Files
            Copy-Item -Path "\\storage\Deployment\simulator_installation\Programs_to_install\Notepad++" -Destination "C:\Program Files\Notepad++" -Recurse -Force
            Write-Output "Notepad++ updated."
            Write-Output " "
        }

} else {

        # Bring Notepad++ application folder to C:\Program Files
        Copy-Item -Path "\\storage\Deployment\simulator_installation\Programs_to_install\Notepad++" -Destination "C:\Program Files\Notepad++" -Recurse -Force
        Write-Output "Notepad++ Installed."
        Write-Output " "
}





## Check if Chrome installed 

$program_installed = "no"
Write-Output "Checking status of Google Chrome..."
$program_installed = (Get-Package *hrome).Name.ToString()


## Install Chrome if needed 

if ($program_installed -ne "Google Chrome"){
        
        Write-Output "Starting Google Chrome installation..."
        Write-Output " "
        msiexec /i "\\storage\deployment\simulator_installation\Programs_to_install\GoogleChromeStandaloneEnterprise64.msi" /qn

} else {

        Write-Output "Google Chrome already installed."
        Write-Output " "

}





## Check if Moba installed 

$program_installed = "no"
Write-Output "Checking status of MobaXTerm..."
$program_installed = (Get-Package moba*).Name.ToString()


## Install moba if needed 

if ($program_installed -ne "MobaXterm"){
        
        Write-Output "Starting MobaXTerm installation..."
        msiexec /i "\\storage\deployment\simulator_installation\Programs_to_install\MobaXterm.msi" /qn
        Write-Output " "

} else {

        Write-Output "MobaXTerm already installed."
        Write-Output " "

}





## Set path to system environment

$path = [System.Environment]::GetEnvironmentVariable('path','machine')


## Check if OpenSSH exist 

Write-Output "Checking existence of OpenSSH in system evironment..."
$exist = $path.Split(";") -contains "C:\Program Files\OpenSSH"
#$exist = $path.Split(";") -contains "%systemroot%\System32\OpenSSH"


#Bring OpenSSH folder to C:\Program Files
Copy-Item -Path "\\storage\Deployment\simulator_installation\Programs_to_install\OpenSSH" -Destination "C:\Program Files\OpenSSH" -Recurse -Force


## If not, configure 

if ($exist -eq $false){

    $path+=';C:\Program Files\OpenSSH\'
    [System.Environment]::SetEnvironmentVariable('path', $path, 'machine')
    Write-Output "Path added to system evironment"
    Write-Output " "




    #$path+=';%systemroot%\System32\OpenSSH'
    #[System.Environment]::SetEnvironmentVariable('path', $path, 'machine')
    #Write-Output "Path added to system evironment"
    #Write-Output " "

} else {

    Write-Output "Path already existing."
    Write-Output " "

}





## Check status of windows hyper V 

Write-Output "Checking status of windows Hyper-V..."
$win_hyper_v = (Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Hypervisor").State.ToString()


## If enabled, disable windows hyper V

if($win_hyper_v -eq "Enabled"){

        Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Hypervisor"
        Write-Output "Hyper-V has been disabled, "
        Write-Output "You need to restart the computer so the action will take place..."

} else {

        Write-Output "Hyper-V already was disabled." 
}





## "Script finished" flag

Write-Output " "
Start-Sleep -Milliseconds 50
Write-Output "Environment configuration completed."
Start-Sleep -Milliseconds 50
Write-Output " "
Write-Output "##############################################"
Write-Output " "