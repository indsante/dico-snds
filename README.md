<img src="app/www/logo-cnam.png" alt="drawing" width="200"/> <img src="app/www/logo-hdh.png" alt="drawing" width="200"/> <img src="app/www/logo-drees.png" alt="drawing" width="150"/>

# Présentation

Ce repo contient le code nécessaire pour faire tourner [l'application du dictionnaire SNDS](https://health-data-hub.shinyapps.io/dico-snds/), un outil de visualisation interactive afin de naviguer dans le contenu du [Système National des Données de Santé](https://www.snds.gouv.fr/SNDS/Accueil).

Il a été développé par la [Direction de la Recherche, des Etudes de l'Evaluation et des Statistiques](https://drees.solidarites-sante.gouv.fr/etudes-et-statistiques/) grâce à la documentation collectée par la [Caisse Nationale d'Assurance Maladie](https://assurance-maladie.ameli.fr/qui-sommes-nous).

# Usage

Le dictionnaire interactif est consultable à [cette adresse](https://health-data-hub.shinyapps.io/dico-snds/).

# Collaboration, développement

## Collaboration

Si vous désirez participer de quelque manière que ce soit (erreur, variable manquante, nomenclature manquante, lien variable-nomenclature), nous vous conseillons de mettre une [issue](https://gitlab.com/healthdatahub/dico-snds/issues) ou bien de modifier directement les fichiers source dans le repo [schema-snds](https://gitlab.com/healthdatahub/schema-snds/issues).

## Nomenclatures
Toutes les nomenclatures du SNDS utilisées dans le dico sont disponibles dans le dosssier [nomenclatures du projet](app/app_data/nomenclatures) au format csv et peuvent être réutilisées pour d'autres usages facilement. Elles ont été extraites depuis le portail CNAM en février 2019.


## Développement

### Avec Rstudio

Si vous souhaitez faire tourner l'application sur votre ordinateur en local afin notamment de faire des changements plus conséquents sur l'application:
+ Clonez ce repo sur votre ordinateur: `git clone https://gitlab.com/healthdatahub/dico-snds.git`
+ Ouvrez dans [Rstudio](https://www.rstudio.com/) `server.R` ou `ui.R` et cliquez sur le bouton `Run App` en haut à droite de la fenêtre principale.
+ Installez les packages nécessaires avec la commande bash `./install_Rpackages.sh` ou bien directement dans R avec `install.packages(c('backports', 'crosstalk', 'dplyr', 'DT', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat'), repos='http://cran.rstudio.com/')`
+ Ajouter un fichier `app/server/var_env.txt`, en copiant le contenu de `app/server/var_env_template.txt`.
 Ce fichier contient les secrets pour se connecter à ElasticSearch (nomenclatures) et MongoDB (logs de l'application). 
+ Vous pouvez lancer les tests en lançant à la racine du projet `./run_tests.sh`

### Avec Docker et test du déploiement sur shinyapps

Si vous voulez tester l'application avec docker et le processus de déploiement via [shinyapp](https://www.shinyapps.io/):

+ Lancer un docker avec R en mode interactif: 

```
docker run -v `pwd`:/home/ -it rocker/r-ver:3.4.4 bash
```

+ Lancer l'installation des packages: `./install_Rpackages.sh`
+ Lancer les tests: `./run_tests.sh`
+ Définir les deux variables d'environnement pour le déploiement: 

```
export TOKEN='XXXXXXX'
export SECRET='XXXXXXX'
```

+ Lancer le déploiement: `./deploy.sh`

# Contacts

Pour toute question et remarque sur l'application, nous vous encourageons à utiliser le **[forum public d'entraide du Health Data Hub](https://entraide.health-data-hub.fr/)**, et en particulier la **[catégorie FAQ](https://entraide.health-data-hub.fr/c/faq)**. 

Si c'est un point technique précis à traiter, il est alors préférable d'ouvrir une **[issue sur GitLab](https://gitlab.com/healthdatahub/dico-snds/issues)**, ou d'écrire à <ld-lab-github@sante.gouv.fr>.

# Auteurs

L'auteur principal de ce logiciel est Matthieu Doutreligne (DREES). 

Le travail initial de synthèse des informations sur le SNDS, à partir des documents de la CNAM, est [archivé à cette adresse](https://gitlab.com/healthdatahub/dico-snds-creation-archive). 
Il a été réalisé par Matthieu Doutreligne et Claire-Lise Dubost (DREES).

Ces informations formelles sont désormais éditées collaborativement dans le dépôt [schema-snds](https://gitlab.com/healthdatahub/schema-snds).

Ce logiciel est maintenu par le Health Data Hub <opensource@health-data-hub.fr>. 
L'historique détaillé des modifications est lisible sur [cette page](https://gitlab.com/healthdatahub/dico-snds/commits/master).
Une vision d'ensemble des contributeurs est disponible sur [cette page](https://gitlab.com/healthdatahub/dico-snds/-/graphs/master).