package Anarres::Mud::Driver::Program::Type;

use strict;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS %TYPES %PROMOTIONS %JOINS);
use Exporter;
use Carp qw(:DEFAULT cluck);
use Data::Dumper;

BEGIN {
	no strict qw(refs);

	%TYPES = (
		T_VOID		=> "v",
		T_NIL		=> "n",
		T_MIXED		=> "_",
		T_BOOL		=> "b",
		T_CLOSURE	=> "f",
		T_INTEGER	=> "i",
		T_MAPPING	=> "m",	# "M_"?
		T_OBJECT	=> "o",
		T_STRING	=> "s",
		T_ARRAY		=> "P_",
			);
	my $package = __PACKAGE__;

	# Now we construct T_*() as a scalar and a sub of the same name
	# returning a blessed type object, and S_*() as a sub returning
	# a constant string for internal use only.

	foreach (keys %TYPES) {
		# Why doesn't this work to let me reference the variable
		# as \$$_ in the eval below?
		# *{"${package}::$_"} = \${"${package}::$_"};		# "use vars"

		my $ssub = $_;
		$ssub =~ s/^T/S/;

		eval qq{
			{
				package ${package}; # ?
				\$${package}::$_ = bless \\\${TYPES{$_}}, "${package}";
				sub $_ () { \$${package}::$_; };
				# \$${package}::$ssub = "$TYPES{$_}";	# Or \$
				sub $ssub () { "$TYPES{$_}" };
			}
		}; die $@ if $@;

		# If you're wondering...
		# print "$_: ${$_} = $${$_}\n";	# Also &{ $_ }
		# print "$ssub: " . &{ $ssub } . "\n";
	}

	# print Dumper(\%{"${package}::"});

	@ISA = qw(Exporter);
	my @types = keys %TYPES;
	my @strings = map { (my $a = $_) =~ s/^T/S/; $a } @types;
	@EXPORT_OK = (@types, @strings);
	%EXPORT_TAGS = (
		all		=> \@EXPORT_OK,
		types	=> \@types,
		strings	=> \@strings,
			);
	# print Dumper(\%EXPORT_TAGS);

	# XXX Of course, the identity isn't _usually_ the correct promotion.
	my $identity = sub { $_[0] };
	# XXX Insert an assert node...
	# my $assert = $identity;

	# The < sign never appears in a type string.

		# Use S_INTEGER, S_BOOL, etc.
	%PROMOTIONS = (	# Like a lattice meet
		$TYPES{T_INTEGER}	. '<' . $TYPES{T_BOOL}		=> $identity,
		$TYPES{T_ARRAY}		. '<' . $TYPES{T_BOOL}		=> $identity,
		$TYPES{T_MAPPING}	. '<' . $TYPES{T_BOOL}		=> $identity,
		$TYPES{T_OBJECT}	. '<' . $TYPES{T_BOOL}		=> $identity,
		$TYPES{T_STRING}	. '<' . $TYPES{T_BOOL}		=> $identity,
		$TYPES{T_CLOSURE}	. '<' . $TYPES{T_BOOL}		=> $identity,

		# Should this have special treatment?
		$TYPES{T_NIL}		. '<' . $TYPES{T_BOOL}		=> $identity,

		# This one should actually work...
		$TYPES{T_BOOL}		. '<' . $TYPES{T_INTEGER}	=> $identity,

		# Do I want this? (for addition, hash deref, assignment)
		$TYPES{T_INTEGER}	. '<' . $TYPES{T_STRING}	=> $identity,
		# Or this? (for hash deref)
		$TYPES{T_OBJECT}	. '<' . $TYPES{T_STRING}	=> $identity,

		#$TYPES{T_VOID}		. '<' . $TYPES{T_VOID}		=> $identity,

		$TYPES{T_MIXED} . '<' . $TYPES{T_INTEGER}		=>
		sub { new Anarres::Mud::Driver::Program::Node::IntAssert(@_) },

		$TYPES{T_MIXED} . '<' . $TYPES{T_STRING}		=>
		sub { new Anarres::Mud::Driver::Program::Node::StrAssert(@_) },

			# XXX sub?
		$TYPES{T_MIXED} . '<' . $TYPES{T_ARRAY}			=>
		sub { new Anarres::Mud::Driver::Program::Node::ArrAssert(@_) },

			# XXX sub?
		$TYPES{T_MIXED} . '<' . $TYPES{T_MAPPING}		=>
		sub { new Anarres::Mud::Driver::Program::Node::MapAssert(@_) },

		$TYPES{T_MIXED} . '<' . $TYPES{T_CLOSURE}		=>
		sub { new Anarres::Mud::Driver::Program::Node::ClsAssert(@_) },

		$TYPES{T_MIXED} . '<' . $TYPES{T_OBJECT}		=>
		sub { new Anarres::Mud::Driver::Program::Node::ObjAssert(@_) },

			);

		# IntAssert StrAssert ArrAssert MapAssert ClsAssert

	# In increasing priority order - we overwrite.
	foreach (keys %TYPES) {
		next if $_ eq "T_VOID";

		# Assert to turn a mixed into anything: XXX work on this
		# $PROMOTIONS{$TYPES{T_MIXED} . '<' . $TYPES{$_}} = $assert;
		# eval qq{ sub { \$_[0]->assert(\$$_) } };
		# sub { new _AMDPN::$assertnode($_[0]); }

		# Anything can become a mixed: OK
		# This is handled by hardcode.
		# $PROMOTIONS{$TYPES{$_} . '<' . $TYPES{T_MIXED}} = $identity;

		# Anything can become a void: OK
		# This is handled by hardcode.
		# $PROMOTIONS{$TYPES{$_} . '<' . $TYPES{T_VOID}} = $identity;

		# Nil can become anything: generate Node::Nil?
		# This is handled by hardcode.
		# $PROMOTIONS{$TYPES{T_NIL} . '<' . $TYPES{$_}} = $identity;

		# Anything is itself: overwrites "_<_"
		# This is handled by hardcode.
		# $PROMOTIONS{$TYPES{$_} . '<' . $TYPES{$_}} = $identity;
	}

#	print "Available types are\n" .
#						join("\n", sort keys %TYPES) . "\n";;
#	print "Available promotions are\n" .
#						join("\n", sort keys %PROMOTIONS) . "\n";;

	%JOINS = (
		$TYPES{T_VOID} . '<' . $TYPES{T_VOID}		=> &{ T_VOID },
			);

	# In increasing priority order - we overwrite.
	foreach (keys %TYPES) {
		next if $_ eq "T_VOID";

		# Nil meets anything.
		$JOINS{$TYPES{T_NIL} . '<' . $TYPES{$_}} = $TYPES{ $_ };
		$JOINS{$TYPES{$_} . '<' . $TYPES{T_NIL}} = $TYPES{ $_ };

		$JOINS{$TYPES{$_} . '<' . $TYPES{$_}}	 = $TYPES{ $_ };

		# Mixed gives a mixed
		# $JOINS{$TYPES{T_MIXED} . '<' . $TYPES{$_}} = $TYPES{T_MIXED};
		# $JOINS{$TYPES{$_} . '<' . $TYPES{T_MIXED}} = $TYPES{T_MIXED};
	}
}

	# Not yet used
sub struct {
	my ($class, @fields) = @_;			# @fields are Types
	my $self = "S{" . join(",", map { $$_ } @fields) . "}";
	return bless \$self, $class;
}

sub equals { (${$_[0]} eq ${$_[1]}); }

# sub typemeet?
# XXX We might not successfully match P_ against _ or vice versa.
sub promote {
	my ($self, $node, $type) = @_;

	return $node if $$self eq $$type;

	# print "Promote $$self to $$type ...\n";

	# This is cool.
	(my $t = $$self ^ $$type) =~ /^\0*/g;
	my $match = substr($$self, 0, pos($t));
	$match =~ s/[^PM].*$//;

	my $self_dr = substr($$self, length $match);
	my $type_dr = substr($$type, length $match);

	# Is this the best way to do it?
	return $node if $type_dr eq S_MIXED;
	return $node if $type_dr eq S_VOID;
	return $node if $self_dr eq S_NIL;

	# XXX return 'defined node $_'
	return $node if $type_dr eq S_BOOL;

	# We should strip prefix P*
	my $key = $self_dr . '<' . $type_dr;

	# print "Key $key: ";

	my $name = ref($node);
	$name =~ s/^.*:://;

	my $prsub = $PROMOTIONS{$key};

	if (!$prsub) {
		# print "Fail to promote $name from $$self to $$type\n";
		return undef;
	}

	# print "Promote $name from $$self to $$type\n";

	return $prsub->($node);
}

sub typejoin {
	my ($self, $type) = @_;

	return $self unless $type;
	return $self if $$self eq $$type;

	# This is cool.
	(my $t = $$self ^ $$type) =~ /^\0*/g;
	my $match = substr($$self, 0, pos($t));
	# If we allow types of the form 'Sfoo' for "class foo" then:
	$match =~ s/[^PM].*$//;

	my $self_dr = substr($$self, length $match);
	my $type_dr = substr($$type, length $match);

	my $join = $JOINS{$self_dr . '<' . $type_dr} || S_MIXED;

		# XXX The 'if' isn't necessary in view of the initial
		# equality test above?
	$match .= $join if $match =~ /^[PM]*$/;	# Remove modifiers

	# print "Match $$self =~ $$type: $match\n";

	return bless \$match, ref($self);

	return $self;
}

sub classp { return ${$_[0]} =~ /^S/; }	# XXX Work on this
sub arrayp { return ${$_[0]} =~ /^P/; }
# sub mappingp { return ${$_[0]} =~ /^M/; }	# Not quite yet used
sub mappingp { return ${$_[0]} eq 'm'; }	# Not quite yet used

	# Deprecate?
sub pointer {
	my ($self, $stars) = @_;	# $type is a Type
	$stars or $stars = 1;
	my $type = ("P" x $stars) . $$self;
	return bless \$type, ref($self);
}

sub array {
	my ($self) = @_;
	my $type = "P" . $$self;
	return bless \$type, ref($self);
}

sub mapping {
	my ($self) = @_;
	return T_MAPPING;

	# XXX Not yet used
	my $type = "M" . $$self;
	return bless \$type, ref($self);
}

sub deref {
	my ($self) = @_;
	my $class = __PACKAGE__;

	if ($$self eq '_') {
		my $out = "_";
		return bless \$out, $class;
	}
	elsif ($$self eq 's') {
		return T_INTEGER;
	}
	elsif ($$self =~ /^P/) {
		my $out = substr($$self, 1);
		# print "Array deref $$self to $out : $class\n";
		return bless \$out, $class;
	}
	confess "Can't deref type $$self";
}

sub dump { return ${$_[0]}; }

1;
