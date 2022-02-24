# Major changes to the IOCCC entry tool set

## Release 0.1

Created this CHANGES.md markdown document.

Added -T flag to `mkiocccentry`, `fnamchk`, `txzchk`, `jstrencode` and
`jstrdecode` to print the IOCCC entry tool set release tag:


```sh
./mkiocccentry -T
./fnamchk -T
./txzchk -T
./jstrencode -T
./jstrdecode -T
```

## Release 0.0

Released early versions of the following tools:

- jstrdecode
- jstrencode
- mkiocccentry
- txzchk

See these man pages for details

- fnamchk.1
- iocccsize.1
- mkiocccentry.1
- txzchk.1