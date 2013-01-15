# Solitaire Chat

Solitaire chat est une application permettant à des utilisateurs de communiquer de manière cryptée. Le cryptage des messages est réalisé grâce à l'algorithme Solitaire de Bruce Schneier. Cette application se base très largement sur le client de chat existant : 

[https://github.com/cayblood/batman-rails-chat-app](https://github.com/cayblood/batman-rails-chat-app)

![Screenshot](https://dl.dropbox.com/u/18506317/images/message_decrypte.jpg)

Wiki:
[https://github.com/gloaec/antikobpae/wiki](https://github.com/gloaec/solitaire-chat/wiki)  

Bug reports and feature requests:  
[https://github.com/gloaec/antikobpae/issues](https://github.com/gloaec/solitaire-chat/issues)

# Dépendances

L'application nécéssite un environement Ruby-on-Rails standard :

 * Ruby >= 1.9.3 (RVM recommended)
 * Rails >= 3.1.0
 * SqlLite3
	
# Installation

Suivez lez étapes suivantes

 1. `$ git clone git://github.com/gloaec/solitaire-chat.git` Cloner le projet
    
ou 

 1. Télécharger et extraire [`solitaire-chat-master.zip`](https://github.com/gloaec/solitaire-chat/archive/master.zip)
 
 2. `$ cd solitaire-chat` Allez à la racine du projet
 3. `$ bundle install` Installer les dépendances RubyGems 
 4. `$ rake db:create` Initialisation de la base de données
 5. `$ rake db:migrate` Migration de la base de données
 6. `$ rails s` Démarrer le serveur dans l'environemment de développement
 7. Allez à l'adresse [http://localhost:3000/](http://localhost:3000/)

# À faire

* Conservation du deck à l'état final après encryption pour fixer la faille de sécurité