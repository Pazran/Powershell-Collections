$target = 1024
mkdir upscaled -ErrorAction SilentlyContinue
Add-Type -AssemblyName System.Drawing

Get-ChildItem *.jpg | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_)

    # If image already bigger than target, just copy (no downscale)
    if ($img.Width -ge $target -and $img.Height -ge $target) {
        Copy-Item $_ "upscaled\$_"
        $img.Dispose()
        return
    }

    # Upscale ratio = make smallest side match target
    $ratio = [Math]::Max($target / $img.Width, $target / $img.Height)
    $newW = [int]($img.Width * $ratio)
    $newH = [int]($img.Height * $ratio)

    $bmp = New-Object System.Drawing.Bitmap $newW, $newH
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = "HighQualityBicubic"
    $g.DrawImage($img, 0, 0, $newW, $newH)

    $bmp.Save("upscaled\$($_.BaseName).jpg")
    $bmp.Dispose(); $g.Dispose(); $img.Dispose()
}
