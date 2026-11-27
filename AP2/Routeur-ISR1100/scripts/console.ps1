# Envoie des commandes au routeur Cisco via le port console (COM5, CH340, pilote 3.4) sans PuTTY.
# Usage : .\console.ps1 -Commands "show version","show ip interface brief" [-Wait 2] [-Port COM5]
param([string[]]$Commands = @(""), [int]$Wait = 2, [string]$Port = 'COM5')

$p = New-Object System.IO.Ports.SerialPort $Port, 9600, 'None', 8, 'One'
$p.Open()
try {
  foreach ($c in $Commands) {
    $p.Write("$c`r")
    Start-Sleep $Wait
    $out = ''
    do { $chunk = $p.ReadExisting(); $out += $chunk; if ($chunk) { Start-Sleep -Milliseconds 600 } } while ($chunk)
    $out
  }
} finally { $p.Close() }
