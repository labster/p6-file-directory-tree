use v6;
use Test;
use lib 'lib';
use File::Directory::Tree;

plan 9;

ok (my $tmpdir = $*TMPDIR), "We can have a tmpdir";
$tmpdir or skip-rest "for EPIC FAIL at finding a place to write";

my $tmppath = $tmpdir.IO;
my $tmpfn;
repeat {
    $tmpfn = (2**32).rand.Int.fmt("%8.8X");
    { skip-rest 'Could not find a place to put tests'; last } if ++$ > 10;
} while $tmppath.child($tmpfn).e;
ok mktree($tmppath.child(
    $*SPEC.catdir( $tmpfn, "bar", $*SPEC.updir, "baz")).Str ), "mktree runs";
ok $tmppath.child($tmpfn).d, '$TEMP/' ~ $tmpfn ~ ' exists';
ok $tmppath.child($tmpfn).dir.elems == 2, "mktree produces correct number of elements";
ok spurt("$tmpdir/$tmpfn/filetree.tmp", "temporary test file, delete after reading"), "created a test file";
say "# ", "$tmpdir/$tmpfn".IO.dir;
ok rmtree($tmppath.child($tmpfn)), "rmtree runs";
ok $tmppath.child($tmpfn).e.not, "rmtree successfully deletes temp files";

if $*DISTRO.is-win {
    skip 'regression test is not run on Windows', 2;
}
else {
    with $*TMPDIR.child: 'file-directory-tree-module-tests' {
      my $inner = $_;
      $inner = $inner.child('a').mkdir for ^120;
      ok .&rmtree, 'no handles leaked by rmtree (requires '
        ~ '`ulimit -n 100` or lower to test properly)';
      ok .e.not,   'dir with inner dirs is gone';
    }
}

done-testing;

# vim: expandtab shiftwidth=4 ft=perl6
