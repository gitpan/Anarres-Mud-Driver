package Anarres::Mud::Driver::Compiler::Node;

use strict;
use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS
				@NODETYPES
				$DEBUG
				);
use Carp qw(:DEFAULT cluck);
use Exporter;
use Data::Dumper;
use Anarres::Mud::Driver::Compiler::Type qw(:types);

sub TYPECHECKNAME	() { 1 }
sub TYPECHECKALIAS	() { 2 }

BEGIN {
	@ISA = qw(
				Exporter
				Anarres::Mud::Driver::Compiler::Dump
				Anarres::Mud::Driver::Compiler::Check
				Anarres::Mud::Driver::Compiler::Generate
		);
	@EXPORT_OK = qw(@NODETYPES $DEBUG TYPECHECKNAME TYPECHECKALIAS);
	%EXPORT_TAGS = (
		all		=> \@EXPORT_OK,
			);

	# Vivify the relevant packages

# It might be useful to have a "Coerce" node which does a runtime
# type coercion/promotion, rather than an Assert node which just
# does a runtime type check.

	@NODETYPES = qw(
		ExpNull StmtNull

		ExpComma

		IntAssert StrAssert ArrAssert MapAssert ClsAssert ObjAssert

		Nil String Integer Array Mapping Closure
		Variable Parameter Funcall CallOther

		VarGlobal VarLocal

		Index Range Member New

		Postinc Postdec Preinc Predec Unot Tilde Plus Minus
		Lsh Rsh Add Sub Mul Div Mod
		Eq Ne Lt Gt Le Ge
		Or And Xor

		IntAdd IntSub IntMul IntDiv IntMod IntLsh IntRsh
		IntEq IntNe IntLt IntGt IntLe IntGe
		IntOr IntAnd IntXor
		LogOr LogAnd

		AddEq SubEq DivEq MulEq ModEq
		AndEq OrEq XorEq
		LshEq RshEq
		LogOrEq LogAndEq

		IntAddEq IntSubEq IntMulEq IntDivEq IntModEq
		IntAndEq IntOrEq IntXorEq
		IntLshEq IntRshEq

		StrAdd        StrMul
		StrEq StrNe StrLt StrGt StrLe StrGe
		StrIndex StrRange

		StrAddEq      StrMulEq

		ArrAdd ArrSub
		ArrEq ArrNe
		ArrUnion ArrIsect
		ArrIndex ArrRange

		MapAdd
		MapEq MapNe
		MapIndex


		Catch Sscanf

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
			use Anarres::Mud::Driver::Compiler::Node qw(:all);
			use Anarres::Mud::Driver::Compiler::Type qw(:all);
			\@ISA = qw(Anarres::Mud::Driver::Compiler::Node);
		}; die $@ if $@;
	}
}

$DEBUG = TYPECHECKNAME;
$DEBUG = 0;

# Now that we have set up the Node packages, we can do this:

use Anarres::Mud::Driver::Compiler::Dump;
use Anarres::Mud::Driver::Compiler::Check;
use Anarres::Mud::Driver::Compiler::Generate;

# Meanwhile, back in the Node package...

sub new {
	my ($class, @vals) = @_;
	die "Construct invalid node type $class" unless $class =~ /::/;
	# print "Construct node $class with " . scalar(@vals) . " values\n";
	my $self = [ undef, 0, @vals ];	# type, flags, vals
	return bless $self, $class;
}

	# The format of a node is [ type, flags, value0, value1, ... ]
sub type	{ $_[0]->[0] }
sub settype { $_[0]->[0] = $_[1] }
sub flags	{ $_[0]->[1] }
sub value	{ $_[0]->[2 + $_[1]] }
sub setvalue{ $_[0]->[2 + $_[1]] = $_[2] }
sub values	{ @{$_[0]}[2..$#{$_[0]}] }
sub setflag	{ $_[0]->[1] |= $_[1] }

{
	package Anarres::Mud::Driver::Compiler::Node::Mapping;
	sub new {
		my $class = shift;
		my $self = $class->SUPER::new(@_);
		# This is a kludge that I really can't be arsed to do in XS
		my @values = map { @{$_} } $self->values;
		splice(@$self, 2, $#$self, @values);
		return $self;
	}
}

1;
