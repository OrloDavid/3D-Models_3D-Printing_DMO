
$prefix = "..\Source\" # Prefix if needed, i.e. c:\path_to_start or ..\Dir\
param(
    [string]$rootDirectory = "C:\path",
    [string]$startFrom = "C:\path", # part of path to cut off from output and replace with prefix
    [string]$outputFile = "C:\path\uvis-dirs.txt",
    [string[]]$ignoreDirs = @() # Directories to ignore "c:\maindir\subdir,c:\maindir\anotherdir"
)

function Get-RelativeFolders {
    param(
        [string]$Path,
        [string]$RelativeTo,
        [string[]]$IgnorePaths
    )

    $relativeFolders = @()
    Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
        $fullPath = $_.FullName
        $shouldIgnore = $IgnorePaths | Where-Object { $fullPath.StartsWith($_) }
        if (-not $shouldIgnore) {
            $relativePath = $fullPath -replace [regex]::Escape($RelativeTo), '$prefix'
            $relativeFolders += $relativePath
        }
    }

    return $relativeFolders
}

# Ensure the path ends with a backslash
$rootDirectory = $rootDirectory.TrimEnd('\') + '\'
$startFrom = $startFrom.TrimEnd('\') + '\'

# Ensure all ignore directories end with a backslash
$ignoreDirs = $ignoreDirs | ForEach-Object { $_.TrimEnd('\') + '\' }

$relativeFolders = Get-RelativeFolders -Path $rootDirectory -RelativeTo $rootDirectory -IgnorePaths $ignoreDirs

# Output with line breaks
$relativeFolders -join "`r`n" | Out-File -FilePath $outputFile

# Add 7 line breaks
"`r`n`r`n`r`n`r`n`r`n`r`n`r`n" | Out-File -FilePath $outputFile -Append

# Output without line breaks
$relativeFolders -join ';' | Out-File -FilePath $outputFile -Append
