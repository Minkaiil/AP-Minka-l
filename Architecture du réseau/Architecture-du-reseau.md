# Architecture du réseau - AP 1

## Répartition et adressage

J'utilise les ressources qui me sont attribuées pour séparer les services de [NOM_DU_PROJET].

| Élément | Mon infrastructure |
| --- | --- |
| Réseaux IP | [PLAGES_IP] |
| VLAN | [LISTE_OU_PLAGE_VLAN] |
| VMID | [PLAGE_VMID] |
| Réseau du contrôleur de domaine | [SOUS_RÉSEAU_DC01] |
| Pont Proxmox | [NOM_DU_BRIDGE] |
| Contrôleur de domaine | [VMID_DC01], [NOM_DC01], [IP_DC01] |
| Passerelle | [IP_PASSERELLE_OU_AUCUNE] |

## Schéma

[INSÉRER_ICI_UN_SCHÉMA_DE_VOTRE_RÉSEAU]

## Flux

1. Mes postes clients utilisent [IP_DNS] pour résoudre [DOMAINE_AD].
2. Ils joignent [NOM_DC01] pour l'authentification et les stratégies de groupe.
3. Les accès entre VLAN et vers Internet passent par [ÉQUIPEMENT_OU_SERVICE_DE_ROUTAGE].

Je compléterai cette page avec les VLAN, les règles de pare-feu et les tests réellement mis en place.
