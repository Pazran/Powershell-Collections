mkdir resized
Add-Type -AssemblyName System.Drawing
Get-ChildItem *.jpg | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    $bmp = New-Object System.Drawing.Bitmap 1024,1024
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Black)
    $ratio = [Math]::Min(1024/$img.Width, 1024/$img.Height)
    $newW = [int]($img.Width*$ratio)
    $newH = [int]($img.Height*$ratio)
    $x = (1024-$newW)/2
    $y = (1024-$newH)/2
    $g.DrawImage($img, $x, $y, $newW, $newH)
    $out = "resized\$($_.BaseName).jpg"
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $img.Dispose(); $bmp.Dispose(); $g.Dispose()
}
