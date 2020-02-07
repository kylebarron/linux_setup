# linux_setup
Bash script to install most software I want on a new computer or VM instance

If you don't have sudo access, there are a few programs that I assume you have already installed:
- `curl`
- `gcc` and other standard build tools
- `autoconf`
- `unzip`

To see if you have these installs you could do:
```
command -v <program>
```
where `<program>` is the program you want to know is installed. If installed, it'll print the path to the program.

### Download

```bash
git clone https://github.com/kylebarron/linux_setup/
cd linux_setup
```

### Zsh

```bash
export sudo='True'
export zsh='True'
export oh-my-zsh='True'
export zsh-autosuggestions='True'
export zsh-syntax-highlighting='True'
export materialshell='True'
export zshrc='True'
bash ./linux_install.sh
```
