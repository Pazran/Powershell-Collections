$target = 1024   # <--- set max dimension here
mkdir resized -ErrorAction SilentlyContinue
Add-Type -AssemblyName System.Drawing

Get-ChildItem -Filter *.jpg | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)

    # If image is smaller than target → skip resizing
    if ($img.Width -le $target -and $img.Height -le $target) {
        Copy-Item $_.FullName "resized\$($_.BaseName).jpg"
        $img.Dispose()
        return
    }

    # Compute resize ratio
    $ratio = [Math]::Min($target / $img.Width, $target / $img.Height)
    $newW = [int]($img.Width * $ratio)
    $newH = [int]($img.Height * $ratio)

    # Create resized image
    $bmp = New-Object System.Drawing.Bitmap $newW, $newH
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = "HighQualityBicubic"
    $g.DrawImage($img, 0, 0, $newW, $newH)

    # Save output
    $bmp.Save("resized\$($_.BaseName).jpg",
        [System.Drawing.Imaging.ImageFormat]::Jpeg)

    $img.Dispose()
    $bmp.Dispose()
    $g.Dispose()
}
