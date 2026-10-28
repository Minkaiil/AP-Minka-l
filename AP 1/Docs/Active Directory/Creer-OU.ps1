# Creation de la structure d'OU - redone.local
# A lancer en PowerShell administrateur sur DC01
# Le script peut etre relance : il ne cree que ce qui manque et ne supprime rien.
Import-Module ActiveDirectory
$ErrorActionPreference = 'Stop'

$Base = (Get-ADDomain).DistinguishedName   # DC=redone,DC=local

$OuPrincipales = 'Administration', 'Groupes', 'Postes', 'Serveurs', 'Utilisateurs'
$Services = 'Reseau-Systeme', 'Direction-DSI', 'RH-Compta-Juridique',
            'Communication-Redaction', 'Developpement', 'Commercial',
            'Labo-Recherche', 'Accueil', 'Visiteurs-Medicaux', 'Demonstration'

# 1. OU principales, directement sous le domaine
foreach ($Nom in $OuPrincipales) {
    $Existe = Get-ADOrganizationalUnit -Filter "Name -eq '$Nom'" -SearchBase $Base -SearchScope OneLevel
    if (-not $Existe) {
        New-ADOrganizationalUnit -Name $Nom -Path $Base
        Write-Host "OU creee : $Nom" -ForegroundColor Green
    } else {
        Write-Host "OU deja presente : $Nom"
    }
}

# 2. Une sous-OU par service, dans l'OU Utilisateurs
$CheminUtilisateurs = "OU=Utilisateurs,$Base"
foreach ($Service in $Services) {
    $Existe = Get-ADOrganizationalUnit -Filter "Name -eq '$Service'" -SearchBase $CheminUtilisateurs -SearchScope OneLevel
    if (-not $Existe) {
        New-ADOrganizationalUnit -Name $Service -Path $CheminUtilisateurs
        Write-Host "OU de service creee : $Service" -ForegroundColor Green
    } else {
        Write-Host "OU de service deja presente : $Service"
    }
}

# 3. Resultat
Get-ADOrganizationalUnit -Filter * |
    Sort-Object DistinguishedName |
    Select-Object Name, DistinguishedName |
    Format-Table -AutoSize
