#!/usr/bin/perl -w

my $cmd = shift;
my $showonly = 0;

if ( $cmd =~ /^-+h(elp)?$/i ) {
    print STDERR ("Usage: $0 [ -n ] perl-expression filenames\n");
    exit 1;
}

if ( $cmd =~ /^-+n$/i ) {
    $showonly = 1;
    $cmd = shift;
}

foreach ( @ARGV ) {
    my $old = $_;
    eval "{$cmd}";
    if ( $@ ) {
        $@ =~ s/ at \(eval.*/./;
	die($@);
    }
    my $new = $_;
    unless ( $old eq $new ) {
	print STDERR ("$old => $new\n");
	next if $showonly;
        rename($old, $new) || die("$old: $!\n");
    }
}
