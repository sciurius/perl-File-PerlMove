# Makefile.PL -- Makefile for pmv.
# $Id$
# Author          : Johan Vromans
# Created On      : Wed Dec 14 15:01:44 2005
# Last Modified By: Johan Vromans
# Last Modified On: Mon Aug 13 14:38:09 2007
# Update Count    : 4
# Status          : Stable

# Verify perl version.
require 5.6.0;

use ExtUtils::MakeMaker;

my @scripts = map { "script/$_" } qw(pmv);

my $x =
WriteMakefile
  (
   NAME         => 'pmv',
   AUTHOR	=> 'Johan Vromans (jvromans@squirrel.nl)',
   ABSTRACT	=> 'move files using Perl power',
   VERSION_FROM => $scripts[0],
   PREREQ_PM	=> { 'Getopt::Long' => 2.00,
		     'Test::More' => 0,
		     'File::Path' => 0,
		     'File::Basename' => 0,
		   },
   EXE_FILES    => \@scripts,
   # *.pm files will be picked up automatically from ./lib
 );

sub WriteSpecfile {
    my $name    = shift;
    my $version = shift;

    my $fh;
    if ( open ($fh, "$name.spec.in") ) {
	print "Writing RPM spec file...\n";
	my $newfh;
	open ($newfh, ">$name.spec");
	while ( <$fh> ) {
	    s/%define modname \w+/%define modname $name/;
	    s/%define modversion \d+\.\d+/%define modversion $version/;
	    print $newfh $_;
	}
	close($newfh);
    }
}

WriteSpecfile($x->{NAME}, $x->{VERSION});
