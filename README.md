# gistrb - A command-line utility to post files directly as Gists on GitHub.com
### Description:
This is a utility to easily post local source files you have on GitHub Gists. It
supports uploading multi-file Gists, authenticated Gists, anonymous Gists, and
declaring the Gists as private or public. You can also attach descriptions to the Gist you post.

## Usage:

```shell
gist [opts] source_file source_file2
```

## Options:
Option                                 | Description
-------------------------------------- | -----------
 -u &#124; --user                      | Post the Gist as currently signed in user
 -s &#124; --sign-in                   | Sign into the utility using your GitHub account
 --sign-out                            | Sign out of the utility
 -p &#124; --public                    | Post the Gist as public (it posts as private by default)
 -d [DESC] &#124; --description [DESC] | Use [DESC] as the description for the Gist
 -c &#124; --clipboard                 | Automatically put the created Gist URL into your clipboard (beta)

## Installation:
Using RubyGems, simply run this command:
`gem install gistrb`

## Requirements:
If on Linux, you need to have xclip installed for clipboard support

To install this on Ubuntu-based distributions, run the following command.
```shell
sudo apt-get install xclip
```

## Some Information
This utility has only been tested on an Ubuntu Linux based machine. Ideally, it'll
run under any Linux environment. I can not guarantee this utility will work under OS X or Windows.

The sign-in system simply stores your OAuth key for the application inside a directory named .gistruby in a non-encrypted file.
Take this information and use at your own risk.

## License
MIT License

Copyright &copy; 2015 Cameron Roe
