# Project Layout
## Tubes

So, how it works in pwntools is that whenever our process has to talk to the outside world, we usew a standard interface.

That's pretty reasonable; the biggest building blocks between processes that have to talk to eachother is sending and receiving bytes. 
After that, we have some helper functions such as recvline, recvn(c), recvuntil(c), etc.

### Types of Tubes
+ Process
+ Remote (http, https, ftp, etc)

## Utils

OCaml doesn't really seem to be friendly with bytes.

### Stuff to build for this
+ integer packing

## Asm

### Automatically grabbing target architecture, os

### Shellcraft

## Logging

Not sure what the best choice for logging is; I didn't find it super useful in pwntools to be honest.
In general `debug` seemed to give way too much info, and I'd just end up filtering it; maybe look at how other projects do logging?


## Working with ELFs
+ ASLR constants
+ Dynlib resolution off leak
## Working with PEs
## Constants
+ Syscall table
+ Read, Write, Execute
## Encoding, Decoding
## Working with core dumps
https://docs.pwntools.com/en/stable/elf/corefile.html
Seems pretty sick
## Format string library
## GDB Support
## QEMU utils
## ROP support
Autorop would be nice

# CLI
+ Checksec
Who knows what else

# Working on right now...
+ More tube related things, like remote
+ Tube helper functions, such as read_string, read_until, etc

# Finished
+ First-class module style abstraction for tube, concrete implementation
in the form of processes
