require 5.006001;
use ExtUtils::MakeMaker;

my @base = qw(lexer parser Parser);
my @obj = map { "$_\.o" } @base;
my @src = map { "$_\.c" } @base;
my @hdr = qw(lexer.h parser.h);

WriteMakefile(
    NAME			=> 'Anarres::Mud::Driver::Compiler::Parser',
    VERSION_FROM	=> 'Parser.pm', # finds $VERSION
    AUTHOR			=> 'Shevek (cpan@anarres.org)',
	INC				=> '-I../include',
	OBJECT			=> "@obj",
	C				=> \@src,
	H				=> \@hdr,

	clean			=> {
				FILES	=> "lex.yy.c lexer.c " .
							"parser.output parser.tab.[ch] parser.[ch]",
						},
);

sub MY::postamble {
	my $self = shift;
	my $old = $self->MM::postamble(@_);
	chomp($old);

	my $lex = $ENV{LEX} || 'flex';
	my $yacc = $ENV{YACC} || 'bison';

	my $new = <<"EON";

LEX = $lex
YACC = $yacc
EON
	$new .= <<'EON';

lexer.c : lexer.yy
	$(LEX) $<
	$(PERL) symchange.pl lex.yy.c > lexer.c
	$(RM_F) lex.yy.c

parser.c parser.h : parser.y
	$(YACC) -vd parser.y
	$(PERL) symchange.pl parser.tab.c > parser.c
	$(PERL) symchange.pl parser.tab.h > parser.h
	$(RM_F) parser.tab.[ch]

AmdpLexer.cc : AmdpLexer.yy
	$(LEX) -o$@ $<

dep : $(C_FILES) $(H_FILES)
	$(RM_F) .depend
	$(CC) -MM $(INC) -I$(PERL_INC) $(CCFLAGS) $(C_FILES) >> .depend

include .depend

config :: $(C_FILES)

EON
	return $old . $new;
}
