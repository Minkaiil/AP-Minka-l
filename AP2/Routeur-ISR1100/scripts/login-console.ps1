# Ouvre une session sur la console de R-REDONE (COM5) et la laisse ouverte pour Claude.
# C'est toi qui tapes l'identifiant et le mot de passe : ils ne sont ni affiches, ni enregistres.
# La session se ferme d'elle-meme apres 5 minutes sans commande (exec-timeout 5 0).
param([string]$Port = 'COM5')

$user = Read-Host "Identifiant [admin-minka]"; if (-not $user) { $user = 'admin-minka' }
$s = Read-Host "Mot de passe de $user" -AsSecureString
$pw = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))

$p = New-Object System.IO.Ports.SerialPort $Port, 9600, 'None', 8, 'One'
$p.Open()
function Send-Cmd($c, $ms = 1500) { $p.Write("$c`r"); Start-Sleep -Milliseconds $ms; $p.ReadExisting() }
try {
  $o = Send-Cmd "" 2500
  if ($o -match 'R-REDONE#') { Write-Host "Deja connecte en mode privilegie." -ForegroundColor Green; return }
  if ($o -notmatch 'Username:') { $o = Send-Cmd "" 2500 }
  $null = Send-Cmd $user
  $o = Send-Cmd $pw 3500
  if ($o -match 'R-REDONE#') {
    $null = Send-Cmd "terminal length 0"
    Write-Host "Connecte : R-REDONE#. Dis a Claude que c'est fait (dans les 5 minutes)." -ForegroundColor Green
  } elseif ($o -match 'R-REDONE>') {
    Write-Host "Connecte mais pas en mode privilegie (R-REDONE>)." -ForegroundColor Yellow
  } else {
    Write-Host "Connexion refusee. Attention : 3 echecs en 60 s bloquent les connexions 2 minutes." -ForegroundColor Red
  }
} finally { $p.Close(); $pw = $null }
