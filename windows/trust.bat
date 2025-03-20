@echo off

echo Writing script

echo Write-Host "Installing certificate..." > temp.ps1
echo Import-Certificate -FilePath %cd%\CodeIntegrity.cat -CertStoreLocation "Cert:\LocalMachine\Root" >> temp.ps1
echo Write-Host >> temp.ps1
echo Write-Host "Done!" >> temp.ps1
echo Pause >> temp.ps1

powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%cd%\temp.ps1\"' -Verb RunAs"
