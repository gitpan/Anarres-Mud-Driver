package Anarres::Mud::Driver::Compiler::Check;

use strict;
use vars qw(@ISA @EXPORT_OK %OPTYPETABLE %NEWOPTYPETABLE %OPCHECKTABLE);
use Carp qw(:DEFAULT cluck);
use Data::Dumper;
use Anarres::Mud::Driver::Compiler::Type;
use Anarres::Mud::Driver::Compiler::Node qw(:all);

push(@Anarres::Mud::Driver::Compiler::Node::ISA, __PACKAGE__);

%NEWOPTYPETABLE = (
	StmtNull	=> [								   T_VOID ],

	Unot		=> [ T_UNKNOWN						=> T_BOOL ],
	Tilde		=> [ T_INTEGER						=> T_INTEGER ],
	Plus		=> [ T_INTEGER						=> T_INTEGER ],
	Minus		=> [ T_INTEGER						=> T_INTEGER ],

	IntLsh		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntRsh		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntAdd		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntSub		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntMul		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntDiv		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntMod		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],

	IntAnd		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntOr		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],
	IntXor		=> [ T_INTEGER, T_INTEGER			=> T_INTEGER ],

	IntEq		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],
	IntNe		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],
	IntGe		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],
	IntLe		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],
	IntGt		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],
	IntLt		=> [ T_INTEGER, T_INTEGER			=> T_BOOL ],


	StrAdd		=> [ T_STRING, T_STRING				=> T_STRING ],
	StrMul		=> [ T_STRING, T_STRING				=> T_STRING ],

	StrEq		=> [ T_STRING, T_STRING				=> T_BOOL ],
	StrNe		=> [ T_STRING, T_STRING				=> T_BOOL ],
	StrGe		=> [ T_STRING, T_STRING				=> T_BOOL ],
	StrLe		=> [ T_STRING, T_STRING				=> T_BOOL ],
	StrGt		=> [ T_STRING, T_STRING				=> T_BOOL ],
	StrLt		=> [ T_STRING, T_STRING				=> T_BOOL ],

	StmtExp		=> [ T_UNKNOWN						=> T_VOID  ],
	StmtRlimits => [ T_INTEGER, T_INTEGER, T_VOID	=> T_VOID ],
	StmtCatch	=> [ T_VOID							=> T_VOID ],

		# Sub?
	StmtIfElse	=> [ T_BOOL, T_VOID, T_VOID			=> T_VOID ],
	StmtIf		=> [ T_BOOL, T_VOID					=> T_VOID ],

	StmtBreak	=> [								   T_VOID ],
	StmtContinue=> [								   T_VOID ],
);

# nodepackage, rettype, arg0type, arg1type, ...
%OPTYPETABLE = (
	# Postinc Postdec Preinc Predec

	StmtNull	=> [[ 'StmtNull', T_VOID, ], ],

	# IntAssert StrAssert ArrAssert MapAssert ClsAssert ObjAssert
	IntAssert	=> [['IntAssert', T_INTEGER, T_UNKNOWN ], ],
	StrAssert	=> [['StrAssert', T_STRING, T_UNKNOWN ], ],
	ArrAssert	=> [['ArrAssert', T_ARRAY, T_UNKNOWN ], ],
	MapAssert	=> [['MapAssert', T_MAPPING, T_UNKNOWN ], ],
	ClsAssert	=> [['ClsAssert', T_CLOSURE, T_UNKNOWN ], ],
	ObjAssert	=> [['ObjAssert', T_OBJECT, T_UNKNOWN ], ],

	# Nil		=> [[ 'Nil', T_NIL, ], ],
	# String	=> [[ 'String', T_STRING, ], ],
	# Integer	=> [[ 'Integer', T_INTEGER, ], ],
	# Array		=> [[ 'Array', T_ARRAY, ], ],				# sub()?
	# Mapping	=> [[ 'Mapping', T_MAPPING, ], ],			# sub()?
	# Closure	=> [[ 'Closure', T_MAPPING, ], ],

						# promote argument to bool by sub?
	Unot	=> [[ 'Unot',  T_BOOL,    T_UNKNOWN, ], ],
	Tilde	=> [[ 'Tilde', T_INTEGER, T_INTEGER, ], ],
	Plus	=> [[ 'Plus',  T_INTEGER, T_INTEGER, ], ],
	Minus	=> [[ 'Minus', T_INTEGER, T_INTEGER, ], ],

	Lsh		=> [[ 'IntLsh', T_INTEGER, T_INTEGER, T_INTEGER, ], ],
	Rsh		=> [[ 'IntRsh', T_INTEGER, T_INTEGER, T_INTEGER, ], ],

	Add		=> [[ 'IntAdd', T_INTEGER, T_INTEGER, T_INTEGER ],
				[ 'StrAdd', T_STRING, T_STRING, T_STRING ],
						# retval becomes sub
				[ 'ArrAdd', T_ARRAY, T_ARRAY, T_ARRAY ],	# sub()?
				[ 'MapAdd', T_MAPPING, T_MAPPING, T_MAPPING ],
				],
	Sub		=> [[ 'IntSub', T_INTEGER, T_INTEGER, T_INTEGER ],
						# retval becomes sub
				[ 'ArrSub', T_ARRAY, T_ARRAY, T_ARRAY ],	# sub()?
				],
	Mul		=> [[ 'IntMul', T_INTEGER, T_INTEGER, T_INTEGER ],
				[ 'StrMul', T_STRING, T_STRING, T_INTEGER ],
				],
	Div		=> [[ 'IntDiv', T_INTEGER, T_INTEGER, T_INTEGER ], ],
	Mod		=> [[ 'IntMod', T_INTEGER, T_INTEGER, T_INTEGER ], ],

	Eq		=> [[ 'IntEq', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrEq', T_BOOL, T_STRING, T_STRING ],
				[ 'IntEq', T_BOOL, T_UNKNOWN, T_UNKNOWN ],	# sub()?
				],
	Ne		=> [[ 'IntNe', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrNe', T_BOOL, T_STRING, T_STRING ],
				[ 'IntNe', T_BOOL, T_UNKNOWN, T_UNKNOWN ],	# sub()?
				],
	Lt		=> [[ 'IntLt', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrLt', T_BOOL, T_STRING, T_STRING ],
				],
	Gt		=> [[ 'IntGt', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrGt', T_BOOL, T_STRING, T_STRING ],
				],
	Le		=> [[ 'IntLe', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrLe', T_BOOL, T_STRING, T_STRING ],
				],
	Ge		=> [[ 'IntGe', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrGe', T_BOOL, T_STRING, T_STRING ],
				],

	Or		=> [[ 'IntOr', T_INTEGER, T_INTEGER, T_INTEGER ],
				[ 'ArrUnion', T_ARRAY, T_ARRAY, T_ARRAY ],	# sub()?
				],
	And		=> [[ 'IntAnd', T_INTEGER, T_INTEGER, T_INTEGER ],
				[ 'ArrIsect', T_ARRAY, T_ARRAY, T_ARRAY ],	# sub()?
				],
	Xor		=> [[ 'IntXor', T_INTEGER, T_INTEGER, T_INTEGER ],
				],

#	Index	=> [[ 'StrIndex', T_INTEGER, T_STRING, T_INTEGER ],
#					# XXX The next two are to be removed.
#				# [ 'ArrIndex', T_INTEGER, T_INTEGER->pointer, T_INTEGER ],# sub()?
#				# [ 'ArrIndex', T_STRING, T_STRING->pointer, T_INTEGER ],# sub()?
#				[ 'ArrIndex', T_UNKNOWN, T_ARRAY, T_INTEGER ],# sub()?
#				[ 'MapIndex', T_UNKNOWN, T_MAPPING, T_STRING ],# sub()?
#				[ 'MapIndex', T_UNKNOWN, T_MAPPING, T_OBJECT ],# sub()?
#				],
#	Range	=> [[ 'StrRange', T_STRING, T_STRING, T_INTEGER, T_INTEGER],
#				[ 'ArrRange', T_ARRAY, T_ARRAY, T_INTEGER, T_INTEGER ],
#															# sub()?
#				],

	Catch	=> [[ 'Catch', T_STRING, T_UNKNOWN, ], ],

	LogOr	=> [[ 'LogOr', T_UNKNOWN, T_UNKNOWN, T_UNKNOWN ], ],	# sub()?
	LogAnd	=> [[ 'LogAnd', T_UNKNOWN, T_UNKNOWN, T_UNKNOWN ], ],	# sub()?

	ExpCond	=> [[ 'ExpCond', T_UNKNOWN, T_BOOL, T_UNKNOWN, T_UNKNOWN ], ],
															# sub()?

	StmtExp	=> [[ 'StmtExp', T_VOID, T_UNKNOWN ], ],
	# StmtDo	=> [[ 'StmtDo', T_VOID, T_BOOL, T_VOID ], ],
	# StmtForeach	# sub - lvalue
	StmtRlimits		# Require the ints to be constant?
			=> [[ 'StmtRlimits', T_VOID, T_INTEGER, T_INTEGER, T_VOID ],
				],
	# StmtTry		# sub - lvalue
	StmtCatch=>[[ 'StmtCatch', T_VOID, T_VOID ]],
	StmtIf	=> [[ 'StmtIf', T_VOID, T_BOOL, T_VOID, T_VOID ],
				[ 'StmtIf', T_VOID, T_BOOL, T_VOID ],
				],

	StmtBreak	=> [[ 'StmtBreak', T_VOID ], ],
	StmtContinue=> [[ 'StmtContinue', T_VOID ], ],
#	StmtReturn	=> [[ 'StmtReturn', T_VOID, T_UNKNOWN ], ],	# XXX sub()

	# Most of these node types are generated by the check
	# process, rather than being input to it.

	map { $_ => 'NOCHECK' } qw(
				IntAdd IntSub IntMul IntDiv IntMod
				IntLsh IntRsh
				IntEq IntNe IntLt IntGt IntLe IntGe
				IntOr IntAnd IntXor

				IntAddEq IntSubEq IntMulEq IntDivEq IntModEq
				IntAndEq IntOrEq IntXorEq
				IntLshEq IntRshEq

				StrAdd        StrMul
				StrEq StrNe StrLt StrGt StrLe StrGe
				StrIndex StrRange

				ArrAdd ArrSub
				ArrEq ArrNe
				ArrUnion ArrIsect
				ArrIndex ArrRange
				
				MapAdd
				MapEq MapNe
				MapIndex

				VarStatic VarGlobal VarLocal
					),
		);

%OPCHECKTABLE = (
	Integer		=> {
			Const	=> "1",		# *const = eval qq{ sub { $_ }; };
				},
);

# print Dumper(\%OPTYPETABLE);

q[
	# All of these need appropriate check methods.
		StmtDo StmtWhile StmtFor StmtForeach
		StmtRlimits StmtTry StmtCatch
		StmtIf StmtSwitch StmtCase StmtDefault
		StmtBreak StmtContinue StmtReturn
] if 0;

sub lvaluep { undef; }
sub constp { undef; }

sub promote_to_block {
	my ($self, $index) = @_;
	my $stmt = $self->value($index);

	return if ref($stmt) =~ /::Block$/;
	confess "Can only convert statements into blocks, not $stmt"
					unless ref($stmt) =~ /::Stmt\w+$/;

	# It's a statement.
	my $block = new Anarres::Mud::Driver::Compiler::Node::Block(
					[],	# locals
					[ $stmt ]);
	$self->setvalue($index, $block);
}

sub convert {
	my ($self, $opcode) = @_;

	$self->debug(DBG_TC_NAME, "Attempt convert " . $self->nodetype .
					" to " . $opcode);

	my @values = $self->values;
	my @template = @{ $NEWOPTYPETABLE{$opcode} };
	my $rettype = pop(@template);

	return undef unless @values == @template;

	my $i = 0;
	my @tvals = ();
	foreach my $type (@template) {
		my $val = $values[$i];
		# XXX I should promote unknown to anything via assert, not
		# assert directly in convert.
		if ($val->type->equals(T_UNKNOWN)) {
			push(@tvals, $val->assert($type));
			next;
		}
		my $tval = $val->promote($type);
		return undef unless $tval;
		push(@tvals, $tval);
	}

	# Hack the node gratuitously.
	splice(@$self, 2, $#$self, @tvals);
	$self->settype($rettype);

	# We might also have a package change.
	my $package = ref($self);
	$package =~ s/::[^:]*$/::$opcode/;
	bless $self, $package;

	return $self;
}

sub assert {	# This sucks somewhat
	my ($self, $type) = @_;
	if (!$self->type->equals(T_UNKNOWN)) {	# DEBUGGING
		confess "Asserting something of known type.";
	}
	print "Asserting " . $self->nodetype . " into " . ${$type} . "\n";
	return $self;

# XXX Removed until new type system online.
#	return new Anarres::Mud::Driver::Program::Node::IntAssert($self)
#					if $type->equals(T_INTEGER);
#	return new Anarres::Mud::Driver::Program::Node::StrAssert($self)
#					if $type->equals(T_STRING);
#	return new Anarres::Mud::Driver::Program::Node::ArrAssert($self)
#					if $type->arrayp;
#	return new Anarres::Mud::Driver::Program::Node::MapAssert($self)
#					if $type->mappingp;
#	return new Anarres::Mud::Driver::Program::Node::ClsAssert($self)
#					if $type->equals(T_CLOSURE);
#	return new Anarres::Mud::Driver::Program::Node::ObjAssert($self)
#					if $type->equals(T_OBJECT);
#	if ($type->equals(T_MIXED)) {
#		print "Warning: Asserting node into type mixed!\n";
#		print $self->dump, "\n";
#		return $self;
#	}
	croak "Cannot assert node into type " . $$type . "!\n";
	return undef;
}

# By default, statements are assumed void.
sub promote {
	my ($self, $newtype) = @_;

	if (ref($self) =~ /Stmt/) {	# DEBUGGING
		return $_[0] if $_[1]->equals(T_VOID);
		# This presumably never happens unless we fuck up in templates.
		print "$_[0] Infers only as void, not " . $$newtype . "\n";
		return undef;
	}
	{	# DEBUGGING
		my $type = $self->type;
		unless ($type) {
			warn "No type in " . $self->nodetype . "\n";
		}
		if (ref($type) !~ /::Type$/) {
			print "Invalid type in " . $self->dump . "\n";
		}
	}
	my $node = $self->type->promote($self, $newtype);
	# print "Node is $node\n" if $node;
	# XXX Typecheck the node here if possible... or just settype it.
	return $node;
}

sub check_fail {
	my ($self, $type) = @_;
	$type = T_FAILED unless $type;
	$self->settype($type);
	return undef;
}

sub check_children {
	my ($self, $vals, $program, @rest) = @_;

	my $ctr = 0;
	my @failed = ();

	foreach (@$vals) {
		next unless $_;		# We get 'undef' statements sometimes.

		unless (ref($_) =~ /::/) {
			print "Cannot typecheck $_ in " . $self->nodetype . "\n";
			next;
		}

		# print "Typecheck child " . $_->dump . "\n";
		push(@failed, $ctr) unless $_->check($program, @rest);
	}
	continue {
		$ctr++;
	}

	if (@failed) {
		$program->error("Failed to typecheck children @failed of " .
						$self->nodetype . ": " .
					join(", ", map { $vals->[$_]->nodetype } @failed));
		return undef;
	}

	return 1;
}

# We have to override this in things like function nodes, I think.
# The principle is that we have a complete parse tree...
sub check {
	my ($self, $program, @rest) = @_;

	if ($self->type) {
		# This might happen if we have aliasing in the parse tree.
		# This should not happen.
		warn "Node " . $self->nodetype . " already has type: $self";
		return 1;
	}

	$self->debug(DBG_TC_NAME, "Auto typechecking " . $self->nodetype);

	my $op = $self->nodetype;
	my @values = $self->values;

	$self->check_children(\@values, $program, @rest)
					or return $self->check_fail;

	my %cache = ();	# A checked node cache.

	# print "Checking with " . scalar(@values) . " values\n";

OPTYPE:
	foreach (@{ $OPTYPETABLE{$op} }) {
		if (ref($_) eq 'ARRAY') {
			my ($pack, $rettype, @argtypes) = @{$_};
#			print "Template $op -> $pack (" .
#							join(", ", map{$$_}@argtypes) . ")\n";
			next unless @argtypes == @values;

			my $i = 0;
			my @tvals = ();
			foreach my $type (@argtypes) {
				next unless defined $type;	# Ability to ignore a child

				my $arg = $values[$i];
				unless ($arg) {
					$program->error("Missing argument $i in " .
									$self->nodetype);
					next OPTYPE;
				}
				# print "Inferring " . $arg->nodetype . " to $$type\n";
				$cache{$i . $$type} ||= $arg->promote($type);
				next OPTYPE unless $cache{$i . $$type};
				push(@tvals, $cache{$i . $$type});
			}
			continue {
				$i++;
			}

			# If we get here, we succeeded. Hack the node gratuitously.
			splice(@$self, 2, $#$self, @tvals);
			$self->settype($rettype);
			my $package = ref($self);
			$package =~ s/::[^:]*$/::$pack/;
			bless $self, $package;

			return 1;
		}
		elsif (ref($_) eq 'CODE') {
			if ($_->($self, \@values, \%cache)) {
				return 1;
			}
		}
		elsif ($_ eq 'NOCHECK') {
			confess "check subroutine called on " . $self->nodetype;
		}
	}

	# If we get here, we failed. Be verbose.

	my @templates = ();
	foreach (@{ $OPTYPETABLE{$op} }) {
		my (undef, undef, @argtypes) = @{$_};
		my $template = join(", ", map { ${ $_ } } @argtypes);
		push(@templates, "$op($template)");
	}

	my @names = map { $_->type ? ${$_->type} : ${&T_FAILED} } @values;

	$program->error("Failed to find a suitable type template for $op(" .
			join(", ", @names) .
			"). Available templates are " . join(", ", @templates) .
			" in\n" . $self->dump);
	return $self->check_fail;
}
# End of 'sub check'

# Now the node-specific packages.

{
	package Anarres::Mud::Driver::Compiler::Node::Nil;
	sub check { $_[0]->settype(T_NIL); $_[0]->setflag(F_CONST); 1; }
}

{
	package Anarres::Mud::Driver::Compiler::Node::String;
	sub check {$_[0]->settype(T_STRING); $_[0]->setflag(F_CONST); 1;}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Integer;
	sub check {$_[0]->settype(T_INTEGER); $_[0]->setflag(F_CONST); 1;}
	sub promote {
		my ($self, $type, @rest) = @_;

		# Yes, a special case.
		if ($self->value(0) == 0) {	# A valid nil
			unless ($type->equals(T_INTEGER)) {
				return new Anarres::Mud::Driver::Compiler::Node::Nil;
			}
		}

		return $self->SUPER::promote($type, @rest);
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Array;
	sub check {
		my ($self, $program, @rest) = @_;

		my @values = $self->values;
		$self->check_children(\@values, $program, @rest)
						or return $self->check_fail;

		my $flag = F_CONST;
		my $type = T_NIL;
		foreach (@values) {
			# Search the types to find a good type.
			$type = $_->type->unify($type);
			$flag &= $_->flags;
		}

		$self->settype($type->array);
		$self->setflag($flag) if $flag;

		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Mapping;
	sub check {
		my ($self, $program, @rest) = @_;

		my @values = $self->values;
		$self->check_children(\@values, $program, @rest)
						or return $self->check_fail;

		my $ret = 1;

		my $flag = F_CONST;
		my $type = T_NIL;
		my $idx = 0;
		foreach (@values) {
			# Search the types to find a good type.
			if ($idx & 1) {
				$type = $_->type->unify($type);
			}
			else {
				my $key = $_->promote(T_STRING);
				if ($key) {
					$self->setvalue($idx, $key);
				}
				else {
					$program->error("Map keys must be strings, not " .
									$_->dump);
					$ret = undef;
				}
			}

			$flag &= $_->flags;
			$idx++;
		}

		$self->settype($type->mapping);
		$self->setflag($flag) if $flag;

		return $ret;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Closure;
	sub check {
		my ($self, $program, @rest) = @_;
		$self->setvalue(1, $program->closure($self));
		$self->settype(T_CLOSURE);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Variable;
	sub lvaluep { 1; }
	# Look up type
	sub check {
		my ($self, $program, @rest) = @_;
		my $name = $self->value(0);
		$self->debug(DBG_TC_NAME, "Typechecking Variable $name");
		my ($var, $class);
		if ($var = $program->local($name)) {
			$class = 'Anarres::Mud::Driver::Compiler::Node::VarLocal';
		}
		elsif ($var = $program->global($name)) {
			$class = 'Anarres::Mud::Driver::Compiler::Node::VarGlobal';
		}
		# elsif ($var = $program->static($name)) {
		#	$class ='Anarres::Mud::Driver::Compiler::Node::VarStatic';
		# }
		else {
			$program->error("Variable $name not found");
			# XXX We should fake something up because we end up
			# dying later?
			return $self->check_fail;
		}
		bless $self, $class;
		$self->settype($var->type);
		# print "Created variable: " . $self->dump . "\n";
		return 1;
	}
	# XXX As an rvalue? Delegate to a basic type infer method.
	# XXX If it's an rvalue then it must be initialised. Also for ++, --
}

{
	package Anarres::Mud::Driver::Compiler::Node::Parameter;
	sub lvaluep { 1; }
	# XXX We could look this up at the current point ...
	sub check { $_[0]->settype(T_UNKNOWN); return 1; }	# XXX Do this!
}

{
	package Anarres::Mud::Driver::Compiler::Node::Funcall;
	# Look up return type, number of args
	sub check {
		my ($self, $program, @rest) = @_;
		# Changing the format of this node will require modifications
		# to StmtIf optimisation.
		my @values = $self->values;
		my $method = shift @values;

		$self->debug(DBG_TC_NAME,
				"Typechecking Funcall to " . $method->name);

		# print Dumper($method);

		my @failed = ();
		my $ctr = 0;
		foreach (@values) {
			$_->check($program, @rest) or push(@failed, $ctr);
			$ctr++;
		}
		if (@failed) {
			$program->error("Failed to typecheck arguments @failed to "
							. $method->name);
			# XXX Wrong! Use the method's type. This should be some
			# sensible default in the case of overloads.
			return $self->check_fail(T_UNKNOWN);
		}

		unshift(@values, $method);
		my $type = $method->typecheck_call($program, \@values);

		return $self->check_fail unless $type;	# Should not happen

#		print "Funcall " . $method->name . " checked and becomes type "
#						. ${$type} . "\n" if 0;

		# We overwrite the method object in the first place too.
		my $i = 0;
		foreach (@values) {
			$self->setvalue($i++, $_);
		}
		$self->settype($type);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::CallOther;
	# XXX Look up return type?
	sub check {
		my ($self, $program, @rest) = @_;
		my ($exp, $name, @values) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking CallOther");
		unshift(@values, $exp);
		$self->check_children(\@values, $program, @rest)
						or return $self->check_fail;
		# XXX What if the lhs is type string?
		$self->settype(T_UNKNOWN);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Index;
	sub lvaluep {
		if ($_[0]->value(0)->lvaluep) {
			$_[0]->setflag(F_LVALUE);
			return 1;
		}
		return undef;
	}

	sub check {
		my ($self, $program, @rest) = @_;
		my ($exp, $idx, $ep) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking Index");
		my $values = [ $exp, $idx ];
		$self->check_children($values, $program, @rest)
						or return $self->check_fail;
		my $idx_i = $idx->promote(T_INTEGER);
		unless ($idx_i) {
			$program->error("Array index must be an integer, " .
							"not " . ${ $idx->type });
		}
		$self->setvalue(1, $idx_i);

		my $type = $exp->type;

		if ($type->equals(T_STRING)) {
			bless $self,
					"Anarres::Mud::Driver::Compiler::Node::StrIndex";
			$self->settype(T_INTEGER);
			return 1;
		}

		if ($type->is_array) {
			bless $self,
					"Anarres::Mud::Driver::Compiler::Node::ArrIndex";
			$self->settype($type->dereference);
			return 1;
		}

		if ($type->is_mapping) {
			bless $self,
					"Anarres::Mud::Driver::Compiler::Node::MapIndex";
			$self->settype($type->dereference);
			return 1;
		}

		$program->error("Expression on LHS of index must be " .
						"string, array or mapping not " .
						${ $exp->type });

		return $self->check_fail;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Range;
	sub check {
		my ($self, $program, @rest) = @_;
		my ($exp, $left, $right, $lendp, $rendp) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking Range");
		my $values = [ $exp, $left, $right ];
		$self->check_children($values, $program, @rest)
						or return $self->check_fail;

		my $left_i = $left->promote(T_INTEGER);
		my $right_i = $right->promote(T_INTEGER);

		unless ($left_i && $right_i) {
			$program->error("Endpoints of range must be integers, " .
							"not " . ${ $left->type } . " and " .
							${ $right->type });
		}

		my $exp_s = $exp->promote(T_STRING);
		if ($exp_s) {
			bless $self,
					"Anarres::Mud::Driver::Compiler::Node::StrRange";
			$self->setvalue(0, $exp_s);
			$self->settype($exp_s->type);
			return 1;
		}
		
		
		my $exp_a = $exp->promote(T_ARRAY);
		if ($exp_a) {
			bless $self,
					"Anarres::Mud::Driver::Compiler::Node::ArrRange";
			$self->setvalue(0, $exp_a);
			$self->settype($exp_a->type);
			return 1;
		}

		$program->error("Expression on LHS of range must be " .
						"string or array, not " . ${ $exp->type });

		return $self->check_fail;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Member;
	sub lvaluep {
		if ($_[0]->value(0)->lvaluep) {
			$_[0]->setflag(F_LVALUE);
			return 1;
		}
		return undef;
	}

	# XXX Do this!
	sub check {
		my ($self, $program, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking Member");
		my ($value, $field) = $self->values;
		$self->check_children([ $value ], $program, @rest)
						or return $self->check_fail;
		# my $type = $program->class_field_type(
		$self->settype(T_FAILED);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::New;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking New");
		my $cname = $self->value(0);
		my $type = $program->class_type($cname);
		$self->settype($type);	# Might be T_FAILED
		return 1;
	}
}

# 1. Promote things to blocks.
# 2. Check children
# 3. Check that things are lvalues.
# 4. Check that things are appropriate types.
# 5. Rebless the current node.
# 6. Set the type of the current node.
# 7. Return a success or failure.

{
	package Anarres::Mud::Driver::Compiler::Node::Sscanf;
	# This should be $_[1], @{$_[2]}
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($exp, $fmt, @values) = $self->values;
		$self->check_children(\@values, $program, $flags|F_LVALUE, @rest)
			&& $exp->check($program, $flags, @rest)
			&& $fmt->check($program, $flags, @rest)
						or return $self->check_fail;

		my $sexp = $exp->promote(T_STRING);
		unless ($sexp) {
			$program->error("Input for sscanf must be string, not " .
							${ $exp->type });
			return $self->check_fail;
		}
		$self->setvalue(0, $sexp);

		my $sfmt = $fmt->promote(T_STRING);
		unless ($sfmt) {
			$program->error("Format for sscanf must be string, not " .
							$fmt->type->dump);
			return $self->check_fail;
		}
		$self->setvalue(1, $sfmt);

		$self->settype(T_INTEGER);
		return 1;
	}
}

foreach ( qw(Postinc Postdec Preinc Predec) ) {
	my $n = lc $_;
	eval qq[
		{
			package Anarres::Mud::Driver::Compiler::Node::$_;
	] . q[
			sub check {
				my ($self, $program, $flags, @rest) = @_;
				my $val = $self->value(0);
				$val->check($program, $flags|F_LVALUE, @rest)
						or return $self->check_fail;
				my $ival = $val->promote(T_INTEGER);
				# We aren't allowed to replace the node with an rvalue
				# It might be an 'unknown' though - Perl semantics leak
				# into LPC if it's a pointer or string.
				unless ($ival == $val) {
					$program->error("Argument to unary operator must " .
									"be integer, not " .
									$val->type->dump);
					return $self->check_fail;
				}
				$self->settype(T_INTEGER);
				return 1;
			}
		}
	]; die $@ if $@;
}

{
	package Anarres::Mud::Driver::Compiler::Node::Assign;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($lval, $exp) = $self->values;

		$self->debug(DBG_TC_NAME, "Typechecking Assign");

		# XXX Work more on lvalues ...
		unless ($lval->check($program, $flags | F_LVALUE, @rest)) {
			$program->error("Failed to typecheck lvalue to assign");
			return $self->check_fail;
		}
		unless ($exp->check($program, $flags, @rest)) {
			$program->error("Failed to typecheck rvalue to assign");
			return $self->check_fail($lval->type);
		}

		my $rval = $exp->promote($lval->type);
		unless ($rval) {
			my $dump = $lval->dump;
			$dump =~ s/\s+/ /g;
			$program->error("Cannot assign type " .
							$exp->type->dump . " to lvalue " .
							$dump ." of type ". $lval->type->dump);
			# Assign always takes the type of the lvalue.
			return $self->check_fail($lval->type);
		}

		# Perhaps this ought to be the more specific of the two types.

		$self->setvalue(1, $rval);
		$self->settype($lval->type);

		return 1;
	}
}

# AddEq - string/string or int/int
{
	package Anarres::Mud::Driver::Compiler::Node::AddEq;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($lval, $rval) = $self->values;

		$self->debug(DBG_TC_NAME, "Typechecking AddEq");

		my $ret = 1;
		$lval->check($program, $flags | F_LVALUE, @rest)
						or $ret = undef;
		$rval->check($program, $flags, @rest)
						or $ret = undef;
		# XXX Do something with the types here.
		$self->settype($lval->type->unify($rval->type));
		return $ret;
	}
}

foreach (qw(SubEq MulEq DivEq ModEq XorEq LshEq RshEq)) {
	my $code = q[
		{
			package Anarres::Mud::Driver::Compiler::Node::] . $_ . q[;
			sub check {
				my ($self, $program, $flags, @rest) = @_;
				my ($lval, $rval) = $self->values;

				$self->debug(DBG_TC_NAME, "Typechecking ] . $_ . q[");

				my $ret = 1;
				$lval->check($program, $flags | F_LVALUE, @rest)
								or $ret = undef;
				unless ($lval->type->equals(T_INTEGER)) {
					$program->error("Operator ] . $_ . q[ can " .
									"only be applied to lvalues of " .
									"type int");
					$ret = undef;
				}
				$rval->check($program, $flags, @rest)
								or $ret = undef;
				my $rval = $rval->promote(T_INTEGER);
				$self->settype(T_INTEGER);
				return $ret;
			}
		}
	];
	eval $code;
	die $@ if $@;
}

# AndEq OrEq 	- arrays or ints
foreach (qw(AndEq OrEq)) {
	my $code = q[
		{
			package Anarres::Mud::Driver::Compiler::Node::] . $_ . q[;
			sub check {
				my ($self, $program, $flags, @rest) = @_;
				my ($lval, $rval) = $self->values;

				$self->debug(DBG_TC_NAME, "Typechecking ] . $_ . q[");

				my $ret = 1;
				$lval->check($program, $flags | F_LVALUE, @rest)
								or $ret = undef;
				$rval->check($program, $flags, @rest)
								or $ret = undef;
				# XXX Do something with the types here.
				$self->settype($lval->type->unify($rval->type));
				return $ret;
			}
		}
	];
	eval $code;
	die $@ if $@;
}


# StrAddEq		- string + string
{
	package Anarres::Mud::Driver::Compiler::Node::StrAddEq;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($lval, $rval) = $self->values;

		$self->debug(DBG_TC_NAME, "Typechecking StrAddEq");

		my $ret = 1;
		$lval->check($program, $flags | F_LVALUE, @rest)
						or $ret = undef;
		$rval->check($program, $flags, @rest)
						or $ret = undef;
		# XXX Do something with the types here.
		$self->settype($lval->type->unify($rval->type));
		return $ret;
	}
}

# StrMulEq		- string x integer
{
	package Anarres::Mud::Driver::Compiler::Node::StrMulEq;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($lval, $rval) = $self->values;

		$self->debug(DBG_TC_NAME, "Typechecking StrMulEq");

		my $ret = 1;
		$lval->check($program, $flags | F_LVALUE, @rest)
						or $ret = undef;
		$rval->check($program, $flags, @rest)
						or $ret = undef;
		# XXX Do something with the types here.
		$self->settype($lval->type->unify($rval->type));
		return $ret;
	}
}

foreach (qw(LogOrEq LogAndEq)) {
	my $code = q[
		{
			package Anarres::Mud::Driver::Compiler::Node::] . $_ . q[;
			sub check {
				my ($self, $program, $flags, @rest) = @_;
				my ($lval, $rval) = $self->values;

				$self->debug(DBG_TC_NAME, "Typechecking ] . $_ . q[");

				my $ret = 1;
				$lval->check($program, $flags | F_LVALUE, @rest)
								or $ret = undef;
				$rval->check($program, $flags, @rest)
								or $ret = undef;
				# XXX This isn't quite right because it's an
				# lvalue so we need to be more strict.
				$self->settype($lval->type->unify($rval->type));
				return $ret;
			}
		}
	];
	eval $code;
	die $@ if $@;
}

{
	package Anarres::Mud::Driver::Compiler::Node::ExpComma;
	sub check {
		my ($self, $program, @rest) = @_;
		my ($left, $right) = $self->values;

		$self->debug(DBG_TC_NAME, "Typechecking ExpComma");

		my $ret = 1;
		$left->check($program, @rest)
						or $ret = undef;
		$right->check($program, @rest)
						or return $self->check_fail(T_VOID);
		$self->settype($right->type);
		return undef;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::Block;
	sub check {
		my ($self, $program, @rest) = @_;
		my @locals = @{ $self->value(0) };
		my @stmts  = @{ $self->value(1) };

		$self->debug(DBG_TC_NAME, "Typechecking Block");

		$program->save_locals;
		foreach (@locals) {
			$program->local($_->name, $_);
		}
		my $succ = 0;
		foreach (@stmts) {
			$succ++ if $_->check($program, @rest);
		}
		$program->restore_locals;

		unless ($succ == @stmts) {
			return $self->check_fail(T_VOID);
		}

		$self->settype(T_VOID);

		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtForeach;
	# XXX This REALLY needs to split into
	# StmtForeachArr and StmtForeachMap
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my $ret;
		$self->debug(DBG_TC_NAME, "Typechecking StmtForeach");
		$self->promote_to_block(3);
		my ($lval0, $lval1, $arr, $block) = $self->values;
		$lval0->check($program, $flags|F_LVALUE, @rest)
						or $ret = undef;
		if ($lval1) {
			$lval1->check($program, $flags|F_LVALUE, @rest)
							or $ret = undef;
		}
		$self->check_children([ $arr, $block ], $program, $flags, @rest)
						or $ret = undef;
		# XXX Check that $arr->type->deref->equals($val->type)
		$_[0]->settype(T_VOID);
		return $ret;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtFor;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtFor");
		$self->promote_to_block(3);	# XXX Do this in a precheck?
		my @values = $self->values;
		$self->check_children(\@values, $program, $flags, @rest)
						or return $self->check_fail(T_VOID);
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtDo;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtDo");
		$self->promote_to_block(1);	# XXX Do this in a precheck?
		my @values = $self->values;
		$self->check_children(\@values, $program, $flags, @rest)
						or return $self->check_fail(T_VOID);
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtWhile;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtWhile");
		$self->promote_to_block(1);	# XXX Do this in a precheck?
		my @values = $self->values;
		$self->check_children(\@values, $program, $flags, @rest)
						or return $self->check_fail(T_VOID);
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtSwitch;
	sub check {
		my ($self, $program, @rest) = @_;
		my ($exp, $block) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking StmtSwitch");
		my $endswitch = $program->start_switch;
		$self->setvalue(2, $endswitch);		# end of switch
		my $ret = $self->check_children([$exp,$block], $program, @rest);
		# XXX Save the exp type in the program object switch stack.
		my $labels = $program->end_switch;
		$self->setvalue(3, $labels->[0]);	# labels
		$self->setvalue(4, $labels->[1]);	# default
		$self->settype(T_VOID);
		return $ret;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtCase;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		my ($left, $right) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking StmtCase");
		my $vals = $right ? [ $left, $right ] : [ $left ];
		$self->check_children($vals, $program, $flags|F_CONST, @rest)
						or return undef;
		# XXX Check that switch type matches case type.
		if ($right) {
			if (!$left->type->equals(T_INTEGER)) {
				$program->error("case X..Y endpoints must be integers.");
				return undef;
			}
			if (!$right->type->equals(T_INTEGER)) {
				$program->error("case X..Y endpoints must be integers.");
				return undef;
			}
			# And the rest ...
			# We must be able to evaluate these as constants.
			$self->setvalue(2, $program->label($left));
		}
		else {
			$self->setvalue(2, $program->label($left));
		}
		$self->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtDefault;
	sub check {
		my ($self, $program, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtDefault");
		$self->setvalue(0, $program->default);	# XXX do in postcheck?
		$self->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtBreak;
	sub check {
		my ($self, $program, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtBreak");
		$self->setvalue(0, $program->getbreaktarget);	# XXX postcheck?
		$self->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtIf;
	sub check {
		my ($self, $program, @rest) = @_;
		my $ret = 1;
		$self->promote_to_block(1);
		if ($self->value(2)) {
			unless (ref($self->value(2)) =~ /::StmtIf$/) {
				$self->promote_to_block(2);
			}
		}
		my ($cond, $if, $else) = $self->values;
		$self->debug(DBG_TC_NAME, "Typechecking StmtIf");
		$cond->check($program, @rest)
						or $ret = undef;

		# Now we inspect $cond and set hints. However, this is wrong
		# in the 'else' block!
		if (ref($cond) =~ /::Funcall$/) {
			my $method = $cond->value(0);
			my $name = $method->name;
			# intp, stringp, boolp, objectp, classp, arrayp, mapp
			if ($name =~ /(?:int|string|bool|object|class|array|map)p/){
				print "Hinting conditional: Call to $name\n";
			}
		}

		$if->check($program, @rest)
						or $ret = undef;

		if (defined $else) {
			# Reverse the hint

			$else->check($program, @rest)
							or $ret = undef;
		}

		$_[0]->settype(T_VOID);
		return $ret;	# Preserved from above;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtReturn;
	sub check {
		my ($self, $program, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtReturn");
		my $val = $self->value(0);
		if ($val) {
			$val->check($program, @rest)
							or return $self->check_fail(T_VOID);
		}
		$self->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Compiler::Node::StmtTry;
	sub check {
		my ($self, $program, $flags, @rest) = @_;
		$self->debug(DBG_TC_NAME, "Typechecking StmtTry");
		my ($try, $lval, $catch) = $self->values;
		my $vals = [ $try, $catch ];
		my $ret = 1;
		$self->check_children($vals, $program, $flags, @rest)
						or $ret = undef;
		$lval->check($program, $flags | F_LVALUE, @rest)
						or $ret = undef;
		$self->settype(T_VOID);
		return $ret;
	}
}

if (1) {
	my $package = __PACKAGE__;
	$package =~ s/::Check$/::Node/;
	no strict qw(refs);
	my @missing;
	my @default;
	foreach (@NODETYPES) {
		push(@default, $_) if defined $OPTYPETABLE{$_};
		next if defined $OPTYPETABLE{$_};
		next if defined &{ "$package\::$_\::check" };
		push(@missing, $_);
	}
	print "No check in @missing\n" if @missing;
	print "Default check in @default\n" if @default;
}

1;