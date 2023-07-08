# $STARTTIME = Get-Date
Write-Host "Script to setup FFMPEG" -ForegroundColor Blue

$ffmpegPath = "C:\ffmpeg\bin"
$targetPath = "C:\ffmpeg"
$checkPath = $env:Path -split ';' | Where-Object { $_ -like '*ffmpeg*' }
$url = "https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-6.0-essentials_build.zip"
$outFile = "C:\ffmpeg.zip"

# Function to set the temporary path
function Set-TempPath {
    $env:Path = "$ffmpegPath;" + $env:Path
}

if (-not $checkPath) {
    if (-not (Test-Path -Path $ffmpegPath)) {
        Invoke-WebRequest -Uri $url -OutFile $outFile
        Expand-Archive -Path $outFile -DestinationPath $targetPath
        Remove-Item -Path $outFile
        $extractedFolder = Get-ChildItem -Path $targetPath
        Get-ChildItem -LiteralPath $extractedFolder.FullName -Recurse | Move-Item -Destination $targetPath
        Remove-Item -LiteralPath $extractedFolder.FullName -Force
    }
    Set-TempPath
}
$userName = $env:USERNAME
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outputFile = "C:\Users\$userName\Videos\$timestamp.mp4"
Write-Host "Recording started to stop the recoding close the child window" -ForegroundColor Cyan
Start-Process -FilePath ffmpeg -ArgumentList "-f gdigrab -framerate 16 -i desktop -an -c:v libx264 -preset veryfast -pix_fmt yuv420p -b:v 600k -maxrate 600k $outputFile" -Wait
Write-Host "converting wait"
Start-Process -FilePath ffmpeg -ArgumentList "-i $outputFile `"C:\Users\$userName\Videos\$timestamp.gif`"" -Wait -WindowStyle Hidden
Write-Host "Done"