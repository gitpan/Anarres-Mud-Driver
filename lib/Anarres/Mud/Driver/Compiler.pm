package Anarres::Mud::Driver::Compiler;

use strict;
use vars qw(@ISA @EXPORT_OK);
use Storable;
use Data::Dumper;

BEGIN {
	use Anarres::Mud::Driver::Compiler::Preprocess;
	@ISA = qw(Anarres::Mud::Driver::Compiler::Preprocess);
	@EXPORT_OK = qw($COMPILER $LEXER $PROGRAM);	# dynamic scope
}

use Anarres::Mud::Driver;
use Anarres::Mud::Driver::Compiler::Preprocess;
use Anarres::Mud::Driver::Compiler::Parse;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{Lexer} = new Anarres::Mud::Driver::Compiler::Lex;
	$self->{Parser} = new Anarres::Mud::Driver::Compiler::Parse;
	return $self;
}

sub parse {
	my ($self, $prog) = @_;
	$self->{Lexer}->from($prog->ppsource);
	eval { $self->{Parser}->yyparse($prog, $self->{Lexer}); };
	if ($@) {
		my $at = $self->{Lexer}->at;
		print "Parse error: $at\n$@";
		return undef;
	}
	return 1;
}

sub save {
	my ($self, $prog, $file) = @_;
	store $prog, $file;
	return 1;
}

sub load {
	my ($self, $prog, $file) = @_;
	$prog = retrieve($file);
	return $prog;
}

# XXX Paths may not contain any of : or '

sub compile {
	my ($self, $path) = @_;

	die "Invalid path - contains ' or :"
					if $path =~ /[:']/;

	my $diskpath = "/home/anarres/mudlib" . $path;

	my $text = $self->file($diskpath);

	my $pptext = $self->preprocess($text, $diskpath);

	my $prog;

	my @cppm = stat("Compiler/Parse.pm");
	my @cpyp = stat("Compiler/Parse.yp");
	if ($cppm[9] < $cpyp[9]) {
		die "Please rebuild Parse.yp first!";
	}

	my @cppt = stat("parsetree");
	if ($cppm[9] > $cppt[9]) {
	# if (0) {
		# Hack hack
		$prog = new Anarres::Mud::Driver::Program(
						Path		=> $path,
						DiskPath	=> $diskpath,
						Source		=> $text,
						PPSource	=> $pptext,
							);

		return "Parse failure" unless $self->parse($prog);

		if (!ref($prog)) {
			print "Program not reference:\n" . $prog;
			return undef;
		}
		$self->save($prog, 'parsetree');
	}
	else {
		$prog = $self->load($prog, 'parsetree');
	}

	# print $prog->dump, "\n";

	$prog->typecheck;

	# print $prog->dump, "\n";

	print "\n\n---\n\n";

	my $perl = $prog->generate($path);

	# return $perl;
}

sub file {
	my ($self, $path) = @_;
	# Look for master and ask?

	# $path = "source.lpc";	# XXX Temporary

	open(DATA, $path) or die "Can't open $path: $!";
	local $/ = undef;
	my $t = <DATA>;
	close(DATA);
	# print "Analyse: $t\n";

	# Other predefines?
	return 
			"#define __AMD__ 1\n" .
			"#define __PORT__ 5000\n" . 
			"#define MUD_NAME \"AnarresPerl\"\n" . 
			"#include <global.h>\n" .
			"# 1 \"$path\"\n" .
			$t;
}

1;
