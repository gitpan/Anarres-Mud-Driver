package Anarres::Mud::Driver::Compiler::Preprocess;

use strict;
use vars qw(@ISA $CPP @CPPARGS);
use Exporter;
use Symbol;
use IO::Handle;
use IPC::Open3;
use Data::Dumper;

BEGIN {
	@ISA = qw(Exporter);
}

$CPP = "/usr/bin/cpp";
@CPPARGS = qw(-nostdinc -undef -Wall
		-I/home/anarres/mudlib/usr/local/include
		-I/home/anarres/mudlib/usr/include);
push(@CPPARGS, qw(-I. -C -dD)) if 0;

sub new {
	my $class = shift;
	my $self = ($#_ == 0) ? { %{ (shift) } } : { @_ };
	return bless $self, $class;
}

sub preprocess {
	my ($self, $text, $path) = @_;
	my ($wtr, $rdr, $err);

	my $dir = $path;
	$dir =~ s,/[^/]*$,,;

	local $/ = undef;

	$err = gensym;	# Make a separate fd, see TFM.

	my $childpid = open3($wtr, $rdr, $err, $CPP, @CPPARGS, "-I$dir");

	print $wtr $text;
	close $wtr;

	my $out = <$rdr>;
	my $errs = <$err>;

	waitpid $childpid, 0;

	# $out =~ s/^#(?:[^\n]*)$//msg;
	# $out =~ s/^\s+$//msg;
	# $out =~ s/\n\n/\n/g;

	my @includes = ( $out =~ m/^#\s*\d+\s*"([^"]*)"/msg );
	my %includes = map { $_ => 1 } @includes;
	delete $includes{""};
	@includes = sort keys %includes;

	# print "Included files: " . join("\n", @includes) . "\n";

	# print "Errors:\n", $errs;
	# print "Result:\n", $out;
	# print $out, "\n---\n\n";

	die $errs if $errs;

	return $out;
}

# my $x = new Anarres::Mud::Driver::Compiler::Preprocess;
# $x->process("#define X 1\nX\n#include <foo.h>");

1;
