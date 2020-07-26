# Chive

<p align="center">
  <h1 align="center">Chive</h1>
  <p align="center">A Bash script for swapping out arbitrary file sections.</p>
  <p align="center">
    <a href="BADGE"><img src="https://img.shields.io/badge/bash-4.3%2B-blue"></a>
    <a href="https://github.com/bl0nd/chive/releases"><img src="https://img.shields.io/badge/release-v0.1.1-blue"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  </p>
</p>

<p align="center"> <img src="/doc/demo.gif" width="800" height="450"/> </p>

## Table of Contents

   * [Installation](#installation)
      * [Manual](#manual)
      * [Packages](#packages)
   * [With Great Power...](#with-great-power)
   * [Usage](#usage)
      * [Targets](#targets)
      * [Variants](#variants)
      * [Switching](#switching)
      * [Deletion](#deletion)
   * [License](#license)

## Installation

### Manual

To build and install from source (requires [fzf](https://github.com/junegunn/fzf)):

```
git clone https://github.com/bl0nd/chive.git && cd chive
sudo make install
```

<!--### Packages-->

<!--Chive is also available on many Linux distributions (as `chive`), including:-->

<!--* Arch Linux-->
<!--* CentOS-->
<!--* Debian-->
<!--* Fedora-->
<!--* RHEL-->
<!--* Ubuntu-->

## With Great Power...

To avoid requiring modifications to the original file, Chive does require some
help from you. In particular, variant switches require that the targeted file
contains the contents of at least one variant belonging to the target.

For example, suppose you have the following setup (`solarized` contains
`colorscheme solarized`):

```console
$ grep colorscheme ~/.vimrc
colorscheme gruvbox

$ chive
vim
└── solarized
```

Running `chive solarized` will fail because there's no way for Chive to know
where to begin replacing text. To fix this, either change `gruvbox` to
`solarized` in `~/.vimrc` or create a Gruvbox variant before running the
command. Either way, Chive will then have a reference point to start from and
the switch will be successful.

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
