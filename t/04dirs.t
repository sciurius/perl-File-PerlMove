#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7;

BEGIN {
    use_ok('File::PerlMove');
}

-d "t" && chdir("t");

require_ok("00common.pl");

our $sz = create_testfile(our $tf = "01basic.dat");

{ my $warn;
  local $SIG{__WARN__} = sub { $warn = "@_"; };
  is(File::PerlMove::move('s;^;04dirs/;', [ $tf ]), 0, "move1");
  like($warn, qr/: no such file or directory/i, "move1 warning");
}

$tf = "01basic.dat";
is(File::PerlMove::move('s;^;04dirs/;', [ $tf ], { createdirs => 1 }), 1, "move2");
$tf = verify("04dirs/$tf", "move2");

cleanup();

rmdir("04dirs");
