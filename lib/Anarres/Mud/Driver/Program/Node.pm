package Anarres::Mud::Driver::Program::Node;

use strict;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS
				@NODETYPES
				%HINTS
				$DEBUG
				);
use Carp qw(:DEFAULT cluck);
use Exporter;
use Data::Dumper;
# use Storable qw(dclone);
use Anarres::Mud::Driver::Program::Type qw(:types);
use Anarres::Mud::Driver::Program::Efun;

sub CONST		()	{ 1 }
sub LVALUE		()	{ 2 }

sub TYPECHECKNAME	() { 1 }
sub TYPECHECKALIAS	() { 2 }

BEGIN {
	my @FLAGS = qw(CONST LVALUE);
	@ISA = qw(Exporter);
	@EXPORT_OK = (@FLAGS,
					qw(@NODETYPES $DEBUG TYPECHECKNAME
							error t_integer t_string));
	%EXPORT_TAGS = (
		flags	=> \@FLAGS,
		all		=> \@EXPORT_OK,
			);

	$DEBUG = 1;
	%HINTS = ();

	# Vivify the relevant packages

# Uplus => Plus
# Uminus => Minus
# Plus => Add
# Minus => Sub
# Divide => Div
# Mult => Mul
# Dot => AddStr

# It might be useful to have a "Coerce" node which does a runtime
# type coercion/promotion, rather than an Assert node which just
# does a runtime type check.

	@NODETYPES = qw(
		ExpNull StmtNull

		IntAssert StrAssert ArrAssert MapAssert ClsAssert ObjAssert

		Nil String Integer Array Mapping Closure
		Variable Parameter Funcall CallOther

		VarGlobal VarLocal

		Index Range

		Postinc Postdec Preinc Predec Unot Tilde Plus Minus
		Lsh Rsh Add Sub Mul Div Mod
		Eq Ne Lt Gt Le Ge
		Or And Xor

		IntAdd IntSub IntMul IntDiv IntMod IntLsh IntRsh
		IntEq IntNe IntLt IntGt IntLe IntGe
		IntOr IntAnd IntXor

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


		Catch Sscanf

		LogOr LogAnd
		ExpCond Assign Block StmtExp
		StmtDo StmtWhile StmtFor StmtForeach
		StmtRlimits StmtTry StmtCatch
		StmtIf StmtSwitch StmtCase StmtDefault
		StmtBreak StmtContinue StmtReturn
			);

	my $PACKAGE = __PACKAGE__;
	foreach (@NODETYPES) {
		eval qq{
			package $PACKAGE\::$_;
			use strict;
			use vars qw(\@ISA);
			use Carp qw(:DEFAULT cluck);
			use Data::Dumper;
			use Anarres::Mud::Driver::Program::Node qw(:all);
			use Anarres::Mud::Driver::Program::Type qw(:types);
			use Anarres::Mud::Driver::Compiler qw(\$PROGRAM);
			\@ISA = qw(Anarres::Mud::Driver::Program::Node);
		}; die $@ if $@;
	}
}

# In the Node package...

sub new {
	my ($class, @vals) = @_;
	die "Construct invalid node type $class" unless $class =~ /::/;
	# print "Construct node $class with " . scalar(@vals) . " values\n";
	my $self = [ undef, 0, @vals ];	# type, flags, vals
	return bless $self, $class;
}

sub error { die @_ }

sub nodetype {
	(my $name = (ref($_[0]) || $_[0])) =~ s/.*:://;
	$name;
}

sub type	{ $_[0]->[0] }
sub settype { $_[0]->[0] = $_[1] }
sub flags	{ $_[0]->[1] }
sub value	{ $_[0]->[2 + $_[1]] }
sub setvalue{ $_[0]->[2 + $_[1]] = $_[2] }
sub values	{ @{$_[0]}[2..$#{$_[0]}] }
sub setflag	{ $_[0]->[1] |= $_[1] }

sub makeblock {
	my ($self, $index) = @_;
	my $block = $self->value($index);
	unless (ref($block) =~ /::Block$/) {
		die "Can only convert statements into blocks, not " .
				$block->nodetype
						unless ref($block) =~ /::Stmt\w+$/;
		# It's a statement.
		$block = new Anarres::Mud::Driver::Program::Node::Block(
						[],	# locals
						[ $block ]);
		$self->setvalue($index, $block);
	}
}

sub assert {	# This sucks somewhat
	my ($self, $type) = @_;
	return new Anarres::Mud::Driver::Program::Node::IntAssert($self)
					if $type->equals(T_INTEGER);
	return new Anarres::Mud::Driver::Program::Node::StrAssert($self)
					if $type->equals(T_STRING);
	return new Anarres::Mud::Driver::Program::Node::ArrAssert($self)
					if $type->arrayp;
	return new Anarres::Mud::Driver::Program::Node::MapAssert($self)
					if $type->mappingp;
	return new Anarres::Mud::Driver::Program::Node::ClsAssert($self)
					if $type->equals(T_CLOSURE);
	return new Anarres::Mud::Driver::Program::Node::ObjAssert($self)
					if $type->equals(T_OBJECT);
	if ($type->equals(T_MIXED)) {
		print "Warning: Asserting node into type mixed!\n";
		print $self->dump, "\n";
		return $self;
	}
	croak "Cannot assert node into type " . $$type . "!\n";
	return undef;
}

# By default, statements are assumed void.
sub infer {
	my ($self, $newtype) = @_;
#	if (ref($self) =~ /Stmt/) {
#		return $_[0] if $_[1]->equals(T_VOID);
#		# This presumably never happens unless we fuck up in templates.
#		print "$_[0] Infers only as void, not " . $$newtype . "\n";
#		return undef;
#	}
#	{
#		my $type = $self->type;
#		print "Inferring $self from $type to $newtype\n";
#		if (ref($type) !~ /::Type$/) {
#			print "Invalid type in " . $self->dump . "\n";
#		}
#	}
	my $node = $self->type->promote($self, $newtype);
	# print "Node is $node\n" if $node;
	# XXX Typecheck the node here if possible... or just settype it.
	return $node;
}

# nodepackage, rettype, arg0type, arg1type, ...
my %OPTYPETABLE = (
	# Postinc Postdec Preinc Predec

	# IntAssert StrAssert ArrAssert MapAssert ClsAssert ObjAssert
	IntAssert	=> [['IntAssert', T_INTEGER, T_MIXED ], ],
	StrAssert	=> [['StrAssert', T_STRING, T_MIXED ], ],
	ArrAssert	=> [['ArrAssert', T_ARRAY, T_MIXED ], ],
	MapAssert	=> [['MapAssert', T_MAPPING, T_MIXED ], ],
	ClsAssert	=> [['ClsAssert', T_CLOSURE, T_MIXED ], ],
	ObjAssert	=> [['ObjAssert', T_OBJECT, T_MIXED ], ],

	# Nil		=> [[ 'Nil', T_NIL, ], ],
	# String	=> [[ 'String', T_STRING, ], ],
	# Integer	=> [[ 'Integer', T_INTEGER, ], ],
	# Array	=> [[ 'Array', T_ARRAY, ], ],					# sub()?
	# Mapping	=> [[ 'Mapping', T_MAPPING, ], ],			# sub()?
	# Closure	=> [[ 'Closure', T_MAPPING, ], ],

						# promote to bool by sub
	Unot	=> [[ 'Unot', T_BOOL, T_BOOL, ], ],				# sub()?
	Tilde	=> [[ 'Tilde', T_INTEGER, T_INTEGER, ], ],
	Plus	=> [[ 'Plus', T_INTEGER, T_INTEGER, ], ],
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
				[ 'IntEq', T_BOOL, T_MIXED, T_MIXED ],		# sub()?
				],
	Ne		=> [[ 'IntNe', T_BOOL, T_INTEGER, T_INTEGER ],
				[ 'StrNe', T_BOOL, T_STRING, T_STRING ],
				[ 'IntNe', T_BOOL, T_MIXED, T_MIXED ],		# sub()?
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

	Index	=> [[ 'StrIndex', T_INTEGER, T_STRING, T_INTEGER ],
					# XXX The next two are to be removed.
				[ 'ArrIndex', T_INTEGER, T_INTEGER->pointer, T_INTEGER ],# sub()?
				[ 'ArrIndex', T_STRING, T_STRING->pointer, T_INTEGER ],# sub()?
				[ 'ArrIndex', T_MIXED, T_ARRAY, T_INTEGER ],# sub()?
				[ 'MapIndex', T_MIXED, T_MAPPING, T_STRING ],# sub()?
				[ 'MapIndex', T_MIXED, T_MAPPING, T_OBJECT ],# sub()?
				],
	Range	=> [[ 'StrRange', T_STRING, T_STRING, T_INTEGER, T_INTEGER],
				[ 'ArrRange', T_ARRAY, T_ARRAY, T_INTEGER, T_INTEGER ],
															# sub()?
				],

	Catch	=> [[ 'Catch', T_STRING, T_MIXED, ], ],

	LogOr	=> [[ 'LogOr', T_MIXED, T_MIXED, T_MIXED ], ],	# sub()?
	LogAnd	=> [[ 'LogAnd', T_MIXED, T_MIXED, T_MIXED ], ],	# sub()?

	ExpCond	=> [[ 'ExpCond', T_MIXED, T_BOOL, T_MIXED, T_MIXED ], ],
															# sub()?

	StmtDo	=> [[ 'StmtDo', T_VOID, T_BOOL, T_VOID ], ],
	StmtWhile
			=> [[ 'StmtWhile', T_VOID, T_BOOL, T_VOID ], ],
	StmtFor	=> [[ 'StmtFor', T_VOID, T_VOID, T_BOOL, T_VOID, T_VOID ],],
	# StmtForeach	# sub - lvalue
	StmtRlimits		# Require the ints to be constant?
			=> [[ 'StmtRlimits', T_VOID, T_INTEGER, T_INTEGER, T_VOID ],
				],
	# StmtTry		# sub - lvalue
	StmtIf	=> [[ 'StmtIf', T_VOID, T_BOOL, T_VOID, T_VOID ],
				[ 'StmtIf', T_VOID, T_BOOL, T_VOID ],
				],

	StmtBreak	=> [[ 'StmtBreak', T_VOID ], ],
	StmtContinue=> [[ 'StmtContinue', T_VOID ], ],
	StmtReturn	=> [[ 'StmtReturn', T_VOID, T_MIXED ], ],	# XXX sub()
		);

q[
	# All of these need appropriate typecheck methods.
		StmtDo StmtWhile StmtFor StmtForeach
		StmtRlimits StmtTry StmtCatch
		StmtIf StmtSwitch StmtCase StmtDefault
		StmtBreak StmtContinue StmtReturn
] if 0;

sub typecheckblock {
	my ($self, $vals, $program, @rest) = @_;

	my @values = @$vals;

	my $succ = 0;
	foreach (@values) {
		$succ++, next unless $_;		# We get 'undef' statements sometimes.
		unless (ref($_) =~ /::/) {
			print "Cannot typecheck $_ in " . $self->nodetype . "\n";
			next;
		}
		# print "Typecheck child " . $_->dump . "\n";
		$succ++ if $_->typecheck($program, @rest);
	}

	if ($succ < @values) {
		return undef;		# temp
		$program->error("Failed to typecheck one or more subnodes of " .
						$self->nodetype);
		return undef;
	}

	return 1;
}

# We have to override this in things like function nodes, I think.
# The principle is that we have a complete parse tree...
sub typecheck {
	# $state contains scope
	my ($self, $program, @rest) = @_;

	if ($self->type) {
		# This will happen since we have aliasing in the parse
		# tree, generated by constructs such as "a -= b" becoming
		# "a = a - b". See Parse.yp for why this is wrong.
		warn "Node " . $self->nodetype . " already has type: $self"
						if $DEBUG & TYPECHECKALIAS;
		return 1;
	}

	print "Auto typechecking " . $self->nodetype . "\n"
					if $DEBUG & TYPECHECKNAME;

	my @values = $self->values;

	$self->typecheckblock(\@values, $program,@rest)
					or return undef;

	my $op = $self->nodetype;

	my %iftable = ();	# A typechecked node cache.

	# print "Checking with " . scalar(@values) . " values\n";

OPTYPE:
	foreach (@{ $OPTYPETABLE{$op} }) {
		if (ref($_) eq 'CODE') {
			if ($_->($self, \@values, \%iftable)) {
				return 1;
			}
		}
		elsif (ref($_) eq 'ARRAY') {
			my ($pack, $rettype, @argtypes) = @{$_};
#			print "Template $op -> $pack has " . scalar(@argtypes) .
#					" values\n";
			next unless @argtypes == @values;

			my $i = 0;
			my @tvals = ();
			foreach my $type (@argtypes) {
				my $arg = $values[$i];
				$iftable{$i . $$type} ||= $arg->infer($type);
				next OPTYPE unless $iftable{$i . $$type};
				push(@tvals, $iftable{$i . $$type});
				$i++;
			}

			# If we get here, we succeeded. Hack the node gratuitously.
			splice(@$self, 2, $#$self, @tvals);
			$self->settype($rettype);
			bless $self, __PACKAGE__ . "::" . $pack;

			return 1;
		}
	}

	# If we get here, we failed. Be verbose.

	my @templates = ();
	foreach (@{ $OPTYPETABLE{$op} }) {
		my (undef, undef, @argtypes) = @{$_};
		my $template = join(", ", map { ${ $_ } } @argtypes);
		push(@templates, "$op($template)");
	}

	$program->error("Failed to find a suitable type template for $op(" .
			join(", ", map { $_->type ? ${ $_->type } : "?" } @values) .
			"). Available templates are " . join(", ", @templates) .
			" in\n" . $self->dump);
	return undef;
}

my %OPCODETABLE = (
	# Can we tell the difference between strings and ints here?
	# DConway says this tells us if it's an int:
	# ($s_ref eq "" && defined $s_val && (~$s_val&$s_val) eq 0)

	ExpNull		=> '',
	StmtNull	=> '',

	Nil			=> 'undef',

	IntAssert	=> 'do { my ($__a) = ((A)); ' .
					'die "Not integer at XXX" if ref($__a); ' .
					'$__a; }',
	StrAssert	=> 'do { my ($__a) = ((A)); ' .
					'die "Not string at XXX" if ref($__a); ' .
					'$__a; }',
	ArrAssert	=> 'do { my ($__a) = ((A)); ' .
					'die "Not array at XXX" if ref($__a) ne "ARRAY"; '.
					'$__a; }',
	MapAssert	=> 'do { my ($__a) = ((A)); ' .
					'die "Not mapping at XXX" if ref($__a) ne "HASH"; '.
					'$__a; }',
	ClsAssert	=> 'do { my ($__a) = ((A)); ' .
					'die "Not closure at XXX" if ref($__a) ne "CODE"; '.
					'$__a; }',
	ObjAssert	=> 'do { my ($__a) = ((A)); ' .	# XXX Fixme
					'die "Not object at XXX" if ref($__a) !~ /::/; ' .
					'$__a; }',


	Postinc	=> '(A)++',
	Postdec	=> '(A)--',
	Preinc	=> '++(A)',
	Predec	=> '--(A)',
	Unot	=> '!(A)',
	Tilde	=> '~(A)',
	Plus	=> '+(A)',
	Minus	=> '-(A)',

	IntLsh	=> '(A) << (B)',
	IntRsh	=> '(A) >> (B)',
	IntAdd	=> '(A) + (B)',
	IntSub	=> '(A) - (B)',
	IntMul	=> '(A) * (B)',
	IntDiv	=> '(A) / (B)',
	IntMod	=> '(A) % (B)',

	StrAdd	=> '(A) . (B)',
	StrMul	=> '(A) x (B)',

	IntEq	=> '(A) == (B)',
	IntNe	=> '(A) != (B)',
	IntLt	=> '(A) < (B)',
	IntGt	=> '(A) > (B)',
	IntLe	=> '(A) <= (B)',
	IntGe	=> '(A) >= (B)',

	StrEq	=> '(A) eq (B)',
	StrNe	=> '(A) ne (B)',
	StrLt	=> '(A) lt (B)',
	StrGt	=> '(A) gt (B)',
	StrLe	=> '(A) le (B)',
	StrGe	=> '(A) ge (B)',

	ArrEq	=> '(A) == (B)',
	ArrNe	=> '(A) != (B)',

	MapEq	=> '(A) == (B)',
	MapNe	=> '(A) != (B)',

	IntOr	=> '(A) | (B)',
	IntAnd	=> '(A) & (B)',
	IntXor	=> '(A) ^ (B)',

	LogOr	=> '(A) || (B)',
	LogAnd	=> '(A) && (B)',
	BitOr	=> '(A) | (B)',
	BitAnd	=> '(A) & (B)',
	BitXor	=> '(A) ^ (B)',

	ExpCond		=> '(A) ? (B) : (C)',

	ArrIndex	=> '(A)->[B]',
	MapIndex	=> '(A)->{B}',
	StrIndex	=> 'substr((A), (B), 1)',	# XXX Wrong!
	ArrRange	=> '[ (A)->[(B)..(C)] ]',

					# eval the args once outside scope of $__* vars
	StrRangeCst	=> 'substr(A, B, (C) - (B))',
	StrRangeVar	=> 'do { my ($__a, $__b, $__c) = ((A), (B), (C)); ' .
					'substr($__a, $__b, ($__c - $__b)) }',

	ArrAdd		=> '[ @{A}, @{B} ]',
	ArrSub		=> 'do { my %__a = map { $_ => 1 } @{B}; ' .
					'[ grep { ! $__a{$_} } @{ A } ] }',

	MapAdd		=> '{ %{A}, %{B} ]',

	Assign		=> 'A = B',
	Catch		=> '(eval { A; }, $@)',

	StmtReturn	=> 'return A;',
	StmtContinue=> 'next;',

	# We can add extra braces around statement|block tokens
	# This lot are all strictly cheating anyway! If this works ...
	StmtExp		=> 'A;',
	StmtDo		=> 'do { B } while (A);',
	StmtWhile	=> 'while (A) { B }',
	StmtFor		=> 'for (A; B; C) D',
	StmtForeach	=> 'foreach my A (@{ B }) C',
	StmtTry		=> 'eval A; if ($@) { my B = $@; C; }',
												# This uses blocks
	StmtCatch	=> 'eval A;',					# A MudOS hack

	# StmtCase	=> 'C: # case',					# A label (unused?)
	# StmtDefault	=> 'A: # default',				# A label!

	# This NOGEN business is really developer support and can be removed
	map { $_ => 'NOGEN' } qw(
							Variable
							Index Range
							Lsh Rsh
							Add Sub Mul Div Mod
							Eq Ne Lt Gt Le Ge Or
							And Xor),
		);

sub gensub {
	my ($self, $name, $code) = @_;

	foreach ('A'..'F') {	# Say ...
		my $arg = ord($_) - ord('A');
		$code =~ s/\b$_\b/' . \$self->value($arg)->generate(\@_) . '/g;
	}

	$code = qq{ sub { my \$self = shift; return '$code'; } };
	# Remove empty concatenations - careful with the templates
	$code =~ s/'' \. //g;
	$code =~ s/ \. ''//g;

	print "$name becomes $code\n";
	my $subref = eval $code;
	die $@ if $@;
	return $subref;
}

# "Refactor", I hear you say?
# This needs a magic token for line number...
sub generate {
	my $self = shift;

	my $name = $self->nodetype;
	# print "Finding code for $name\n";
	my $code = $OPCODETABLE{$name};
	return "GEN($name)" unless defined $code;

	# This is mostly for debugging. It can be safely removed.
	if ($code eq 'NOGEN') {
		warn "Attempt to generate NOGEN opcode $name";
		return "GEN($name)";
	}

	my $subref = $self->gensub($name, $code);

	{
		# Backpatch our original package.
		no strict qw(refs);
		*{ ref($self) . '::generate' } = $subref;
	}

	return $subref->($self, @_);
}

sub dumptype {
	my $self = shift;
	return "" unless $self->type;
	my $flags =
			$self->flags & CONST  ? "C" : "" .
			$self->flags & LVALUE ? "L" : "" ;
	return "[" . $flags . $self->type->dump(@_) . "] ";
}

sub dump {
	my $self = shift;
	$self->dumpblock( [ $self->values ], @_ );
}

sub dumpblock {
	my ($self, $vals, $indent, @rest) = @_;
	$indent++;

	my $op = $self->nodetype;

	my @fields = map {
			  ! $_				? "<undef>"
			: ! ref($_)			? "q[$_]"
			: ref($_) !~ /::/	? "[" . ref($_) . "]"
			: $_->dump($indent, @rest)
					} @$vals;
	my $sep = "\n" . ("\t" x $indent);
	return join($sep,
			"(" . $self->dumptype($indent, @rest) . lc $op,
			@fields
				) . ")";
	# return join($sep, "([V] block", @locals, @stmts) . ")";
}


sub t_integer {	# Modifies its arguments
	my $base = $_[0];
	my $func = $_[1];
	foreach (@_[2..$#_]) {
		$_ = $_->infer(T_INTEGER);
		unless ($_) {
			error "Argument $base to $func not integer";
		}
		$base++;
	}
}

sub t_string {	# Modifies its arguments
	my $base = $_[0];
	my $func = $_[1];
	foreach (@_[2..$#_]) {
		# print "t_string($_)\n";
		confess "t_string on nonref" unless ref $_;
		$_ = $_->infer(T_STRING);
		unless ($_) {
			error "Argument $base to $func not string";
		}
		$base++;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::ExpNull;
	sub typecheck { $_[0]->settype(T_NIL); 1; }
}

if (0) {
my %assertmap = (
	IntAssert	=> 'T_INTEGER',
	StrAssert	=> 'T_STRING',
	ArrAssert	=> 'T_ARRAY',
	MapAssert	=> 'T_MAPPING',
	ObjAssert	=> 'T_OBJECT',
		);
foreach (qw(IntAssert StrAssert ArrAssert MapAssert
				ObjAssert)) {	# XXX Do ClsAssert
	my $type = $assertmap{$_};
	eval qq[
		{
			package Anarres::Mud::Driver::Program::Node::$_;
	] . q[
			sub typecheck {
				my ($self, $program, @rest) = @_;
				my $val = $self->value(0);
				while ((ref($val) =~ /::...Assert/)) {
					if (ref($val) eq ref($self)) {
						$val = $val->value(0);
						$self->setvalue(0, $val);
					}
					else {
						die "Cannot assert " . ref($val) . " into " .
										ref($self);
					}
				}
				unless ($val->type) {
					$val->typecheck($program, @rest)
									or return undef;
				}
	] . qq[
				\$self->settype($type);
				return 1;
			}
		}
	]; die $@ if $@;
}	# foreach
}	# lexical scope

{
	package Anarres::Mud::Driver::Program::Node::Nil;
	sub typecheck { $_[0]->settype(T_NIL); $_[0]->setflag(CONST); 1; }
}

{
	package Anarres::Mud::Driver::Program::Node::String;
	use String::Escape qw(quote printable);
	sub typecheck {$_[0]->settype(T_STRING); $_[0]->setflag(CONST); 1;}
	sub dump { return quote(printable($_[0]->value(0))) }
		# XXX This will interpolate by mistake.
	sub generate { quote(printable($_[0]->value(0))) }
}

{
	package Anarres::Mud::Driver::Program::Node::Integer;
	sub typecheck {$_[0]->settype(T_INTEGER); $_[0]->setflag(CONST); 1;}
	sub infer {
		my ($self, $type, @rest) = @_;

		# Yes, a special case.
		if ($self->value(0) == 0) {	# A valid nil
			unless ($type->equals(T_INTEGER)) {
				return new Anarres::Mud::Driver::Program::Node::Nil;
			}
		}

		return $self->SUPER::infer($type, @rest);
	}
	sub dump { return $_[0]->value(0) }
	sub generate { $_[0]->value(0) }
}

{
	package Anarres::Mud::Driver::Program::Node::Array;
	sub typecheck {
		my ($self, $program, @rest) = @_;

		my @values = $self->values;
		$self->typecheckblock(\@values, $program,@rest)
						or return undef;

		my $flag = CONST;
		my $type = T_NIL;
		foreach (@values) {
			# Search the types to find a good type.
			$type = $_->type->typejoin($type);
			$flag &= $_->flags;
		}

		$self->settype($type->pointer);
		$self->setflag($flag) if $flag;

		return 1;
	}
	sub generate {
		my ($self, $indent, @rest) = @_;
		$indent++;

		my @vals = map { $_->generate($indent, @rest) } $self->values;

		return "[ ]" unless @vals;

		$indent--;
		my $isep = "\n" . ("\t" x $indent);
		my $sep = "," . $isep . "\t";
		return "[" . $isep . "\t" . join($sep, @vals) . $isep . "]";
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Mapping;
	sub typecheck {
		my ($self, $program, @rest) = @_;

		my @values = $self->values;
		$self->typecheckblock(\@values, $program,@rest)
						or return undef;

		my $ret = 1;

		my $flag = CONST;
		my $type = T_NIL;
		my $idx = 0;
		foreach (@values) {
			# Search the types to find a good type.
			if ($idx & 1) {
				$type = $_->type->typejoin($type);
			}
			else {
				my $key = $_->infer(T_STRING);
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

	sub generate {
		my ($self, $indent, @rest) = @_;
		$indent++;

		my @vals = map { $_->generate($indent, @rest) } $self->values;
		return "{ }" unless @vals;

		my @out = ();
		while (my @tmp = splice(@vals, 0, 2)) {
			push(@out, $tmp[0] . "\t=> " . $tmp[1] . ",");
		}

		$indent--;
		my $isep = "\n" . ("\t" x $indent);
		my $sep = $isep . "\t";
		return "{$isep\t" . join($sep, @out) . "$isep}";
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Closure;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		$self->setvalue(1, $program->closure($self));
		$self->settype(T_CLOSURE);
		return 1;
	}
	# XXX This needs to store the owner object so we can emulate the
	# LPC behaviour of function_owner. Something like [ $self, sub {} ]
	sub generate {
		my $self = shift;
		# return "sub { " . $self->value(0)->generate(@_) . " }";
		return '$self->{Closures}->[' . $self->value(1) . ']';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Variable;
	# XXX Look up type
	sub typecheck {
		my ($self, $program, @rest) = @_;
		# cluck "Typechecking Variable $self";
		my $name = $self->value(0);
		my ($var, $class);
		if ($var = $program->local($name)) {
			$class = 'Anarres::Mud::Driver::Program::Node::VarLocal';
		}
		elsif ($var = $program->global($name)) {
			$class = 'Anarres::Mud::Driver::Program::Node::VarGlobal';
		}
		else {
			$program->error("Variable $name not found");
			# We should fake something up because we end up dying later?
			return undef;
		}
		bless $self, $class;
		$self->settype($var->type);
		# print "Created variable: " . $self->dump . "\n";
		return 1;
	}
	# XXX As an rvalue? Delegate to a basic type infer method.
	# XXX If it's an rvalue then it must be initialised. Also for ++, --
	# sub dump { $_[0]->value(0)->dump; }
	sub dump {
		my $self = shift;
		# my $var = $self->value(0);
		# XXX Typechecking should replace with an object?
		# return ref($var) ? $var->dump : $var;
		return "(" . $self->dumptype . "variable "
						. $self->value(0) . ")";
	}
}

{
	package Anarres::Mud::Driver::Program::Node::VarLocal;
	sub dump {
		"(" . $_[0]->dumptype . "varlocal " . $_[0]->value(0) . ")";
	}
	sub generate {
		return '$' . $_[0]->value(0);
	}
}

{
	package Anarres::Mud::Driver::Program::Node::VarGlobal;
	sub dump {
		"(" . $_[0]->dumptype . "varglobal " . $_[0]->value(0) . ")";
	}
	sub generate {
		my $self = shift;
		my $name = $self->value(0);
		return '$self->{Variables}->{' . $name . '}';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Parameter;
	sub dump {
		my $self = shift;
		return "(" . $self->dumptype . "parameter "
						. $self->value(0) . ")";
	}
	# XXX We could look this up at the current point ...
	sub infer { $_[0]->assert($_[1]) }	# XXX As an rvalue?
	sub typecheck { $_[0]->settype(T_MIXED); return 1; }
	sub generate { '$_[' . $_[0]->value(0) . ']' }
}

{
	package Anarres::Mud::Driver::Program::Node::Funcall;
	# XXX Look up return type, number of args
	sub typecheck {
		my ($self, $program, @rest) = @_;
		# Changing the format of this node will require modifications
		# to StmtIf optimisation.
		my @values = $self->values;
		my $method = shift @values;
		my @args = @{ $method->args };

		print "Typechecking Funcall to " . $method->name . "\n"
					if $DEBUG & TYPECHECKNAME;

		my $succ = 0;
		foreach (@values) {
			$succ++ if $_->typecheck($program, @rest);
		}
		if ($succ < @values) {
			$program->error("Failed to typecheck one or more arguments "
							. " to " . $method->name);
			return undef;
		}

		# print $self->dump . "\n";

		# XXX Allow varargs and patch up?
		if (@values < @args) {
			$program->error("Too few arguments to function " .
							$method->name);
			return undef;
		}
		elsif (@values > @args) {
			$program->error("Too many (" . scalar(@values) .
							") arguments to function " . $method->name);
			return undef;
		}

		unshift(@values, $method);
		my $type = $method->typecheck_call($program, \@values);

		return undef unless $type;

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

	sub dump {
		my $self = shift;
		my @args = $self->values;
		my $method = shift @args;
		@args = map { " " . $_->dump(@_) } @args;
		return "(" . $self->dumptype(@_) . "funcall '" .
						$method->name . "'" . join("", @args) . ")"
	}
	sub generate {
		my $self = shift;
		my @args = $self->values;
		my $method = shift @args;
		@args = map { $_->generate(@_) } @args;
		return $method->generate_call(@args);
	}
}

{
	package Anarres::Mud::Driver::Program::Node::CallOther;
	# XXX Look up return type
	sub typecheck {
		my ($self, $program, @rest) = @_;
		my ($exp, $name, @values) = $self->values;
		print "Typechecking CallOther\n"
					if $DEBUG & TYPECHECKNAME;
		unshift(@values, $exp);
		$self->typecheckblock(\@values, $program, @rest)
						or return undef;
		# XXX What if the lhs is type string?
		$self->settype(T_MIXED);
		return 1;
	}
	# sub infer { $_[0]->assert($_[1]) }
	sub dump {
		my $self = shift;
		my @values = $self->values;
		my $exp = shift @values;
		my $name = shift @values;
		my $type = $self->dumptype;
		@values = map { ref($_) =~ /::/ ? " " . $_->dump(@_) : $_ }
						@values;
		return "(" . $type . "callother " . $exp->dump(@_) . " -> '" .
						$name . "'" . join("", @values) . ")"
	}
	sub generate {
		my $self = shift;
		my @values = $self->values;
		my $exp = shift @values;
		my $name = shift @values;
		@values = map { $_->generate(@_) } @values;
		return '(' . $exp->generate(@_) . ')->' . $name . '(' .
						join(", ", @values) . ')';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Index;
}

{
	package Anarres::Mud::Driver::Program::Node::ArrIndex;
}

{
	package Anarres::Mud::Driver::Program::Node::MapIndex;
}

{
	package Anarres::Mud::Driver::Program::Node::StrRange;
	# Don't do this!
	sub generate_cst {
		my $self = shift;
		*generate_cst = $self->gensub('StrRange',
						$OPCODETABLE{'StrRangeCst'});
		return $self->generate_cst(@_);
	}
	sub generate_var {
		my $self = shift;
		*generate_var = $self->gensub('StrRange',
						$OPCODETABLE{'StrRangeVar'});
		return $self->generate_var(@_);
	}
	# XXX We need to check for lvalues around here. :-(
	sub generate {
		my $self = shift;
		my $val = $self->value(1);
		# Variables are unchanged across this operation.
		# What we really mean here is, "Is it pure?"
		# But that would not necessarily amount to an optimisation.
		# A better question might be, "Is it elementary?"
		# (VarLocal or VarGlobal)
		if (ref($val) =~ /::Var(Loc|Glob)al$/ || ($val->flags)&CONST) {
			return $self->generate_cst(@_);
		}
		else {
			return $self->generate_var(@_);
		}
	}
}

{
	package Anarres::Mud::Driver::Program::Node::ArrRange;
}

{
	package Anarres::Mud::Driver::Program::Node::Catch;
}

{
	package Anarres::Mud::Driver::Program::Node::Sscanf;
	# This should be $_[1], @{$_[2]}
	sub typecheck {
		my ($self, $program, $flags, @rest) = @_;
		my ($exp, $fmt, @values) = $self->values;
		$self->typecheckblock(\@values, $program, $flags|LVALUE, @rest)
			&& $exp->typecheck($program, $flags, @rest)
			&& $fmt->typecheck($program, $flags, @rest)
						or return undef;

		my $sexp = $exp->infer(T_STRING);
		unless ($sexp) {
			$program->error("Input for sscanf must be string, not " .
							$exp->type->dump);
			return undef;
		}
		$sexp->typecheck($program, $flags, @rest) unless $sexp->type;
		$self->setvalue(0, $sexp);

		my $sfmt = $fmt->infer(T_STRING);
		unless ($sfmt) {
			$program->error("Format for sscanf must be string, not " .
							$fmt->type->dump);
			return undef;
		}
		$sfmt->typecheck($program, $flags, @rest) unless $sfmt->type;
		$self->setvalue(1, $sfmt);

		$self->settype(T_INTEGER);
		return 1;
	}
	# sub infer { $_[0]->assert($_[1]) }

	sub generate {
		my $self = shift;
		my ($exp, $fmt, @values) = $self->values;
		@values = map { ', ' . $_->generate(@_) } @values;
		return 'XXX_sscanf(' . $exp->generate(@_) . ', ' .
					$fmt->generate(@_) .
					join('', @values) . ')';
	}
}

foreach ( qw(Postinc Postdec Preinc Predec) ) {
	my $n = lc $_;
	eval qq[
		{
			package Anarres::Mud::Driver::Program::Node::$_;
	] . q[
			sub typecheck {
				my ($self, $program, $flags, @rest) = @_;
				my $val = $self->value(0);
				$val->typecheck($program, $flags|LVALUE, @rest)
						or return undef;
				my $ival = $val->infer(T_INTEGER);
				unless ($ival) {
					$program->error("Argument to unary operator must " .
									"be integer, not " .
									$val->type->dump);
					return undef;
				}
				$ival->typecheck($program, $flags, @rest)
								unless $ival->type;
				$self->setvalue(0, $ival);
				$self->settype(T_INTEGER);
				return 1;
			}
		}
	]; die $@ if $@;
}

{
	package Anarres::Mud::Driver::Program::Node::Unot;
	sub typecheck {	# Interesting...
		my ($self, $program, @rest) = @_;

		my $val = $self->value(0);
		$val->typecheck($program, @rest);
		my $vt = $val->type;

		if ($vt->equals(T_NIL)) {
			$program->warning("Expression always true due to type");
			$self->setvalue(0, 1);
			bless $self, "Anarres::Mud::Driver::Program::Node::Integer";
			$self->typecheck($program, @rest);
		}
		elsif ($val = $val->infer(T_BOOL)) {
			$self->setvalue(0, $val);
			$val->typecheck($program, @rest) unless $val->type;
		}
		else {
			$program->error("Cannot convert " . ${$vt} . " to bool");
			return undef;
		}

		$self->settype(T_BOOL);
		return 1;
	}
}

foreach ( qw(Tilde Plus Minus) ) {
	eval qq{
		{
			package Anarres::Mud::Driver::Program::Node::$_;
		}
	}; die $@ if $@;
}

foreach ( qw(Lsh Rsh Mul Div Mod)) {
	eval qq{
		{
			package Anarres::Mud::Driver::Program::Node::$_;
		}
	}; die $@ if $@;
}

{
	package Anarres::Mud::Driver::Program::Node::StrAdd;
}

{
	package Anarres::Mud::Driver::Program::Node::Add;
}

{
	package Anarres::Mud::Driver::Program::Node::Sub;
}

{
	package Anarres::Mud::Driver::Program::Node::ArrAdd;
	sub old_new { shift; return __PACKAGE__->SUPER::new(T_ARRAY, 0, @_); }
	# sub infer { $_[1]->arrayp ? $_[0] : undef }
}

{
	package Anarres::Mud::Driver::Program::Node::MapAdd;
	sub old_new { shift; return __PACKAGE__->SUPER::new(T_MAPPING, 0, @_); }
	# sub infer { $_[1]->equals(T_MAPPING) ? $_[0] : undef }
}

{
	package Anarres::Mud::Driver::Program::Node::ArrSub;
	# None of these three methods are used.
	sub invoke {	# Can't really do this inline?
		my %table = map { $_ => 1 } @{ $_[1] };
		return [ grep { ! $table{$_} } @{ $_[0] } ]
	}
	sub noninline_generate {
		my $self = shift;
		return 'Anarres::Mud::Driver::Program::Node::ArrSub::invoke(' .
						$self->value(0)->generate(@_) . ', ' .
						$self->value(1)->generate(@_) . ')';
	}
	sub inlinegen {
		my $self = shift;
		my @stmts = (
			'my $__l = ' . $self->value(1)->generate . ';',
			'my $__r = ' . $self->value(0)->generate . ';',
			'my %__t = map { $_ => 1 } @$__l;',
			'[ grep { !$__t{$_} } @$__r ];',
				);
	}
}

{
	package Anarres::Mud::Driver::Program::Node::ArrUnion;
	# XXX Generate this inline like ArrSub.
	sub invoke {
		my @left = @{ $_[0] };
		my %table = map { $_ => 1 } @left;
		foreach (@{ $_[1] }) {
			push(@left, $_) unless $table{$_};
		}
		return \@left;
	}
	sub generate {
		my $self = shift;
		return 'Anarres::Mud::Driver::Program::Node::ArrUnion::invoke('.
						$self->value(0)->generate(@_) . ', ' .
						$self->value(1)->generate(@_) . ')';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::ArrIsect;
	# XXX Generate this inline like ArrSub.
	# sub infer { $_[1]->arrayp ? $_[0] : undef }
	sub invoke {
		my @out = ();
		my %table = map { $_ => 1 } @{ $_[1] };
		foreach (@{ $_[0] }) {
			push(@out, $_) if $table{$_};
		}
		return \@out;
	}
	sub generate {
		my $self = shift;
		return 'Anarres::Mud::Driver::Program::Node::ArrIsect::invoke('.
						$self->value(0)->generate(@_) . ', ' .
						$self->value(1)->generate(@_) . ')';
	}
}

foreach (qw(IntEq IntNe IntLt IntGt IntLe IntGe)) {
	my $strop = $_;
	$strop =~ s/^Int/Str/;
	eval qq{
		{
			package Anarres::Mud::Driver::Program::Node::$_;
		}
		{
			package Anarres::Mud::Driver::Program::Node::$strop;
		}
	}; die $@ if $@;
}

{
	package Anarres::Mud::Driver::Program::Node::LogOr;
}

{
	package Anarres::Mud::Driver::Program::Node::LogAnd;
}

foreach (qw(Or And Xor)) {
	eval qq{
		{
			package Anarres::Mud::Driver::Program::Node::$_;
		}
	}; die $@ if $@;
}

{
	package Anarres::Mud::Driver::Program::Node::ExpCond;
}

{
	package Anarres::Mud::Driver::Program::Node::Assign;
	sub typecheck {
		my ($self, $program, $flags, @rest) = @_;
		my ($lval, $exp) = $self->values;

		print "Typechecking Assign\n"
					if $DEBUG & TYPECHECKNAME;

		# XXX Work more on lvalues ...
		unless ($lval->typecheck($program, $flags | LVALUE, @rest)) {
			$program->error("Failed to typecheck lvalue to assign");
			return undef;
		}
		unless ($exp->typecheck($program, $flags, @rest)) {
			$program->error("Failed to typecheck rvalue to assign");
			return undef;
		}

		my $vtype = $lval->type;
		if ($vtype->equals(T_MIXED)) {
			$self->settype($exp->type);
		}
		else {
			my $val = $exp->infer($vtype);
			unless ($val) {
				my $dump = $lval->dump;
				$dump =~ s/\s+/ /g;
				$program->error("Cannot assign type " .
								$exp->type->dump . " to lvalue " .
								$dump ." of type ". $lval->type->dump);
				return undef;
			}
			$val->typecheck($program, $flags, @rest) unless $val->type;
			$self->setvalue(1, $val);

			$self->settype($lval->type);
		}

		return 1;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::Block;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		my @locals = @{ $self->value(0) };
		my @stmts  = @{ $self->value(1) };

		$program->save_locals;
		foreach (@locals) {
			$program->local($_);
		}
		my $succ = 0;
		foreach (@stmts) {
			$succ++ if $_->typecheck($program, @rest);
		}
		$program->restore_locals;

		return undef unless $succ == @stmts;

		$self->settype(T_VOID);

		return 1;
	}
	sub dump {
		my $self = shift;
		return $self->dumpblock(
				[ @{ $self->value(0) },	# locals
				  @{ $self->value(1) },	# statements
				], @_ );
	}
	sub generate {
		my ($self, $indent, @rest) = @_;
		$indent++;

		my @args = map { $_->name } @{ $self->value(0) };
		my $args = @args
						? 'my ($' . join(', $', @args) . ');'
						: '# no locals in block';
		my @vals = map { $_->generate($indent, @rest) }
						@{ $self->value(1) };

		$indent--;
		my $isep = "\n" . ("\t" x $indent);
		my $sep = $isep . "\t";
		return '{' . $sep . join($sep, $args, @vals) . $isep . "}";
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtNull;
	sub typecheck { $_[0]->settype(T_VOID); 1; }
}

{
	package Anarres::Mud::Driver::Program::Node::StmtExp;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		print "Typechecking StmtExp\n"
					if $DEBUG & TYPECHECKNAME;
		my @values = $self->values;
		$self->typecheckblock(\@values, $program, @rest)
						or return undef;
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtForeach;
	sub typecheck {
		my ($self, $program, $flags, @rest) = @_;
		print "Typechecking StmtForeach\n"
					if $DEBUG & TYPECHECKNAME;
		$self->makeblock(2);
		my ($val, $arr, $block) = $self->values;
		$self->typecheckblock([ $arr, $block ], $program, $flags, @rest)
			&& $val->typecheck($program, $flags|LVALUE, @rest)
						or return undef;
		# XXX Check that $arr->type->deref->equals($val->type)
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtFor;
	sub typecheck {
		my ($self, $program, $flags, @rest) = @_;
		print "Typechecking StmtFor\n"
					if $DEBUG & TYPECHECKNAME;
		$self->makeblock(3);
		my @values = $self->values;
		$self->typecheckblock(\@values, $program, $flags, @rest)
						or return undef;
		$_[0]->settype(T_VOID);
		return 1;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtSwitch;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		my ($exp, $block) = $self->values;
		print "Typechecking StmtSwitch\n"
					if $DEBUG & TYPECHECKNAME;
		my $endswitch = $program->save_labels;
		$self->setvalue(2, $endswitch);		# end of switch
		$self->typecheckblock([ $exp, $block ], $program, @rest)
						or return undef;
		# XXX Save the exp type in the program object switch stack.
		my $labels = $program->restore_labels;
		$self->setvalue(3, $labels->[0]);	# labels
		$self->setvalue(4, $labels->[1]);	# default
		$self->settype(T_VOID);
		return 1;
	}
	sub generate {
		my $self = shift;
		my $indent = shift;

		my $isep = "\n" . ("\t" x $indent);
		my $sep = $isep . "\t";

		$indent++;

		my ($exp, $block) = $self->values;
		my $dump = $exp->dump;
		$dump =~ s/\s+/ /g;
		my $labels = $self->value(3);
		#              default label  or  end of switch
		my $default = $self->value(4) || $self->value(2);

		# Put this n program header?
		my @hashdata =
				map { $sep . "\t\t" .
						$labels->{$_}->generate($indent, @_) .
								"\t=> " . $_ . "," }
						keys %{ $labels };
		my $hashdata = join('', @hashdata);

		return '{' .
			$sep . '# ([v] switch ' . $dump . ')' .
			$sep . 'my %LABELS = (' . $hashdata . ');' .
			$sep . '# ' . join(", ", keys %{ $labels }) .
			$sep . 'my $__a = ' . $exp->generate($indent, @_) . ';' .
			$sep . 'exists $LABELS{$__a} ' .
					'? goto $LABELS{$__a} ' .
					': goto ' . $default . ';' .
			$sep .  $block->generate($indent, @_) .
			$sep .  $self->value(2) . ':' .
		$isep . '}';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtCase;
	sub typecheck {
		my ($self, $program, $flags, @rest) = @_;
		my ($left, $right) = $self->values;
		print "Typechecking StmtCase\n"
					if $DEBUG & TYPECHECKNAME;
		my $vals = $right ? [ $left, $right ] : [ $left ];
		$self->typecheckblock($vals, $program, $flags|CONST, @rest)
						or return undef;
		if ($right) {
			if (! $left->type->equals($right->type)) {
				$program->error("Endpoints of range in 'case' do not " .
								"match.");
				return undef;
			}
			# And the rest ...
			$self->setvalue(2, $program->label($left));
		}
		else {
			$self->setvalue(2, $program->label($left));
		}
		$self->settype(T_VOID);
		return 1;
	}
	sub generate {
		my $self = shift;
		my $dump = $self->dump;
		$dump =~ s/\s+/ /g;
		return $self->value(2) . ': # ' . $dump;
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtDefault;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		print "Typechecking StmtDefault\n"
					if $DEBUG & TYPECHECKNAME;
		$self->setvalue(0, $program->default);
		$self->settype(T_VOID);
		return 1;
	}
	sub generate {
		my $self = shift;
		return $self->value(0) . ': # default';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtBreak;
	sub typecheck {
		my ($self, $program, @rest) = @_;
		print "Typechecking StmtBreak\n"
					if $DEBUG & TYPECHECKNAME;
		$self->setvalue(0, $program->getbreaktarget);
		$self->settype(T_VOID);
		return 1;
	}
	sub generate {
		my $self = shift;
		return 'goto ' . $self->value(0) . '; # break';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtRlimits;
	sub generate {
		my $self = shift;
		return $self->value(3)->generate(@_) . ';';
	}
}

{
	package Anarres::Mud::Driver::Program::Node::StmtIf;
	# XXX Promote $_[1] to bool in new/typecheck
	sub typecheck {
		my ($self, $program, @rest) = @_;
		$self->makeblock(1);
		if ($self->value(2)) {
			unless (ref($self->value(2)) =~ /::StmtIf$/) {
				$self->makeblock(2);
			}
		}
		my ($cond, $if, $else) = $self->values;
		print "Typechecking StmtIf\n"
					if $DEBUG & TYPECHECKNAME;
		$cond->typecheck($program, @rest)
						or return undef;
		# Now we inspect $cond and set hints.
		if (ref($cond) =~ /::Funcall$/) {
			my $method = $cond->value(0);
			my $name = $method->name;
			# intp, stringp, boolp, objectp, classp, arrayp, mapp
			if ($name =~ /(?:int|string|bool|object|class|array|map)p/){
				print "Hinting conditional: Call to $name\n";
			}
		}
		my $vals = defined $else
				? [ $if, $else, ]
				: [ $if, ];
		return $self->typecheckblock($vals, $program, @rest)
						or return undef;
		$_[0]->settype(T_VOID);
		return 1;
	}
	sub dump {
		my $self = shift;
		my ($cond, $if, $else) = $self->values;
		my $vals = defined $else
				? [ $cond, $if, $else, ]
				: [ $cond, $if, ];
		return $self->dumpblock($vals, @_);
	}
	sub generate {
		my ($self, $indent, @args) = @_;
		my $sep = "\t" x $indent;
		my $out =
			"if (" .
				$self->value(0)->generate($indent + 2, @args) . ") " .
					$self->value(1)->generate($indent, @args);
		my $else = $self->value(2);
		if ($else) {
			if (ref($else) =~ /::StmtIf$/) {
				# Get an 'elsif'
				$out .= "\n" . $sep . "els" .
								$else->generate($indent, @args);
			}
			else {
				$out .=
					"\n" . $sep . "else " .
						$else->generate($indent, @args);
			}
		}
		return $out;
	}
}

foreach (qw(
		StmtDo StmtWhile
		StmtTry StmtCatch
		StmtBreak StmtContinue
		StmtReturn
		)) {
	eval qq{
		{
			package Anarres::Mud::Driver::Program::Node::$_;
		}
	}; die $@ if $@;
}

if (1) {
	my $package = __PACKAGE__;
	no strict qw(refs);
	my @nogen;
	foreach (@NODETYPES) {
		next if defined $OPCODETABLE{$_};
		next if defined &{ "$package\::$_\::generate" };
		push(@nogen, $_);
	}
	print "No generate in @nogen\n";
}

1;
