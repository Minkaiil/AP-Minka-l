# TrueNAS - AP 1

> État : **à réaliser**. Je complète cette page avec mes captures au fur et à mesure.

## Objectif

Mettre en place un serveur de fichiers **TrueNAS** avec un partage par service, dont les droits s'appuient sur les groupes `GG_<service>` de l'Active Directory.

## Environnement

| Élément | Valeur |
| --- | --- |
| Serveur | VM TrueNAS (VMID *à définir*) |
| IP | *à définir* |
| Stockage | *à définir* |
| Version | *à définir* |

## Étapes prévues

1. **Créer la VM** sur Proxmox avec un disque système et des disques de données dédiés.
2. **Installer TrueNAS**, configurer l'IP fixe et le DNS (10.2.81.2).
3. **Créer le pool de stockage** et les **datasets** : un par service, plus un espace commun.
4. **Joindre TrueNAS au domaine** redone.local (Directory Services > Active Directory).
5. **Créer les partages SMB** et attribuer les droits aux groupes `GG_<service>` (ACL), jamais aux comptes individuels.
6. **Activer les instantanés** (snapshots) planifiés sur les datasets.
7. **Tester** depuis CLIENT01 : accès au partage de son service, refus sur celui d'un autre service.

## Points à justifier à l'oral

- Pourquoi un dataset par service (quotas, droits, snapshots indépendants).
- La différence entre une sauvegarde et un snapshot.
- Pourquoi les droits sont donnés aux groupes.

> **Capture à ajouter :** pool et datasets

> **Capture à ajouter :** jonction au domaine

> **Capture à ajouter :** test d'accès depuis CLIENT01
