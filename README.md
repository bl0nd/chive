# Chive

Chive is a file variant switcher. In short, Chive can replace sections of a
file with other text or data without requiring modifications to the original
file.

<!--## Motivation-->

<!--Suppose you would like to easily switch between different versions of-->
<!--`~/.vimrc` and `~/.bashrc` (perhaps you often change Vim color schemes and Bash-->
<!--prompts).-->

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

```sh
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

Chive switches between **variants** of **targets**. A variant is a version of a
file section (e.g., `colorscheme gruvbox`). A target is a name for a file to be
managed by Chive (e.g., `vim`, `vim-keybinds` `bash`).

Chive has three main operations:

1. Target creation
2. Variant creation
3. Variant switching

### Target Creation

To create a target, use the `--target | -t` flag:

```sh
$ chive -t vim bash
```

This creates two **empty targets**: `vim` and `bash`. Empty targets contain no
information on what file each target manages. Consequently, they are ignored
by Chive. After all, Chive can't operate on what it doesn't know!

This brings us to how Chive accepts data. In short, arbitrary data may be
passed to Chive through `STDIN`, meaning that Bash facilities such as pipes
(`|`), [input redirection](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Input)
(`<`), [here docs](https://tldp.org/LDP/abs/html/here-docs.html) (`<<`), and
[here strings](https://tldp.org/LDP/abs/html/x17837.html) (`<<<`) can be used
configure Chive in an easy and elegant way.

For example, to create **full targets**:

```sh
$ chive -t vim-colors vim-keybinds <<< ~/.vimrc

$ chive -t bash sway << EOF
$HOME/.bashrc
$HOME/.config/sway/config
EOF
```

Now Chive knows that `vim-colors` and `vim-keybinds` manage `~/.vimrc`, while
`bash` and `sway` manage `~/.bashrc` and `~/.config/sway/config`, respectively.

Note that:

* To have shell expansion and substitution in here strings, don't quote the string.

* Here docs don't expand `~`, so be sure to use `$HOME` instead.

### Variant Creation

Now that we have targets, the next thing to do is create variants.

### Rules

#### Naming
<!--* Target and template names may consist of letters, numbers, `-`, and `_`.-->
<!--* Target and template names may start with a letter or number.-->
<!--* Target and template names must be unique across target and template namespaces-->

#### Variants
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
