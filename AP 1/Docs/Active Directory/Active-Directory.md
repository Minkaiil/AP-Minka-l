# Active Directory - AP 1 [NOM_DU_PROJET]

Je présente ici la mise en place de mon contrôleur de domaine, avec mes propres captures d'écran.

## 1. Créer la machine virtuelle

J'ai créé une VM sur [PLATEFORME_DE_VIRTUALISATION] avec le **VMID [VMID_DC01]**. Elle dispose de [NOMBRE_VCPU] vCPU, [RAM_GIO] Gio de RAM et [TAILLE_DISQUE_GIO] Gio de stockage. Sa carte réseau utilise [BRIDGE_ET_VLAN]. J'y ai installé [VERSION_WINDOWS_SERVER].

[CAPTURE_01 : VM du contrôleur de domaine dans Proxmox]

## 2. Configurer le nom et le réseau

J'ai nommé le serveur **[NOM_DC01]** et configuré son adresse **[IP_DC01]/[PRÉFIXE]**. Son DNS préféré est **[IP_DNS]** et sa passerelle est **[IP_PASSERELLE_OU_AUCUNE]**.

[CAPTURE_02 : configuration IP du serveur]

## 3. Installer AD DS et DNS

J'ai installé les rôles **AD DS** et **DNS**, puis promu le serveur comme premier contrôleur du domaine **[DOMAINE_AD]**. Le nom NetBIOS est **[NOM_NETBIOS]**.

[CAPTURE_03 : installation des rôles]

[CAPTURE_04 : nom du domaine Active Directory]

## 4. Créer les OU, groupes et comptes

J'ai placé les OU principales directement sous **[DOMAINE_AD]** : [LISTE_DES_OU_PRINCIPALES]. Les services se trouvent dans l'OU **[NOM_OU_SERVICES]**. J'ai créé [NOMBRE_GROUPES] groupes et [NOMBRE_COMPTES] comptes pour [EXPLICATION_DE_LA_RÉPARTITION].

[CAPTURE_05 : arborescence des OU]

[CAPTURE_06 : groupes de sécurité]

[CAPTURE_07 : comptes utilisateurs]

Le [script de création](Creer-AD-Template.ps1) utilise les fichiers [services.csv](services.csv) et [utilisateurs.csv](utilisateurs.csv). J'adapte leurs valeurs à mon projet avant de l'exécuter.

## 5. Vérifier le fonctionnement

J'ai contrôlé le nom du serveur, l'adressage, la résolution DNS et l'état du domaine avec [COMMANDES_ET_TESTS_UTILISÉS]. J'ai ensuite [TEST_DE_JONCTION_D_UN_POSTE_ET_DE_CONNEXION_UTILISATEUR].

[CAPTURE_08 : résultats des tests]

Les captures ne sont pas fournies dans ce modèle. Je remplace chaque emplacement par une image de ma propre infrastructure et j'adapte la légende.
