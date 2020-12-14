#! perl

package t::foo;

use strict;
use warnings;

sub foo {
    $_ = uc($_);
}
sub bar {
    $_ = ucfirst($_);
}

1;
