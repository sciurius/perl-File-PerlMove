#!/usr/bin/perl -w
my $RCS_Id = '$Id$ ';

# Skeleton for Getopt::Long.

# Author          : Johan Vromans
# Created On      : Tue Sep 15 15:59:04 1992
# Last Modified By: Johan Vromans
# Last Modified On: Sat Aug  7 15:13:06 2004
# Update Count    : 101
# Status          : Unknown, Use with caution!

################ Common stuff ################

use strict;

# Package name.
my $my_package = 'Sciurix';
# Program name and version.
my ($my_name, $my_version) = $RCS_Id =~ /: (.+).pl,v ([\d.]+)/;
# Tack '*' if it is not checked in into RCS.
$my_version .= '*' if length('$Locker$ ') > 12;

################ Command line parameters ################

my $showonly = 0;		# just show, do nothing
my $reverse = 0;		# process in reverse order
my $overwrite = 0;		# overwrite existing files
my $link = 0;			# link instead of rename
my $symlink = 0;		# symlink instead
my $verbose = 0;		# more verbosity

# Development options (not shown with --help).
my $debug = 0;			# debugging
my $trace = 0;			# trace (show process)
my $test = 0;			# test mode.

# Process command line options.
app_options();

# Post-processing.
$trace |= ($debug || $test);

################ Presets ################

my $TMPDIR = $ENV{TMPDIR} || $ENV{TEMP} || '/usr/tmp';

################ The Process ################

my $cmd = shift;

@ARGV = reverse(@ARGV) if $reverse;
foreach ( @ARGV ) {
    my $old = $_;
    eval "{$cmd}";
    if ( $@ ) {
        $@ =~ s/ at \(eval.*/./;
	die($@);
    }
    my $new = $_;
    unless ( $old eq $new ) {
	if ( $verbose || $showonly ) {
	    print STDERR ("$old => $new\n");
	    next if $showonly;
	}
	if ( ! $overwrite && -e $new ) {
	    warn("$new: exists\n");
	    next;
	}

	if ( $symlink ) {
	    symlink($old, $new) || warn("$old: $!\n");
	}
	elsif ( $link ) {
	    link($old, $new) || warn("$old: $!\n");
	}
	else {
	    rename($old, $new) || warn("$old: $!\n");
	}
    }
}

exit 0;

################ Subroutines ################

################ Command Line Options ################

use Getopt::Long qw(:config bundling);

sub app_options {
    eval { Getopt::Long::->VERSION(2.34) };	# will enable help/version

    GetOptions(ident	   => \&app_ident,
	       'verbose|v'   => \$verbose,

	       # application specific options go here
	       'link|l'	     => \$link,
	       'symlink|s'   => \$symlink,
	       'dry-run|n'   => \$showonly,
	       'reverse|r'   => \$reverse,
	       'overwrite|o' => \$overwrite,

	       # development options
	       test	   => \$test,
	       trace	   => \$trace,
	       debug	   => \$debug)
      or Getopt::Long::HelpMessage(2);
}

sub app_ident {
    print STDOUT ("This is $my_package [$my_name $my_version]\n");
}

__END__

=head1 NAME

pmv - rename files using Perl expressions

=head1 SYNOPSIS

pmv [options] [file ...]

Options:

   --dry-run -n         show, but do not do it
   --link		link instead of rename
   --symlink		symlink instead of rename
   --reverse -r		process in reverse order
   --overwite -o	overwrite exisiting files
   --ident		show identification
   --help		brief help message
   --verbose		verbose information

=head1 DESCRIPTION

B<This program> will apply the given Perl expression to each of the
file names. If the result is different from the original name, the
file will be renamed, linked, or symlinked.

=head1 OPTIONS

=over 8

=item B<--dry-run> B<-n>

Show the changes, but do not rename the files.

=item B<--link>

Link instead of rename.

=item B<--symlink>

Symlink instead of rename.

=item B<--reverse>

Process the files in reversed order.

=item B<--overwrite>

Overwrite existing files.

=item B<--verbose>

More verbose information.

=item B<--version>

Print a version identification to standard output and exits.

=item B<--help>

Print a brief help message to standard output and exits.

=item B<--ident>

Prints a program identification.

=item I<file>

File name(s).

=back

=head1 EXAMPLES

To change editor backup files back to Perl sources:

    $ pmv 's/\.bak$/.pl/' *.bak
    foo.bak => foo.pl
    bar.bak => bar.pl

Shift numbered examples to a new section:

    $ pmv --reversed 's/^ex(\d)/"ex".($1+3)/ge' ex*
    ex42.dat => ex72.dat
    ex25.dat => ex55.dat
    ex22.dat => ex52.dat
    ex13.dat => ex43.dat
    ex12.dat => ex42.dat

Note that these need to be processed in reversed order, to prevent
C<ex12.dat => ex42.dat> botching with the exisitng C<ex42.dat>.

=head1 AUTHOR

Johan Vromans <jvromans@squirrel.nl>

=head1 COPYRIGHT

This programs is Copyright 2004, Squirrel Consultancy.

This program is free software; you can redistribute it and/or modify
it under the terms of the Perl Artistic License or the GNU General
Public License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

=cut
