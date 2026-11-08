# Creation des groupes et des comptes utilisateurs - redone.local
# A lancer en PowerShell administrateur sur DC01, apres Creer-OU.ps1
# Regle de login : 1ere lettre du prenom + nom, en minuscules (ex : amartin)
# Mot de passe de laboratoire : Nom + 123!  (ex : Martin123!)
# Le script peut etre relance : il ne cree que ce qui manque et ne supprime rien.
Import-Module ActiveDirectory
$ErrorActionPreference = 'Stop'

$Domaine = (Get-ADDomain).DNSRoot            # redone.local
$Base = (Get-ADDomain).DistinguishedName     # DC=redone,DC=local
$CheminUtilisateurs = "OU=Utilisateurs,$Base"
$CheminGroupes = "OU=Groupes,$Base"

# Donnees : service -> 3 comptes (prenom, nom). Le premier compte est le responsable.
$Services = [ordered]@{
    'Reseau-Systeme'          = @(@('Karim','Haddad'),    @('Alex','Martin'),     @('Thomas','Bernard'))
    'Direction-DSI'           = @(@('Claire','Fontaine'), @('Julie','Petit'),     @('Marc','Durand'))
    'RH-Compta-Juridique'     = @(@('Nadia','Benali'),    @('Sophie','Dubois'),   @('Lucas','Thomas'))
    'Communication-Redaction' = @(@('Pierre','Lambert'),  @('Emma','Robert'),     @('Hugo','Richard'))
    'Developpement'           = @(@('Yanis','Kaci'),      @('Manon','Leroy'),     @('Louis','Moreau'))
    'Commercial'              = @(@('Laura','Perrin'),    @('Sarah','Simon'),     @('David','Laurent'))
    'Labo-Recherche'          = @(@('Isabelle','Faure'),  @('Chloe','Michel'),    @('Antoine','Garcia'))
    'Accueil'                 = @(@('Fatima','Diallo'),   @('Audrey','David'),    @('Nicolas','Bertrand'))
    'Visiteurs-Medicaux'      = @(@('Olivier','Marchand'),@('Paul','Roux'),       @('Camille','Vincent'))
    'Demonstration'           = @(@('Julien','Blanc'),    @('Elodie','Fournier'), @('Maxime','Morel'))
}

# Verification : les OU creees par Creer-OU.ps1 doivent exister
$OuAttendues = @($CheminUtilisateurs, $CheminGroupes)
foreach ($Service in $Services.Keys) { $OuAttendues += "OU=$Service,$CheminUtilisateurs" }
foreach ($Ou in $OuAttendues) {
    try { Get-ADOrganizationalUnit -Identity $Ou | Out-Null }
    catch { throw "OU introuvable : $Ou. Lancer d'abord Creer-OU.ps1." }
}

function New-GroupeSiAbsent([string]$Nom, [string]$Description) {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$Nom'")) {
        New-ADGroup -Name $Nom -SamAccountName $Nom -GroupScope Global -GroupCategory Security -Path $CheminGroupes -Description $Description
        Write-Host "Groupe cree : $Nom" -ForegroundColor Green
    } else {
        Write-Host "Groupe deja present : $Nom"
    }
}

function Add-MembreSiAbsent([string]$Groupe, [string]$Login) {
    $Membre = Get-ADGroupMember -Identity $Groupe | Where-Object { $_.SamAccountName -eq $Login }
    if (-not $Membre) { Add-ADGroupMember -Identity $Groupe -Members $Login }
}

New-GroupeSiAbsent 'GG_Responsables' 'Responsables de service'
$Total = 0

foreach ($Service in $Services.Keys) {
    $CheminService = "OU=$Service,$CheminUtilisateurs"
    $Groupe = "GG_$Service"
    Write-Host "== $Service ==" -ForegroundColor Cyan
    New-GroupeSiAbsent $Groupe "Utilisateurs du service $Service"

    $Comptes = $Services[$Service]
    for ($i = 0; $i -lt $Comptes.Count; $i++) {
        $Prenom = $Comptes[$i][0]
        $Nom = $Comptes[$i][1]
        $Login = (($Prenom.Substring(0, 1) + $Nom).ToLower()) -replace '[^a-z0-9]', ''
        $EstResponsable = ($i -eq 0)
        if ($EstResponsable) { $Titre = 'Responsable' } else { $Titre = 'Collaborateur' }

        if (-not (Get-ADUser -Filter "SamAccountName -eq '$Login'")) {
            $MotDePasse = ConvertTo-SecureString ($Nom + '123!') -AsPlainText -Force
            # Pas de DisplayName a la creation : Windows refuse un mot de passe qui contient une partie du nom complet.
            $Parametres = @{
                Name                 = "$Prenom $Nom"
                GivenName            = $Prenom
                Surname              = $Nom
                SamAccountName       = $Login
                UserPrincipalName    = "$Login@$Domaine"
                EmailAddress         = "$Login@redone.com"
                Department           = $Service
                Title                = $Titre
                Path                 = $CheminService
                AccountPassword      = $MotDePasse
                Enabled              = $true
                PasswordNeverExpires = $true
            }
            try {
                New-ADUser @Parametres
                Set-ADUser -Identity $Login -DisplayName "$Prenom $Nom"
                Write-Host "  Compte cree : $Login ($Titre)" -ForegroundColor Green
            } catch {
                Write-Host "  ERREUR pour $Login : $_" -ForegroundColor Red
                continue
            }
        } else {
            Write-Host "  Compte deja present : $Login"
        }

        Add-MembreSiAbsent $Groupe $Login
        if ($EstResponsable) { Add-MembreSiAbsent 'GG_Responsables' $Login }
        $Total++
    }
}

Write-Host "Termine : $($Services.Count) services, $Total comptes definis." -ForegroundColor Cyan
Get-ADUser -Filter * -SearchBase $CheminUtilisateurs -Properties Department, Title |
    Sort-Object Department, Title, SamAccountName |
    Select-Object SamAccountName, Department, Title |
    Format-Table -AutoSize
