package Anarres::Mud::Driver::Compiler::Type;

use strict;
use warnings;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS);
use Exporter;


BEGIN {
	my @TYPES = qw(
				T_BOOL
				T_CLOSURE
				T_INTEGER
				T_MAPPING
				T_NIL
				T_OBJECT
				T_STRING
				T_UNKNOWN
				T_VOID

				T_ARRAY T_MAPPING

				T_M_ARRAY T_M_MAPPING

				T_FAILED
								);
	my @FLAGS = qw(F_CONST F_LVALUE);

	@ISA = qw(Exporter);
	@EXPORT_OK = (@TYPES, @FLAGS);
	%EXPORT_TAGS = (
		types	=> \@TYPES,
		flags	=> \@FLAGS,
		all		=> \@EXPORT_OK,
			);
}

sub T_CLASS		()	{
	my $package = __PACKAGE__;
	my $self = T_M_CLASS . $_[0];
	return bless \$self, $package;
}

sub F_CONST		()	{ 1 }
sub F_LVALUE	()	{ 2 }

sub array {
	my ($self, $num) = @_;
	$num = 1 unless defined $num;
	my $out = "*" x $num . $$self;
	return bless \$out, ref($self);
}

sub mapping {
	my ($self, $num) = @_;
	$num = 1 unless defined $num;
	my $out = "#" x $num . $$self;
	return bless \$out, ref($self);
}

sub dereference {
	my ($self) = @_;
	my $new;
	if ($$self =~ /^[*#]/) {
		$new = substr($$self, 1)
	}
	elsif ($$self eq ${ &T_STRING }) {
		$new = T_INTEGER;
	}
	else {
		die "Cannot dereference nonreference type $$self";
	}
	return bless \$new, ref($self);
}

sub dump {
	return ${$_[0]};
}

sub equals {
	return ${$_[0]} eq ${$_[1]};
}

# Called from Node->promote in Check.pm
sub promote {
	my ($self, $node, $type) = @_;
	# We might be promoted to a more specific type.
	# We might be promoted to a less specific type.
	# This routine must return a typechecked object.
	if ($$self ne $$type) {
		print "Promoting " . sprintf("%-20.20s", $node->nodetype) .
						" from $$self to $$type\n";
	}
	return $node;	# XXX do something here!
}

1;
