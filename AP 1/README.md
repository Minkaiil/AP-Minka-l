# AP 1 - Services d'infrastructure autour d'Active Directory

## Contexte

Mon projet consiste à construire l'infrastructure système d'une entreprise fictive de [NOMBRE_EMPLOYÉS] personnes, organisée en 10 services : Réseau & Système, Direction / DSI, RH / Compta / Juridique / Secrétariat administratif, Communication / Rédaction, Développement, Commercial, Labo-Recherche, Accueil, Visiteurs et Démonstration. Je m'appuie sur [LIEN_OU_NOM_DU_DOSSIER_DE_CONTEXTE] pour définir le périmètre de l'AP 1.

## Objectif

Je mets en place sur **Proxmox** :

- un contrôleur de domaine **Active Directory** avec DNS (VM 600) ;
- un **script PowerShell** qui crée les OU, groupes et comptes en production à partir de fichiers CSV ;
- un second contrôleur de domaine (**AD secondaire**) pour la tolérance de panne ;
- un serveur de gestion de parc et de tickets **GLPI** (VM Debian) ;
- un serveur de fichiers **TrueNAS** intégré au domaine.

## Documentation

| Sujet | Description |
| --- | --- |
| [Architecture du réseau](../Architecture%20du%20r%C3%A9seau/Architecture-du-reseau.md) | VLAN, adressage et flux |
| [Active Directory](Docs/Active%20Directory/Active-Directory.md) | VM, domaine, OU, groupes, comptes et script |
| [AD secondaire](Docs/AD%20secondaire/AD-secondaire.md) | Second contrôleur de domaine et réplication |
| [GLPI](Docs/GLPI/GLPI.md) | Installation et liaison avec l'annuaire |
| [TrueNAS](Docs/TrueNAS/TrueNAS.md) | Stockage, partages et droits par groupe |

## Avancement

| Chantier | État |
| --- | --- |
| VM du contrôleur de domaine, IP, AD DS + DNS | Réalisé |
| OU, groupes et comptes par service | Réalisé (à documenter avec les captures) |
| Script de création d'utilisateurs | Modèle fourni, à tester |
| AD secondaire | À réaliser |
| GLPI | À réaliser |
| TrueNAS | À réaliser |

Je mets ce tableau à jour au fur et à mesure et je ne passe un chantier à « Réalisé » qu'après l'avoir testé.
