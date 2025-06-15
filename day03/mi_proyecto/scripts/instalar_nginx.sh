#!/bin/bash

set -e  

sudo apt update
sudo apt install -y nginx unzip

sudo systemctl enable nginx
sudo systemctl start nginx

DESTINO="/var/www/html"

sudo mkdir -p "$DESTINO"

unzip -o /vagrant/scripts/site.zip -d "/vagrant/scripts/site"

sudo cp -r /vagrant/scripts/site/startbootstrap-grayscale-gh-pages*/* "$DESTINO"

sudo chown -R www-data:www-data "$DESTINO"
sudo chmod -R 755 "$DESTINO"

sudo systemctl restart nginx

