# Function to organize files in a specified directory
function Organize-Files {
    param (
        [string]$sourceDir = "C:\Documents\Unsorted"
    )

    # Get all files in the source directory
    $files = Get-ChildItem -Path $sourceDir -File

    foreach ($file in $files) {
        # Extract the file extension (without the dot)
        $extension = $file.Extension.TrimStart(".")

        # Define the destination folder based on the file type
        switch ($extension.ToLower()) {
            { $_ -in @('png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Images"
                break
            }
            { $_ -in @('txt', 'doc', 'docx', 'pdf', 'rtf') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Documents"
                break
            }
            { $_ -in @('mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'mpeg', 'm4v') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Videos"
                break
            }
            { $_ -in @('mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a', 'wma') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Audio"
                break
            }
            { $_ -in @('zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'xz') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Archives"
                break
            }
            { $_ -in @('exe', 'msi', 'bat', 'sh', 'ps1', 'vbs') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Executables"
                break
            }
            { $_ -in @('html', 'htm', 'css', 'js') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Web"
                break
            }
            { $_ -in @('xlsx', 'xls', 'csv', 'ods') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Spreadsheets"
                break
            }
            { $_ -in @('pptx', 'ppt', ' odp') } {
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Presentations"
                break
            }
            default {
                # If the file is not categorized, move it to a "Other" folder
                $destinationFolder = Join-Path -Path $sourceDir -ChildPath "Other"
                break
            }
        }

        # Create the destination folder if it doesn't exist
        if (-Not (Test-Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder
        }

        # Move the file to the destination folder
        Move-Item -Path $file.FullName -Destination $destinationFolder
    }

    Write-Output "Files organized successfully in $sourceDir."
}

# Call the function with the provided source directory or default directory
$sourceDir = if ($args.Count -eq 0) { "C:\Documents\Unsorted" } else { $args[0] }
Organize-Files -sourceDir $sourceDir