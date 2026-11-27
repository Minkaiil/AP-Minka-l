# Partie B de la configuration R-REDONE : adresses, mots de passe et SNMPv3.
# C'est toi qui tapes les secrets : ils ne sont ni affichés, ni enregistrés.
param([string]$Port = 'COM5')

function Read-Ip($msg, [switch]$Optional) {
  while ($true) {
    $v = Read-Host $msg
    if ($Optional -and -not $v) { return $null }
    if ($v -match '^(\d{1,3}\.){3}\d{1,3}$') { return $v }
    Write-Host "Adresse IP invalide." -ForegroundColor Red
  }
}
function Read-Secret($msg, $min) {
  while ($true) {
    $a = Read-Host $msg -AsSecureString; $b = Read-Host "  Confirme" -AsSecureString
    $pa = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($a))
    $pb = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($b))
    if ($pa -ne $pb) { Write-Host "  Les deux saisies different." -ForegroundColor Red; continue }
    if ($pa.Length -lt $min -or $pa -match '\s|\?') { Write-Host "  $min caracteres minimum, sans espace ni '?'." -ForegroundColor Red; continue }
    return $pa
  }
}

Write-Host "`n=== Adresses ===" -ForegroundColor Cyan
Write-Host "SSH autorise depuis toute la plage 192.168.100.0/24."
Write-Host "IP du serveur Zabbix telle que le routeur la voit."
Write-Host "Si Zabbix est en 10.2.81.x derriere le pfSense, c'est l'IP WAN du pfSense sur 192.168.100.x."
$ipZbx = Read-Ip "IP Zabbix (Entree vide = SNMP plus tard)" -Optional

Write-Host "`n=== Mots de passe ===" -ForegroundColor Cyan
$mdpAdmin  = Read-Secret "Mot de passe du compte admin-minka (12 car. min.)" 12
do { $mdpEnable = Read-Secret "Mot de passe enable (different du precedent)" 12
     if ($mdpEnable -eq $mdpAdmin) { Write-Host "  Doit etre different du mot de passe admin-minka." -ForegroundColor Red } } while ($mdpEnable -eq $mdpAdmin)
if ($ipZbx) {
  $cleAuth = Read-Secret "Cle SNMPv3 d'authentification SHA (8 car. min.)" 8
  $clePriv = Read-Secret "Cle SNMPv3 de chiffrement AES (8 car. min.)" 8
}

$cmds = @(
  "", "configure terminal",
  "security passwords min-length 12",
  "username admin-minka privilege 15 algorithm-type scrypt secret $mdpAdmin",
  "enable algorithm-type scrypt secret $mdpEnable",
  "ip access-list standard ADMIN-SSH", " 10 permit 192.168.100.0 0.0.0.255", " 20 deny any log", " exit",
  "login block-for 120 attempts 3 within 60",
  "login quiet-mode access-class ADMIN-SSH",
  "line vty 0 4", " access-class ADMIN-SSH in", " exec-timeout 5 0", " transport input ssh", " login local", " exit",
  "no ip access-list standard ACL-SSH-ADMIN",
  "no username admin", ""   # IOS demande [confirm] : la ligne vide confirme
)
if ($ipZbx) {
  $cmds += "ip access-list standard SNMP-ZABBIX", " permit host $ipZbx", " deny any log", " exit",
           "snmp-server group ZABBIX v3 priv read LECTURE access SNMP-ZABBIX",
           "snmp-server user zabbix ZABBIX v3 auth sha $cleAuth priv aes 128 $clePriv"
}
# En dernier : la console demandera desormais un identifiant.
$cmds += "line con 0", " exec-timeout 5 0", " logging synchronous", " login local", " exit", "end", "write memory"

$p = New-Object System.IO.Ports.SerialPort $Port, 9600, 'None', 8, 'One'
$p.Open()
try {
  foreach ($c in $cmds) {
    $p.Write("$c`r"); Start-Sleep -Milliseconds 1500
    $o = $p.ReadExisting()                          # l'echo contient les secrets : jamais affiche
    if ($o -match '% (Invalid|Incomplete|Ambiguous)|% Password') {
      Write-Host "Erreur IOS sur la ligne : $(($c -split ' ')[0..2] -join ' ') ..." -ForegroundColor Red
    }
  }
  Start-Sleep 4; $null = $p.ReadExisting()
  $p.Write("show running-config | include ^username|^enable|^security|^login|access-class`r"); Start-Sleep 3
  Write-Host ($p.ReadExisting() -replace '(secret 9 )\S+', '$1<hash masque>')
  $p.Write("show ip access-lists ADMIN-SSH`r"); Start-Sleep 2; Write-Host $p.ReadExisting()
  if ($ipZbx) { $p.Write("show snmp user`r"); Start-Sleep 3; Write-Host $p.ReadExisting() }
} finally { $p.Close(); $mdpAdmin = $mdpEnable = $cleAuth = $clePriv = $null }
Write-Host "`nTermine. Dis a Claude que c'est fait." -ForegroundColor Green
