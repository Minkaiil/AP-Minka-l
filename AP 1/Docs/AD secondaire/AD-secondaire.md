# AD secondaire - AP 1

> État : **à réaliser**. Je complète cette page avec mes captures au fur et à mesure.

## Objectif

Ajouter un second contrôleur de domaine pour que l'authentification et le DNS continuent de fonctionner si le premier (SRV-AD-Minkail, 10.2.81.2) tombe en panne.

## Étapes prévues

1. **Créer la VM** sur Proxmox : VMID [VMID_DC02], nom [NOM_DC02], Windows Server 2022, même VLAN que le premier DC.
2. **Configurer le réseau** : IP fixe [IP_DC02]/24, passerelle 10.2.81.1, DNS préféré 10.2.81.2 (le premier DC), puis son propre DNS en auxiliaire une fois promu.
3. **Joindre le serveur au domaine** [DOMAINE_AD].
4. **Installer AD DS et DNS**, puis promouvoir le serveur comme **contrôleur de domaine supplémentaire** (et non comme nouveau domaine), avec le rôle de **catalogue global**.
5. **Vérifier la réplication** :

```powershell
repadmin /replsummary
repadmin /showrepl
dcdiag /q
Get-ADDomainController -Filter * | Select Name, IPv4Address, IsGlobalCatalog
```

6. **Tester la tolérance de panne** : arrêter SRV-AD-Minkail, vérifier qu'une ouverture de session sur VM-USER fonctionne toujours, puis le redémarrer.
7. **Mettre à jour le DNS des clients** : les deux contrôleurs sont déclarés comme serveurs DNS.

## Points à justifier à l'oral

- Pourquoi deux contrôleurs : disponibilité et répartition de charge.
- Ce que réplique AD (annuaire, SYSVOL) et à quelle fréquence.
- Les rôles FSMO : où ils se trouvent et ce qui se passe en cas de panne du détenteur.

[CAPTURE : promotion du second DC]

[CAPTURE : résultat de repadmin /replsummary]

[CAPTURE : test avec le premier DC éteint]
