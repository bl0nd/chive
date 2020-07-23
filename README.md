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

```console
$ chive -t vim bash
vim
bash
```

This creates two **empty targets**: `vim` and `bash`. As the name suggests,
empty targets do not manage any file. Consequently, they are ignored by Chive.
After all, Chive can't operate on what it doesn't know!

This brings us to how Chive accepts data. In short, arbitrary data may be
passed to Chive through `STDIN`, meaning that built-in Bash facilities such as
pipes (`|`), input redirection (`<`), here docs (`<<`), and here strings
(`<<<`) can be used configure Chive in an easy and elegant way.

Thus, to create **full targets** or reconfigure empty ones:

```console
$ chive -t vim-colors vim-keybinds <<< ~/.vimrc
vim-colors
vim-keybinds

$ chive -t bash sway << EOF
$HOME/.bashrc
$HOME/.config/sway/config
EOF
vim-colors
vim-keybinds
bash
sway
```

Here, both `vim-colors` and `vim-keybinds` manage `~/.vimrc`, while `bash` and
`sway` manage `~/.bashrc` and `~/.config/sway/config`, respectively.

<!--* To have shell expansion and substitution in here strings, don't quote the string.-->

<!--* Here docs don't expand `~`, so be sure to use `$HOME` instead.-->

### Variant Creation

The next step is to create variants with the `--variant | -v` flag:

```console
$ chive
alacritty
vim

$ chive -v solarized gruvbox
vim: added "solarized"
vim: added "gruvbox"
alacritty: added "solarized"
alacritty: added "gruvbox"

$ chive -t sway <<< ~/.config/sway/config
alacritty
sway
vim

$ chive -v zenburn sway vim solarized
sway: added "zenburn"
sway: added "solarized"
vim: added "zenburn"
```

If don't specify any targets, the variants will be created for all targets. If
we do provide targets, the variants will be created only for those targets.
Also, note that order doesn't matter when listing out targets and variants.

So far, we've only added **empty variants**. But we can use `STDIN` to add more
useful variants, right? Well, yes and no. Unfortunately, when multiple variants
become involved, things start to break down:

* Variants are often multi-line, meaning we can't distinguish between variant
  data as easily as we could target paths.

* Providing a cookie-cutter variant often doesn't make any sense, especially
  when multiple targets are involved.

Thus, the approach I suggest is as follows:

* If you are adding or configuring an individual variant, use the `STDIN`
  approach just like before:

  ```console
  $ chive
  alacritty
  vim

  $ chive -v vim solarized <<< "colorscheme solarized"
  vim: added "solarized"

  $ curl ... | chive -v alacritty gruvbox
  alacritty: added "gruvbox"
  ```

* If you are adding multiple variants for the same target,

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
