# AP 1 - Services d'infrastructure : partages, GLPI et sauvegarde

> État : **en cours**. Cet atelier s'appuie sur l'[infrastructure de base](../Infrastructure/README.md), déjà en place.

## Contexte

Le domaine `redone.local`, son DNS, ses deux contrôleurs, le poste client et le serveur de fichiers sont déjà construits et documentés dans [Infrastructure](../Infrastructure/README.md). L'AP 1 ajoute à cette base des **services applicatifs** utiles à l'exploitation d'un système d'information : l'accès de chaque employé aux fichiers de son service, la gestion du parc et des tickets, et la sauvegarde des serveurs.

## Objectif

- Rendre le serveur de fichiers exploitable : **un lecteur réseau `S:`** monté par GPO, avec le dossier de chaque service et un dossier commun.
- Déployer **GLPI** sur un serveur Debian (`SRV-GLPI`), relié à l'annuaire Active Directory pour que les utilisateurs s'authentifient avec leur compte de domaine.
- Sauvegarder les machines avec **Veeam Backup & Replication** (`SRV-VEEAM`) et prouver qu'on sait les restaurer.

## Chantiers

| # | Chantier | Page | État |
| --- | --- | --- | --- |
| 1 | Partages des 10 services et lecteur `S:` par GPO | [Partages-Services](Partages-Services/Partages-Services.md) | Réalisé |
| 2 | GLPI sur Debian, lié à l'annuaire | [GLPI](GLPI/GLPI.md) | Réalisé |
| 3 | Sauvegarde avec Veeam Backup & Replication | [Veeam](Veeam/Veeam.md) | En cours |

## Prérequis

| Élément | Valeur |
| --- | --- |
| Domaine | `redone.local` |
| DNS | 10.2.81.2 et 10.2.81.3 |
| VLAN | 600, réseau 10.2.81.0/24, passerelle 10.2.81.1 |
| VMID disponibles | 607 à 699 (605 : `SRV-GLPI`, 606 : `SRV-VEEAM`) |
