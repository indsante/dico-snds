<img src="app/www/logo-cnam.png" alt="drawing" width="200"/> <img src="app/www/logo-inds.png" alt="drawing" width="200"/> <img src="app/www/logo-drees.png" alt="drawing" width="150"/>

# Présentation

Ce repo contient le code nécessaire pour faire tourner [l'application du dictionnaire SNDS](https://drees.shinyapps.io/dico-snds/), un outil de visualisation interactive afin de naviguer dans le contenu du [Système National des Données de Santé](https://www.snds.gouv.fr/SNDS/Accueil).

Il a été développé par la [Direction de la Recherche, des Etudes de l'Evaluation et des Statistiques](https://drees.solidarites-sante.gouv.fr/etudes-et-statistiques/) grâce à la documentation collectée par la [Caisse Nationale d'Assurance Maladie](https://assurance-maladie.ameli.fr/qui-sommes-nous).

# Usage

Le dictionnaire interactif est consultable à [cette adresse](http://dico-snds.health-data-hub.fr/).

# Collaboration, développement

## Collaboration

Si vous désirez participer de quelque manière que ce soit (erreur, variable manquante, nomenclature manquante, lien variable-nomenclature), nous vous conseillons de mettre une [issue](https://gitlab.com/healthdatahub/dico-snds/issues) ou bien de modifier directement les fichiers source dans le repo [schema-snds](https://gitlab.com/healthdatahub/schema-snds/issues).

## Développement

### Avec Rstudio

Si vous souhaitez faire tourner l'application sur votre ordinateur en local afin notamment de faire des changements plus conséquents sur l'application:
+ Clonez ce repo sur votre ordinateur: `git clone https://gitlab.com/healthdatahub/dico-snds.git`
+ Ouvrez dans [Rstudio](https://www.rstudio.com/) `server.R` ou `ui.R` et cliquez sur le bouton `Run App` en haut à droite de la fenêtre principale.
+ Installez les packages nécessaires avec la commande bash `./install_Rpackages.sh` ou bien directement dans R avec `install.packages(c('backports', 'crosstalk', 'dplyr', 'DT', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat'), repos='http://cran.rstudio.com/')`
+ Vous pouvez lancer les tests en lançant à la racine du projet `./run_tests.sh`

### Avec Docker et test du déploiement

Si vous voulez tester l'application avec docker et le processus de déploiement:

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