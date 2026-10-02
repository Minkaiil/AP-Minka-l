# Utiliser ce modèle

1. Copiez le dossier `Modele-Infra-SISR` dans un nouveau dépôt. Renommez le projet si besoin.
2. Remplacez **tous** les champs entre crochets `[ ... ]` par vos propres informations. Cherchez le caractère `[` dans les fichiers Markdown et CSV pour ne rien oublier.
3. Gardez uniquement les services utiles à votre contexte dans `services.csv`. Ajoutez exactement trois lignes de personnes par service dans `utilisateurs.csv` ou adaptez le contrôle du script si votre besoin est différent.
4. Relisez le script `Creer-AD-Template.ps1`, indiquez le vrai domaine dans `$DomaineAttendu`, puis exécutez-le sur votre contrôleur de domaine. Il crée les objets manquants sans supprimer les objets existants. Il vous demande un mot de passe au lancement : ne le mettez pas dans le dépôt.
5. Ajoutez vos captures dans `AP 1/Docs/Active Directory/images`, puis remplacez les lignes `[CAPTURE_...]` de la documentation par des liens Markdown, par exemple `![Console AD](images/05-ou.png)`.
6. Ajustez les textes à ce qui a été **réellement installé et testé**. Supprimez les rubriques qui ne concernent pas votre projet et complétez AP 2 quand ce travail commencera.

Le ZIP ne contient ni captures d'écran, ni comptes personnels, ni mot de passe. Les plages IP, VLAN et VMID sont volontairement à renseigner pour chaque étudiant.
