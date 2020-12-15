#! perl

package t::foo;

use strict;
use warnings;

sub foo {
    uc($_[0]);
}
sub bar {
    ucfirst($_[0]);
}

1;
