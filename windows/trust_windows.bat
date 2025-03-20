@echo off

echo Writing script

echo Write-Host "Installing certificate..." > temp.ps1
echo Rename-Item %cd%\Dashboard.msix %cd%\Dashboard.zip >> temp.ps1
echo tar --strip-components=1 -zxvf %cd%\Dashboard.zip -C %cd% AppxMetadata/CodeIntegrity.cat >> temp.ps1
echo Rename-Item %cd%\Dashboard.zip %cd%\Dashboard.msix >> temp.ps1
echo Import-Certificate -FilePath %cd%\CodeIntegrity.cat -CertStoreLocation "Cert:\LocalMachine\Root" >> temp.ps1
echo Write-Host >> temp.ps1
echo Write-Host "Done!" >> temp.ps1
echo Pause >> temp.ps1

powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%cd%\temp.ps1\"' -Verb RunAs"
pause
del temp.ps1
del CodeIntegrity.cat
