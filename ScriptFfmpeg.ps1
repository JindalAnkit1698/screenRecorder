$STARTTIME = Get-Date
Write-Host "Script to setup FFMPEG" -ForegroundColor Blue

$ffmpegPath = "C:\ffmpeg\bin"
$targetPath = "."
$checkPath = $env:Path -split ';' | Where-Object { $_ -like '*ffmpeg*' }
$URL = "https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-6.0-essentials_build.zip"
$OUTFILE = "ffmpeg.zip"
if (-not $checkPath) {
    if (Test-Path -Path $ffmpegPath) {
        $env:Path = "$ffmpegPath;" + $env:Path
    }
    else {
        $downloadedFile = Invoke-WebRequest -Uri $URL -OutFile $OUTFILE
        if ($downloadedFile.StatusCode -eq 200) {
            Expand-Archive -Path $OUTFILE
        }
        Expand-Archive -Path $OUTFILE -DestinationPath .
        Remove-Item -Path $OUTFILE -Force
        Get-ChildItem -Path $targetPath
    }
}

Invoke-WebRequest -Uri $URL -OutFile $OUTFILE

Expand-Archive -Path $OUTFILE

Write-Host "Done" -ForegroundColor Green

Write-Host "StartTime => $STARTTIME"
$ProcessFolder = (Get-ChildItem ffmpeg).Name
Move-Item -Path ffmpeg/$ProcessFolder/* -Destination .\ffmpeg -Force
Remove-Item -Path .\ffmpeg/$ProcessFolder -Recurse -Force