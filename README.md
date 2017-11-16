# gistrb - A command-line utility to post files directly as Gists on GitHub.com
### Description:
This is a utility to easily post local source files you have on GitHub Gists. It
supports uploading multi-file Gists, authenticated Gists, anonymous Gists, and
declaring the Gists as private or public. You can also attach descriptions to the Gist you post.

## Usage:

```shell
gistrb [opts] source_file source_file2 ...
```

`gistrb` also supports input from STDIN. If `gistrb` is invoked with no files and nothing piped in, then it will wait
on the terminal for input from STDIN until it reads an EOF character. An EOF character can be inserted on the terminal using Ctrl+D.

Any files in the Gist from STDIN will be labelled as "STDIN".

```shell
$ cat foo.txt | gistrb [opts] source_file # Reads foo.txt from piped STDIN and source_file as a file.
$ gistrb [opts] # Waits until it reads Ctrl+D and processes that data as STDIN
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

## License
MIT License

Copyright &copy; 2017 Cameron Roe
