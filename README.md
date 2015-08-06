[![Build Status](https://travis-ci.org/bpinto/dutiful.svg?branch=master)](https://travis-ci.org/bpinto/dutiful)
[![Dependency Status](https://gemnasium.com/bpinto/dutiful.svg)](https://gemnasium.com/bpinto/dutiful)
[![Gitter](https://img.shields.io/badge/gitter-join%20chat-blue.svg)](https://gitter.im/bpinto/dutiful?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Dutiful

### What?
  Dutiful is a user-friendly tool for managing your application settings and preference files.
  
### Why?
  Getting a new computer should be a pleasure.  Formatting your computer should be less hassle.

### How?
  We detect and keep your application settings and preference files in sync with your favorite storage service (iCloud, Dropbox, etc.).

<br>
## Installation

```shell
gem install dutiful
```

## Usage

`dutiful backup`

Backup all preference files.

`dutiful list`

List all preference files and their current sync status.

`dutiful restore`

Restore all preference files.

## Customization

Dutiful detects the preference files on your computer and keeps them in sync automatically, so you don't need to do anything prior to its usage.
However, if you do want to override its default settings, check out the [docs](doc).

## Supported Storages

 - [Dropbox](https://www.dropbox.com)
 - [iCloud](https://www.icloud.com)
 - Any folder on your computer.

## Supported Applications
 - [Alfred](http://www.alfredapp.com)
 - [Brew](http://brew.sh)
 - [Bundler](http://bundler.io)
 - [Dash](https://kapeli.com/dash)
 - [Dutiful](https://github.com/bpinto/dutiful/)
 - [Fish](http://fishshell.com)
 - [Git](https://git-scm.com)
 - [iTerm2](https://iterm2.com)
 - [Oh My Zsh](http://ohmyz.sh)
 - [OSX Screencapture](db/osx-screencapture.toml)
 - [Popcorn-Time](https://popcorntime.io)
 - [RubyMine](https://www.jetbrains.com/ruby/)
 - [The Silver Searcher](http://geoff.greer.fm/ag/)
 - [tmux](https://tmux.github.io)
 - [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
 - [Vim](http://www.vim.org)
 - [z](https://github.com/rupa/z)
 - [Zsh](http://www.zsh.org)
 
## License

[MIT](http://mit-license.org) © [Contributors](https://github.com/bpinto/dutiful/graphs/contributors)
