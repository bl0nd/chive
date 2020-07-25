# Chive

Chive is a variant switcher that allows you to easily swap out arbitrary file
sections without requiring any modifications to the original file.

## Installation

### Manual

To build and install from source:

```
git clone https://github.com/bl0nd/chive.git && cd chive
make
sudo make install
```

### Packages

Chive is also available on many Linux distributions (as `chive`), including:

* Arch Linux
* CentOS
* Debian
* Fedora
* RHEL
* Ubuntu

## Usage

### Targets

To create empty targets:

```console
$ chive -t vim alacritty
alacritty
vim
```

To create full targets or modify existing ones:

```console
$ chive -t vim alacritty << EOF
> $HOME/.vimrc
> $HOME/.config/alacritty/alacritty.yml
> EOF
alacritty
vim

$ chive -t bash-prompt bash-alias <<< ~/.bashrc
alacritty
bash-alias
bash-prompt
vim
```

### Variants

To create empty variants for all targets:

```console
$ chive -v solarized gruvbox
vim: added "solarized"
vim: added "gruvbox"
alacritty: added "solarized"
alacritty: added "gruvbox"
```

To create empty variants for some targets (order does not matter):

```console
$ chive -v vim solarized gruvbox
vim: added "zenburn"
vim: added "ayu"
```

To create individual full variants:

```console
$ chive -v vim solarized <<< "colorscheme solarized"
vim: added "solarized"

$ curl https://raw.githubusercontent.com/.../gruvbox_dark.yaml | chive -v alacritty gruvbox
alacritty: added "gruvbox"
```

To create multiple full variants, `-e` will bring up an `fzf` listing so that
you may choose which to edit:

```console
$ chive -e -v solarized gruvbox
  alacritty/gruvbox
  alacritty/solarized
  vim/gruvbox
> vim/solarized
  4/4
>
```

### Switching

To switch variants for all targets:

```console
$ chive solarized
```

To switch variants for some targets:

```console
$ chive vim solarized alacritty gruvbox
```

To switch variants for some targets and all other targets:

```console
$ chive vim solarized gruvbox
```


### Deletion

To delete targets or variants, `-d` will bring up an `fzf` listing so that you
may choose which to delete:

```console
$ chive -d
  alacritty
  alacritty/gruvbox
  alacritty/solarized
  vim
  vim/gruvbox
> vim/solarized
  6/6
>
```

## License
This project is released under the [MIT](LICENSE) license.
