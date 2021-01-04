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

#### Adding Vim plugins using Pathogen

To add a new submodule, run the following command where the first argument to
`add` is the url locating the submodule to install and the second argument is
the location to install it.

    # git submodule add <submodule_url> <destination>
    git submodule add https://github.com/leafgarland/typescript-vim vim/vim.symlink/bundle/typescript-vim

#### Initializing submodules

When first installing dotfiles on a new machine — or if a new submodule was
added to the remote from another machine —run the following to initialize
submodules:

    git submodule update --init --recursive

#### Updating submodules

To update the git submodules that I've used to organize vim plugins run the following command (
[Stack Overflow question](http://stackoverflow.com/questions/5828324/update-git-submodule)):

  ```
  git submodule foreach git pull origin master
  ```

After updating the submodules make sure to check in the updated commit references.

#### Updating submodules — after fetching remote changes

When performing a fetch of the remote repository results in updated submodules
— where each submodule's directory is marked as "modified" with a "(new
commits)" annotation after the directory name — run the following command to
update submodules to their remote states:

  ```
  git submodule update
  ```
#### Removing submodules

To remove a submodule run the following commands — as outlined in [this
answer](https://stackoverflow.com/a/29850245) on Stack Overflow:

  ```
  git submodule deinit <submodule_path_without_trailing_slash>
  git rm <submodule_path_without_trailing_slash>
  ```

## todo

* Update the README below: this is from the original forked repo
