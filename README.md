```

██╗   ██╗ ██████╗ ██╗   ██╗██████╗ ██╗     
╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗██║     
 ╚████╔╝ ██║   ██║██║   ██║██████╔╝██║     
  ╚██╔╝  ██║   ██║██║   ██║██╔══██╗██║     
   ██║   ╚██████╔╝╚██████╔╝██║  ██║███████╗
   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝     
 ```
[![Release](https://img.shields.io/badge/release-1.0-brightgreen)](https://github.com/mateuscomh/yoURL/releases)
[![Build Status](https://github.com/mateuscomh/yoURL/actions/workflows/shell-linter.yml/badge.svg)](https://github.com/mateuscomh/yoURL/actions/workflows/shell-linter.yml)

# URL shortner and upload files direct from terminal
Send files direct from terminal to https://0x0.st or short url by https://tinyurl.com

Works on 
- GNU/Linux 
- MacOS
- WSL2

Depends: 
- curl 
- qrencode
- xclip
- pbcopy(MacOS)


Usage:
To short links:
```
yourl.sh 'http://www.URLtoShortner.com'
```

To sent files:
```
yourl.sh '/Path/To/Your/File'
```


### Disclamer
Maximum file size: 512.0 MiB
Blocked file types: application/x-dosexec, application/x-executable, application/x-hdf5, application/java-archive, Android APKs and system images.

TERMS OF SERVICE
----------------

This is NOT a platform for:
- piracy
- pornography and gore
- extremist material of any kind
- malware / botnet C&C
- anything related to crypto currencies
- backups (yes, this includes your minecraft stuff, seriously
    people have been dumping terabytes of it here for years)
- CI build artifacts
- doxxing, database dumps containing personal information
- anything illegal under German law

## Licensing Your Contributions

Please note that when contributing to this project, you agree to license your contributions under the terms of the GPL-3.
[complete copy of GPL-3 here](https://www.gnu.org/licenses/gpl-3.0.html).

---

