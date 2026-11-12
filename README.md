# Infrastructure RedOne - Minkaïl (BTS SIO 2, option SISR)

Ce dépôt documente l'infrastructure que je construis pour mes deux ateliers professionnels (AP) : un système d'information d'entreprise virtualisé sur Proxmox, organisé autour d'Active Directory. Chaque page décrit une étape reproductible, avec mes valeurs, mes captures et les points à justifier à l'oral.

L'entreprise fictive est le laboratoire pharmaceutique **RedOne**, décrit dans le document de contexte « RedOne - Organisation » (CERTA, non reproduit ici).

## Organisation

Le travail se fait en trois temps :

1. **[Infrastructure de base](Infrastructure/README.md)** : domaine Active Directory, DNS, second contrôleur, postes clients et serveur de fichiers. C'est le socle commun aux deux ateliers.
2. **[AP 1](AP1/README.md)** : services d'infrastructure ajoutés sur ce socle (GLPI et un second service).
3. **[AP 2](AP2/README.md)** : interconnexion de Proxmox et des switchs physiques, segmentation de bout en bout.

## Avancement

| Partie | Chantier | Page | État |
| --- | --- | --- | --- |
| Infrastructure | Architecture du réseau | [Architecture-du-reseau](Infrastructure/Architecture-du-reseau/Architecture-du-reseau.md) | Plan défini |
| Infrastructure | Serveur DC01 : VM, Windows Server, réseau | [Serveur](Infrastructure/Serveur/Serveur.md) | Réalisé |
| Infrastructure | Active Directory et DNS | [Active-Directory](Infrastructure/Active-Directory/Active-Directory.md) | Réalisé |
| Infrastructure | Structure d'OU | [Structure-OU](Infrastructure/Active-Directory/Structure-OU.md) | Réalisé |
| Infrastructure | Groupes et comptes utilisateurs | [Groupes-Comptes](Infrastructure/Active-Directory/Groupes-Comptes.md) | Réalisé |
| Infrastructure | Poste client Windows 11 | [Client-Windows11](Infrastructure/Client/Client-Windows11.md) | Réalisé |
| Infrastructure | AD secondaire | [AD-secondaire](Infrastructure/AD-secondaire/AD-secondaire.md) | Réalisé |
| Infrastructure | TrueNAS | [TrueNAS](Infrastructure/TrueNAS/TrueNAS.md) | Réalisé |
| Infrastructure | Poste client Debian 13 (TP) | [Client-Debian](Infrastructure/Client-Debian/Client-Debian.md) | Réalisé |
| Infrastructure | DHCP | à venir | Reporté |
| AP 1 | GLPI | [GLPI](AP1/GLPI/GLPI.md) | À venir |
| AP 1 | Service complémentaire | à définir | À venir |
| AP 2 | Segmentation de bout en bout | [AP 2](AP2/README.md) | À venir |

## TP de cours

Travaux pratiques réalisés sur les machines de l'infrastructure, hors ateliers professionnels.

| TP | Machine | Page |
| --- | --- | --- |
| Antivirus ClamAV : installation, temps réel, planification, ClamUI | Poste Debian 13 (604) | [ClamAV](TP/ClamAV/ClamAV.md) |

## Environnement

Les ressources qui me sont attribuées sur la plateforme Proxmox de la classe :

| Ressource | Plage |
| --- | --- |
| Réseaux IP | 10.2.81.0/24 à 10.2.100.0/24 |
| VLAN ID | 600 à 699 |
| VMID Proxmox | 600 à 699 |

Hyperviseur : Proxmox VE 9, nœud `pve`, stockage des VM `Raid5-VMs`, pont `vmbr2`. Domaine Active Directory : **`redone.local`** (NetBIOS `REDONE`). Le détail des machines est dans [Infrastructure](Infrastructure/README.md#machines).

## Organisation du dépôt

```
.
├── README.md                       Vue d'ensemble et avancement
├── Infrastructure/                 Infrastructure de base
│   ├── README.md                   Chantiers et machines
│   ├── Architecture-du-reseau/     Adressage, VLAN, flux
│   ├── Serveur/                    VM DC01, installation, réseau
│   ├── Active-Directory/           AD DS, DNS, OU, comptes, scripts
│   ├── Client/                     Poste Windows 11
│   ├── Client-Debian/              Poste Debian 13 (TP)
│   ├── AD-secondaire/              Second contrôleur DC02
│   └── TrueNAS/                    Serveur de fichiers
├── AP1/                            Services d'infrastructure
│   ├── README.md
│   └── GLPI/
├── AP2/                            Interconnexion Proxmox et switchs
└── TP/                             TP de cours (ClamAV)
```

## Conventions

- Une page par chantier : objectif, valeurs, étapes avec captures, vérifications, questions pour l'oral.
- Les captures sont dans le dossier `images/` de chaque page, numérotées dans l'ordre de lecture.
- Les noms de fichiers, d'OU et de groupes n'ont ni accent ni espace.
- Aucun mot de passe ni identifiant d'administration n'est publié dans ce dépôt.
