[![Build Status](https://travis-ci.org/labster/p6-file-directory-tree.svg?branch=master)](https://travis-ci.org/labster/p6-file-directory-tree)

[![Build status](https://ci.appveyor.com/api/projects/status/github/labster/p6-file-directory-tree?svg=true)](https://ci.appveyor.com/project/labster/p6-file-directory-tree)

NAME
====

File::Directory::Tree - Create and delete directory trees

SYNOPSIS
========

    # make a new directory tree
    mktree "foo/bar/baz/quux";
    # delete what you just made
    rmtree "foo";
    # clean up your /tmp -- but don't delete /tmp itself
    empty-directory "/tmp";

DESCRIPTION
===========

File::Directory::Tree provides recursive versions of mkdir and rmdir. This might be useful for things like setting up a repo all at once.

FUNCTIONS
=========

mktree
------

Makes a directory tree with the given path. If any elements of the tree do not already exist, this will make new directories.

    sub mktree (IO::Path( Cool:D ) $path, Int $mask = 0o777)

Accepts an optional second argument, the permissions mask. This is supplied to mkdir, and used for all of the directories it makes; the default is `777` (`a+rwx`). It takes an integer, but you really should supply something in octal like 0o755 or :8('500').

Returns True if successful.

rmtree
------

This deletes all files under a directory tree with the given path before deleting the directory itself. It will recursively call unlink and rmdir until everything under the path is deleted.

Returns True if successful, and False if it cannot delete a file.

empty-directory
---------------

Also deletes all items in a given directory, but leaves the directory itself intact. After running this, the only thing in the path should be '.' and '..'.

Returns True if successful, and False if it cannot delete a file.

TODO
====

  * Probably handle errors in the test file better

SEE ALSO
========

  * Perl 6 docs: [https://docs.perl6.org/routine/rmdir](rmdir()), [https://docs.perl6.org/routine/mkdir](mkdir)

  * [File::Temp](https://github.com/perlpilot/p6-File-Temp)

AUTHOR
======

Brent "Labster" Laabs <bslaabs@gmail.com>

Based loosely on code by written Daniel Muey in Perl 5's [https://metacpan.org/pod/File::Path::Tiny](File::Path::Tiny).

COPYRIGHT AND LICENSE
=====================

Copyright 2013, 2018 Brent Laabs

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

