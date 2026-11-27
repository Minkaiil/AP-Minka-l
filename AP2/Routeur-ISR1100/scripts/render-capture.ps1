# Transforme une sortie texte de la console Cisco en capture PNG façon terminal.
# Usage : .\render-capture.ps1 -In captures\01.txt -Out images\01.png -Title "Console R-REDONE"
param([Parameter(Mandatory)][string]$In, [Parameter(Mandatory)][string]$Out, [string]$Title = 'R-REDONE - console')
Add-Type -AssemblyName System.Drawing

$lines = (Get-Content $In -Encoding UTF8) | ForEach-Object { $_.TrimEnd() }
$font  = New-Object System.Drawing.Font('Consolas', 13)
$bold  = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$tmp   = New-Object System.Drawing.Bitmap 1, 1
$g0    = [System.Drawing.Graphics]::FromImage($tmp)
$lh    = [int][Math]::Ceiling($font.GetHeight($g0)) + 2
$maxW  = ($lines | ForEach-Object { $g0.MeasureString($_, $font).Width } | Measure-Object -Maximum).Maximum
$g0.Dispose(); $tmp.Dispose()

$pad = 18; $bar = 34
$w = [int][Math]::Max(700, $maxW + 2 * $pad); $h = $bar + $pad * 2 + $lh * [Math]::Max(1, $lines.Count)
$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.TextRenderingHint = 'ClearTypeGridFit'
$g.Clear([System.Drawing.Color]::FromArgb(12, 12, 12))
$g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(44, 44, 44))), 0, 0, $w, $bar)
$g.DrawString($Title, $bold, [System.Drawing.Brushes]::Gainsboro, 12, 8)

$cPrompt = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(97, 214, 214))
$cLog    = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(150, 150, 150))
$cOk     = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(120, 220, 120))
$cTxt    = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 220, 220))
$y = $bar + $pad
foreach ($l in $lines) {
  $b = $cTxt
  if ($l -match '^\S+[#>]') { $b = $cPrompt }
  elseif ($l -match '^\*\w{3} \d') { $b = $cLog }
  elseif ($l -match '\[OK\]|Enabled|\bup\b') { $b = $cOk }
  $g.DrawString($l, $font, $b, $pad, $y); $y += $lh
}
$g.Dispose()
New-Item -ItemType Directory -Force (Split-Path $Out) | Out-Null
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
"Capture : $Out"
