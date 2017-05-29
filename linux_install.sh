#!/bin/bash

# Install R
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get install r-base r-base-dev -y

# Install R Packages
sudo apt-get -fy install
sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev gdal-bin libgdal-dev python-software-properties
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get upgrade -y gdal-bin libgdal-dev
touch install_packages.R
echo '#!/usr/bin/Rscript' >> install_packages.R
echo 'install.packages(c("tidyverse", "foreach", "doParallel", "AER", "feather", "stringr", "maptools", "ggmap", "sf", "gtrendsR", "gdata"), repos="https://cloud.r-project.org/")' >> install_packages.R
./install_packages.R
rm install_packages.R

# Install RStudio Desktop
wget https://download1.rstudio.org/rstudio-1.0.143-amd64.deb
sudo apt-get -fy install
sudo dpkg -i rstudio-1.0.143-amd64.deb
rm rstudio-1.0.143-amd64.deb

# Install RStudio Server
sudo apt-get install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
sudo gdebi --n rstudio-server-1.0.143-amd64.deb
echo "www-address=127.0.0.1" >> /etc/rstudio/rserver.conf
sudo rstudio-server restart
rm rstudio-server-1.0.143-amd64.deb

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# doesn't work on headless remote linux machine because audio/visual drivers not installed
rm google-chrome-stable_current_amd64.deb

# Install Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -y
sudo apt-get install -y spotify-client

# Install TeX
sudo apt-get install -y texlive-full

# Install Texmaker
sudo apt-get install -y texmaker

# Install Lyx
sudo add-apt-repository -y ppa:lyx-devel/release
sudo apt-get update
sudo apt-get install -y lyx

# Install Git Kraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb

# Install FileZilla
sudo apt-get install -y filezilla

# Install Google Earth
wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable_current_amd64.deb
rm google-earth-stable_current_amd64.deb

# Install Rodeo
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 33D40BC6
sudo add-apt-repository "deb http://rodeo-deb.yhat.com/ rodeo main"
sudo apt-get update
sudo apt-get -y install rodeo

# Install VLC
sudo apt-get install -y vlc

# Install Julia
cd /opt
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/0.5/julia-0.5.2-linux-x86_64.tar.gz
sudo tar -xzf julia-0.5.2-linux-x86_64.tar.gz
sudo mv julia-f4c6c9d4bb/ julia/
sudo rm julia-0.5.2-linux-x86_64.tar.gz
echo 'export PATH="/opt/julia/bin:$PATH"' >> ~/.profile
cd

# Download and install Keybase but not run
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt-get install -fy

# Install QGIS
sudo add-apt-repository "deb http://qgis.org/ubuntugis-ltr xenial main/"
sudo add-apt-repository "deb-src http://qgis.org/ubuntugis-ltr xenial main"
sudo add-apt-repository "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 073D307A618E5811
sudo apt-get update
sudo apt-get install -y qgis python-qgis qgis-plugin-grass

# Install Atom
wget https://atom-installer.github.com/v1.17.2/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm atom-amd64.deb

# Install Anaconda
wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
sudo bash Anaconda3-4.3.1-Linux-x86_64.sh -b -p /opt/anaconda
rm Anaconda3-4.3.1-Linux-x86_64.sh
echo 'export PATH="/opt/anaconda/bin:$PATH"' >> ~/.profile

# Install CUDA
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
mv cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb cuda.deb
sudo dpkg -i cuda.deb
sudo apt-get update
sudo apt-get install -y cuda
echo 'export PATH="/usr/local/cuda-8.0/bin:$PATH"' >> ~/.profile
echo 'export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:LD_LIBRARY_PATH"' >> ~/.profile
rm cuda.deb
nvcc -V
# compile examples:
# cd /usr/local/cuda-8.0/samples
# sudo make
# cd bin



# MANUAL INSTALLS:
# Install Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
# Needs manual input to link accounts

# Keybase
run_keybase

# Atom Packages
