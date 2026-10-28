# Architecture du réseau

## Ressources attribuées

| Ressource | Plage |
| --- | --- |
| Réseaux IP | 10.2.81.0/24 à 10.2.100.0/24 |
| VLAN ID | 600 à 699 |
| VMID Proxmox | 600 à 699 |

## Plateforme

| Élément | Valeur |
| --- | --- |
| Hyperviseur | Proxmox VE 9, nœud `pve` |
| Stockage des VM | `Raid5-VMs` |
| Pont réseau | `vmbr2`, avec gestion des VLAN : le tag est posé sur la carte réseau de chaque VM |
| Passerelle de chaque réseau | adresse .1, portée par le pare-feu pfSense de la plateforme (VLAN créés par l'équipe réseau de la classe) |
| Domaine Active Directory | `redone.local` |

## Machines

| Machine | IP | VLAN | Rôle | État |
| --- | --- | --- | --- | --- |
| `DC01` | 10.2.81.2/24 | 600 | Contrôleur de domaine, DNS | Réalisé |
| `DC02` | à définir | 600 | Second contrôleur de domaine | À venir |
| `CLIENT01` | 10.2.81.10 | 600 | Poste Windows 11 | Réalisé |
| `SRV-GLPI` | à définir | 600 | GLPI (Debian) | À venir |

## Zones de RedOne et plan d'adressage prévu

Le contexte découpe l'entreprise en 12 zones. Je les répartis sur mes réseaux avec la règle **VLAN 600 + n ↔ 10.2.(81 + n).0/24**. Ce plan est **prévu** : seul le VLAN 600 est en service pour l'instant.

| VLAN | Réseau | Zone |
| --- | --- | --- |
| 600 | 10.2.81.0/24 | Serveurs |
| 601 | 10.2.82.0/24 | Réseau & Système |
| 602 | 10.2.83.0/24 | Direction / DSI |
| 603 | 10.2.84.0/24 | RH / Compta / Juridique / Secrétariat administratif |
| 604 | 10.2.85.0/24 | Communication / Rédaction |
| 605 | 10.2.86.0/24 | Développement |
| 606 | 10.2.87.0/24 | Commercial |
| 607 | 10.2.88.0/24 | Labo-Recherche |
| 608 | 10.2.89.0/24 | Accueil |
| 609 | 10.2.90.0/24 | Visiteurs (Wi-Fi invité) |
| 610 | 10.2.91.0/24 | Démonstration |
| 611 | 10.2.92.0/24 | Sortie |

Les visiteurs médicaux, qui travaillent sur le terrain, n'ont pas de VLAN dans ce plan : ils ont en revanche une OU dans l'annuaire.

## Règles de filtrage du contexte

- Chaque VLAN, sauf Visiteurs, peut accéder uniquement aux VLAN **Serveurs** et **Sortie**.
- Le VLAN **Visiteurs** peut seulement interroger les serveurs **DNS** et **DHCP** et sortir sur Internet.

Leur mise en œuvre de bout en bout est traitée dans l'[AP 2](../AP%202/README.md).

## Flux en place

1. Les machines du domaine utilisent `10.2.81.2` (DC01) comme serveur DNS pour résoudre `redone.local`.
2. Elles joignent `DC01` pour l'authentification et les stratégies de groupe.
3. L'accès à Internet passe par la passerelle `10.2.81.1`.
