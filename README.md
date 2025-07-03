# Elevenshtein

Elevenshtein is an Elisp extension for the [Emacs](https://www.gnu.org/software/emacs/) text editor that enables a user to calculate the edit (or [Levenshtein](https://en.wikipedia.org/wiki/Levenshtein_distance)) distance between two buffers.

## Installation Instructions

1. Download and save the file [elevenshtein.el](https://raw.githubusercontent.com/igb/elevenshtein/main/lisp/elevenshtein.el) to a local directory on the computer where you run Emacs.

2. Locate your *.emacs* file in your home directory and add the following line:
```Elisp
(load "/path/of/local/directory/where/file/was/saved/into/elevenshtein")
```
Note that you do not need the ".el" filename extension in the path, just the path of the local directory in which the downloaded file resides followed by the string "elevenshtein".

If you do not have a *.emacs* in your home directory go ahead and create an empty file and add the line described above.

```Shell
touch ~/.emacs; echo  '(load "/path/of/local/directory/where/file/was/saved/into/elevenshtein")' >> ~/.emacs
```
Ok, now you are good to go. Just launch or restart Emacs!

## How to use it

**TL;DR:** *M-x edit-distance-buf*

### Details ###
While using Emacs, if you want to calculate the edit distance of two buffers, execute the command *M-x edit-distance-buf*. You will then be prompted to enter the first buffer. You can hit *tab* to see a list of available buffers. After entering the first bufffer you will be prompted to enter the second buffer (once again you can use *tab* to see available buffers). Upon entering the second buffer, the edit distance between the buffers will be calculated and dispayed in the mini buffer.


#### Example ####
![example chat](https://raw.githubusercontent.com/igb/elevenshtein/refs/heads/main/examples/example.gif)

## Questions? ##

You can always contact me with any questions at [@igb@mastodon.hccp.org](https://mastodon.hccp.org/@igb).
