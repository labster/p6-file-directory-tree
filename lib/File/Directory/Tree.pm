module File::Directory::Tree;

use File::Spec;
use IO::Path::More;

# this will use IO::Path instead of IO::Path::More when .parent is ported

sub mktree ($path, Int :$mask = 0o777 ) is export {
	return True if $path.IO ~~ :d;
	my $p = IO::Path::More.new($path);
	my @makedirs;
	while $p !~~ :e {
		@makedirs.push($p);
		$p.=parent;
	}
	for @makedirs.reverse -> $dir {
		mkdir($dir, $mask) or return False unless $dir.e;
	}
	True;
}

#these too.  Thanks to .contents, we currently have an strange mix of IO::Path
#and IO::Path::More where .path and .Str are defined differently.

sub empty-directory ($path-to-empty) is export {
	my $path = IO::Path::More.new(~$path-to-empty);
	$path.d or fail "$path-to-empty is not a directory";
	for $path.contents -> $file {
		#say $file.perl;
		if $file.l.not and $file.d { rmtree $file.path }
		else { unlink $file.path }
	}
	True;
}

sub rmtree ($path-to-remove) is export {
	my $path = IO::Path::More.new(~$path-to-remove);
	return True if !$path.e;
	$path.d or fail "$path-to-remove is not a directory";
	empty-directory($path.path) or return False;
	rmdir($path.path) or return False;
	True;
}

