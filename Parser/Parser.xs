#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "lexer.h"
#include "parser.h"

/* Apparently we are expected to provide this type as named. */

typedef
struct _amd_parser {
	void	*foo;
} *Anarres__Mud__Driver__Compiler__Parser;

typedef
struct _keyword_t
{
	char			*keyword;
	int				 token;
	AMDP_YYSTYPE	 lval;
}
keyword_t;

#define NOLVAL	{ .number = 0 }

static keyword_t keywords[] = {
	{ "break",		L_BREAK,			NOLVAL },
	{ "case",		L_CASE,				NOLVAL },
	{ "class",		L_CLASS,			NOLVAL },
	{ "continue",	L_CONTINUE,			NOLVAL },
	{ "default",	L_DEFAULT,			NOLVAL },
	{ "do",			L_DO,				NOLVAL },
	{ "efun",		L_EFUN,				NOLVAL },
	{ "else",		L_ELSE,				NOLVAL },
	{ "for",		L_FOR,				NOLVAL },
	{ "foreach",	L_FOREACH,			NOLVAL },
	{ "function",	L_BASIC_TYPE,		{ .str = T_CLOSURE } },
	{ "if",			L_IF,				NOLVAL },
	{ "in",			L_IN,				NOLVAL },
	{ "inherit",	L_INHERIT,			NOLVAL },
	{ "int",		L_BASIC_TYPE,		{ .str = T_INTEGER } },
	{ "mapping",	L_BASIC_TYPE,		{ .str = T_MAPPING } },
	{ "mixed",		L_BASIC_TYPE,		{ .str = T_UNKNOWN } },
	{ "new",		L_NEW,				NOLVAL },
	{ "nomask",		L_TYPE_MODIFIER,	NOLVAL },
	{ "nosave",		L_TYPE_MODIFIER,	NOLVAL },
	{ "object",		L_BASIC_TYPE,		{ .str = T_OBJECT } },
	{ "private",	L_TYPE_MODIFIER,	NOLVAL },
	{ "protected",	L_TYPE_MODIFIER,	NOLVAL },
	{ "public",		L_TYPE_MODIFIER,	NOLVAL },
	{ "return",		L_RETURN,			NOLVAL },
	{ "rlimits",	L_RLIMITS,			NOLVAL },
	{ "sscanf",		L_SSCANF,			NOLVAL },
	{ "string",		L_BASIC_TYPE,		{ .str = T_STRING } },
	// { "static",		L_TYPE_MODIFIER,	NOLVAL },
	{ "switch",		L_SWITCH,			NOLVAL },
	{ "varargs",	L_TYPE_MODIFIER,	NOLVAL },
	{ "virtual",	L_TYPE_MODIFIER,	NOLVAL },
	{ "void",		L_VOID,				{ .str = T_VOID } },
	{ "while",		L_WHILE,			NOLVAL },
};

/* There must be a function to do this already? */
void
amdp_require(const char *package)
{
	char	 buf[512];
	char	*rp;
	char	*wp;
	SV		*sv;

	/* Leave space for ".pm" */
	strncpy(buf, package, 509);
	buf[509] = '\0';

	rp = buf;
	wp = buf;
	while (*rp) {
		if (*rp == ':' && *(rp + 1) == ':') {
			*wp++ = '/';
			rp++;
			if (!*rp)
				break;
			rp++;
		}
		else {
			*wp++ = *rp++;
		}
	}
	*wp = '\0';
	strcat(buf, ".pm");

	require_pv(buf);

	sv = get_sv("@", FALSE);
	if (SvTRUE(sv)) {
		croak("require_pv(%s = %s): %s\n",
						package, buf, SvPV_nolen(sv));
	}
}

void
amdp_dump(const char *prefix, SV *sv)
{
	dSP;
	int	 count;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv);
	PUTBACK;
	count = call_pv("Data::Dumper::Dumper", G_SCALAR);
	SPAGAIN;
	if (count != 1)
		croak("Didn't get a return value from Dumper\n");
	printf("%s: %s\n", prefix, POPp);
	fflush(stdout);
	PUTBACK;
	FREETMPS;
	LEAVE;
}

void
amdp_peek(const char *prefix, SV *sv)
{
	dSP;
	int	 count;

	printf("Peeking at %s\n", prefix);
	fflush(stdout);

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv);
	PUTBACK;
	count = call_pv("Devel::Peek::Dump", G_DISCARD);
	FREETMPS;
	LEAVE;
}

MODULE = Anarres::Mud::Driver::Compiler::Parser	PACKAGE = Anarres::Mud::Driver::Compiler::Parser

PROTOTYPES: ENABLE

BOOT:
{
	amdp_require("Data::Dumper");
	amdp_require("Devel::StackTrace");
	amdp_require("Devel::Peek");
	amdp_require(_AMD "::Program");
	amdp_require(_AMD "::Program::Node");
	// amdp_require(_AMD "::Program::Type");

	{
		SV			*sv;
		SV			*pv;
		int			 size;
		int			 i;

		size = sizeof(keywords) / sizeof(keywords[0]);

		/* Don't put this into Perl-space or it can get fucked with. */
		/* One day we might want to allow that. */
		amdp_kwtab = newHV();
		amdp_lvaltab = newHV();

		for (i = 0; i < size; i++) {
			hv_store(amdp_kwtab,
				keywords[i].keyword, strlen(keywords[i].keyword),
				newSViv(keywords[i].token), 0);
			if (keywords[i].lval.number) {
				sv = newSViv(PTR2IV((void *)(&keywords[i].lval) ));
				pv = newRV_noinc(sv);
				hv_store(amdp_lvaltab,
					keywords[i].keyword, strlen(keywords[i].keyword),
					pv, 0);
			}
		}
	}

	{
		AV	*nodetypes;

		nodetypes = get_av(_AMD "::Program::Node::NODETYPES", 0);
		if (!nodetypes)
			croak("No nodetypes!\n");
	}
}

Anarres::Mud::Driver::Compiler::Parser
new(class)
	SV *	class
	CODE:
		RETVAL = Newz(0, RETVAL, 1, struct _amd_parser);
	OUTPUT:
		RETVAL

int
lex(class, str)
	SV *	class
	char *	str
	CODE:
		test_lexer(str);
		RETVAL = 0;
	OUTPUT:
		RETVAL

int
parse(class, prog, str)
	SV *	class
	SV *	prog
	char *	str
	CODE:
		amdp_yyparser_parse(prog, str);
		RETVAL = 0;
	OUTPUT:
		RETVAL

void
DESTROY(self)
	Anarres::Mud::Driver::Compiler::Parser	self
	CODE:
		Safefree(self);
