# Chive

Have you ever wanted to easily switch between different versions of `~/.vimrc`
or `~/.bashrc` (perhaps you often change Vim color schemes and Bash prompts)?
Well, look no further!  Chive allows you to easily replace sections of a file
with other text or data without requiring modifications to the original file.

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

Chive allows you to switch between **variants** of **targets**:

* A variant is a version of a file section (e.g., `colorscheme gruvbox`, `PS=❯ `).
* A target is an alias for a file (e.g., `vim`, `bash`).

### Target Creation

The first thing you'll need to do is create a target:

```sh
$ chive -t vim bash
```

This creates two **empty targets**: `vim` and `bash`. As the name suggests,
empty targets do not manage any file. Consequently, they are ignored by Chive.
After all, Chive can't operate on what it doesn't know!

This brings us to how Chive accepts data. In short, arbitrary data may be
passed to Chive through `STDIN`, meaning that built-in Bash facilities such as
pipes (`|`), [input redirection](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Input)
(`<`), [here docs](https://tldp.org/LDP/abs/html/here-docs.html) (`<<`), and
[here strings](https://tldp.org/LDP/abs/html/x17837.html) (`<<<`) can be used
configure Chive in an easy and elegant way.

Thus, to create **full targets** or reconfigure empty targets:

```sh
$ chive -t vim-colors vim-keybinds <<< ~/.vimrc
vim-colors
vim-keybinds

$ chive -t bash sway << EOF
> $HOME/.bashrc
> $HOME/.config/sway/config
> EOF
vim-colors
vim-keybinds
bash
sway
```

Now Chive knows that both `vim-colors` and `vim-keybinds` manage `~/.vimrc`,
while `bash` and `sway` manage `~/.bashrc` and `~/.config/sway/config`,
respectively.

<!--* To have shell expansion and substitution in here strings, don't quote the string.-->

<!--* Here docs don't expand `~`, so be sure to use `$HOME` instead.-->

### Variant Creation

Now that we have full targets, we can create **empty variants** with the
`--variant | -v` flag.

```sh
$ chive -v solarized gruvbox
vim-colors: added "solarized"
vim-colors: added "gruvbox"
vim-keybinds: added "solarized"
vim-keybinds: added "gruvbox"
bash: added "solarized"
bash: added "gruvbox"
sway: added "solarized"
sway: added "gruvbox"
```

We can see that if we don't specify a target, variants will be created for all
targets. Let's be a bit more specific:

```sh
$ chive -v bash prompt-1
bash: added "prompt-1"

$ chive -v var1 sway var2 bash
sway: added "var1"
sway: added "var2"
bash: added "var1"
bash: added "var2"
```

You can see that order does not matter, and that we can specify multiple targets.

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
