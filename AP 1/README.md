# AP 1 - Active Directory et services d'infrastructure

## Contexte

Je construis l'infrastructure système de **RedOne**, un laboratoire pharmaceutique dont le siège parisien compte plus de 350 postes et plus de 100 serveurs virtuels (d'après le document de contexte). Le réseau y est segmenté en VLAN par service : Réseau & Système, Direction / DSI, RH / Compta / Juridique / Secrétariat administratif, Communication / Rédaction, Développement, Commercial, Labo-Recherche, Accueil, Visiteurs et Démonstration, plus les zones Serveurs et Sortie.

## Objectif

Mettre en place sur **Proxmox** :

- un contrôleur de domaine **Active Directory** avec DNS pour le domaine `redone.local` ;
- une structure d'**OU**, des groupes et des comptes par service, créés par scripts PowerShell ;
- un poste **Windows 11** joint au domaine ;
- un second contrôleur de domaine (**AD secondaire**) pour la tolérance de panne ;
- un serveur de gestion de parc et de tickets **GLPI**, relié à l'annuaire ;
- un serveur de fichiers **TrueNAS** avec des droits par groupe.

## Chantiers

| # | Chantier | Page | État |
| --- | --- | --- | --- |
| 1 | VM DC01, Windows Server 2022, réseau | [Serveur](Docs/Serveur/Serveur.md) | Réalisé |
| 2 | AD DS et DNS, domaine `redone.local` | [Active Directory](Docs/Active%20Directory/Active-Directory.md) | Réalisé |
| 3 | Structure d'OU | [Structure d'OU](Docs/Active%20Directory/Structure-OU.md) | Réalisé |
| 4 | Groupes et comptes utilisateurs | [Groupes et comptes](Docs/Active%20Directory/Groupes-Comptes.md) | Réalisé |
| 5 | Poste Windows 11, jonction au domaine | à venir | À venir |
| 6 | DHCP | à venir | Reporté |
| 7 | AD secondaire | [AD secondaire](Docs/AD%20secondaire/AD-secondaire.md) | À venir |
| 8 | GLPI | [GLPI](Docs/GLPI/GLPI.md) | À venir |
| 9 | TrueNAS | [TrueNAS](Docs/TrueNAS/TrueNAS.md) | À venir |

Le réseau et l'adressage sont décrits dans [Architecture du réseau](../Architecture-du-reseau/Architecture-du-reseau.md).

## Méthode

Chaque chantier suit la même démarche : je réalise l'étape sur Proxmox, je prends mes captures au fil de l'eau, je vérifie le résultat par un test, puis je pose un snapshot Proxmox (sans la RAM) pour pouvoir revenir à cet état. La documentation permet de refaire l'AP de zéro à tout moment.
