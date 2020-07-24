# Chive

Chive allows you to switch between **variants** of **targets**:

* A variant is a a file section (e.g., `colorscheme gruvbox`, `PS=❯ `).
* A target is an alias for a file (e.g., `vim`, `bash`).

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

Suppose you want to switch between different colorschemes in Vim and Alacritty.

### Target Creation

First, create some targets using the `--target | -t` flag:

```console
$ chive -t vim alacritty
alacritty
vim
```

This creates two targets: `vim` and `alacritty`.

However, we've already made a mistake! Recall that targets are aliases for
files. But notice that we never actually provided any file paths for either of
our targets! Consequently, Chive simply ignores the `vim` and `alacritty`
targets. After all, how can Chive operate on Vim's configuration file if it
doesn't know where it is?

To fix this, pass in your file paths to Chive's `STDIN`:

```console
$ chive -t vim <<< ~/.vimrc
vim

$ chive -t alacritty <<< ~/.config/alacritty/alacritty.yml
alacritty
vim

# OR

$ chive -t vim alacritty << EOF
> $HOME/.vimrc
> $HOME/.config/alacritty/alacritty.yml
> EOF
alacritty
vim
```

Chive now knows that `vim` manages `~/.vimrc`, and `alacritty` manages
`~/.config/alacritty/alacritty.yml`!

<!--* To have shell expansion and substitution in here strings, don't quote the string.-->

<!--* Here docs don't expand `~`, so be sure to use `$HOME` instead.-->

### Variant Creation

The next step is to create variants for each of targets. To do this, use the
`--variant | -v` flag:

```console
$ chive -v solarized gruvbox
vim: added "solarized"
vim: added "gruvbox"
alacritty: added "solarized"
alacritty: added "gruvbox"
```

You can see that if we don't specify any targets, the `solarized` and `gruvbox`
variants are created for all of our targets. If you only want to create
variants for a particular target, simply add the target's name to the list
(note that order does not matter, just write them however they pop into your
head!):

```console
$ chive -v zenburn vim ayu
vim: added "zenburn"
vim: added "ayu"
```

As you might have guessed, we've been adding blank variants to Chive this whole
time. Luckily, we can do what we did before with `STDIN` to add more useful
variants, right?  Well, yes and no. Unfortunately, when multiple variants get
involved, things start to break down. In particular, variants are often multi-line,
so its hard to what data belongs to which variant. Also, cookie-cutter variants typically
become useless whenever multiple targets are involved.

So what are we supposed to do? Well, here's what I suggest: for creating or
modifying individual variants, use the `STDIN` approach:

```console
$ chive -v vim solarized <<< "colorscheme solarized"
vim: added "solarized"

$ curl ... | chive -v alacritty gruvbox
alacritty: added "gruvbox"
```

On the other hand, when working with multiple variants, use the `--edit | -e`
flag to bring up relevant variants in `fzf` so that you may edit each one:

<!--TODO: Use GIF here-->

```console
$ chive -e -v solarized zenburn
  alacritty/solarized
  alacritty/zenburn
> vim/zenburn
  3/3
>
  ```

Note that `-v` indicates that you want to *add* new variants. Thus, old
variants (like `vim/solarized`) won't show up in the `fzf` listing since we
already added that in the previous command. To modify existing variants,
specify only the `-e` flag:

```console
$ chive -e solarized zenburn
  alacritty/solarized
  alacritty/zenburn
> vim/solarized
> vim/zenburn
  4/4
>
  ```


### Variant Switching

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
