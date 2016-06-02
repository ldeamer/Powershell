

$ScreenBounds = [Windows.Forms.SystemInformation]::WorkingArea
$ScreenshotObject = New-Object Drawing.Bitmap $ScreenBounds.Width, $ScreenBounds.Height
$DrawingGraphics = [Drawing.Graphics]::FromImage($ScreenshotObject)
$DrawingGraphics.CopyFromScreen($ScreenBounds.Location, [Drawing.Point]::Empty, $ScreenBounds.Size)
$DrawingGraphics.Dispose()
$ScreenshotObject.Save('c:\users\ldeamer\desktop\screengrab.png')
$ScreenshotObject.Dispose()
