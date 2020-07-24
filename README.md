# Chive

Chive is a tool that swaps out arbitrary file sections with custom data,
without requiring modifications to the original file.

```sh
$ chive -t vim alacritty << EOF
$HOME/.vimrc
$HOME/.config/alacritty/alacritty.yml

$ chive -v vim gruvbox <<< "colorscheme gruvbox"
$ chive -v vim solarized <<< "colorscheme solarized"

$ curl ... | chive -v alacritty gruvbox
$ curl ... | chive -v alacritty solarized
```

<!--## Motivation-->

<!--Traditionally, you'd more or less maintain entire copies of both files and-->
<!--switch between the copies manually. However,-->

<!--* The differences between copies are typically small compared to the rest of-->
  <!--the file, making this approach quite wasteful.-->

<!--* You have to switch copies for each file manually. That is, you have to do-->
  <!--something like `cp vim-gruvbox ~/.vimrc && cp bash-pure ~/.bashrc`).-->

<!--Most other solutions typically use a version control system such as Git,-->
<!--tracking different versions of files as branches or commits. However,-->

<!--* This often requires turning `$HOME` or other directories into a Git repository.-->

<!--* If you track changes unrelated to color schemes and prompts, maintaining and-->
  <!--switching between different versions becomes a lot harder. And even if you-->
  <!--don't, you'd have to manually exclude the unrelated changes on every-->
  <!--staging/commit.-->

<!--* It's much too complex for what we're trying to do. You shouldn't need to know-->
  <!--how commits or branches work just to switch color schemes.-->

<!--Finally, we have programs such as [mondo]() and [pywal](), which more or less-->
<!--use special template files to replace sections of a file. However,-->

<!--* They typically require modifications to the original file.-->

<!--* They're quite limited in scope (e.g., `mondo` and `pywal` are geared towards-->
  <!--colors).-->

<!--And so here we are.-->

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

## Getting Started

Suppose you want to switch between different color-schemes in Vim and
Alacritty.

### Target Creation

The first thing you'll need to do is create **targets**, or file aliases:

```console
$ chive -t vim alacritty
alacritty
vim
```

This creates two targets: `vim` and `alacritty`. However, because we didn't
provide any file paths for our targets, Chive will simply ignore them. After
all, if a target doesn't know what it is aliasing, how can Chive know? To fix
this, simply pass in the file paths to Chive's `STDIN`:

```console
$ chive -t vim alacritty << EOF
> $HOME/.vimrc
> $HOME/.config/alacritty/alacritty.yml
> EOF
alacritty
vim

OR

$ chive -t vim <<< ~/.vimrc
vim

$ chive -t alacritty <<< ~/.config/alacritty/alacritty.yml
alacritty
vim
```


<!--* To have shell expansion and substitution in here strings, don't quote the string.-->

<!--* Here docs don't expand `~`, so be sure to use `$HOME` instead.-->

### Variant Creation

Now that Chive knows that `vim` manages `~/.vimrc` and `alacritty` manages
`~/.config/alacritty/alacritty.yml`, the next step is to create **variants**
for each target:

```console
$ chive -v solarized gruvbox
vim: added "solarized"
vim: added "gruvbox"
alacritty: added "solarized"
alacritty: added "gruvbox"
```

If you only want to create variants for certain targets, simply add their names
to the list (note that order does not matter):

```console
$ chive -v zenburn vim ayu
vim: added "zenburn"
vim: added "ayu"
```

Now, empty variants aren't really useful, so let's update them with some
content. If adding a single variant, pass in data through `STDIN`:

```console
$ chive -v vim solarized <<< "colorscheme solarized"
vim: added "solarized"

$ curl https://raw.githubusercontent.com/.../gruvbox_dark.yaml | chive -v alacritty gruvbox
alacritty: added "gruvbox"
```

If adding multiple variants, use the `--edit | -e` flag to bring up relevant
variants in `fzf` so that you may edit each one individually:

```console
$ chive -e -v dracula onedark
  alacritty/dracula
  alacritty/onedark
  vim/dracula
> vim/onedark
  4/4
>
```

### Variant Switching

And that's it! You can now easily switch between different color schemes in
both Vim and Alacritty!

```bash
$ chive ayu                        # all = ayu
$ chive vim ayu alacritty dracula  # vim = ayu | alacritty = dracula
$ chive vim alacritty ayu dracula  # vim & alacritty = ayu | others = dracula
```

<!--### Rules-->

<!--#### Naming-->
<!--* Target and template names may consist of letters, numbers, `-`, and `_`.-->
<!--* Target and template names may start with a letter or number.-->
<!--* Target and template names must be unique across target and template namespaces-->

<!--#### Variants-->
<!--In order to switch variants without requiring additional information in the-->
<!--original target file, Chive needs some help. In particular, Chive needs to-->
<!--somehow know where in the target to begin deleting and adding text/data.-->

<!--To do this, Chive searches all the variants for a particular target to see if-->
<!--any of them has an exact match against the target file. If there is, then Chive-->
<!--can determine on its own where it needs to start and how much work it needs to-->
<!--do. If none of the variants have a match against the target, then Chive cannot-->
<!--do anything.-->

<!--Consequently, it is very important that you do not modify sections managed by-->
<!--Chive and that your initial variant matches what you have in the target file-->
<!--exactly, otherwise Chive won't know where to start!-->

## License
This project is released under the [MIT](LICENSE) license.
