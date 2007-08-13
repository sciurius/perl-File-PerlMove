#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 11;

BEGIN {
    use_ok('File::PerlMove');
}

-d "t" && chdir("t");

require_ok("00common.pl");

our $sz = create_testfile(our $tf = "01basic.dat");

try_move('s/\.dat$/.tmp/', "01basic.tmp", "move1");

try_move('uc', "01BASIC.TMP", "move2");

try_move('lc', "01basic.tmp", "move3");

try_move(sub { s/^(\d+)/sprintf("%03d", 32+$1)/e; },
	 "033basic.tmp", "move4");

cleanup();

sub try_move {
    my ($code, $new, $tag) = @_;
    is(File::PerlMove::move($code, [ $tf ]), 1, $tag);
    $tf = verify($new, $tag);
}
