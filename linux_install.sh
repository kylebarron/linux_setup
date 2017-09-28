#!/bin/bash

cwd=$(pwd)

sudo apt upgrade -y
sudo apt install curl

# Install Git
sudo apt install git

# Download my dotfiles
cd $cwd
git clone https://github.com/kylebarron/dotfiles.git
cd dotfiles
git submodule update --init --recursive
cd ../

# Install Zsh, Oh My Zsh, and Zsh Syntax Highlighting
sudo apt install zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo apt install zsh-syntax-highlighting

# Install the materialshell theme for zsh and update .zshrc
cd $cwd
cp dotfiles/zsh/materialshell.zsh-theme ~/.oh-my-zsh/themes/
cp dotfiles/zsh/zshrc_desktop ~/.zshrc

# Update .bashrc
cp dotfiles/bash/bashrc_desktop ~/.bashrc

# Install Anaconda
# Python 3.6:
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
bash Anaconda3-4.4.0-Linux-x86_64.sh -b -p ~/opt/anaconda3
rm Anaconda3-4.4.0-Linux-x86_64.sh
sudo chmod -R a+rX /usr/local/lib

# Install other python packages
pip install mkdocs-material mkdocs

# Install R
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt update
sudo apt install r-base r-base-dev -y

# Install R Packages
sudo apt -fy install
sudo apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev gdal-bin libgdal-dev python-software-properties
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt update
sudo apt upgrade -y gdal-bin libgdal-dev
touch install_packages.R
echo '#!/usr/bin/Rscript' >> install_packages.R
echo 'install.packages(c("tidyverse", "foreach", "doParallel", "AER", "feather", "stringr", "maptools", "ggmap", "sf", "gtrendsR", "gdata", "magrittr", "tidytext", "lintr", "formatR"), repos="https://cloud.r-project.org/")' >> install_packages.R
# IRkernel support:
echo "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cloud.r-project.org/')" >> install_packages.R
echo "devtools::install_github('IRkernel/IRkernel')" >> install_packages.R
echo "IRkernel::installspec( )" >> install_packages.R
chmod +x install_packages.R
./install_packages.R
rm install_packages.R

# Install RStudio Desktop
wget https://download1.rstudio.org/rstudio-1.0.153-amd64.deb
sudo apt install libjpeg62 libgstreamer0.10-0 libgstreamer-plugins-base0.10-0
sudo apt -fy install
sudo dpkg -i rstudio-1.0.153-amd64.deb
rm rstudio-1.0.153-amd64.deb
# Replace RStudio settings
mkdir -p ~/.rstudio-desktop/monitored/user-settings/
cp dotfiles/rstudio/user-settings ~/.rstudio-desktop/monitored/user-settings/user-settings

# Install RStudio Server
sudo apt install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.0.153-amd64.deb
sudo gdebi --n rstudio-server-1.0.153-amd64.deb
echo "www-address=127.0.0.1" | sudo tee --append /etc/rstudio/rserver.conf
#sudo rstudio-server restart
sudo rstudio-server start
rm rstudio-server-1.0.153-amd64.deb

# Install MySQL
wget https://dev.mysql.com/get/mysql-apt-config_0.8.7-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.7-1_all.deb
# Select options
sudo apt update
sudo apt install mysql-server

# Install Node.js and npm
# Needed to install term3 as an Atom package
cd /opt
sudo wget https://nodejs.org/dist/v6.11.2/node-v6.11.2-linux-x64.tar.xz
sudo tar xvfJ node-v6.11.2-linux-x64.tar.xz
sudo rm node-v6.11.2-linux-x64.tar.xz
sudo mv node-v6.11.2-linux-x64 node
cd $cwd

# Install Google Chrome
sudo apt install libappindicator1
sudo apt -fy install
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# doesn't work on headless remote linux machine because audio/visual drivers not installed
rm google-chrome-stable_current_amd64.deb

# Install Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update -y
sudo apt install -y spotify-client

# Install TeX
sudo apt install -y texlive-full

# Install Texmaker
sudo apt install -y texmaker

# Install Lyx
sudo add-apt-repository -y ppa:lyx-devel/release
sudo apt update
sudo apt install -y lyx

# Install f.lux
sudo apt install git python-appindicator python-xdg python-pexpect python-gconf python-gtk2 python-glade2 libxxf86vm1
git clone "https://github.com/xflux-gui/xflux-gui.git"
cd xflux-gui
python download-xflux.py
sudo python setup.py install
cd ../
rm -rf xflux-gui

# Update Git config
cp dotfiles/git/gitconfig_desktop ~/.gitconfig

# Install Git Kraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb

# Install Jekyll for making static sites
sudo apt install ruby-full
sudo gem install jekyll
sudo gem install bundler
# Need to run (sudo) bundle install or bundle update in website folder to install other dependent gems.

# Install VirtualBox
wget http://download.virtualbox.org/virtualbox/5.1.26/virtualbox-5.1_5.1.26-117224~Ubuntu~xenial_amd64.deb
sudo dpkg -i virtualbox-5.1_5.1.26-117224-Ubuntu-xenial_amd64.deb
# Download VirtualBox Extension Pack
wget http://download.virtualbox.org/virtualbox/5.1.26/Oracle_VM_VirtualBox_Extension_Pack-5.1.26-117224.vbox-extpack
sudo adduser `whoami` vboxusers

# Install SSH Server
sudo apt install -y openssh-server

# SSH Server for encrypted home folder
sudo mkdir /etc/ssh/$(whoami)
sudo chmod 755 /etc/ssh/$(whoami)
#sudo mv ~/.ssh/authorized_keys /etc/ssh/$(whoami)/authorized_keys
sudo touch /etc/ssh/$(whoami)/authorized_keys
sudo chmod 644 /etc/ssh/$(whoami)/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqIiTcGgYb0DHwLG+WQXgt7t+pBFYdyO494VFFsv5KFa1g+pqdcvZyPoyVqV2ZT2h5w055gKau+GLbtavyK74GRDJFYBNomuEIXp9RBWTt6/qzpnMKTvmMAKgLTujIrUjtYbVhncUB7mV438FecbnNBQW61jqCkEQQSwUlli94RD3C+qOjnLIe9vrIlvcYbZMZUfCmL7VUQByJlkvfhpiteRzXfpXamuCgQAn8GiE9c9S1EFkqcT/7ECLkJNL8ToNVDU7DieQP1ZIIPy6ktG3EOYAcmJwVQ3kSYJcQqL8cy4PVHrZuLyKefKrqeRaSFs1uA83DpjOCxfSBmmqBMR9kLAdG+rkA+a8/Fjn6BPyab6Kr0Uxy0LJfHGgUGA5hKwZExfLzioSIXH9veHUETOcUhG4fmhCWuRGD2ZW2231R/s9ZVjZrdkzCoIrrcnhN4LrnQb29aP15V3RH6hJhWPG8e+paOfIvW8zQaQoqPf9exGhV+CaPPh3OqLKPU1qSZDjyShb4GxKqCJz3ScKIf+bAi+8T/rvQVsw3gLzc+kD9yLdbX30HIUI5sQdyYZAKVNfpuWgIe9e7Q1DVZP3IeBot5GZyTUave7FpTum4TPxc3vUn5ktz7HRMt03Ff64hV3b5RMJbV8s2zaoMUyid79wNUGU2AZAxOWjnVZuaIzPtXw== kyle@mac.local" | sudo tee --append /etc/ssh/$(whoami)/authorized_keys
sudo sed -i 's@#AuthorizedKeysFile@AuthorizedKeysFile@g' /etc/ssh/sshd_config
sudo sed -i 's@%h/.ssh/authorized_keys@/etc/ssh/%u/authorized_keys@g' /etc/ssh/sshd_config
sudo sed -i 's@#PasswordAuthentication yes@PasswordAuthentication no@g' /etc/ssh/sshd_config
sudo sed -i 's@LogLevel INFO@LogLevel VERBOSE@g' /etc/ssh/sshd_config
sudo service ssh restart

## Rclone
# Fetch and unpack
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
rm rclone-current-linux-amd64.zip 
cd rclone-*-linux-amd64
# Copy binary file
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
# Install manpage
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
cd $cwd
rm -r rclone-v1.37-linux-amd64

# Fuzzy File Finder
cd $cwd
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install FileZilla
sudo apt install -y filezilla

# Install Google Earth
sudo apt install lsb-core
sudo apt -fy install
wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable_current_amd64.deb
rm google-earth-stable_current_amd64.deb

# Install VLC
sudo apt install -y vlc

# Install Julia
cd /opt
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.0-linux-x86_64.tar.gz
sudo tar -xzf julia-0.6.0-linux-x86_64.tar.gz
sudo mv julia-903644385b/ julia/
sudo rm julia-0.6.0-linux-x86_64.tar.gz
cd $cwd

# Install Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce
sudo docker run hello-world

# Install IJulia
# Pkg.add("IJulia")

# Bash Jupyter Kernel
pip install bash_kernel
sudo mkdir /usr/local/share/jupyter
sudo chown $USER:$USER /usr/local/share/jupyter
python -m bash_kernel.install

# Download and install Keybase but not run
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt install -fy
rm keybase_amd64.deb

# Install QGIS
sudo add-apt-repository "deb http://qgis.org/ubuntugis xenial main"
sudo add-apt-repository "deb-src http://qgis.org/ubuntugis xenial main"
sudo add-apt-repository "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main"
sudo apt-key adv        --keyserver keyserver.ubuntu.com --recv-keys 073D307A618E5811
sudo apt-key adv        --keyserver keyserver.ubuntu.com --recv-keys 089EBE08314DF160
sudo apt update
sudo apt install -y qgis python-qgis qgis-plugin-grass

# Install PostgreSQL
sudo touch /etc/apt/sources.list.d/pgdg.list
echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' | sudo tee --append /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install postgresql-9.6

# Install PostGIS
# NOTE Must have already added UbuntuGIS GPG keys
sudo apt install postgis

# Install Atom
wget https://github.com/atom/atom/releases/download/v1.19.0/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm atom-amd64.deb

# Restore Atom Settings
mkdir -p ~/.atom
cp dotfiles/atom/* ~/.atom/
# Change Atom Icon to atom-material-ui Icon
sudo cp dotfiles/atom/atom_icon.png /usr/share/pixmaps/atom_material_ui.png
sudo sed -i 's/Icon=atom/Icon=atom_material_ui/' /usr/share/applications/atom.desktop

# Install Atom Packages
# apm list --installed --bare > package-list.txt
apm install --packages-file "dotfiles/atom/desktop_package_list.txt"
apm update

# Install Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text

# Install Pandoc
sudo apt install pandoc
# My PATH puts /opt/anaconda/bin before /usr/bin because I want python 3.6 to be automatically sourced
# But /opt/anaconda/bin has old versions of pandoc and pandoc-citeproc, and I want the newer versions to be used
# So I'll remove those binaries in /opt/anaconda/bin and symlink it to /usr/bin
# sudo rm /opt/anaconda/bin/pandoc Doesn't exist?
# sudo rm /opt/anaconda/bin/pandoc-citeproc
sudo ln -s /usr/bin/pandoc          ~/opt/anaconda/bin/pandoc
sudo ln -s /usr/bin/pandoc-citeproc ~/opt/anaconda/bin/pandoc-citeproc

# autokey-gtk
sudo add-apt-repository ppa:troxor/autokey
sudo apt update
sudo apt install -y autokey-gtk
mkdir -p ~/.config/autokey/data/Sample\ Scripts/
cp dotfiles/autokey/code/run_stata.py          ~/.config/autokey/data/My\ Phrases/run_stata.py
cp dotfiles/autokey/code/.run_stata.json       ~/.config/autokey/data/My\ Phrases/.run_stata.json
cp dotfiles/autokey/code/run_stata_chunk.py    ~/.config/autokey/data/My\ Phrases/run_stata_chunk.py
cp dotfiles/autokey/code/.run_stata_chunk.json ~/.config/autokey/data/My\ Phrases/.run_stata_chunk.json

# Miscellaneous random other small things
sudo apt install -y tmux
cp dotfiles/tmux/tmux.conf ~/.tmux.conf
sudo apt install python3-dev python3-pip
sudo pip3 install thefuck
sudo apt install tree
sudo apt install shellcheck
sudo apt install xclip

wget https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz
extract hub-linux-amd64-2.2.9.tgz
cd hub-linux-amd64-2.2.9
sudo ./install

sudo apt install -y libmagick++-dev

# Fira Code Font
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
    wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
done
fc-cache -f

# Flat plat design
sudo apt install -y gnome-themes-standard gnome-tweak-tool pixmap
curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz
cd Flat-Plat-20170605 && sudo ./install.sh

# Install CUDA
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
mv cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb cuda.deb
sudo dpkg -i cuda.deb
sudo apt update
sudo apt install -y cuda
echo 'export PATH="/usr/local/cuda-8.0/bin:$PATH"' >> ~/.zshrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:LD_LIBRARY_PATH"' >> ~/.zshrc
rm cuda.deb
nvcc -V
# compile examples:
# cd /usr/local/cuda-8.0/samples
# sudo make
# cd bin

# Install OpenVPN to use PIA
sudo apt install -y openvpn unzip
cd /etc/openvpn
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
sudo apt install unzip
sudo unzip openvpn.zip
sudo rm openvpn.zip
sudo touch pass.txt ## Add username and pasword in here manually
sudo chmod 600 pass.txt
for filename in *.ovpn
do
  sudo sed -i 's@auth-user-pass@auth-user-pass pass.txt@g' $filename
done

# Remove Unity App Animations (cause I like hiding the launcher)
# 1) Install Compiz Settings Manager
sudo apt install compizconfig-settings-manager
ccsm
# 2) Compiz Setting Manager -> Desktop -> Ubuntu Unity Plugin -> Launcher
# 3) Launch Animation: None 
#    Urgent Animation: None 
#    Hide Animation: Fade Only Dash Blur: No Blur 
# 4) CSM -> Effects 5) Disabled everything except Windows Decoration 6) Installed few unity tweakers and made sure that settings there match ones in CSM. In my case MyUnity still was showing Hide Animation set to Fade and Slide, so I changed it to Fade Only there as well.
# https://askubuntu.com/a/320734/654313


# MANUAL INSTALLS:
# Install Dropbox
sudo apt install python-gpgme
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
# Needs manual input to link accounts

# Keybase
run_keybase

# Other manual stuff:
# go to gnome-tweak-tool and turn on flat-plat-dark
# 
# 
