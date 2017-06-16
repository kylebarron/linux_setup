#!/bin/bash

# Update .bashrc
cp ~/.bashrc ~/.bashrc_original
cp dotfiles/.bashrc_personal ~/.bashrc
. ~/.bashrc

sudo apt-get install curl

# Install Anaconda
wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
sudo bash Anaconda3-4.3.1-Linux-x86_64.sh -b -p /opt/anaconda
rm Anaconda3-4.3.1-Linux-x86_64.sh
echo 'export PATH="/opt/anaconda/bin:$PATH"' >> ~/.bashrc

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
echo 'install.packages(c("tidyverse", "foreach", "doParallel", "AER", "feather", "stringr", "maptools", "ggmap", "sf", "gtrendsR", "gdata", "magrittr", "tidytext", "lintr", "formatR"), repos="https://cloud.r-project.org/")' >> install_packages.R
# IRkernel support:
echo "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cloud.r-project.org/')" >> install_packages.R
echo "devtools::install_github('IRkernel/IRkernel')" >> install_packages.R
echo "IRkernel::installspec()" >> install_packages.R
sudo chmod +x install_packages.R
sudo ./install_packages.R
rm install_packages.R

# Install RStudio Desktop
wget https://download1.rstudio.org/rstudio-1.0.143-amd64.deb
sudo apt-get -fy install
sudo dpkg -i rstudio-1.0.143-amd64.deb
rm rstudio-1.0.143-amd64.deb
# Replace RStudio settings
cp rstudio/user-settings /home/kyle/.rstudio-desktop/monitored/user-settings/user-settings

# Install RStudio Server
sudo apt-get install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
sudo gdebi --n rstudio-server-1.0.143-amd64.deb
sudo echo "www-address=127.0.0.1" >> /etc/rstudio/rserver.conf
#sudo rstudio-server restart
sudo rstudio-server start
rm rstudio-server-1.0.143-amd64.deb

# Install Node.js and npm
# Needed to install term3 as an Atom package
cd /opt
sudo wget https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz
sudo tar xvfJ node-v6.10.3-linux-x64.tar.xz
sudo rm node-v6.10.3-linux-x64.tar.xz
sudo mv node-v6.10.3-linux-x64 node
echo 'export PATH="/opt/node/bin:$PATH"' >> ~/.bashrc
cd ~/linux_setup

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -fy install
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

# Install Git
sudo apt-get install git

# Update Git config
git config --global user.name "Kyle Barron"
git config --global user.email barronk@mit.edu
git config --global core.editor nano

# Install Git Kraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb

# Install SSH Server
sudo apt-get install -y openssh-server

# SSH Server for encrypted home folder
sudo mkdir /etc/ssh/$(whoami)
sudo chmod 755 /etc/ssh/$(whoami)
#sudo mv ~/.ssh/authorized_keys /etc/ssh/$(whoami)/authorized_keys
sudo touch /etc/ssh/$(whoami)/authorized_keys
sudo chmod 644 /etc/ssh/$(whoami)/authorized_keys
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9qYxWBMPHc22t7gEa1mbDPlBkISDXGYGsJt9z6skeQqzZnqrqhqoXOQUXTSwJm5p4+1gCPR63KjwKPp5rAIKNuNKAM1Cf+1RDyLu1I6Ixtf6fv5NtWr1oK2VwTyMP+rPvaYAaNpr5aMF6JqJGt37/qVY9hyJu2D6p2tw5N/fzgtALeK820qeposmfb5DCn90zsDyTHi7khpp5nO9WfCFXFYO87Vxk2pzeMYSwmiabHdL6Tqs7jjNC3XLuOxaB9drv0J+PcNLclFEjeLq0dGWPleIGmjEx2xi7xWBsmYM2bnpADcuAMd25xpICf4rkr/tVlIbuiy8nUli9p6wiK8PKMcwxVs8+kVD+VuEmqTPKdNnk2zYSLkkEZSyo+X1wReXq56rtRJQWhpvFMvEUMbne4oHk90QYpVgMXZSiNF4h6srQq1yeSnV72UTmr9M2cgYkQXw9j0oB93Yoh8mpZIgCn9wBHWGljMURyR28Le1/dAPJvFSri6HhcV5+jy54g2q5PxlLNcA2AZneh5VW88VnW0iNrS9gN/Btk1EumcD3x2+M4XCdNhTzI548WFBEDNF2TO4VcEZIsqIsScWdoK6o/A7Bp2k5Pxj0RTkbB8jX5VbCwWrNQuY7ZPiiGBJchR18agWJDtlSV2AzvXW0tiAYG8yapBgvdzn3L9lvJ0vQnw== kyle@mac-linux" >> /etc/ssh/$(whoami)/authorized_keys
sudo sed -i 's@#AuthorizedKeysFile@AuthorizedKeysFile@g' /etc/ssh/sshd_config
sudo sed -i 's@%h/.ssh/authorized_keys@/etc/ssh/%u/authorized_keys@g' /etc/ssh/sshd_config
sudo sed -i 's@#PasswordAuthentication yes@PasswordAuthentication no@g' /etc/ssh/sshd_config
sudo sed -i 's@LogLevel INFO@LogLevel VERBOSE@g' /etc/ssh/sshd_config
sudo service ssh restart

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
sudo apt-get -fy install
sudo apt-get -y install rodeo

# Install VLC
sudo apt-get install -y vlc

# Install Julia
cd /opt
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/0.5/julia-0.5.2-linux-x86_64.tar.gz
sudo tar -xzf julia-0.5.2-linux-x86_64.tar.gz
sudo mv julia-f4c6c9d4bb/ julia/
sudo rm julia-0.5.2-linux-x86_64.tar.gz
echo 'export PATH="/opt/julia/bin:$PATH"' >> ~/.bashrc
cd ~/linux_setup

# Install IJulia
# Pkg.add("IJulia")

# Download and install Keybase but not run
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt-get install -fy

# Install QGIS
sudo add-apt-repository "deb http://qgis.org/ubuntugis-ltr xenial main/"
sudo add-apt-repository "deb-src http://qgis.org/ubuntugis-ltr xenial main"
sudo add-apt-repository "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 073D307A618E5811
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 089EBE08314DF160
sudo apt-get update
sudo apt-get install -y qgis python-qgis qgis-plugin-grass

# Install Atom
wget https://atom-installer.github.com/v1.17.2/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm atom-amd64.deb

# Change Atom Icon to atom-material-ui Icon
# Download icons
cd ~/linux_setup
wget https://www.dropbox.com/s/8gyn40sw95626dx/Atom-MD-Icon.zip?dl=1
unzip Atom-MD-Icon.zip?dl=1
sudo cp ~/Atom\ Icon/PNGs/icon_512x512@2x.png /usr/share/pixmaps/atom_material_ui.png
sudo sed -i 's/Icon=atom/Icon=atom_material_ui/' /usr/share/applications/atom.desktop
rm -r ~/__MACOSX/
rm -r ~/Atom\ Icon/
rm ~/Atom-MD-Icon.zip?dl=1

# Install Atom Packages
apm install --packages-file "atom/package-list.txt"

# Miscellaneous 
sudo apt-get install pandoc

# Flat plat design
sudo apt-get install gnome-themes-standard gnome-tweak-tool pixmap 
curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz
cd Flat-Plat-20170605 && sudo ./install.sh


# Install CUDA
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
mv cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb cuda.deb
sudo dpkg -i cuda.deb
sudo apt-get update
sudo apt-get install -y cuda
echo 'export PATH="/usr/local/cuda-8.0/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:LD_LIBRARY_PATH"' >> ~/.bashrc
rm cuda.deb
nvcc -V
# compile examples:
# cd /usr/local/cuda-8.0/samples
# sudo make
# cd bin

# Other .bashrc edits




# Install OpenVPN to use PIA
#sudo apt-get install -y openvpn unzip
#cd /etc/openvpn
#sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
#sudo unzip openvpn.zip
#sudo rm openvpn.zip
#touch pass.txt ## Add username and pasword in here manually
#for filename in *.ovpn
#do
#  sudo echo 'auth-user-pass pass.txt' >> $filename
#done
#sudo openvpn 'config-filename-goes-here.ovpn'


# MANUAL INSTALLS:
# Install Dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
# Needs manual input to link accounts

# Keybase
run_keybase
