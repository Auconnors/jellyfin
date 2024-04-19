#!/bin/bash
#Auconnors

confirmation_install() {
    while true; do
        read -p "Voulez-vous vraiment installer Jellyfin ? (y/n) " yn
        case $yn in
            [YyOo]* ) return 0;; # Continuer
            [Nn]* ) exit;;    # Quitter le script
            * ) echo "Veuillez répondre par 'y' ou 'n'.";;
        esac
    done
}

confirmation_install
confirmation_certif
echo "1. Installation de docker"
apt install docker.io docker-compose -y

echo "2. Création répertoire /etc/jellyfin"
mkdir /etc/jellyfin
mkdir /etc/jellyfin/certs
mkdir /etc/jellyfin/media

echo "3. Mise en place du répertoire /etc/jellyfin"
mv ./haproxy.cfg /etc/jellyfin
mv ./docker-compose.yml /etc/jellyfin
openssl genrsa -out /etc/jellyfin/certs/jellyfin.crt.key
openssl req -new -x509 -key /etc/jellyfin/certs/jellyfin.crt.key -out /etc/jellyfin/certs/jellyfin.crt -days 3650 -subj '/CN=jellyfin.local'
chmod 644 /etc/jellyfin/certs/jellyfin.crt
chmod 644 /etc/jellyfin/certs/jellyfin.crt.key

echo "4. Mise du service jellyfin"
mv ./jellyfin.service /etc/systemd/system/
systemctl daemon-reload 


echo "5. Démarrage jellyfin"
systectl start jellyfin

echo "-----------------------------------------------"
echo "		https://jellyfin.local               "
echo "	Ne pas oublier enregistrement dns !!         "
echo "-----------------------------------------------" 
