package Anarres::Mud::Driver::Compiler::Lex;

use strict;
use vars qw(@ISA @EXPORT_OK
	%SYMTAB %TYPETAB %MODTAB %TOKTAB
	%DEQUOTE
	$RE_OPERATOR $RE_ONECHAR
	$RE_INTEGER $RE_HEXINTEGER $RE_CHARACTER $RE_STRING
	$RE_PARAMETER $RE_IDENTIFIER
	$RE_COMMENT $RE_CPPCOMMENT
		);
use Exporter;
use Storable;
use String::Escape qw( unquote unprintable );
use Data::Dumper;
use Anarres::Mud::Driver::Compiler::Symbol;
use Anarres::Mud::Driver::Program::Type qw(:types);
use Anarres::Mud::Driver::Program qw(:flags);

@ISA = qw(Exporter);
@EXPORT_OK = qw(%TYPETAB);

%SYMTAB = qw(
	break		L_BREAK
	case		L_CASE
	catch		L_CATCH
	class		L_CLASS
	continue	L_CONTINUE
	default		L_DEFAULT
	do			L_DO
	efun		L_EFUN
	else		L_ELSE
	for			L_FOR
	foreach		L_FOREACH
	if			L_IF
	in			L_IN
	inherit		L_INHERIT
	new			L_NEW
	nil			L_NIL
	return		L_RETURN
	rlimits		L_RLIMITS
	switch		L_SWITCH
	sscanf		L_SSCANF
	try			L_TRY
	while		L_WHILE
		);

%TYPETAB = (
	bool		=> T_BOOL,
	function	=> T_CLOSURE,
	int			=> T_INTEGER,
	mapping		=> T_MAPPING,
	mixed		=> T_MIXED,
	object		=> T_OBJECT,
	string		=> T_STRING,
	void		=> T_VOID,
		);

%MODTAB = (
	nomask		=> M_NOMASK,
	nosave		=> M_NOSAVE,
	private		=> M_PRIVATE,
	protected	=> M_PROTECTED,
	public		=> M_PUBLIC,

	varargs		=> M_VARARGS,
		);
	# virtual		L_TYPE_MODIFIER

%TOKTAB = qw@
	+=			L_PLUS_EQ
	-=			L_MINUS_EQ
	/=			L_DIV_EQ
	*=			L_TIMES_EQ
	%=			L_MOD_EQ
	&=			L_AND_EQ
	|=			L_OR_EQ
	^=			L_XOR_EQ
	.=			L_DOT_EQ

	==			L_EQ
	!=			L_NE
	<=			L_LE
	>=			L_GE

	||			L_LOR
	&&			L_LAND

	++			L_INC
	--			L_DEC

	>>			L_RSH
	<<			L_LSH

	([			L_MAP_START
	])			L_MAP_END
	({			L_ARRAY_START
	})			L_ARRAY_END
	(:			L_FUNCTION_START
	:)			L_FUNCTION_END

	::			L_COLONCOLON
	->			L_ARROW
	..			L_RANGE

	...			L_ELLIPSIS
		@;

%DEQUOTE = (
	n		=> "\n",
	r		=> "\r",
	t		=> "\t",
	'"'		=> '"',
	'\\'	=> '\\'
		);

$RE_ONECHAR		= '[\+-/\*%&\|<>\^~\?\.\{\},;:\(\)\[\]!=]';
$RE_OPERATOR	= join("|", qw@
			\.\.\.

			[\+\-/\*%&\|\^\.=!<>]=
			\|\| &&
			\+\+ --
			<< >>
			\(\[ \]\) \(\{ \}\) \(: :\)
			:: -> \.\.
		@) . "|" . $RE_ONECHAR;
$RE_INTEGER		= '\d+';
$RE_HEXINTEGER	= '0x[[:xdigit:]]+';
$RE_CHARACTER	= qr@'(?:[^\\']+|\\.)*'@;
$RE_STRING		= qr@"(?:[^\\"]+|\\.)*"@;
$RE_PARAMETER	= '\$\d+';
$RE_IDENTIFIER	= '[a-zA-Z_]\w*';

$RE_COMMENT		= '/\*(?:\*+[^/]|[^*])*\*/';
$RE_CPPCOMMENT	= '//.*$';

foreach (0..255) {
	my $c = chr($_);
	if ($c =~ /$RE_ONECHAR/o) {
		# print "Operator: $c\n";
		$TOKTAB{$c} = $c;
	}
}

# print $RE_OPERATOR, "\n"; # tee hee

sub new {
	my $class = shift;
	my $self = ($#_ == 0) ? { %{ (shift) } } : { @_ };

	my %symtab = map {
		$_ => new Anarres::Mud::Driver::Compiler::Symbol(
						$_, $SYMTAB{$_}, undef,
							)
			} keys %SYMTAB;
	my %typetab = map {
		$_ => new Anarres::Mud::Driver::Compiler::Symbol(
						$_, 'L_BASIC_TYPE', $TYPETAB{$_},
							)
			} keys %TYPETAB;
	my %modtab = map {
		$_ => new Anarres::Mud::Driver::Compiler::Symbol(
						$_, 'L_TYPE_MODIFIER', $MODTAB{$_},
							)
			} keys %MODTAB;

	$self->{Symtab} = { %symtab, %typetab, %modtab, };

	$self->{Text} = 0;
	$self->{Unput} = [ ];

	return bless $self, $class;
}

# sub symbol {
# 	my ($self, $name) = @_;
# 
# 	local *::symtab = $self->{Symtab};
# 	return $::symtab{$name} if $::symtab{$name};
# 
# 	$::symtab{$name} = new Anarres::Mud::Driver::Compiler::Symbol(
# 					$name, 'L_IDENTIFIER'
# 						);
# }

sub unput {
	my $self = shift @_;	# The rest is tokens [ tok, val ]
	# push(@{$self->{Unput}}, @_);
	local *::text = \$self->{Text};
}

sub rewind {
	my ($self, $length) = @_;
	pos($self->{Text}) -= $length;

}

sub from {
	my ($self, $text) = @_;
	$self->{Text} = $text;
	pos($self->{Text}) = 0;
}

sub at {
	my ($self) = @_;
	local *::text = \$self->{Text};
	my $pos = pos($::text);

	$::text =~ /\G\s*(.{24}[^\s]+)\s/msgcx
		or $::text =~ /\G\s*([^\s]+)\s/msgcx;
	my $after = $1;
	pos($::text) = $pos;

	$::text =~ /\s([^\s]+.{10})\s*\G/msgcx
		or $::text =~ /\s([^\s]+)\s*\G/msgcx
			or $::text =~ /([^\s]*)\s*\G/msgcx;
	my $before = $1;
	pos($::text) = $pos;

	my $loc = "$before  <<<HERE>>>  $after";
	$loc =~ s/[\n\t]/ /g;

	return "\n\tfile $self->{File} line $self->{Line}" .
			"\n\t$loc";
}

sub lex {
	my ($self) = @_;

#	if (@{$self->{Unput}}) {
#		my $tok = pop @{$self->{Unput}};
#		return @$tok;
#	}

	local *::text = \$self->{Text};

	SKIP: {
		if ($::text =~ /\G(\s+)/mscg) {
			my $white = $1;
			$white =~ s/[^\n]//g;
			$self->{Line} += length $white;
#			if (length $white) {
#				my $file = $self->{File};
#				$file =~ s,^.*/,,;
#				print "Skip " . length($white) .
#					" lines to $file: $self->{Line}\n"
#			}
		}

		if ($::text =~ m/^\G#\s*(?:line\s*)?/mscg) {
			# Line directives don't count for lines, hence eat the \n
			if ($::text =~ m/\G(\d+)\s*"([^"\n]*)"[^\n]*\n/mscg) {
				$self->{Line} = $1;
				$self->{File} = $2;
				# print "Line directive: $2: $1\n";
			}
			elsif ($::text =~ m/\Gpragma\s*([^\n]*)$/mscg) {
				my @pragmas = split(/\s+/, $1);
				print "Pragma directive: @pragmas\n";
				# $self->pragma(@pragmas);
			}
			else {
				$::text =~ m/\G([^\n]*)$/mscg;
				print "Unrecognised directive: $1\n";
			}
			redo SKIP;
		}

		# XXX Temp
		# redo SKIP if $::text =~ m/\G($RE_COMMENT)/ocg;
		# redo SKIP if $::text =~ m/\G($RE_CPPCOMMENT)/mocg;
	}

	# my $str = substr($::text, pos($::text), 12);
	# $str =~ s/\n/ /g;
	# print "Token hunt from '$str' at " . pos($::text) . "\n";

	return ($TOKTAB{$1}, $1)
			if $::text =~ m/\G($RE_OPERATOR)/ocg;
#	return ($1, $1)
#			if $::text =~ m/\G($RE_ONECHAR)/ocg;
	return ('L_PARAMETER', substr($1, 1))
			if $::text =~ /\G($RE_PARAMETER)/ocg;

	return ('L_HEXINTEGER', hex($1))
			if $::text =~ /\G($RE_HEXINTEGER)/ocg;
	return ('L_INTEGER', $1)
			if $::text =~ /\G($RE_INTEGER)/ocg;
	if ($::text =~ /\G($RE_CHARACTER)/ocg) {
		print "Character match $1\n";
		my $char = unquote(unprintable($1));
		# Die if it's over length.
		return ('L_CHARACTER', ord(substr($char, 1, 1)));
	}

	# XXX Die "invalid integer" if trailing garbage on integer

	return ('L_STRING', unquote(unprintable($1)))
			if $::text =~ /\G($RE_STRING)/ocg;

	if ($::text =~ /\G($RE_IDENTIFIER)/ocg) {
		my $sym = $self->{Symtab}->{$1};
		if ($sym) {
			return ($sym->[SYM_TYPE], $sym->[SYM_VALUE]);
		}
		else {
			return ('L_IDENTIFIER', $1);
		}
	}

	# We can do this last. It's rare.
	return ('', undef) if pos($::text) == length $::text;

	$::text =~ /\G\s*([^\s]+)\s/gc;
	die "Cannot analyse '$1'\n";
	return ('ERROR', $1);
}

sub lex_debug {
	my ($self) = @_;

	my @foo = $self->lex;

	if ($foo[0]) {
		my $type = $foo[0];
		my $text;
		if (!defined $foo[1]) {
			$text = "[undef]";
		}
		elsif (ref($foo[1]) =~ /Symbol$/) {
			$text = $foo[1]->[SYM_TEXT];
		}
		else {
			$text = $foo[1];
		}

		print sprintf("%-20.20s: %s\n", $type, $text);
	}
	else {
		print "EOF\n";
	}

	return @foo;
}

sub analyse {
	my ($self, $text) = @_;
	$self->from($text);

	my $i = 0;

	while (my @foo = $self->lex_debug) {
		last unless $foo[0];
	}
}

1;
