$STARTTIME = Get-Date
Write-Host "Script to setup FFMPEG" -ForegroundColor Blue

$URL = "https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-6.0-essentials_build.zip"
$OUTFILE = "ffmpeg.zip"

Invoke-WebRequest -Uri $URL -OutFile $OUTFILE

Expand-Archive -Path $OUTFILE

Write-Host "Done" -ForegroundColor Green

Write-Host "StartTime => $STARTTIME"
Write-Host "EndTime => $(Get-Date)"
$ProcessFolder = (Get-ChildItem ffmpeg).Name
Move-Item -Path ffmpeg/$ProcessFolder/* -Destination .\ffmpeg -Force
Remove-Item -Path .\ffmpeg/$ProcessFolder -Recurse -Force