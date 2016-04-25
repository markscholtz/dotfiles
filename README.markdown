# Dotfiles

## personal notes

### Ingoring tags files globally
From tpope's vim-pathogen README:

  >>Will you accept these 14 pull requests adding a .gitignore for tags so I don't see untracked changes in my dot files repository?

  >No, but I'll teach you how to ignore tags globally:

  ```
  git config --global core.excludesfile '~/.cvsignore'
  echo tags >> ~/.cvsignore
  ```

  >While any filename will work, I've chosen to follow the ancient tradition of .cvsignore because utilities like rsync use it, too. Clever, huh?

### Submodules

#### Initializing submodules

When first installing dotfiles on a new machine run the following to initialize submodules:

    git submodule update --init --recursive

#### Updating submodules

To update the git submodules that I've used to organize vim plugins run the following command (
[Stack Overflow question](http://stackoverflow.com/questions/5828324/update-git-submodule)):

  ```
  git submodule foreach git pull origin master
  ```

After updating the submodules make sure to check in the updated commit references.

## todo

* Update the README below: this is from the original forked repo

---

## dotfiles

Your dotfiles are how you personalize your system. These are mine. The very
prejudiced mix: OS X, zsh, Ruby, Rails, git, homebrew, rvm, vim. If you
match up along most of those lines, you may dig my dotfiles.

I was a little tired of having long alias files and everything strewn about
(which is extremely common on other dotfiles projects, too). That led to this
project being much more topic-centric. I realized I could split a lot of things
up into the main areas I used (Ruby, git, system libraries, and so on), so I
structured the project accordingly.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read my post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## Installation

### General

Run the following commands to clone and install dotfiles:

    cd ~
    mkdir code
    git clone https://github.com/markscholtz/dotfiles.git
    cd ~/code/dotfiles
    rake install

The install rake task will symlink the appropriate files in `.dotfiles` to your
home directory. Everything is configured and tweaked within `~/.dotfiles`,
though.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

### Git

The gitconfig file requires a bit of customization when changing and so
currently is not automatically symlinked as part of the installation process.

Run the following command to copy a gitconfig template:

    cd ~/code/dotfiles
    cp git/gitconfig.symlink.myexample git/gitconfig.symlink
    rake install

Then make the following changes:

- Delete unnecessary comments.
- Update user.email.
- Set credential.helper based on operating system.

### OS X

Install all Homebrew CLI applications specified in the Brewfile by running:

    brew update # Initialize empty git repository.
    brew bundle

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `rake install`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you. Fork it, remove what you
don't use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `rake install`.
- **topic/\*.completion.sh**: Any files ending in `completion.sh` get loaded
  last so that they get loaded after we set up zsh autocomplete functions.

## add-ons

There are a few things I use to make my life awesome. They're not a required
dependency, but if you install them they'll make your life a bit more like a
bubble bath.

- If you want some more colors for things like `ls`, install grc: `brew install
  grc`.
- If you install the excellent [rvm](http://rvm.beginrescueend.com) to manage
  multiple rubies, your current branch will show up in the prompt. Bonus.

## thanks

Originally forked from and inspired by [Zash Holman's
dotfiles](https://github.com/holman/dotfiles).
