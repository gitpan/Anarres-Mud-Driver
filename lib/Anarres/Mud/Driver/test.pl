use strict;
use lib q[../../..];
use Carp qw(:DEFAULT cluck);
use Data::Dumper;
use Time::HiRes qw(time);

BEGIN {
	local $SIG{__DIE__} = sub { confess @_; };
	local $SIG{__WARN__} = sub { cluck @_; };
	use Anarres::Mud::Driver::Compiler;
	use Anarres::Mud::Driver::Efun::MudOS;
}

# yapp -vm 'Anarres::Mud::Driver::Compiler::Parse' -o Parse.pm Parse.yp

$Data::Dumper::Indent = 1;
select STDERR;
$| = 1;
select STDOUT;
$| = 1;

sub mungeerror {
	my $err = shift;
	$err =~ s/Anarres::Mud::Driver::Program::Node/_AMDPN/g;
	$err =~ s/Anarres::Mud::Driver::Program/_AMDP/g;
	$err =~ s/Anarres::Mud::Driver::Compiler/_AMDC/g;
	$err =~ s/Anarres::Mud::Driver/_AMD/g;
	confess $err if $err =~ /Deep recursion/i;
	return $err;
}

$SIG{__DIE__} = sub { confess mungeerror @_; };
$SIG{__WARN__} = sub { cluck mungeerror @_; };

sub test {
	my $path = "/usr/libexec/sefun.c";
	my $c = new Anarres::Mud::Driver::Compiler;
	my $p = $c->compile($path);
	print $p, "\n";

	return;

	eval qq{ $p };
	if ($@) {
		die $@;
	}
	else {
		print "\nEval successful!\n";
	}
}

print "Compile complete\n";

my $now = time;

if (0) {
	use Anarres::Mud::Driver::Program::Type qw(:types);
	my $a = T_INTEGER->pointer;
	my $b = T_ARRAY;

	$b->meet($a);
}
else {
	eval { &test; };
	print mungeerror($@) if $@;
}

print "Time taken: " . (time() - $now) . " seconds\n";

# print Dumper(\%INC);

1;
