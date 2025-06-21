param(
    [Parameter(Mandatory = $true)]
    [string]$AppName,
    
    [Parameter(Mandatory = $true)]
    [string]$Org
)

# Stop the script if any command fails
$ErrorActionPreference = "Stop"

# --- 1. Create/Reset the Temp Directory ---
if (Test-Path "temp") {
    Remove-Item -Recurse -Force "temp"
}
New-Item -ItemType Directory -Force -Path "temp" | Out-Null

# Change directory to temp and create a new Flutter project with FVM
Set-Location "temp"
& fvm flutter create $AppName --org $Org

# Return to the root directory
Set-Location ..

# --- 2. Prepare the Project Directory ---
# Create the projects\<AppName> folder if it doesn't exist
$projectPath = "projects\$AppName"
if (-not (Test-Path $projectPath)) {
    New-Item -ItemType Directory -Force -Path $projectPath | Out-Null
}

# --- 3. Clean Up the Template ---
Set-Location "template/app"
& fvm flutter clean
if (Test-Path "coverage") { Remove-Item -Recurse -Force "coverage" }
if (Test-Path ".idea")    { Remove-Item -Recurse -Force ".idea" }
& fvm flutter pub get
Set-Location ../..

# --- 4. Copy the Template to Temp ---
# This copies the entire "template" folder into temp (creating temp\template)
Copy-Item -Recurse "template" "temp" -Force

# --- 5. Remove Unwanted Template Directories and Files ---
if (Test-Path "temp\template\app\android") { Remove-Item -Recurse -Force "temp\template\app\android" }
if (Test-Path "temp\template\app\ios")     { Remove-Item -Recurse -Force "temp\template\app\ios" }
if (Test-Path "temp\template\app\web")       { Move-Item "temp\template\app\web" "temp\" }
if (Test-Path "temp\template\.env")          { Remove-Item -Force "temp\template\.env" }

# --- 6. Copy Template Files to the Project Directory ---
# Copy all contents of temp\template into projects\<AppName>
Copy-Item -Recurse "temp\template\*" $projectPath -Force

# Remove unwanted directories from the newly copied project
if (Test-Path "$projectPath\packages") { Remove-Item -Recurse -Force "$projectPath\packages" }
if (Test-Path "$projectPath\supabase") { Remove-Item -Recurse -Force "$projectPath\supabase" }

# --- 7. Copy Files from the Flutter Create Command ---
# These commands check if the directories exist and then copy them into the app folder
if (Test-Path "temp\$AppName\android") { 
    Copy-Item -Recurse "temp\$AppName\android" "$projectPath\app" -Force 
}
if (Test-Path "temp\$AppName\ios") { 
    Copy-Item -Recurse "temp\$AppName\ios" "$projectPath\app" -Force 
}
if (Test-Path "temp\$AppName\web") { 
    Copy-Item -Recurse "temp\$AppName\web" "$projectPath\app" -Force 
}

# Replace the web/index.html and flutter_bootstrap.js with those from temp\web
if (Test-Path "$projectPath\app\web\index.html") { 
    Remove-Item -Force "$projectPath\app\web\index.html" 
}
Copy-Item "temp\web\index.html" "$projectPath\app\web\" -Force
Copy-Item "temp\web\flutter_bootstrap.js" "$projectPath\app\web\" -Force

# --- 8. Replace Template App Name in Files ---
# For file types: *.dart, *.yaml, *.md, *.html, replace 'gadfly_flutter_template' with the app name
$extensions = @("*.dart", "*.yaml", "*.md", "*.html")
foreach ($ext in $extensions) {
    Get-ChildItem -Path $projectPath -Recurse -Filter $ext | ForEach-Object {
        (Get-Content $_.FullName) -replace "gadfly_flutter_template", $AppName | Set-Content $_.FullName
    }
}

# --- 9. Copy Additional Template Components ---
# Copy the packages directory
Copy-Item -Recurse "temp\template\packages" $projectPath -Force

# Prepare the supabase folder and copy its subdirectories/files
$supabasePath = "$projectPath\supabase"
if (-not (Test-Path $supabasePath)) {
    New-Item -ItemType Directory -Force -Path $supabasePath | Out-Null
}
Copy-Item -Recurse "temp\template\supabase\migrations" $supabasePath -Force
Copy-Item -Recurse "temp\template\supabase\functions" $supabasePath -Force
Copy-Item "temp\template\supabase\seed.sql" $supabasePath -Force

# --- 10. Run Flutter Commands in the Project's App Directory ---
Set-Location "$projectPath\app"
& fvm flutter clean
& fvm flutter pub get
& fvm dart fix --apply

# --- 11. Initialize Supabase ---
# Return to the project root folder for the supabase initialization
Set-Location ".."
& supabase init --with-vscode-settings

# --- 12. Copy VSCode Settings ---
# Return to the root folder and update VSCode extensions file
Set-Location "..\.."
if (Test-Path "$projectPath\.vscode\extensions.json") {
    Remove-Item -Force "$projectPath\.vscode\extensions.json"
}
Copy-Item "temp\template\.vscode\extensions.json" "$projectPath\.vscode\" -Force

# --- 13. Clean Up ---
if (Test-Path "temp") {
    Remove-Item -Recurse -Force "temp"
}
