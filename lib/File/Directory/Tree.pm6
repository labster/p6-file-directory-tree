use v6.c;
unit module File::Directory::Tree:ver<1.0.0>:auth<cpan:LABSTER>;

multi sub mktree (Cool:D $path is copy, Int :$mask = 0o777 ) is export {
	return True if $path.IO ~~ :d;
	$path.=IO;
	my @makedirs;
	while $path !~~ :e {
		@makedirs.push($path);
		$path.=parent;
	}
	for @makedirs.reverse -> $dir {
		mkdir($dir, $mask) or return False unless $dir.e;
	}
	True;
}

multi sub empty-directory (Cool:D $path is copy) {
    empty-directory $path.IO;
}

multi sub empty-directory (IO::Path:D $path) is export {
	$path.d or fail "$path is not a directory";
	for eager $path.dir -> $file {
		#say $file.perl;
		if $file.l.not and $file.d { rmtree $file }
		else { unlink $file }
	}
	True;
}

multi sub rmtree (Cool:D $path is copy) {
    rmtree $path.IO;
}

multi sub rmtree (IO::Path:D $path) is export {
	return True if !$path.e;
	$path.d or fail "$path is not a directory";
	empty-directory($path.IO) or return False;
	rmdir($path.IO) or return False;
	True;
}



=begin pod

[![Build status](https://ci.appveyor.com/api/projects/status/github/labster/p6-file-directory-tree?svg=true)](https://ci.appveyor.com/project/labster/p6-file-directory-tree)

=head1 NAME

File::Directory::Tree - Create and delete directory trees

=head1 SYNOPSIS

	# make a new directory tree
	mktree "foo/bar/baz/quux";
	# delete what you just made
	rmtree "foo";
	# clean up your /tmp -- but don't delete /tmp itself
	empty-directory "/tmp";

=head1 DESCRIPTION

File::Directory::Tree provides recursive versions of mkdir and rmdir.
This might be useful for things like setting up a repo all at once.

=head1 FUNCTIONS

=head2 mktree

Makes a directory tree with the given path.  If any elements of the tree do not already exist, this will make new directories.

	sub mktree (IO::Path( Cool:D ) $path, Int $mask = 0o777)

Accepts an optional second argument, the permissions mask.  This is supplied to mkdir, and used for all of the directories it makes; the default is `777` (`a+rwx`).  It takes an integer, but you really should supply something in octal like 0o755 or :8('500').

Returns True if successful.

=head2 rmtree

This deletes all files under a directory tree with the given path before deleting the directory itself.  It will recursively call unlink and rmdir until everything under the path is deleted.

Returns True if successful, and False if it cannot delete a file.

=head2 empty-directory

Also deletes all items in a given directory, but leaves the directory itself intact.  After running this, the only thing in the path should be '.' and '..'.

Returns True if successful, and False if it cannot delete a file.

=head1 TODO

=item Probably handle errors in the test file better

=head1 SEE ALSO

=item Perl 6 docs: L<https://docs.perl6.org/routine/rmdir|rmdir()>, L<https://docs.perl6.org/routine/mkdir|mkdir>
=item L<File::Temp|https://github.com/perlpilot/p6-File-Temp>

=head1 AUTHOR

Brent "Labster" Laabs <bslaabs@gmail.com>

Based loosely on code by written Daniel Muey in Perl 5's L<https://metacpan.org/pod/File::Path::Tiny|File::Path::Tiny>.

=head1 COPYRIGHT AND LICENSE

Copyright 2013, 2018 Brent Laabs

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
