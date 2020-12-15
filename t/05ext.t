#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 5;

BEGIN {
    use_ok('File::PerlMove');
}

-d "t" && chdir("t");
use lib '..';

require_ok("./00common.pl");

our $sz = create_testfile(our $tf = "05ext.dat");

is(pmv('t::foo', [ $tf ], { createdirs => 1 }), 1, "ext1");
$tf = verify(uc($tf), "move2");

cleanup();

unlink( $tf, uc($tf) );
