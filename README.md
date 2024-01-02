# 🎵 MySampled

Bienvenue sur **MySampled**, une application innovante de reconnaissance de samples musicaux. En intégrant l'API de **Shazam** et une API de reconnaissance de samples, MySampled se positionne comme un outil indispensable pour les amateurs de musique, les DJ, et les producteurs. Conçue en **Swift** et s'appuyant sur **UIKit**, cette application offre une expérience utilisateur fluide et agréable.


![Screen1](https://github.com/lionel045/MySampled/assets/64079278/1cc7048b-f650-42eb-a953-452fa989e080)
![Screen2](https://github.com/lionel045/MySampled/assets/64079278/9341689e-371f-4737-8889-58efb20a1237)
![Screen3](https://github.com/lionel045/MySampled/assets/64079278/4d9f5284-8659-4b33-8db6-5e7f65eedc32)

## 🌟 Fonctionnalités Reconnaissance de Samples 
Découvrez les samples cachés dans vos morceaux préférés en utilisant une technologie de pointe. Intégration Shazam : Identifiez rapidement la musique jouant autour de vous grâce à l'API de Shazam. Interface Utilisateur UIKit : Naviguez avec facilité grâce à une interface utilisateur intuitive et réactive. 

## 🛠 Prérequis

- Disposer d'un mac

- Disposer de Xcode : Notre environnement de développement de choix pour compiler et exécuter l'application. Clé API via RapidAPI : Vous devez générer une clé API pour Shazam en visitant Shazam API sur RapidAPI. 🔑 Configuration de la clé API Pour intégrer l'API Shazam dans MySampled :

  Obtenir la clé API : Rendez-vous sur [RapidAPI](https://rapidapi.com/diyorbekkanal/api/shazam-api6/pricing) et générer votre clé API Shazam. Création du fichier ApiKey.plist : Dans Xcode, créez un fichier ApiKey.plist au sein de votre projet. Ajout de la clé API dans ApiKey.plist : Ouvrez le fichier ApiKey.plist. Créez un nouveau dictionnaire avec la clé X-RapidAPI-Key. Insérez la clé API que vous avez obtenue de RapidAPI comme valeur pour cette clé.

## 📲 Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/lionel045/MySampled
```
2. Ouvrez le projet dans Xcode : Lancez Xcode et ouvrez le dossier du projet.
3. Crée un fichier ApiKey.plist : Dans la section root ajouté ***X-RapidAPI-Key*** dans row ajouté la clé api générer précédemment.
4.  Exécutez l'application : Compilez et lancez l'application sur votre simulateur ou appareil iOS.

# RoadMap 
Roadmap
🚧 État Actuel du Projet
- MySampled est actuellement en phase de développement actif. Les fonctionnalités principales sont en place, mais nous travaillons sur l'amélioration continue de l'application, notamment en ce qui concerne l'interface utilisateur.

Prochaines Étapes
- Amélioration du Front-End : Nous nous concentrons sur l'amélioration de l'interface utilisateur pour offrir une expérience plus intuitive, réactive et agréable. Cela inclut la révision des layouts, l'enrichissement des interactions utilisateur et l'optimisation de la performance visuelle.

- Ajout d'une Tab Bar : Pour améliorer la navigation au sein de l'application, nous prévoyons d'intégrer une tab bar. Cela permettra aux utilisateurs d'accéder rapidement aux différentes fonctionnalités et sections de l'application.

- Persistance des Données : Nous envisageons d'implémenter la fonctionnalité de persistance des données. Cela permettra aux utilisateurs de sauvegarder et de retrouver facilement les morceaux identifiés et les samples découverts.


Lien pour l'api de [Shazam](https://rapidapi.com/diyorbekkanal/api/shazam-api6/pricing)
Pas de panique l'utilisation de l'API est gratuite
