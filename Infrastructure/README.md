# Infrastructure de base - RedOne

Cette partie décrit l'infrastructure commune sur laquelle reposent les deux ateliers professionnels : un domaine Active Directory, son DNS, un second contrôleur, un poste client et un serveur de fichiers, le tout sur le VLAN 600 de Proxmox. Elle se construit une fois ; les ateliers [AP 1](../AP1/README.md) et [AP 2](../AP2/README.md) s'y ajoutent.

## Chantiers

| # | Chantier | Page | État |
| --- | --- | --- | --- |
| 0 | Architecture du réseau | [Architecture du réseau](Architecture-du-reseau/Architecture-du-reseau.md) | Plan défini |
| 1 | VM DC01, Windows Server 2022, réseau | [Serveur](Serveur/Serveur.md) | Réalisé |
| 2 | AD DS et DNS, domaine `redone.local` | [Active Directory](Active-Directory/Active-Directory.md) | Réalisé |
| 3 | Structure d'OU | [Structure d'OU](Active-Directory/Structure-OU.md) | Réalisé |
| 4 | Groupes et comptes utilisateurs | [Groupes et comptes](Active-Directory/Groupes-Comptes.md) | Réalisé |
| 5 | Poste Windows 11, jonction au domaine | [Poste client](Client/Client-Windows11.md) | Réalisé |
| 6 | AD secondaire | [AD secondaire](AD-secondaire/AD-secondaire.md) | Réalisé |
| 7 | TrueNAS, partages par groupe | [TrueNAS](TrueNAS/TrueNAS.md) | Réalisé |
| - | DHCP | à venir | Reporté |

## Machines

| Machine | Nom Proxmox (VMID) | Nom du système | IP | VLAN |
| --- | --- | --- | --- | --- |
| Premier contrôleur de domaine | `DC01-REDONE` (600) | `DC01` | 10.2.81.2/24 | 600 |
| Poste utilisateur Windows 11 | `CLIENT01` (601) | `CLIENT01` | 10.2.81.10/24 | 600 |
| Second contrôleur de domaine | `DC02-REDONE` (602) | `DC02` | 10.2.81.3/24 | 600 |
| Serveur de fichiers TrueNAS | `TrueNAS` (603) | `truenas` | 10.2.81.4/24 | 600 |

DNS des machines : `10.2.81.2` (`DC01`) puis `10.2.81.3` (`DC02`). Passerelle : `10.2.81.1`.

## Méthode

Chaque chantier suit la même démarche : je réalise l'étape sur Proxmox, je prends mes captures au fil de l'eau, je vérifie le résultat par un test, puis je pose un snapshot Proxmox (sans la RAM) pour pouvoir revenir à cet état. La documentation permet de refaire l'infrastructure de zéro à tout moment.
