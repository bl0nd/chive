# Chive

Chive is a file variant switcher. In short, Chive can replace sections of a
file with other text or data without requiring modifications to the original
file.

# Motivation


# Installation

### Manual

### Packages

# Usage

### Rules
#### Naming
* Target and template names may consist of letters, numbers, `-`, and `_`.
* Target and template names may start with a letter or number.
* Target and template names must be unique across target and template namespaces

#### Variants
In order to switch variants without requiring additional information in the
original target file, Chive needs some help from you. In particular, Chive
must somehow know where in the target to start deleting and adding content.

To do this, Chive searches all the variants for a particular target to see if
any of them has an exact match against the target file. If there is, then Chive
can determine on its own where it needs to start and how much work it needs to
do. If none of the variants have a match against the target, then Chive cannot
do anything.

Consequently, it is very important that you do not modify sections managed by
Chive and that your initial variant matches what you have in the target file
exactly, otherwise Chive won't know where to start!

# License
