#!/usr/bin/perl

use strict;
use warnings;

# Check if we can symlink.
my $can_symlink;
BEGIN {
    $can_symlink = eval { symlink("",""); 1 };
}

use Test::More
    $can_symlink
    ? ( tests => 9 )
    : ( skip_all => "Platform has no symlink" );

BEGIN {
    use_ok('File::PerlMove');
}

-d "t" && chdir("t");

require_ok("00common.pl");

our $sz = create_testfile(our $tf = "01basic.dat");

try_symlink('s/\.dat$/.tmp/', "01basic.tmp", "symlink1");

{ my $warn;
  local $SIG{__WARN__} = sub { $warn = "@_"; };
  $tf = "01basic.dat";
  is(File::PerlMove::move('s/\.dat$/.tmp/', [ $tf ], { symlink => 1 }), 0, "symlink2");
  like($warn, qr/: exists/, "symlink2 warning");
}

cleanup();

sub try_symlink {
    my ($code, $new, $tag) = @_;
    is(File::PerlMove::move($code, [ $tf ], { symlink => 1 }), 1, $tag);
    verify($new, $tag);
    my @st1 = lstat($tf);
    my @st2 = lstat($new);
    is(-s $new, $sz, "$tag check size");
    isnt($st1[1], $st2[1], "$tag check inode");
    $tf = $new;
}

