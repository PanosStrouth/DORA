#!/bin/bash
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo mkdir /downloads/grafana -p
cd /downloads/grafana/
sudo wget https://packages.grafana.com/gpg.key
sudo apt-key add gpg.key
sudo add-apt-repository 'deb [arch=amd64,i386] https://packages.grafana.com/oss/deb stable main'
sudo apt-get update
sudo apt-get install -y grafana
sudo ln -s /lib/systemd/system/grafana-server.service /etc/systemd/system/grafana-server.service
sudo service grafana-server status
sudo service grafana-server start
