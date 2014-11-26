#!/usr/bin/env python
from sys import argv, exit
from os import remove
from os.path import splitext, isfile
from shutil import copyfile

############ PARAMETERS #############
old_file = 'in'
global_extension = '.hex'
#####################################

KRED = '\x1B[31m'
KNRM = '\x1B[0m'

old_file += global_extension
info = """
    This utility will delete the file defined as old_file, and
    copy the argument given file in it's place.
    This gives us the ability to test whatever file
    we want without recompiling our testbench!

    Usage:
         %s newfile_with_or_without_extension_here(%s)
""" % (argv[0], global_extension)

def main():
    if ( len(argv) != 2):
        print(info)
        exit(-1)

    new_file = argv[1]
    name, extension = splitext(new_file)

    #check the extension, if it's missing add global
    if extension == '' :
        new_file = name + global_extension
    elif extension != global_extension:
        print('\n%s[error]:%s Probably bad extension [%s]\n' % (KRED, KNRM, extension))
        return

    #delete old file
    if isfile(old_file):
        remove(old_file)

    #copy the new file
    if isfile(new_file):
        print('\n[%s] %s<<%s [%s].\n' % (old_file, KRED, KNRM, new_file))
        copyfile(new_file, old_file)
    else :
        print('\n%s[error]:%s Probably bad filename [%s]\n' % (KRED, KNRM, new_file ))

if __name__ == '__main__' :
    main()
