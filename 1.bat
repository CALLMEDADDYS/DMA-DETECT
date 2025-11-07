@echo off
setlocal enabledelayedexpansion

set OUTPUT_DIR=%~dp0
for /f "tokens=1-6 delims=/: " %%a in ("%date% %time%") do (
  set YYYY=%%c
  set MM=%%a
  set DD=%%b
)
for /f "tokens=1-2 delims=." %%x in ("%time%") do (
  set T=%%x
)
set T=%T::=-%
set TIMESTAMP=%YYYY%-%MM%-%DD%_%T%

set OUTFILE=%OUTPUT_DIR%pci_dump_%TIMESTAMP%.txt

echo Dumping PCI devices to "%OUTFILE%" ...
powershell -NoProfile -Command ^
  "Get-WmiObject Win32_PnPEntity | Where-Object { $_.PNPDeviceID -and ($_.PNPDeviceID -match 'PCI') } | " ^
  "Select-Object Name, PNPDeviceID, DeviceID, Manufacturer, Service | " ^
  "Format-Table -AutoSize | Out-String | Set-Content -Path '%OUTFILE%' -Encoding UTF8"

if exist "%OUTFILE%" (
  echo Done. Saved to "%OUTFILE%"
  start "" "%OUTFILE%"
) else (
  echo Failed to create output file.
)

endlocal
pause
