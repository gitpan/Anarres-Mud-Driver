package Anarres::Mud::Driver::Program::Efun;

use strict;
use vars qw(@ISA @EXPORT_OK %EFUNS %EFUNFLAGS);
use Carp;
use Exporter;
use Anarres::Mud::Driver::Program::Method qw(:flags);

@ISA = qw(Anarres::Mud::Driver::Program::Method);
@EXPORT_OK = qw(register %EFUNS %EFUNFLAGS);

%EFUNS = ();
%EFUNFLAGS = ();

sub register {
	my ($class, $flags, $rettype, @argtypes) = @_;

	# print "Registering efun $class\n";

	my $efun = $class;
	$efun =~ s/^.*:://;

	croak "Duplicate efun $efun" if $EFUNS{$efun};

	my @args = ();
	my $i = 0;
	foreach (@argtypes) {
		my $arg = new Anarres::Mud::Driver::Program::Variable(
						Type	=> $_,
						Name	=> "arg" . $i,
							);
		push(@args, $arg);
		$i++;
	}

	{
		no strict qw(refs);
		*{"$class\::ISA"} = [ qw(Anarres::Mud::Driver::Program::Efun) ]
						unless @{"$class\::ISA"};
	}

	my $instance = $class->new(
					Name	=> $efun,
					Type	=> $rettype,
					Args	=> \@args,
						);

	$EFUNS{$efun} = $instance;
	$EFUNFLAGS{$efun} = $flags | M_EFUN | M_INHERITED;

}

# Unfortunately, we need this for the ::invoke. Unless we throw
# that into 'Name' as well, but then Name wouldn't match the hash
# key in the Program object.
sub gencall {
	my ($self, @args) = @_;
	return ref($self) . "::invoke(" . join(", ", @args) . ")";
}

sub dump {
	my $self = shift;
	my $name = ref($self);
	$name =~ s/^.*:://;
	return "(efun $name)";
}

1;