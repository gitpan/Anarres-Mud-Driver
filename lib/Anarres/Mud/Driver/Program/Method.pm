package Anarres::Mud::Driver::Program::Method;

use strict;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS);
# use overload '""' => sub { "AMD::Method(" . $_[0]->name . ")" };
use Data::Dumper;
use Carp qw(cluck);
use Anarres::Mud::Driver::Program::Variable;

@ISA = qw(Anarres::Mud::Driver::Program::Variable);
@EXPORT_OK = qw(M_NOMASK M_NOSAVE
				M_PRIVATE M_PROTECTED M_PUBLIC
				M_VARARGS
				M_EFUN M_INHERITED M_PURE);
%EXPORT_TAGS = (
		flags	=> \@EXPORT_OK,
		all		=> \@EXPORT_OK,
			);

	# Some of these belong to the function, some belong to the program
	# in which it is declared. All except 'inherited' can be attached
	# to the function. (or variable)
sub M_NOMASK	() { 0x001 } 
sub M_NOSAVE	() { 0x002 } 
sub M_PRIVATE	() { 0x004 } 
sub M_PROTECTED	() { 0x008 } 
sub M_PUBLIC	() { 0x010 } 

sub M_VARARGS	() { 0x020 } 

sub M_EFUN		() { 0x100 } 
sub M_INHERITED	() { 0x200 } 
sub M_APPLY		() { 0x400 } 
sub M_PURE		() { 0x800 } 

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
	# print $self->dump, "\n";

	# Start adding locals, etc, etc.

	$program->reset_labels;
	$program->save_locals;
	foreach (@{ $self->args }) {
		$program->local($_);
	}
	my $code = $self->code;
	if ($code) {
		$code->typecheck($program, @rest);
	}
	else {
		$program->error("No code in method " . $self->name);
	}
	$program->restore_locals;
	print $self->dump, "\n";
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
	# XXX Generate warning if no return from nonvoid function.
	my $tail = "\n\treturn undef;\n}\n";

	my @args = map { ', $' . $_->name } @{ $self->args };
	my $args = "\t" . 'my ($self' . join('', @args) . ') = @_;' .
					"\n\t";

	return $head . $args . $self->code->generate($indent, @_) . $tail;
}

	# This has a weird prototype for a typecheck method.
sub typecheck_call {
	my ($self, $program, $values, @rest) = @_;

	my $i = 1;
	foreach (@{ $self->args }) {
		my $val = $values->[$i];
		# print "Matching arg against " . $_->dump . "\n";
		my $arg = $val->infer($_->type);
		if (! $arg) {
			$program->error("Argument " . ($i + 1) . " to " .
							$self->name .
							" is type " . ${ $val->type } .
							" not type " . ${ $_->type });
		}
		elsif ($arg != $val) {
			$arg->typecheck($program, undef, @rest);
			$values->[$i] = $arg;
		}
		# print "OK\n";
	}
	continue {
		$i++;
	}

#		print "Funcall " . $method->name . " checked and becomes type "
#						. ${$method->type} . "\n" if 0;
	return $self->type;
}

sub generate_call {
	my ($self, @args) = @_;
	return '$self->' . $self->name . "(" . join(", ", @args) . ")";
}

1;
