package Anarres::Mud::Driver::Program;

use strict;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS %PROGS);
use Exporter;
use Carp qw(:DEFAULT cluck);
use Data::Dumper;
use File::Basename;
use String::Escape qw(quote printable);
use Anarres::Mud::Driver::Program::Method qw(:flags);
use Anarres::Mud::Driver::Program::Efun qw(efuns efunflags);

@ISA = qw(Exporter);
@EXPORT_OK = (qw(package_to_path path_to_package));
%EXPORT_TAGS = (
	all	=> \@EXPORT_OK,
		);

%PROGS = (
	"/foo/bar"	=> new Anarres::Mud::Driver::Program(Path=>"/foo/bar"),
		);

# Class methods

sub new {
	my $class = shift;
	my $self = ($#_ == 0) ? { %{ (shift) } } : { @_ };

	confess "No Path in program" unless $self->{Path};

	$self->{Inherits} = { };
	$self->{Globals} = { };
	$self->{Locals} = { };
	$self->{Labels} = { };
	$self->{LabelDefault} = undef;
	$self->{Methods} = efuns;
	$self->{MethodFlags} = efunflags;

	$self->{ScopeStack} = [ ];
	$self->{LabelStack} = [ ];

	$self->{Warnings} = [ ];
	$self->{Errors} = [ ];

	$self->{Label} = 0;

	$self->{Closures} = [ ];

	return bless $self, $class;
}

sub find {	# find Anarres::Mud::Driver::Program $path
	return $PROGS{$_[1]};
}

sub path_to_package {
	my $path = shift;
	$path =~ s,/,::,g;
	$path =~ s/\.c$//;
	return "Anarres::Mud::Library" . $path;
}

sub package_to_path {
	my $package = shift;
	die "package_to_path: Invalid package name"
			unless $package =~ s/^Anarres::Mud::Library//;
	$package =~ s,::,/,g;
	return $package;
}

# Debugging methods

sub warning {
	my $self = shift;
	print "WARNING: $_\n" foreach @_;
	push(@{ $self->{Warnings} }, @_);
}

sub error {
	my $self = shift;
	print "ERROR: $_\n" foreach @_;
	push(@{ $self->{Errors} }, @_);
}

# Instance query methods

sub path { return $_[0]->{Path}; }
sub source { return $_[0]->{Source}; }
sub ppsource { return $_[0]->{PPSource}; }
sub package { return path_to_package $_[0]->{Path}; }

sub methods	{ return values %{ $_[0]->{Methods} }; }
# sub locals	{ return values %{ $_[0]->{Globals} }; }
sub globals	{ return values %{ $_[0]->{Globals} }; }

sub variable {
	my ($self, $name) = @_;
	return $self->{Locals}->{$name}
		|| $self->{Globals}->{$name}
		|| undef;
}

# Instance modification methods

sub closure {
	my ($self, $clousure) = @_;
	return (push(@{ $self->{Closures} }, $clousure) - 1);
}

sub reset_labels {
	my $self = shift;
	# invoke for new method?
	die "Label stack not empty" if @{ $self->{LabelStack} };
	$self->{LabelDefault} = undef;
	$self->{Labels} = { };
	$self->{EndSwitch} = undef;
	$self->{LabelStack} = [ ];
}

sub save_labels {
	my $self = shift;
	push(@{$self->{LabelStack}},
			[
				$self->{Labels},
				$self->{LabelDefault},
				$self->{EndSwitch},
			]);
	$self->{LabelDefault} = undef;
	$self->{Labels} = { };
	$self->{EndSwitch} = $self->label(undef);
	print "Push labels: " . scalar(@{ $self->{LabelStack} }) . "\n";
	return $self->{EndSwitch};
}

sub restore_labels {
	my $self = shift;
	my $ret = [ $self->{Labels}, $self->{LabelDefault} ];
	my ($labels, $default, $endswitch) =
					@{ pop(@{ $self->{LabelStack} }) };
	$self->{Labels} = { %{$self->{Labels}}, %$labels, };
	$self->{LabelDefault} ||= $default;
	$self->{EndSwitch} = $endswitch;
	print "Pop labels: " . scalar(@{ $self->{LabelStack} }) . "\n";
	return $ret;
}

sub label {
	my ($self, $val) = @_;
	my $label = '__AMD_LABEL' . $self->{Label}++;
	if (defined $val) {
		# print "Adding label $val => $label\n";
		$self->{Labels}->{$label} = $val
	}
	return $label;
}

sub default {
	my $self = shift;
	return ($self->{LabelDefault} = $self->label(undef));
}

# XXX This should return something else if we're in a loop.
sub getbreaktarget {
	$_[0]->{EndSwitch};
}

sub save_locals {
	my $self = shift;
	my %saved = %{ $self->{Locals} };
	push(@{$self->{ScopeStack}}, \%saved);
}

sub restore_locals {
	my $self = shift;
	$self->{Locals} = pop(@{ $self->{ScopeStack} });
}

	# XXX Check that we don't declare a variable of type void.

sub local {
	my ($self, $var) = @_;

	return $self->{Locals}->{$var} unless ref($var);

	my $name = $var->name;

	$self->warning("Local $name masks previous definition")
			if $self->{Locals}->{$name};

	# print "Storing local variable " . $var->dump . "\n";

	$self->{Locals}->{$name} = $var;

	return ();
}

sub global {
	my ($self, $var, $mods) = @_;

	return $self->{Globals}->{$var} unless ref($var);

	my $name = $var->name;

	$self->error("Global $name masks previous definition in file XXX")
			if $self->{Globals}->{$name};

	# print "Storing variable $name\n";

	$self->{Globals}->{$name} = $var;

	return ();
}

sub method {
	my ($self, $method, $mods) = @_;

	unless (ref $method) {
		$method =~ s/^.*:://;	# XXX Remove and do properly.
		my $ob = $self->{Methods}->{$method};
		die "Method $method not found" unless $ob;
		return $ob;
	}

	my $name = $method->name;

	return "Method $name already exists"
			if $self->{Methods}->{$name};

	# XXX Check prototype match with superclass
	# XXX Check sanity of modifiers

	$self->{Methods}->{$name} = $method;
	$self->{MethodFlags}->{$name} = $mods;

	return ();
}

sub inherit {
	my ($self, $path) = @_;

	my $inh = $PROGS{$path};
	return "Could not find inherited program $_" unless $inh;

	my $name = basename($path, ".c");
	return "Already inheriting file named $name"
					if $self->{Inherits}->{$path};

	$self->{Inherits}->{$name} = $inh;

	my @errors;

	foreach ($inh->globals) {
		my $err = $self->global($_);
		push(@errors, $err), next if $err;
		# Variable flags? Accessibility.
	}

	foreach ($inh->methods) {
		my $err = $self->method($_);	# Check if efun
		push(@errors, $err), next if $err;
		$self->{MethodFlags}->{$_->name} =
				$inh->{MethodFlags}->{$_->name} | M_INHERITED;
	}

	return @errors;
}

# Debugging

sub dump {
	my ($self) = @_;

	my @inh = map { "(inherit " .
					quote(printable $_) . " " .
					quote(printable $self->{Inherits}->{$_}->path)
					. ")" }
					keys %{$self->{Inherits}};
	my @glob = sort map { $_->dump(1) } values %{$self->{Globals}};
	my @meth = sort
			map { $self->{Methods}->{$_}->dump(1) }
				grep { ! ($self->{MethodFlags}->{$_} & M_EFUN) }
					keys %{$self->{Methods}};

	my $out = "(program\n\t" . join("\n\t", @inh, @glob, @meth) . "\n)";

	return $out;
}

# Semantics

sub typecheck {
	my $self = shift;

	my @meth = grep { ! ($self->{MethodFlags}->{$_} & M_EFUN) }
					keys %{$self->{Methods}};

	my $ret = 1;
	foreach (@meth) {
		$ret &&= $self->{Methods}->{$_}->typecheck($self, 0);
	}

	return $ret;
}

# Output

sub generate {
	my ($self, $path) = @_;

	my $package = $self->package;
	my $head = << "EOH";
# Program $path
package $package;
use strict;
	# XXX Put closures, goto tables, etc in?
EOH

	my @vars = qw($PROGRAM);
	my $base;

	if (scalar %{ $self->{Inherits} }) {
		my $inh = join " ",
				map { $_->package }
						values %{ $self->{Inherits} };
		push(@vars, qw(@ISA));
		$base = << "EOI";

\@ISA = qw($inh);
EOI

	}
	else {
		$base = << "EON";

sub new {
	my \$class = shift;
	my \$self = { };
	return bless \$self, \$class;
}
EON
	}

	$head .= 'use vars qw(' . join(" ", @vars) . ");\n";
	# XXX $path forms part of a Perl program. Beware.
	$head .= '*PROGRAM = \$' . __PACKAGE__ . "::PROGS{'$path'};\n";

	# These have a very large extent.
	local *::methods = $self->{Methods};
	local *::methodflags = $self->{MethodFlags};

	my @meth = map { $::methods{$_}->generate(0, $path) }
				grep { ! ($::methodflags{$_} & M_EFUN) }
					keys %::methods;

	my $tail = "\n1;\n";

	return $head . $base . join("\n\n", @meth) . $tail;
}

1;
