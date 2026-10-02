# Minkail - Infrastructure SISR (BTS SIO 2)

Ce dépôt présente l'infrastructure que j'ai réalisée pour mes deux ateliers professionnels (AP) de l'option SISR.

| Atelier | Contenu | État |
| --- | --- | --- |
| [AP 1](AP%201/README.md) | Active Directory, GLPI, TrueNAS, script de création d'utilisateurs, AD secondaire | En cours |
| [AP 2](AP%202/README.md) | Interconnexion Proxmox et switchs physiques : segmentation de bout en bout | À venir |

## Mon environnement Proxmox

Mon infrastructure tourne sur le nœud **pve** de l'hyperviseur Proxmox du BTS, dans le pool **Minkail** (tag `bts.sio2`). Je travaille sur le **VLAN 600**. Les disques des VM sont stockés sur le volume **Raid5-VMs**.

| VMID | Nom | Rôle | Système |
| --- | --- | --- | --- |
| 600 | SRV-AD-Minkail | Contrôleur de domaine (AD DS + DNS) | Windows Server 2022 Standard |
| 605 | VM-USER | Poste utilisateur | Windows 11 |
| 610 | VM-Debian | Serveur Linux | Debian |

Le contrôleur de domaine utilise l'adresse **10.2.81.2/24**.

## Documentation

- [Architecture du réseau](Architecture%20du%20r%C3%A9seau/Architecture-du-reseau.md)
- [AP 1 - Active Directory](AP%201/Docs/Active%20Directory/Active-Directory.md)
- [AP 1 - GLPI](AP%201/Docs/GLPI/GLPI.md)
- [AP 1 - TrueNAS](AP%201/Docs/TrueNAS/TrueNAS.md)
- [AP 1 - AD secondaire](AP%201/Docs/AD%20secondaire/AD-secondaire.md)
- [AP 2 - Segmentation de bout en bout](AP%202/README.md)
