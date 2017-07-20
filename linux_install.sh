#!/bin/bash

sudo apt-get upgrade -y

# Install Zsh
sudo apt install zsh

# Install Oh My Zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install the materialshell theme for zsh
cd ~/linux_setup
git clone https://github.com/carloscuesta/materialshell.git
cp materialshell/zsh/materialshell.zsh-theme ~/.oh-my-zsh/themes/
sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="materialshell"@g' ~/.zshrc
# Remove black background from folders and symlinks
sed -i "s@export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'@#export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'@g" ~/.oh-my-zsh/themes/materialshell.zsh-theme
echo "export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'" >> ~/.oh-my-zsh/themes/materialshell.zsh-theme
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console


# Update .zshrc
mv ~/.zshrc ~/.zshrc_original
cp dotfiles/.zshrc ~/.zshrc
# zsh ~/.bashrc

sudo apt install curl

# Install Anaconda
wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
sudo bash Anaconda3-4.3.1-Linux-x86_64.sh -b -p /opt/anaconda
rm Anaconda3-4.3.1-Linux-x86_64.sh
echo 'export PATH="/opt/anaconda/bin:$PATH"' >> ~/.zshrc

# Install R
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt install r-base r-base-dev -y

# Install R Packages
sudo apt-get -fy install
sudo apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev gdal-bin libgdal-dev python-software-properties
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get upgrade -y gdal-bin libgdal-dev
touch install_packages.R
echo '#!/usr/bin/Rscript' >> install_packages.R
echo 'install.packages(c("tidyverse", "foreach", "doParallel", "AER", "feather", "stringr", "maptools", "ggmap", "sf", "gtrendsR", "gdata", "magrittr", "tidytext", "lintr", "formatR"), repos="https://cloud.r-project.org/")' >> install_packages.R
# IRkernel support:
echo "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cloud.r-project.org/')" >> install_packages.R
echo "devtools::install_github('IRkernel/IRkernel')" >> install_packages.R
echo "IRkernel::installspec( )" >> install_packages.R
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
sudo apt install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
sudo gdebi --n rstudio-server-1.0.143-amd64.deb
echo "www-address=127.0.0.1" | sudo tee --append /etc/rstudio/rserver.conf
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
echo 'export PATH="/opt/node/bin:$PATH"' >> ~/.zshrc
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
sudo apt install -y spotify-client

# Install TeX
sudo apt install -y texlive-full

# Install Texmaker
sudo apt install -y texmaker

# Install Lyx
sudo add-apt-repository -y ppa:lyx-devel/release
sudo apt-get update
sudo apt install -y lyx

# Install Git
sudo apt install git

# Update Git config
mv ~/.gitconfig ~/.gitconfig_original
cp dotfiles/.gitconfig ~/.gitconfig

# Install Git Kraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb

# Install SSH Server
sudo apt install -y openssh-server

# SSH Server for encrypted home folder
sudo mkdir /etc/ssh/$(whoami)
sudo chmod 755 /etc/ssh/$(whoami)
#sudo mv ~/.ssh/authorized_keys /etc/ssh/$(whoami)/authorized_keys
sudo touch /etc/ssh/$(whoami)/authorized_keys
sudo chmod 644 /etc/ssh/$(whoami)/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9qYxWBMPHc22t7gEa1mbDPlBkISDXGYGsJt9z6skeQqzZnqrqhqoXOQUXTSwJm5p4+1gCPR63KjwKPp5rAIKNuNKAM1Cf+1RDyLu1I6Ixtf6fv5NtWr1oK2VwTyMP+rPvaYAaNpr5aMF6JqJGt37/qVY9hyJu2D6p2tw5N/fzgtALeK820qeposmfb5DCn90zsDyTHi7khpp5nO9WfCFXFYO87Vxk2pzeMYSwmiabHdL6Tqs7jjNC3XLuOxaB9drv0J+PcNLclFEjeLq0dGWPleIGmjEx2xi7xWBsmYM2bnpADcuAMd25xpICf4rkr/tVlIbuiy8nUli9p6wiK8PKMcwxVs8+kVD+VuEmqTPKdNnk2zYSLkkEZSyo+X1wReXq56rtRJQWhpvFMvEUMbne4oHk90QYpVgMXZSiNF4h6srQq1yeSnV72UTmr9M2cgYkQXw9j0oB93Yoh8mpZIgCn9wBHWGljMURyR28Le1/dAPJvFSri6HhcV5+jy54g2q5PxlLNcA2AZneh5VW88VnW0iNrS9gN/Btk1EumcD3x2+M4XCdNhTzI548WFBEDNF2TO4VcEZIsqIsScWdoK6o/A7Bp2k5Pxj0RTkbB8jX5VbCwWrNQuY7ZPiiGBJchR18agWJDtlSV2AzvXW0tiAYG8yapBgvdzn3L9lvJ0vQnw== kyle@mac-linux" | sudo tee --append /etc/ssh/$(whoami)/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLj+wWR7tstScXy6vDi7NmMqSu40tiF1Qa6OLIqtMVCRRvxhu+AAL6Ig/7wcPz1A0vwgMbpahfNq//FgyHIZLiYz+ysrrfUZxhBr6jQMXe+BDugZTBV9epsVxw3qzHvI4X04/sT7v0mybQb4MLWZ8rpeJLChKxASMO02JPLIi6tK9qlh+SMJFld+joMZTa8uxaBLipWSJL2F3kEZveA7/lAWqz/Kj6zERTVUb6kxSDujCRCP2oPOP3/546/1iwSI8pmo1WXifStAmJ5DQp0xBGdn495zVV5RVyqz2+qUnN7LKg+U3AqJdKmBHT9CDGm9+nBagSXoO8CRx/mmmQR3rp kyle@mac-osx" | sudo tee --append /etc/ssh/$(whoami)/authorized_keys
sudo sed -i 's@#AuthorizedKeysFile@AuthorizedKeysFile@g' /etc/ssh/sshd_config
sudo sed -i 's@%h/.ssh/authorized_keys@/etc/ssh/%u/authorized_keys@g' /etc/ssh/sshd_config
sudo sed -i 's@#PasswordAuthentication yes@PasswordAuthentication no@g' /etc/ssh/sshd_config
sudo sed -i 's@LogLevel INFO@LogLevel VERBOSE@g' /etc/ssh/sshd_config
sudo service ssh restart

# Fuzzy File Finder
cd ~/linux_setup
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# autokey-gtk
sudo add-apt-repository ppa:troxor/autokey
sudo apt update
sudo apt install autokey-gtk
# My stata commands are in autokey/

# Install FileZilla
sudo apt install -y filezilla

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
sudo apt install -y vlc

# Install Julia
cd /opt
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/0.5/julia-0.5.2-linux-x86_64.tar.gz
sudo tar -xzf julia-0.5.2-linux-x86_64.tar.gz
sudo mv julia-f4c6c9d4bb/ julia/
sudo rm julia-0.5.2-linux-x86_64.tar.gz
echo 'export PATH="/opt/julia/bin:$PATH"' >> ~/.zshrc
cd ~/linux_setup

# Install IJulia
# Pkg.add("IJulia")

# Bash Jupyter Kernel
pip install bash_kernel
python -m bash_kernel.install

# Download and install Keybase but not run
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt install -fy

# Install QGIS
sudo add-apt-repository "deb http://qgis.org/ubuntugis-ltr xenial main/"
sudo add-apt-repository "deb-src http://qgis.org/ubuntugis-ltr xenial main"
sudo add-apt-repository "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 073D307A618E5811
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 089EBE08314DF160
sudo apt-get update
sudo apt install -y qgis python-qgis qgis-plugin-grass

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
# apm list --installed --bare > package-list.txt
apm install --packages-file "atom/package-list.txt"
apm update

# Install Pandoc
sudo apt install pandoc
# My PATH puts /opt/anaconda/bin before /usr/bin because I want python 3.6 to be automatically sourced
# But /opt/anaconda/bin has old versions of pandoc and pandoc-citeproc, and I want the newer versions to be used
# So I'll remove those binaries in /opt/anaconda/bin and symlink it to /usr/bin
sudo rm /opt/anaconda/bin/pandoc
sudo rm /opt/anaconda/bin/pandoc-citeproc
sudo ln -s /usr/bin/pandoc /opt/anaconda/bin/pandoc
sudo ln -s /usr/bin/pandoc-citeproc /opt/anaconda/bin/pandoc-citeproc

# autokey-gtk
sudo add-apt-repository ppa:troxor/autokey
sudo apt update
sudo apt install autokey-gtk

# Install tmux
sudo apt install tmux

# Update .bashrc
mv ~/.bashrc ~/.bashrc_original
cp dotfiles/.bashrc_personal ~/.bashrc
. ~/.bashrc


# Flat plat design
sudo apt install gnome-themes-standard gnome-tweak-tool pixmap
curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz
cd Flat-Plat-20170605 && sudo ./install.sh

# Install Ruby and Jekyll
sudo apt install ruby-full
sudo gem install jekyll


# Install CUDA
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
mv cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb cuda.deb
sudo dpkg -i cuda.deb
sudo apt-get update
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
<<<<<<< HEAD
#sudo apt install -y openvpn unzip
#cd /etc/openvpn
#sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
#sudo unzip openvpn.zip
#sudo rm openvpn.zip
#touch pass.txt ## Add username and pasword in here manually
#for filename in *.ovpn
#do
#  sudo echo 'auth-user-pass pass.txt' >> $filename
# don't use sudo echo
#done
#sudo openvpn 'config-filename-goes-here.ovpn'
=======
sudo apt-get install -y openvpn unzip
cd /etc/openvpn
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
sudo apt-get install unzip
sudo unzip openvpn.zip
sudo rm openvpn.zip
touch pass.txt ## Add username and pasword in here manually
sudo chmod 600 pass.txt
for filename in *.ovpn
do
  sudo sed -i 's@auth-user-pass@auth-user-pass pass.txt@g' $filename
done

# Remove Unity App Animations (cause I like hiding the launcher)
# 1) Installed Compiz Sttings Manager 2) Compiz Setting Manager -> Unity -> Experimental tab 3) Launch Animation: None Urgent Animation: None Hide Animation: Fade Only Dash Blur: No Blur 4) CSM -> Effects 5) Disabled everything except Windows Decoration 6) Installed few unity tweakers and made sure that settings there match ones in CSM. In my case MyUnity still was showing Hide Animation set to Fade and Slide, so I changed it to Fade Only there as well.
# https://askubuntu.com/a/320734/654313
>>>>>>> ee0fc31ef02f2cbdbaacbfb71e215c2c73f21078


# MANUAL INSTALLS:
# Install Dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
# Needs manual input to link accounts

# Keybase
run_keybase
