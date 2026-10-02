# TrueNAS - AP 1

> État : **à réaliser**. Je complète cette page avec mes captures au fur et à mesure.

## Objectif

Mettre en place un serveur de fichiers **TrueNAS** avec un partage par service, dont les droits s'appuient sur les groupes `GG_<service>` de l'Active Directory.

## Environnement

| Élément | Valeur |
| --- | --- |
| Serveur | VM TrueNAS (VMID [VMID_TRUENAS]) |
| IP | [IP_TRUENAS] |
| Stockage | [DISQUES_VIRTUELS_ET_VOLUME_PROXMOX] |
| Version | [VERSION_TRUENAS] |

## Étapes prévues

1. **Créer la VM** sur Proxmox avec un disque système et des disques de données dédiés.
2. **Installer TrueNAS**, configurer l'IP fixe et le DNS (10.2.81.2).
3. **Créer le pool de stockage** et les **datasets** : un par service, plus un espace commun.
4. **Joindre TrueNAS au domaine** [DOMAINE_AD] (Directory Services > Active Directory).
5. **Créer les partages SMB** et attribuer les droits aux groupes `GG_<service>` (ACL), jamais aux comptes individuels.
6. **Activer les instantanés** (snapshots) planifiés sur les datasets.
7. **Tester** depuis VM-USER : accès au partage de son service, refus sur celui d'un autre service.

## Points à justifier à l'oral

- Pourquoi un dataset par service (quotas, droits, snapshots indépendants).
- La différence entre une sauvegarde et un snapshot.
- Pourquoi les droits sont donnés aux groupes.

[CAPTURE : pool et datasets]

[CAPTURE : jonction au domaine]

[CAPTURE : test d'accès depuis VM-USER]
