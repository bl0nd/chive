# Chive

Chive is a file variant switcher. In short, Chive can replace sections of a
file with other text or data without requiring modifications to the original
file.

# Motivation

Suppose we would like to easily switch between different versions of `~/.vimrc`
and `~/.bashrc`. Perhaps you often switch between different Vim color schemes
and Bash prompts.

Traditionally, you'd have to maintain entire copies of both files, switching
between copies via commands such as `cp` or `mv`. However, the differences
between copies are typically small compared to the rest of the file, and so
this method is often incredibly wasteful, not to mention you can only switch
copies one file at a time (i.e., `cp vim ~/.vimrc && cp bash ~/.bashrc`).

Other solutions typically use a version control system such as Git, tracking
different versions of files as branches or commits. However, there are a few
problems with this approach:

* It often requires turning `$HOME` or other directories into a Git repository.

* Switching is still limited to one file at a time.

* If you track changes unrelated to color schemes and prompts, maintaining and
  switching between different versions becomes a lot harder. If you don't track
  the changes, you'll have to manually exclude them each time you commit a new
  version.

* It's much too complex for what we're trying to do. You shouldn't need to know
  how commits or branches work to switch color schemes!

Finally, we have programs such as [mondo]() or [pywal](). These types of
programs typically require modifications to the targeted file and configuration
for custom use is often complex.

So here we are.

# Installation

### Manual

### Packages

## Usage

Before getting started, let's go over some terminology:

* *Target* - A name for a file you want Chive to manage (e.g., `vim`, `bash`).

* *Variant* - A version of a section of a file (e.g., `colorscheme gruvbox`).

With that out of the way, Chive has 3 main operations:

1. Create targets
2. Create variants
3. Switch between variants.

### Target Creation

Let's start with target creation.

It'd be a real bother to have To start, we create targets for each file we want to manage
one using the `--template` flag.

```sh
$ chive -t vim alacritty
```

This creates two **default targets**: `vim` and `alacritty`. Now, note that
default targets have no information on what they're supposed to be managing.
For example, the target `vim` doesn't know that it's supposed to manage
`~/.vimrc`. Clearly, Chive can't do anything for `vim` if it doesn't know where
to do operate.

This brings us to how Chive accepts data (which is different from arguments or
options): through STDIN.


Chive's behavior depends STDIN. In particular, a non-empty STDIN allows for the
creation of custom templates and variants.

Note that heredocs do not expand `~`, so be sure to use `$HOME` instead.

To create targets:

```sh
# default templates
$ chive -t vim alacritty

# custom templates
$ chive -t vim <<< ~/.vimrc

$ chive -t alacritty sway << EOF
$HOME/.config/alacritty/alacritty.yml
$HOME/.config/sway/config
EOF
```

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

# License
