package Anarres::Mud::Driver::Compiler::Type;

use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);
use Exporter;

BEGIN {
	$VERSION = 0.10;
	@ISA = qw(DynaLoader Exporter);
	@EXPORT = qw(T_CLASS F_CONST F_LVALUE);	# .xs adds more to this
	require DynaLoader;
	bootstrap Anarres::Mud::Driver::Compiler::Type;
}

sub T_CLASS {
	my $class = __PACKAGE__;
	my $self = T_M_BEGINCLASS . join('', map { $$_ } @_) . T_M_ENDCLASS;
	return $class->new($self);
}

sub F_CONST		()	{ 1 }
sub F_LVALUE	()	{ 2 }

sub array {
	my ($self, $num) = @_;
	$num = 1 unless defined $num;
	my $out = "*" x $num . $$self;
	return $self->new($out);
}

sub mapping {
	my ($self, $num) = @_;
	$num = 1 unless defined $num;
	my $out = "#" x $num . $$self;
	return $self->new($out);
}

sub dereference {
	my ($self) = @_;
	my $new;
	if ($$self =~ /^[*#]/) {
		$new = substr($$self, 1)
	}
	elsif ($$self eq ${ &T_STRING }) {	# XXX Remove this case?
		warn "Dereferencing string!";
		$new = T_INTEGER;
	}
	else {
		die "Cannot dereference nonreference type $$self";
	}
	return $self->new($new);
}

sub is_array {
	return ${$_[0]} =~ /^\*/;
}

sub is_mapping {
	return ${$_[0]} =~ /^#/;
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
