#!/bin/bash
sudo apt-get instal -yl software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.6
sudo apt-get install -y python3-pip
sudo pip3 install Flask
sudo mkdir FLASK
cd FLASK
#download your S3 stuff here
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
