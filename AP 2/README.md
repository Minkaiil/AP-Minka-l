# AP 2 - Interconnexion Proxmox et switchs physiques : la segmentation de bout en bout

> État : **à venir**.

## Contexte

Mes machines virtuelles tournent sur Proxmox, mais les postes, les serveurs et la passerelle sont reliés par des **switchs physiques**. Pour que la séparation entre services (VLAN) tienne de bout en bout, la configuration doit être cohérente de la VM jusqu'au port du switch.

## Objectif

Faire transiter plusieurs VLAN entre Proxmox et les switchs physiques sur un seul lien (trunk 802.1Q), et prouver que chaque VM n'atteint que ce qui lui est autorisé.

## Schéma de principe

```
VM (tag VLAN 600) -- vmbr (VLAN aware) -- carte physique du nœud
        -- trunk 802.1Q -- port du switch -- autres switchs / routeur-pare-feu
```

## Étapes prévues

### 1. Côté Proxmox

- Activer **VLAN aware** sur le pont Linux et déclarer les VLAN autorisés.
- Poser le **tag VLAN** sur la carte réseau de chaque VM (par exemple 600).

Extrait de `/etc/network/interfaces` :

```
auto vmbr0
iface vmbr0 inet manual
    bridge-ports [INTERFACE_PHYSIQUE]
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 2-4094
```

### 2. Côté switchs physiques

- Créer les VLAN et leur donner un nom.
- Configurer le port vers Proxmox en **trunk** limité aux VLAN utiles.
- Configurer les ports des postes physiques en **accès**.

Exemple (syntaxe Cisco, à adapter à mon matériel [MARQUE_ET_MODÈLE]) :

```
vlan 600
 name Minkail
interface [PORT_VERS_PROXMOX]
 switchport mode trunk
 switchport trunk allowed vlan 600
interface [PORT_POSTE]
 switchport mode access
 switchport access vlan 600
```

### 3. Routage et filtrage entre VLAN

- Définir où se fait le routage inter-VLAN : [ÉQUIPEMENT].
- Écrire les règles de filtrage entre zones (utilisateurs, serveurs, visiteurs, sortie).

### 4. Tests et preuves

| Test | Résultat attendu |
| --- | --- |
| VM-USER vers SRV-AD-Minkail (même VLAN) | Réponse au ping |
| VM d'un VLAN vers un autre VLAN non autorisé | Blocage |
| Visiteurs vers Serveurs | Blocage |
| Vérification du trunk (`show interfaces trunk`) | VLAN autorisés visibles |
| Capture de trames (`tcpdump -e -i [INTERFACE]`) | Tag 802.1Q visible |

## Points à justifier à l'oral

- Différence entre port d'accès et trunk, et rôle du VLAN natif.
- Pourquoi limiter les VLAN autorisés sur le trunk.
- Où se fait le filtrage et pourquoi un VLAN seul n'est pas une sécurité suffisante.

## Réalisations

[ÉTAPES_ET_PREUVES_AP2]
