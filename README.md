# Infrastructure RedOne - Minkaïl (BTS SIO 2, option SISR)

Ce dépôt documente l'infrastructure que je construis pour mes deux ateliers professionnels (AP) : un système d'information d'entreprise virtualisé sur Proxmox, organisé autour d'Active Directory. Chaque page décrit une étape reproductible, avec mes valeurs, mes captures et les points à justifier à l'oral.

L'entreprise fictive est le laboratoire pharmaceutique **RedOne**, décrit dans le document de contexte « RedOne - Organisation » (CERTA, non reproduit ici).

## Avancement

| Atelier | Chantier | Page | État |
| --- | --- | --- | --- |
| AP 1 | Architecture du réseau | [Architecture-du-reseau](Architecture-du-reseau/Architecture-du-reseau.md) | Plan défini |
| AP 1 | Serveur DC01 : VM, Windows Server, réseau | [Serveur](AP%201/Docs/Serveur/Serveur.md) | Réalisé |
| AP 1 | Active Directory et DNS | [Active-Directory](AP%201/Docs/Active%20Directory/Active-Directory.md) | Réalisé |
| AP 1 | Structure d'OU | [Structure-OU](AP%201/Docs/Active%20Directory/Structure-OU.md) | Réalisé |
| AP 1 | Groupes et comptes utilisateurs | [Groupes-Comptes](AP%201/Docs/Active%20Directory/Groupes-Comptes.md) | Réalisé |
| AP 1 | Poste client Windows 11 | [Client-Windows11](AP%201/Docs/Client/Client-Windows11.md) | Réalisé |
| AP 1 | DHCP | à venir | Reporté |
| AP 1 | AD secondaire | [AD-secondaire](AP%201/Docs/AD%20secondaire/AD-secondaire.md) | Réalisé |
| AP 1 | GLPI | [GLPI](AP%201/Docs/GLPI/GLPI.md) | À venir |
| AP 1 | TrueNAS | [TrueNAS](AP%201/Docs/TrueNAS/TrueNAS.md) | À venir |
| AP 2 | Segmentation de bout en bout | [AP 2](AP%202/README.md) | À venir |

## Environnement

Les ressources qui me sont attribuées sur la plateforme Proxmox de la classe :

| Ressource | Plage |
| --- | --- |
| Réseaux IP | 10.2.81.0/24 à 10.2.100.0/24 |
| VLAN ID | 600 à 699 |
| VMID Proxmox | 600 à 699 |

Hyperviseur : Proxmox VE 9, nœud `pve`, stockage des VM `Raid5-VMs`, pont `vmbr2`. Domaine Active Directory : **`redone.local`** (NetBIOS `REDONE`).

| Machine | Nom Proxmox | Nom Windows / Linux | IP | VLAN | État |
| --- | --- | --- | --- | --- | --- |
| Premier contrôleur de domaine | `DC01-REDONE` | `DC01` | 10.2.81.2/24 | 600 | Réalisé |
| Second contrôleur de domaine | 602 | `DC02` | 10.2.81.3 | 600 | Réalisé |
| Poste utilisateur Windows 11 | 601 | `CLIENT01` | 10.2.81.10 | 600 | Réalisé |
| Serveur GLPI (Debian) | à créer | `SRV-GLPI` | à définir | 600 | À venir |

## Organisation du dépôt

```
.
├── README.md                       Vue d'ensemble et avancement
├── Architecture-du-reseau/         Adressage, VLAN, flux
├── AP 1/
│   ├── README.md                   Contexte et ordre des chantiers
│   └── Docs/
│       ├── Serveur/                VM DC01, installation, réseau
│       ├── Active Directory/       AD DS, DNS, structure d'OU, scripts
│       ├── AD secondaire/
│       ├── GLPI/
│       └── TrueNAS/
└── AP 2/                           Interconnexion Proxmox et switchs
```

## Conventions

- Une page par chantier : objectif, valeurs, étapes avec captures, vérifications, questions pour l'oral.
- Les captures sont dans le dossier `images/` de chaque page, numérotées dans l'ordre de lecture.
- Les noms de fichiers, d'OU et de groupes n'ont ni accent ni espace.
- Aucun mot de passe ni identifiant d'administration n'est publié dans ce dépôt.
