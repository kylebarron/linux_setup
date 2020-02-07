#! /usr/bin/env bash

cd /tmp
export PATH=$HOME/local/bin:$PATH
sudo_not_installed=$'The following programs were not able to be installed without sudo:\n'

if [[ $sudo = 'True' ]]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y build-essential autoconf unzip curl
fi

if [[ $git = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository ppa:git-core/ppa -y
        sudo apt-get update -y
        sudo apt-get install git -y
    else
        link="https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz"
        wget $link -O /tmp/git.tar.gz
        mkdir /tmp/git
        tar -xzvf /tmp/git.tar.gz -C /tmp/git --strip-components 1

        cd /tmp/git
        ./configure --prefix=$HOME/local/
        make && make install
    fi
fi

# Download my dotfiles
git clone https://github.com/kylebarron/dotfiles.git /tmp/dotfiles

if [[ $gitconfig = 'True' ]]; then
    cp /tmp/dotfiles/git/gitconfig_desktop ~/.gitconfig
fi

if [[ $zsh = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y zsh
    else
        wget -O /tmp/zsh.tar.gz https://sourceforge.net/projects/zsh/files/latest/download
        cd /tmp
        mkdir zsh && tar -xvJf zsh.tar.gz -C zsh --strip-components 1
        cd /tmp/zsh

        ./configure --prefix=$HOME/local/
        make && make install
    fi
fi

if [[ $oh-my-zsh = 'True' ]]; then
    git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

    # Breaks the flow:
    # if [[ $sudo = 'True' ]]; then
    #     sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    # fi
fi

if [[ $zsh-autosuggestions = 'True' ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ $zsh-syntax-highlighting = 'True' ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [[ $materialshell = 'True' ]]; then
    cp /tmp/dotfiles/zsh/materialshell.zsh-theme ~/.oh-my-zsh/themes/
fi

if [[ $zshrc = 'True' ]]; then
    cp /tmp/dotfiles/zsh/zshrc_desktop ~/.zshrc
fi

if [[ $bashrc = 'True' ]]; then
    cp /tmp/dotfiles/bash/bashrc_desktop ~/.bashrc
    if [[ $sudo != 'True' ]]; then
        cat 'exec $HOME/bin/zsh -l' >> ~/.bashrc
    fi
fi

if [[ $ssh-server = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # Install SSH Server
        sudo apt install -y openssh-server

        # SSH Server for encrypted home folder
        sudo mkdir -p /etc/ssh/$(whoami)
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
    else
        sudo_not_installed+=$'- openssh-server\n'
    fi
fi

if [[ $anaconda3 = 'True' ]]; then
    latest="$(curl https://repo.continuum.io/archive/ | grep -P 'Anaconda3-\d\.\d\.\d-Linux-x86_64' | sed -n 1p | cut -d '"' -f 2)"
    wget 'https://repo.continuum.io/archive/'$latest -O /tmp/anaconda3.sh
    bash /tmp/anaconda3.sh -b -p ~/local/anaconda3
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y python3-dev python3-pip
    fi
    ~/local/anaconda3/bin/conda update --all
    export PATH=$HOME/local/anaconda3/bin:$PATH
    rm ~/local/anaconda3/bin/curl
elif [[ $miniconda3 = 'True' ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda3.sh
    bash /tmp/miniconda3.sh -b -p ~/local/miniconda3
    ~/local/miniconda3/bin/conda update --all
    export PATH=$HOME/local/miniconda3/bin:$PATH
fi

if [[ $anaconda2 = 'True' ]]; then
    latest="$(curl https://repo.continuum.io/archive/ | grep -P 'Anaconda2-\d\.\d\.\d-Linux-x86_64' | sed -n 1p | cut -d '"' -f 2)"
    wget 'https://repo.continuum.io/archive/'$latest -O /tmp/anaconda2.sh
    bash /tmp/anaconda2.sh -b -p ~/local/anaconda2
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y python3-dev python3-pip
    fi
    ~/local/anaconda2/bin/conda update --all
    export PATH=$HOME/local/anaconda2/bin:$PATH
fi

if [[ $jupyter-notebook-remote = 'True' ]]; then
    jupyter notebook --generate-config
    sed -i "s@#c.NotebookApp.port = 8888@c.NotebookApp.port = 8888@g" ~/.jupyter/jupyter_notebook_config.py
    sed -i "s@#c.NotebookApp.open_browser = True@c.NotebookApp.open_browser = False@g" ~/.jupyter/jupyter_notebook_config.py
fi

if [[ $mkdocs = 'True' ]]; then
    pip install mkdocs mkdocs-material
fi

if [[ $yapf = 'True' ]]; then
    pip install yapf
    mkdir -p ~/.config/yapf/
    cp /tmp/dotfiles/yapf/yapf.py ~/.config/yapf/style
fi

if [[ $r = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu xenial/"
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
        sudo apt update
        sudo apt install -y r-base r-base-dev
        sudo chown -R $USER:$USER /usr/local/lib/R/site-library
        # https://stackoverflow.com/questions/29969838/setting-r-libs-avoiding-would-you-like-to-use-a-personal-library-instead
    else
        sudo_not_installed+=$'- R\n'
    fi
fi

if [[ $r-tidyverse = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo chown -R $USER:$USER /usr/local/lib/R/site-library
        sudo apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev
    else
        mkdir -p ~/local/R/site-library/
        export R_LIBS_USER='~/local/R/site-library/'
    fi
    Rscript -e "install.packages('tidyverse', repos='https://cran.us.r-project.org')"
fi

if [[ $r-all = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt -fy install
        sudo apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev gdal-bin libgdal-dev python-software-properties
        sudo add-apt-repository -y ppa:ubuntugis/ppa
        sudo apt update
        sudo apt upgrade -y gdal-bin libgdal-dev
        Rscript /tmp/dotfiles/install_packages.R
    fi
fi

if [[ $rstudio-desktop = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        latest="$(curl https://www.rstudio.com/products/rstudio/download/ | grep 'href' | grep -i -E 'rstudio-xenial-1\.[[:digit:]]+\.[[:digit:]]+-amd64\.deb' | cut -d '"' -f 2)"
        if [[ -n "$latest" ]]; then
            wget $latest -O /tmp/rstudio-desktop.deb
        else
            wget https://download1.rstudio.org/rstudio-xenial-1.1.423-amd64.deb -O /tmp/rstudio-desktop.deb
        fi
        sudo apt install -y libjpeg62 libgstreamer0.10-0 libgstreamer-plugins-base0.10-0
        sudo apt -fy install
        sudo dpkg -i -O /tmp/rstudio-desktop.deb

        # Replace RStudio settings
        mkdir -p ~/.rstudio-desktop/monitored/user-settings/
        cp /tmp/dotfiles/rstudio/user-settings ~/.rstudio-desktop/monitored/user-settings/user-settings
    else
        sudo_not_installed+=$'- RStudio desktop\n'
    fi
fi

if [[ $rstudio-server = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        latest="$(curl https://www.rstudio.com/products/rstudio/download-server/ | grep '$ wget' | grep 'amd64' | grep -o -P 'http.+?(?=</code)')"
        if [[ -n "$latest" ]]; then
            wget $latest -O /tmp/rstudio-server.deb
        else
            wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb -O /tmp/rstudio-server.deb
        fi
        sudo apt install -y gdebi-core
        sudo gdebi --n /tmp/rstudio-server.deb
        echo "www-address=127.0.0.1" | sudo tee --append /etc/rstudio/rserver.conf
        sudo rstudio-server start
    else
        sudo_not_installed+=$'- RStudio server\n'
    fi
fi

if [[ $julia = 'True' ]]; then
    latest="$(curl https://julialang.org/downloads/ | grep 'href' | grep -io -P 'http.+?julia-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+-linux-x86_64.tar.gz' | head -n 1)"
    if [[ -n "$latest" ]]; then
        wget $latest -O /tmp/julia.tar.gz
    else
        wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz -O /tmp/julia.tar.gz
    fi
    mkdir /tmp/julia/
    tar -xzvf /tmp/julia.tar.gz -C /tmp/julia/ --strip-components 1

    mkdir -p ~/local/bin/
    mv /tmp/julia/bin/* ~/local/bin/

    mkdir -p ~/local/include/
    mv /tmp/julia/include/* ~/local/include/

    mkdir -p ~/local/lib/
    mv /tmp/julia/lib/* ~/local/lib/

    mkdir -p ~/local/share/applications/
    mv /tmp/julia/share/applications/* ~/local/share/applications/

    mkdir -p ~/local/share/doc/
    mv /tmp/julia/share/doc/* ~/local/share/doc/

    mkdir -p ~/local/share/man/man1/
    mv /tmp/julia/share/man/man1/* ~/local/share/man/man1/

    mv /tmp/julia/share/julia ~/local/share/

    if [[ $ijulia = 'True' ]]; then
        ~/local/bin/julia -e 'Pkg.add("IJulia")'
    fi
fi

if [[ $go = 'True' ]]; then
    wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz -O /tmp/go.tar.gz
    mkdir ~/local/go
    tar -xzvf /tmp/go.tar.gz -C ~/local/go --strip-components 1

    export GOROOT=$HOME/local/go
    export GOPATH=$HOME/github/go
    export PATH=$PATH:$GOROOT/bin

    if [[ $gophernotes = 'True' ]]; then
        go get -u github.com/gopherdata/gophernotes
        mkdir -p ~/.local/share/jupyter/kernels/gophernotes
        cp $GOPATH/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes
    fi
fi

if [[ $mysql = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        wget https://dev.mysql.com/get/mysql-apt-config_0.8.7-1_all.deb -O /tmp/mysql-apt-config.deb
        sudo dpkg -i /tmp/mysql-apt-config.deb

        # Select options
        sudo apt update
        sudo apt install -y mysql-server
    else
        sudo_not_installed+=$'- MySQL\n'
    fi
fi

if [[ $postgres = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo touch /etc/apt/sources.list.d/pgdg.list
        echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' | sudo tee --append /etc/apt/sources.list.d/pgdg.list
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
        sudo apt update
        sudo apt install -y postgresql-10
        sudo apt install -y pgloader
    else
        sudo_not_installed+=$'- PostgreSQL\n'
    fi
fi

if [[ $postgis = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository -y ppa:ubuntugis/ppa
        sudo apt update
        sudo apt install -y postgis
        sudo apt install -y postgresql-10-postgis-2.4
    else
        sudo_not_installed+=$'- PostGIS\n'
    fi
fi

if [[ $qgis = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository "deb http://qgis.org/ubuntugis xenial main"
        sudo add-apt-repository "deb-src http://qgis.org/ubuntugis xenial main"
        sudo add-apt-repository "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main"
        sudo apt-key adv        --keyserver keyserver.ubuntu.com --recv-keys 073D307A618E5811
        sudo apt-key adv        --keyserver keyserver.ubuntu.com --recv-keys 089EBE08314DF160
        sudo apt update
        sudo apt install -y qgis python-qgis qgis-plugin-grass
    else
        sudo_not_installed+=$'- QGIS\n'
    fi
fi

if [[ $readstat = 'True' ]]; then
    # NOTE: this assumes you installed Anaconda in the same location I did
    # NOTE: This depends on you having correct values of LD_LIBRARY_PATH
    git clone https://github.com/WizardMac/ReadStat.git /tmp/ReadStat
    cd /tmp/ReadStat
    ./autogen.sh
    if [[ $anaconda3 = 'True' ]]; then
        cat ~/local/anaconda3/share/aclocal/libtool.m4 >> aclocal.m4
        cat ~/local/anaconda3/share/aclocal/ltoptions.m4 >> aclocal.m4
        cat ~/local/anaconda3/share/aclocal/ltversion.m4 >> aclocal.m4
        cat ~/local/anaconda3/share/aclocal/lt\~obsolete.m4 >> aclocal.m4
    elif [[ $anaconda2 = 'True' ]]; then
        cat ~/local/anaconda2/share/aclocal/libtool.m4 >> aclocal.m4
        cat ~/local/anaconda2/share/aclocal/ltoptions.m4 >> aclocal.m4
        cat ~/local/anaconda2/share/aclocal/ltversion.m4 >> aclocal.m4
        cat ~/local/anaconda2/share/aclocal/lt\~obsolete.m4 >> aclocal.m4
    elif [[ $miniconda3 = 'True' ]]; then
        cat ~/local/miniconda3/share/aclocal/libtool.m4 >> aclocal.m4
        cat ~/local/miniconda3/share/aclocal/ltoptions.m4 >> aclocal.m4
        cat ~/local/miniconda3/share/aclocal/ltversion.m4 >> aclocal.m4
        cat ~/local/miniconda3/share/aclocal/lt\~obsolete.m4 >> aclocal.m4
    fi
    ./configure --prefix=$HOME/local
    make && make install
fi

if [[ $atom = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        link="$(curl -s https://api.github.com/repos/atom/atom/releases/latest | grep 'browser_download_url' | grep 'deb' | cut -d '"' -f 4)"
        wget $link -O /tmp/atom.deb
        sudo dpkg -i /tmp/atom.deb

        mkdir -p ~/.atom
        cp /tmp/dotfiles/atom/* ~/.atom/

        # Change Atom Icon to atom-material-ui Icon
        sudo cp /tmp/dotfiles/atom/atom_icon.png /usr/share/pixmaps/atom_material_ui.png
        sudo sed -i 's/Icon=atom/Icon=atom_material_ui/' /usr/share/applications/atom.desktop
    else
        sudo_not_installed+=$'- Atom\n'
    fi

    if [[ $atom-packages = 'True' ]]; then
        apm install --packages-file "/tmp/dotfiles/atom/desktop_package_list.txt"
        apm update
    fi
fi

if [[ $fira-code = 'True' ]]; then
    mkdir -p ~/.local/share/fonts
    for type in Bold Light Medium Regular Retina; do
        wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
        "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
    done
    fc-cache -f
fi

if [[ $sublime-text = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        sudo apt update
        sudo apt install -y sublime-text
    else
        sudo_not_installed+=$'- Sublime Text\n'
    fi
fi

if [[ $pandoc = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        wget `curl -s https://api.github.com/repos/jgm/pandoc/releases/latest | grep 'browser_download_url' | grep 'deb' | cut -d '"' -f 4` -O /tmp/pandoc.deb
        sudo dpkg -i /tmp/pandoc.deb
    else
        wget `curl -s https://api.github.com/repos/jgm/pandoc/releases/latest | grep 'browser_download_url' | grep '.tar.gz' | cut -d '"' -f 4` -O /tmp/pandoc.tar.gz
        mkdir /tmp/pandoc
        tar xvzf /tmp/pandoc.tar.gz --strip-components 1 -C /tmp/pandoc

        mkdir -p ~/local/bin
        mv /tmp/pandoc/bin/* ~/local/bin/

        mkdir -p ~/local/share/man/man1
        gunzip /tmp/pandoc/share/man/man1/*
        mv /tmp/pandoc/share/man/man1/* ~/local/share/man/man1/
    fi
fi

if [[ $autokey-gtk = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository ppa:troxor/autokey
        sudo apt update
        sudo apt install -y autokey-gtk
    else
        sudo_not_installed+=$'- Autokey\n'
    fi
fi

if [[ $nodejs8 = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
        sudo apt-get install -y nodejs build-essential
    else
        latest="$(curl https://nodejs.org/dist/latest-v8.x/ | grep -P 'linux-x64\.tar\.gz' | sed -n 1p | cut -d '"' -f 2)"
        wget https://nodejs.org/dist/latest-v8.x/$latest -O /tmp/node-v8.tar.gz

        mkdir /tmp/node
        tar -xzvf /tmp/node-v8.tar.gz -C /tmp/node/ --strip-components 1

        mkdir -p ~/local/bin/
        mv /tmp/node/bin/* ~/local/bin/

        mkdir -p ~/local/include/
        mv /tmp/node/include/* ~/local/include/

        mkdir -p ~/local/lib/
        mv /tmp/node/lib/* ~/local/lib/

        mkdir -p ~/local/share/doc/
        mv /tmp/node/share/doc/* ~/local/share/doc/

        mkdir -p ~/local/share/man/man1/
        mv /tmp/node/share/man/man1/* ~/local/share/man/man1/

        npm config set prefix ~/local
    fi

    if [[ $ijavascript = 'True' ]]; then
        npm install -g ijavascript
        ijsinstall
    fi
elif [[ $nodejs9 = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
        sudo apt-get install -y nodejs build-essential
    else
        latest="$(curl https://nodejs.org/dist/latest-v9.x/ | grep -P 'linux-x64\.tar\.gz' | sed -n 1p | cut -d '"' -f 2)"
        wget https://nodejs.org/dist/latest-v9.x/$latest -O /tmp/node-v9.tar.gz

        mkdir /tmp/node
        tar -xzvf /tmp/node-v9.tar.gz -C /tmp/node/ --strip-components 1

        mkdir -p ~/local/bin/
        mv /tmp/node/bin/* ~/local/bin/

        mkdir -p ~/local/include/
        mv /tmp/node/include/* ~/local/include/

        mkdir -p ~/local/lib/
        mv /tmp/node/lib/* ~/local/lib/

        mkdir -p ~/local/share/doc/
        mv /tmp/node/share/doc/* ~/local/share/doc/

        mkdir -p ~/local/share/man/man1/
        mv /tmp/node/share/man/man1/* ~/local/share/man/man1/

        npm config set prefix ~/local
    fi

    if [[ $ijavascript = 'True' ]]; then
        npm install -g ijavascript
        ijsinstall
    fi
fi

if [[ $google-chrome = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y libappindicator1
        sudo apt -fy install
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
        sudo dpkg -i /tmp/chrome.deb
    else
        sudo_not_installed+=$'- Google Chrome\n'
    fi
fi

if [[ $google-earth = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y lsb-core
        sudo apt -fy install
        wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb -O /tmp/google-earth.deb
        sudo dpkg -i /tmp/google-earth.deb
    else
        sudo_not_installed+=$'- Google Earth\n'
    fi
fi

if [[ $texlive = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y texlive-full
    else
        wget https://mirrors.sorengard.com/ctan/systems/texlive/tlnet/install-tl-unx.tar.gz -O /tmp/install-tl-unx.tar.gz
        mkdir /tmp/texlive
        tar -xvzf /tmp/install-tl-unx.tar.gz -C /tmp/texlive/ --strip-components 1
        cd /tmp/texlive
        ./install-tl --profile=/tmp/dotfiles/tex/texlive.profile
    fi
fi

if [[ $texmaker = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y texmaker
    else
        sudo_not_installed+=$'- TexMaker\n'
    fi
fi

if [[ $lyx = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository -y ppa:lyx-devel/release
        sudo apt update
        sudo apt install -y lyx
    else
        sudo_not_installed+=$'- Lyx\n'
    fi
fi

if [[ $spotify = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
        echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt update -y
        sudo apt install -y spotify-client
    else
        sudo_not_installed+=$'- Spotify\n'
    fi
fi

if [[ $gitkraken = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        wget https://release.gitkraken.com/linux/gitkraken-amd64.deb -O /tmp/gitkraken.deb
        sudo dpkg -i /tmp/gitkraken.deb
    else
        sudo_not_installed+=$'- GitKraken\n'
    fi
fi

if [[ $jekyll = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y ruby-full
        sudo gem install jekyll
        sudo gem install bundler
        # Need to run (sudo) bundle install or bundle update in website folder to install other dependent gems.
    else
        sudo_not_installed+=$'- Jekyll\n'
    fi
fi

if [[ $virtualbox = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        link="http://download.virtualbox.org/virtualbox/5.2.2/virtualbox-5.2_5.2.2-119230~Ubuntu~xenial_amd64.deb"
        wget $link -O /tmp/virtualbox.deb
        sudo dpkg -i /tmp/virtualbox.deb

        # Download VirtualBox Extension Pack
        link="http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack"
        wget $link -O ~/VirtualBox_Extension_Pack.vbox-extpack
        sudo adduser `whoami` vboxusers
    else
        sudo_not_installed+=$'- VirtualBox\n'
    fi
fi

### Utilities

if [[ $ag = 'True' ]]; then
    # Dependencies:
    # PCRE
    wget https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz -O /tmp/pcre.tar.gz
    mkdir /tmp/pcre
    tar -xzvf /tmp/pcre.tar.gz -C /tmp/pcre --strip-components 1
    cd /tmp/pcre
    ./configure --prefix=$HOME/local
    make && make install

    # LZMA
    wget https://tukaani.org/xz/xz-5.2.3.tar.gz -O /tmp/xz.tar.gz
    mkdir /tmp/xz
    tar -xzvf /tmp/xz.tar.gz -C /tmp/xz --strip-components 1
    cd /tmp/xz
    ./configure --prefix=$HOME/local
    make && make install

    wget https://github.com/ggreer/the_silver_searcher/archive/2.1.0.tar.gz -O /tmp/the_silver_searcher.tar.gz
    mkdir /tmp/the_silver_searcher
    tar -xzvf /tmp/the_silver_searcher.tar.gz -C /tmp/the_silver_searcher --strip-components 1
    cd /tmp/the_silver_searcher/
    ./autogen.sh
    ./configure --prefix=$HOME/local
    make && make install
fi

if [[ $bash-kernel = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        pip install bash_kernel
        sudo mkdir /usr/local/share/jupyter
        sudo chown $USER:$USER /usr/local/share/jupyter
        python -m bash_kernel.install
    else
        sudo_not_installed+=$'- Bash Jupyter Kernel\n'
    fi
fi

if [[ $caprine = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        wget `curl -s https://api.github.com/repos/sindresorhus/caprine/releases/latest | grep 'browser_download_url' | grep 'deb' | cut -d '"' -f 4` -O /tmp/caprine.deb
        sudo dpkg -i /tmp/caprine.deb
    else
        sudo_not_installed+=$'- Caprine\n'
    fi
fi

if [[ $chromedriver = 'True' ]]; then
    latest="$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE)"
    wget https://chromedriver.storage.googleapis.com/$latest/chromedriver_linux64.zip -O /tmp/chromedriver.zip
    unzip /tmp/chromedriver.zip
    mv chromedriver ~/local/bin/
fi


if [[ $compizconfig = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # Remove Unity App Animations (cause I like hiding the launcher)
        # 1) Install Compiz Settings Manager
        sudo apt install -y compizconfig-settings-manager compiz-plugins-extra
        ccsm
        # 2) Compiz Setting Manager -> Desktop -> Ubuntu Unity Plugin -> Launcher
        # 3) Launch Animation: None
        #    Urgent Animation: None
        #    Hide Animation: Fade Only Dash Blur: No Blur
        # 4) CSM -> Effects 5) Disabled everything except Windows Decoration 6) Installed few unity tweakers and made sure that settings there match ones in CSM. In my case MyUnity still was showing Hide Animation set to Fade and Slide, so I changed it to Fade Only there as well.
        # https://askubuntu.com/a/320734/654313
        #
        # Keyboard shortcut to move window between monitors
        # currently mapped to ctrl + super + alt + left and ctrl + super + alt + right
        # http://www.arj.no/2017/01/03/move-windows-ubuntu/
    else
        sudo_not_installed+=$'- Compiz Config\n'
    fi
fi

if [[ $direnv = 'True' ]]; then
    link="$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | grep 'browser_download_url' | grep 'linux-amd64' | cut -d '"' -f 4)"
    wget $link -O ~/local/bin/direnv
    chmod +x ~/local/bin/direnv
fi

if [[ $docker = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
           $(lsb_release -cs) \
           stable"
        sudo apt update
        sudo apt install -y docker-ce

        # Manage docker as a non-root user
        # https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
        sudo groupadd docker
        sudo usermod -aG docker $USER
    else
        sudo_not_installed+=$'- Docker\n'
    fi
fi

if [[ $docker_compose = 'True' ]]; then
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

if [[ $dropbox = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # MANUAL INSTALLS:
        # Install Dropbox
        sudo apt install -y python-gpgme
        #cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
        #~/.dropbox-dist/dropboxd
        # Needs manual input to link accounts
    else
        sudo_not_installed+=$'- Dropbox\n'
    fi
fi

if [[ $fd = 'True' ]]; then
    link="$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep 'browser_download_url' | grep 'x86_64-unknown-linux-musl.tar.gz' | cut -d '"' -f 4)"
    wget $link -O /tmp/fd.tar.gz

    mkdir /tmp/fd
    tar -xzvf /tmp/fd.tar.gz -C /tmp/fd --strip-components 1

    mkdir -p ~/local/bin/
    mv /tmp/fd/fd ~/local/bin/
    mkdir -p ~/local/share/man/man1/
    mv /tmp/fd/fd.1 ~/local/share/man/man1/
fi

if [[ $filezilla = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y filezilla
    else
        sudo_not_installed+=$'- FileZilla\n'
    fi
fi

if [[ $flat-plat = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # Flat plat design
        sudo apt install -y gnome-themes-standard gnome-tweak-tool pixmap
        curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz
        cd Flat-Plat-20170605 && sudo ./install.sh
        # go to gnome-tweak-tool and turn on flat-plat-dark
    else
        sudo_not_installed+=$'- Flat-plat theme\n'
    fi
fi

if [[ $flux ]]; then
    # # Install f.lux
    # sudo apt install -y git python-appindicator python-xdg python-pexpect python-gconf python-gtk2 python-glade2 libxxf86vm1
    # git clone "https://github.com/xflux-gui/xflux-gui.git"
    # cd xflux-gui
    # python download-xflux.py
    # sudo python setup.py install
    # cd ../
    # rm -rf xflux-gui
fi

if [[ $fuzzy-file-finder = 'True' ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [[ $gtop = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo npm install -g gtop
    else
        npm install -g gtop
    fi
fi

if [[ $hub = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        link="$(curl -s https://api.github.com/repos/github/hub/releases/latest | grep 'browser_download_url' | grep 'linux-amd64' | cut -d '"' -f 4)"
        wget $link -O /tmp/hub.tar.gz
        mkdir /tmp/hub
        tar -xzvf /tmp/hub.tar.gz -C /tmp/hub --strip-components 1
        sudo /tmp/hub/install
    else
        sudo_not_installed+=$'- Hub\n'
    fi
fi

if [[ $jq = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y jq
    else
        sudo_not_installed+=$'- jq\n'
    fi
fi

if [[ $keybase = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # Download and install Keybase but not run
        wget https://prerelease.keybase.io/keybase_amd64.deb -O /tmp/keybase.deb
        sudo dpkg -i /tmp/keybase.deb
        sudo apt-get install -fy
        # run_keybase
    else
        sudo_not_installed+=$'- Keybase\n'
    fi
fi

if [[ $lastpass-cli = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        ## Lastpass CLI
        sudo apt install -y openssl libcurl4-openssl-dev libxml2 libssl-dev libxml2-dev pinentry-curses xclip cmake build-essential pkg-config
        git clone git@github.com:lastpass/lastpass-cli.git /tmp/lastpass-cli
        cd /tmp/lastpass-cli
        # Note: Make sure your PATH is ok. I encountered an error by having anaconda too high in my PATH
        make && sudo make install

        # link=$(curl -s https://api.github.com/repos/lastpass/lastpass-cli/releases/latest | grep tarball_url | cut -d '"' -f 4)
        # wget $link -O lastpass-cli.tar.gz
        # tar -xvzf lastpass-cli.tar.gz
        # cd lastpass-lastpass-cli-96977ad
        # make
    else
        sudo_not_installed+=$'- Lastpass CLI\n'
    fi
fi

if [[ $libmagick = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y libmagick++-dev
    else
        sudo_not_installed+=$'- libmagick\n'
    fi
fi

if [[ $libpostal = 'True' ]]; then
    git clone https://github.com/openvenues/libpostal /tmp/libpostal
    cd /tmp/libpostal
    ./bootstrap.sh

    cat m4/libtool.m4 >> aclocal.m4
    cat m4/ltoptions.m4 >> aclocal.m4
    cat m4/ltversion.m4 >> aclocal.m4
    cat m4/lt\~obsolete.m4 >> aclocal.m4

    ./configure --prefix=$HOME/local --datadir=$HOME/local/data
    make -j4 && make install
fi

if [[ $micro = 'True' ]]; then
    link="$(curl -s https://api.github.com/repos/zyedidia/micro/releases/latest | grep 'browser_download_url' | grep 'linux64' | cut -d '"' -f 4)"
    wget $link -O /tmp/micro.tar.gz
    mkdir /tmp/micro
    tar -xzvf /tmp/micro.tar.gz -C /tmp/micro --strip-components 1

    mkdir -p ~/local/bin
    mv /tmp/micro/micro ~/local/bin/

    mkdir -p ~/.config/micro
    cp /tmp/dotfiles/micro/* ~/.config/micro/
fi

if [[ $nitrogen = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # For having different wallpapers on each monitor
        # https://askubuntu.com/questions/390367/using-different-wallpapers-on-multiple-monitors-gnome-2-compiz
        sudo apt install -y nitrogen
    else
        sudo_not_installed+=$'- Nitrogen\n'
    fi
fi

if [[ $openvpn = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # Install OpenVPN to use PIA
        sudo apt install -y openvpn

        if [[ $privateinternetaccess_config = 'True' ]]; then
            cd /etc/openvpn
            sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
            sudo apt install -y unzip
            sudo unzip openvpn.zip
            sudo rm openvpn.zip
            sudo touch pass.txt ## Add username and pasword in here manually
            sudo chmod 600 pass.txt
            for filename in *.ovpn
            do
              sudo sed -i 's@auth-user-pass@auth-user-pass pass.txt@g' $filename
            done
        fi
    else
        sudo_not_installed+=$'- OpenVPN\n'
    fi
fi

if [[ $peek = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        # https://github.com/phw/peek
        sudo add-apt-repository ppa:peek-developers/stable
        sudo apt update
        sudo apt install -y peek
    else
        sudo_not_installed+=$'- Peek\n'
    fi
fi

if [[ $pv = 'True' ]]; then
    wget https://www.ivarch.com/programs/sources/pv-1.6.6.tar.gz -O /tmp/pv.tar.gz
    mkdir /tmp/pv
    tar -xzvf /tmp/pv.tar.gz -C /tmp/pv --strip-components 1
    cd /tmp/pv
    ./configure --prefix=$HOME/local
    make && make install
fi

if [[ $rclone = 'True' ]]; then
    # Fetch and unpack
    wget https://downloads.rclone.org/rclone-current-linux-amd64.zip -O /tmp/rclone.zip
    cd /tmp
    unzip rclone.zip
    cd rclone-*-linux-amd64

    # Copy binary file
    mkdir -p ~/local/bin/
    cp rclone ~/local/bin/
    chown $USER:$USER ~/local/bin/rclone
    chmod 755 ~/local/bin/rclone

    # Install manpage
    mkdir -p ~/local/share/man/man1
    cp rclone.1 ~/local/share/man/man1/
fi

if [[ $redshift = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y redshift
    else
        sudo_not_installed+=$'- Redshift\n'
    fi
fi

if [[ $ripgrep = 'True' ]]; then
    link="$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep 'browser_download_url' | grep 'x86_64' | grep 'linux' | cut -d '"' -f 4)"
    wget $link -O /tmp/ripgrep.tar.gz
    mkdir /tmp/ripgrep
    tar -xvzf /tmp/ripgrep.tar.gz -C /tmp/ripgrep --strip-components 1
    cd /tmp/ripgrep

    mkdir -p ~/local/bin/
    mv rg ~/local/bin/

    mkdir -p ~/local/share/man/man1/
    mv doc/rg.1 ~/local/share/man/man1/
fi

if [[ $shellcheck = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y shellcheck
    else
        sudo_not_installed+=$'- shellcheck\n'
    fi
fi

if [[ $smem = 'True' ]]; then
    wget https://selenic.com/repo/smem/archive/tip.tar.gz -O /tmp/smem.tar.gz
    mkdir /tmp/smem
    tar -xzvf /tmp/smem.tar.gz -C /tmp/smem --strip-components 1

    mkdir -p ~/local/bin/
    mv /tmp/smem/smem ~/local/bin/

    mkdir -p ~/local/man/man8/
    mv /tmp/smem/smem.8 ~/local/man/man8/
fi

if [[ $speed-test = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo npm install -g speed-test
    else
        npm install -g speed-test
    fi
fi

if [[ $thefuck = 'True' ]]; then
    pip install thefuck
fi

if [[ $tmux = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y libevent-dev
    else
        mkdir -p ~/local/share
        echo 'CPPFLAGS=-I$HOME/local/include' > ~/local/share/config.site
        echo 'LDFLAGS=-L$HOME/local/lib' >> ~/local/share/config.site
        link="$(curl -s https://api.github.com/repos/libevent/libevent/releases/latest | grep 'browser_download_url' | grep -P '.tar.gz(?!\.asc)' | cut -d '"' -f 4)"
        wget $link -O /tmp/libevent.tar.gz
        mkdir /tmp/libevent
        tar -xvzf /tmp/libevent.tar.gz -C /tmp/libevent --strip-components 1
        cd /tmp/libevent
        ./configure --prefix=$HOME/local
        make && make install
    fi

    if [[ $sudo = 'True' ]]; then
        sudo apt install -y tmux
    else
        link="$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep 'browser_download_url' | grep -P '.tar.gz(?!\.asc)' | cut -d '"' -f 4)"
        wget $link -O /tmp/tmux.tar.gz
        mkdir /tmp/tmux
        tar -xvzf /tmp/tmux.tar.gz -C /tmp/tmux --strip-components 1
        cd /tmp/tmux
        ./configure --prefix=$HOME/local
        make && make install
    fi
fi

if [[ $oh_my_tmux = 'True' ]]; then
    cd
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf ~/.tmux
    cp .tmux/.tmux.conf.local .

    cp /tmp/dotfiles/tmux/tmux.conf.local ~/.tmux.conf.local
fi

if [[ $tree = 'True' ]]; then
    if [[ sudo = 'True' ]]; then
        sudo apt install -y tree
    else
        mkdir -p ~/local/
        wget ftp://mama.indstate.edu/linux/tree/tree-1.7.0.tgz -O /tmp/tree.tgz
        mkdir /tmp/tree
        tar -xzvf /tmp/tree.tgz -C /tmp/tree --strip-components 1
        cd /tmp/tree
        sed -i "s@prefix = /usr@prefix = $HOME/local@g" Makefile
        make && make install
    fi
fi

if [[ $vlc = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y vlc
    else
        sudo_not_installed+=$'- VLC\n'
    fi
fi

if [[ $xclip = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo apt install -y xclip
    else
        # yum install -y automake autoconf git libXmu libXmu-devel libtool
        git clone https://github.com/astrand/xclip.git /tmp/xclip
        cd /tmp/xclip
        autoreconf
        ./configure --prefix=$HOME/local/
        make && make install
        make install.man
    fi
fi

if [[ $xsel = 'True' ]]; then
    git clone https://github.com/kfish/xsel /tmp/xsel
    cd /tmp/xsel
    ./autogen.sh --prefix=$HOME/local
    make && make install
fi

if [[ $xsv = 'True' ]]; then
    link="$(curl -s https://api.github.com/repos/BurntSushi/xsv/releases/latest | grep 'browser_download_url' | grep 'x86_64' | grep 'linux' | cut -d '"' -f 4)"
    wget $link -O /tmp/xsv.tar.gz
    mkdir /tmp/xsv
    tar -xvzf /tmp/xsv.tar.gz -C /tmp/xsv

    mkdir -p ~/local/bin/
    mv /tmp/xsv/xsv ~/local/bin/
fi


if [[ $cuda = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
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
    else
        sudo_not_installed+=$'- CUDA\n'
    fi
fi

### Photography software

if [[ $darktable = 'True' ]]; then
    if [[ $sudo = 'True' ]]; then
        sudo add-apt-repository ppa:pmjdebruijn/darktable-release
        sudo apt update
        sudo apt install -y darktable
    else
        sudo_not_installed+=$'- Darktable\n'
    fi
fi

# if [[ $digikam = 'True' ]]; then
#     wget https://download.kde.org/stable/digikam/digikam-5.7.0-01-x86-64.appimage -O digikam.appimage
# fi

rm -rf /tmp/*

echo "$sudo_not_installed"
