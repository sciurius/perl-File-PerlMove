#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 8;

BEGIN {
    use_ok('File::PerlMove');
}

-d "t" && chdir("t");
use lib '..';

my $o = { testing => 1 };

is(File::PerlMove::build_sub('t::foo', $o ),
   "t::foo => foo", "t::foo => foo");
is(File::PerlMove::build_sub('t::foo=bar', $o ),
   "t::foo => bar", "t::foo => bar");
is(File::PerlMove::build_sub('foo', $o ),
   "File::PerlMove::foo => foo", "File::PerlMove::foo => foo");
is(File::PerlMove::build_sub('foo=bar', $o ),
   "File::PerlMove::foo => bar", "File::PerlMove::foo => bar");
is(File::PerlMove::build_sub('uc', $o ),
   "File::PerlMove::BuiltIn => uc", "File::PerlMove::BuiltIn => uc");
is(File::PerlMove::build_sub(':foo:bar:', $o ),
   "Encode::from_to(\$_,\"foo\",\"bar\")", "Encode::from_to(\$_,\"foo\",\"bar\")");
is(File::PerlMove::build_sub('s/foo/bar/', $o ),
   "sub { \$_ = \$_[0]; s/foo/bar/; \$_ }", "sub { \$_ = \$_[0]; s/foo/bar/; \$_ }");


package File::PerlMove::foo;

sub foo { }

sub bar { }

BEGIN { $INC{'File/PerlMove/foo.pm'} = "__embedded__"; }
