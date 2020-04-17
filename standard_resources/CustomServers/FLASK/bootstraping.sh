#!/bin/bash
sudo mkdir FLASK
cd FLASK
sudo apt-get instal -yl software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.6
sudo apt-get install -y python-pip
sudo pip3 install Flask
