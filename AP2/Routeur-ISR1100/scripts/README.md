# Scripts du routeur R-REDONE

Ces scripts PowerShell m'ont servi à configurer le routeur Cisco C1111-8P **par le câble console, sans PuTTY**, et à produire les captures de la [page du routeur](../Routeur-ISR1100.md).

Ils utilisent la classe .NET `System.IO.Ports.SerialPort`, présente dans Windows PowerShell 5.1 : il n'y a rien à installer.

**Aucun mot de passe n'est écrit dans ces fichiers.** Les secrets sont tapés au clavier avec `Read-Host -AsSecureString`, envoyés au routeur, puis effacés de la mémoire. L'écho de la console, qui contient le mot de passe en clair, n'est jamais affiché.

## Prérequis

| Élément | Valeur |
| --- | --- |
| Câble | Console USB-série (puce CH340), port `COM5` |
| Pilote | CH340 **3.4.2014.8**. La version 3.9.2024.9 refuse l'ouverture du port depuis .NET |
| Réglages | 9600 bauds, 8 bits, pas de parité, 1 bit de stop |
| Lancement | `powershell -ExecutionPolicy Bypass -File .\<script>.ps1` |

Le numéro du port COM se lit dans le Gestionnaire de périphériques, rubrique « Ports (COM et LPT) ». Chaque script accepte `-Port COMx` s'il est différent.

## Les scripts

| Script | Rôle |
| --- | --- |
| [console.ps1](console.ps1) | Envoie une liste de commandes sur la console et affiche les réponses. C'est l'outil de base de tous les autres. |
| [login-console.ps1](login-console.ps1) | Ouvre une session sur la console : tu tapes l'identifiant et le mot de passe, la session reste ouverte 5 minutes (`exec-timeout 5 0`) pour enchaîner avec `console.ps1`. |
| [config-partie-B.ps1](config-partie-B.ps1) | Applique la partie de la configuration qui contient des secrets : compte `admin-minka`, `enable secret`, ACL SSH, `login block-for`, SNMPv3 facultatif, puis `login local` sur la console. Vérifie la longueur (12 caractères) et la confirmation de chaque mot de passe. |
| [render-capture.ps1](render-capture.ps1) | Transforme une sortie texte de la console en image PNG façon terminal (invites en cyan, journaux en gris, `[OK]` en vert). C'est ce qui produit les images du dossier `images/`. |

### Exemples

Lire l'état des interfaces :

```powershell
.\console.ps1 -Commands "terminal length 0","show ip interface brief" -Wait 3
```

Se connecter, puis appliquer un fichier de configuration :

```powershell
.\login-console.ps1
.\console.ps1 -Commands (Get-Content .\config\R-REDONE-config-actuelle.txt) -Wait 1
```

Enregistrer une sortie et en faire une capture :

```powershell
.\console.ps1 -Commands "","show ip route" -Wait 3 | Out-File route.txt -Encoding utf8
.\render-capture.ps1 -In route.txt -Out ..\images\route.png -Title "R-REDONE : table de routage"
```

## Les fichiers de configuration

| Fichier | Contenu |
| --- | --- |
| [config/R-REDONE-config-actuelle.txt](config/R-REDONE-config-actuelle.txt) | **La configuration complète actuelle**, sans secret. Elle suffit à reconstruire le routeur après un `write erase`, en ajoutant les comptes avec `config-partie-B.ps1`. |
| [config/01-partie-A-sans-secret.txt](config/01-partie-A-sans-secret.txt) | Première application de la configuration complète (historique : adresse `.50`, prises `Gi0/1/0-3`). |
| [config/02-raccordement-salle-250.txt](config/02-raccordement-salle-250.txt) | Passage en `192.168.100.250`, NTP et DNS vers DC01. |
| [config/verifications.txt](config/verifications.txt) | Toutes les commandes `show` et `ping` pour vérifier le routeur. |

## Problèmes rencontrés

| Symptôme | Cause | Solution |
| --- | --- | --- |
| « Un périphérique attaché au système ne fonctionne pas correctement » à l'ouverture du port | Pilote CH340 3.9.2024.9 | Installer le pilote CH340 3.4.2014.8 |
| Une commande de la partie B ignorée après `no username admin` | IOS demande une confirmation `[confirm]`, la ligne suivante sert de réponse | Envoyer une ligne vide juste après |
| `ssh: connect to host ... Connection timed out` | Adresse `.50` déjà utilisée par une autre machine du réseau de la salle | Routeur passé en `.250` |
| `%SSH-3-NO_MATCH: No matching kex algorithm found` | IOS-XE 16.12 ne propose que des échanges de clés SHA-1, refusés par OpenSSH récent | `KexAlgorithms +diffie-hellman-group14-sha1` dans `%USERPROFILE%\.ssh\config` |
