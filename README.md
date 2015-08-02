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

`dutiful sync`

Sync all preference files.

## Customization

Dutiful detects the preference files on your computer and keeps them in sync automatically, so you don't need to do anything prior to its usage.
However, if you do want to override its default settings, check out the [docs](doc).

## Supported Storages

 - [Dropbox](https://www.dropbox.com)
 - [iCloud](https://www.icloud.com)
 - Any folder on your computer.
 
## License

[MIT](http://mit-license.org) © [Contributors](https://github.com/bpinto/dutiful/graphs/contributors)
