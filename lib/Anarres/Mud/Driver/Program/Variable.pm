package Anarres::Mud::Driver::Program::Variable;

use strict;
use vars qw(@ISA);
# use overload '""' => sub { "AMD::Variable(" . $_[0]->name . ")" };
use Exporter;

@ISA = qw(Exporter);

# New representation will be [ Type, Flags, Name, Args, Code ]
# Args and Code are only relevant for Method objects.

sub new {
	my $class = shift;
	my $self = ($#_ == 0) ? { %{ (shift) } } : { @_ };
	return bless $self, $class;
}

sub name { return $_[0]->{Name}; }
sub type { return $_[0]->{Type}; }

sub dump {
	my $self = shift;

	return "([" . $self->type->dump(@_) . "] var " . $self->name . ")";
}

1;
