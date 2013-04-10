use Test;
use File::Directory::Tree;
use File::Spec;
use IO::Path::More;

plan 7;

ok (my $tmpdir = File::Spec.tmpdir), "We can haz a tmpdir";
$tmpdir or skip_rest "for EPIC FAIL at finding a place to write";

my $tmppath = IO::Path::More.new($tmpdir);
ok mktree($tmppath.append(
	"foo", "bar", File::Spec.updir, "baz").Str ), "mktree runs";
ok $tmppath.append("foo").d, '$TEMP/foo exists';
ok $tmppath.append('foo').contents.elems == 2, "mktree produces correct number of elements";
ok spurt("$tmpdir/foo/filetree.tmp", "temporary test file, delete after reading"), "created a test file";
say "# ", "$tmpdir/foo".path.contents;
ok rmtree($tmppath.append("foo")), "rmtree runs";
ok $tmppath.append("foo").e.not, "rmtree successfully deletes temp files";

done;