package Anarres::Mud::Driver::Program::Method;

use strict;
use vars qw(@ISA @EXPORT_OK);
use Data::Dumper;
use Carp qw(cluck);
use Anarres::Mud::Driver::Compiler::Lex qw(%TYPETAB);
use Anarres::Mud::Driver::Program::Variable;

@ISA = qw(Anarres::Mud::Driver::Program::Variable);

#sub new {
#	my $class = shift;
#	my $self = $class->SUPER::new(@_);
#	return $self;
#}

sub args { return $_[0]->{Args}; }

# Code is added later in the parser (was?)
sub code {
	my ($self, $code) = @_;
	# cluck "Add code $code to method $self->{Name}\n" if $code;
	if (defined $code) {
		$self->{Code} = $code;
		# print Dumper($code);
	}
	return $self->{Code};
}

sub typecheck {
	my ($self, $program, @rest) = @_;
	print "Typechecking method " . $self->name . " (top level)\n";
	print $self->dump, "\n";

	# Start adding locals, etc, etc.

	$program->reset_labels;
	$program->save_locals;
	$program->locals($self->args);
	my $code = $self->code;
	if ($code) {
		$code->typecheck($program, @rest);
	}
	else {
		$program->error("No code in method " . $self->name);
	}
	$program->restore_locals;
	# print $self->dump, "\n";
}

sub dump {
	my $self = shift;
	my $indent = shift;
	$indent++;

	my $sep = "\n" . ("\t" x $indent);

	my $out = "([" . $self->type->dump(@_) . "] method " . $self->name;
	my $args = join("", map { " " . $_->dump($indent, @_) } @{$self->args});
	my $code = ! $self->code				? "(nocode)"
			: ref($self->code) !~ /::/		? ref($self->code)
			: $self->code->dump($indent, @_)
		;

	$out  = $out .
		$sep . "(args" . $args . ")" .
		$sep . $code . ")";

	return $out;
}

sub gencall {
	my ($self, @args) = @_;
	return '$self->' . $self->name . "(" . join(", ", @args) . ")";
}

	# This should generate Perl code for the method
sub generate {
	my $self = shift;
	my $indent = shift;
	$indent++;

	return "\n\n# No code in " . $self->name . "\n\n\n"
					unless $self->code;

	my $proto = '$' . ('$' x @{$self->args});
	my $rtproto = join("", map { ${ $_->type } } @{ $self->args });
	my $head =
		"\n# method " . $self->name . " proto " . $rtproto . "\n" .
		"sub " . $self->name . " ($proto) {\n";
	my $tail = "\n}\n";

	my @args = map { ', $' . $_->name } @{ $self->args };
	my $args = "\t" . 'my ($self' . join('', @args) . ') = @_;' .
					"\n\t";

	return $head . $args . $self->code->generate($indent, @_) . $tail;
}

1;
