# Modele de creation AD : aucune suppression d'objet.
# A adapter, relire et executer sur un controleur de domaine en PowerShell administrateur.
# Remplir les CSV et le domaine ci-dessous avant l'execution.

$DomaineAttendu = '[DOMAINE_AD]'
$OuPrincipales = @('Administration', 'Groupes', 'Postes', 'Serveurs', 'Utilisateurs')
$Repertoire = Split-Path -Parent $MyInvocation.MyCommand.Path

Import-Module ActiveDirectory -ErrorAction Stop
$ErrorActionPreference = 'Stop'

if ($DomaineAttendu -match '\[') {
    throw 'Remplacez [DOMAINE_AD] par votre vrai domaine avant de lancer le script.'
}

$Domaine = Get-ADDomain
if ($Domaine.DNSRoot -ne $DomaineAttendu) {
    throw "Domaine inattendu : $($Domaine.DNSRoot). Attendu : $DomaineAttendu"
}

$Services = @(Import-Csv -LiteralPath (Join-Path $Repertoire 'services.csv') -Encoding UTF8)
$Personnes = @(Import-Csv -LiteralPath (Join-Path $Repertoire 'utilisateurs.csv') -Encoding UTF8)

if ($Services.Count -eq 0 -or $Personnes.Count -eq 0) {
    throw 'Completer services.csv et utilisateurs.csv avant execution.'
}
if ((@($Services | Where-Object { $_.Service -match '\[' })).Count -gt 0 -or
    (@($Personnes | Where-Object { $_.Service -match '\[' -or $_.Prenom -match '\[' -or $_.Nom -match '\[' -or $_.Identifiant -match '\[' })).Count -gt 0) {
    throw 'Remplacez tous les champs entre crochets dans les CSV.'
}

$NomsServices = @($Services | ForEach-Object { $_.Service })
if (@($NomsServices | Select-Object -Unique).Count -ne $NomsServices.Count) {
    throw 'Un nom de service apparait plusieurs fois dans services.csv.'
}
if (@($Personnes.Identifiant | Select-Object -Unique).Count -ne $Personnes.Count) {
    throw 'Un identifiant apparait plusieurs fois dans utilisateurs.csv.'
}
foreach ($Service in $NomsServices) {
    if (@($Personnes | Where-Object { $_.Service -eq $Service }).Count -ne 3) {
        throw "Le service $Service doit avoir exactement trois personnes dans utilisateurs.csv."
    }
}
foreach ($Personne in $Personnes) {
    if ($Personne.Service -notin $NomsServices) {
        throw "Service inconnu pour $($Personne.Identifiant) : $($Personne.Service)"
    }
}

$MotDePasse = Read-Host 'Mot de passe initial des nouveaux comptes' -AsSecureString
$Base = $Domaine.DistinguishedName
foreach ($Nom in $OuPrincipales) {
    $Ou = Get-ADOrganizationalUnit -LDAPFilter "(ou=$Nom)" -SearchBase $Base -SearchScope OneLevel
    if (-not $Ou) {
        New-ADOrganizationalUnit -Name $Nom -Path $Base
        Write-Host "OU creee : $Nom"
    }
}

$CheminUtilisateurs = "OU=Utilisateurs,$Base"
$CheminGroupes = "OU=Groupes,$Base"
foreach ($Service in $NomsServices) {
    $Ou = Get-ADOrganizationalUnit -LDAPFilter "(ou=$Service)" -SearchBase $CheminUtilisateurs -SearchScope OneLevel
    if (-not $Ou) {
        New-ADOrganizationalUnit -Name $Service -Path $CheminUtilisateurs
        Write-Host "OU de service creee : $Service"
    }
    $NomGroupe = "GG_$Service"
    $Groupe = Get-ADGroup -Filter "SamAccountName -eq '$NomGroupe'" -ErrorAction SilentlyContinue
    if (-not $Groupe) {
        New-ADGroup -Name $NomGroupe -SamAccountName $NomGroupe -GroupScope Global -GroupCategory Security -Path $CheminGroupes
        Write-Host "Groupe cree : $NomGroupe"
    } elseif ($Groupe.DistinguishedName -notlike "*,OU=Groupes,$Base") {
        throw "Le groupe $NomGroupe existe hors de l'OU Groupes."
    }
}

foreach ($Personne in $Personnes) {
    $Existant = Get-ADUser -Filter "SamAccountName -eq '$($Personne.Identifiant)'" -ErrorAction SilentlyContinue
    if (-not $Existant) {
        $NomComplet = "$($Personne.Prenom) $($Personne.Nom)"
        New-ADUser -Name $NomComplet -GivenName $Personne.Prenom -Surname $Personne.Nom `
            -DisplayName $NomComplet -SamAccountName $Personne.Identifiant `
            -UserPrincipalName "$($Personne.Identifiant)@$DomaineAttendu" `
            -Path "OU=$($Personne.Service),$CheminUtilisateurs" `
            -AccountPassword $MotDePasse -Enabled $true
        Write-Host "Compte cree : $($Personne.Identifiant)"
    } elseif ($Existant.DistinguishedName -notlike "*,OU=$($Personne.Service),$CheminUtilisateurs") {
        throw "Le compte $($Personne.Identifiant) existe hors de l'OU prevue."
    }
    $NomGroupe = "GG_$($Personne.Service)"
    $Membre = Get-ADGroupMember -Identity $NomGroupe | Where-Object { $_.SamAccountName -eq $Personne.Identifiant }
    if (-not $Membre) {
        Add-ADGroupMember -Identity $NomGroupe -Members $Personne.Identifiant
    }
}

Write-Host "Termine : $($NomsServices.Count) services et $($Personnes.Count) comptes definis dans les CSV."
