package Anarres::Mud::Driver::Compiler::Symbol;

use strict;
use vars qw(@ISA @EXPORT);
use Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(SYM_TEXT SYM_TYPE SYM_VALUE);

sub SYM_TEXT()	{ 0 }	# The token itself
sub SYM_TYPE()	{ 1 }	# The return value for yylex
sub SYM_VALUE()	{ 2 }	# Any auxiliary value

# [ text, type, value, ...]

sub new {
	my $class = shift;
	my @self = ($#_ == 0) ? @{ (shift) } : @_;
	return bless \@self, $class;
}

sub text { $_[0]->[SYM_TEXT]; }

1;
