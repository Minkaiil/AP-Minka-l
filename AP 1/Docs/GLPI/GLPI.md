# GLPI - AP 1

> État : **à réaliser**. Je complète cette page avec mes captures au fur et à mesure.

## Objectif

Déployer **GLPI** pour gérer le parc informatique et les tickets d'incident de l'entreprise, et le relier à l'annuaire Active Directory pour que les utilisateurs s'authentifient avec leur compte de domaine.

## Environnement

| Élément | Valeur |
| --- | --- |
| Serveur | VM Debian (VMID 610, VM-Debian) |
| IP | [IP_VM_DEBIAN] |
| Pile | Apache (ou Nginx), PHP, MariaDB |
| Version de GLPI | [VERSION_GLPI] |

## Étapes prévues

1. **Préparer Debian** : mise à jour, IP fixe, nom d'hôte.

```bash
sudo apt update && sudo apt upgrade -y
```

2. **Installer la pile LAMP** : Apache, MariaDB et les extensions PHP requises par GLPI.
3. **Créer la base de données** et un utilisateur dédié avec des droits limités à cette base.

```sql
CREATE DATABASE glpi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY '<mot_de_passe>';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
```

4. **Télécharger et déployer GLPI** dans le répertoire web, avec les bons droits.
5. **Lancer l'installation web** et supprimer le fichier d'installation ensuite.
6. **Changer les mots de passe par défaut** des comptes de démonstration.
7. **Lier GLPI à Active Directory** (LDAP, port 389 ou 636) avec un compte de service en lecture seule, et importer les utilisateurs des 10 services.
8. **Tester** : connexion avec un compte de domaine, création d'un ticket, inventaire d'un poste.

## Points à justifier à l'oral

- Pourquoi un compte de service LDAP en lecture seule plutôt qu'un administrateur du domaine.
- Pourquoi LDAPS est préférable à LDAP.
- La différence entre l'inventaire du parc et la gestion des tickets.

Je ne publie pas les mots de passe de la base ni du compte LDAP dans le dépôt.

[CAPTURE : page d'installation de GLPI]

[CAPTURE : configuration de l'annuaire LDAP]

[CAPTURE : ticket de test]
