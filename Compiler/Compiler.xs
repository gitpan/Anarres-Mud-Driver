#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "compiler.h"
#include "parser.h"

/* Apparently we are expected to provide this type as named. */

typedef
struct _amd_parser {
	void	*foo;
} *Anarres__Mud__Driver__Compiler;

typedef char *Anarres__Mud__Driver__Compiler__Type;

typedef
struct _keyword_t
{
	char		*keyword;
	int			 token;
	AMD_YYSTYPE	 lval;
}
keyword_t;

#define NOLVAL	{ .number = 0 }

#define define_T_(x) static const char	T_## x[]	= { C_ ## x, 0 }

define_T_(VOID);
// define_T_(NIL);
define_T_(UNKNOWN);
define_T_(BOOL);
define_T_(CLOSURE);
define_T_(INTEGER);
define_T_(OBJECT);
define_T_(STRING);
// define_T_(M_ARRAY);
// define_T_(M_MAPPING);
define_T_(FAILED);

static const char T_ARRAY[]	= { C_M_ARRAY, C_UNKNOWN, 0 };
static const char T_MAPPING[]	= { C_M_MAPPING, C_UNKNOWN, 0 };

static keyword_t keywords[] = {
	{ "bool",		L_BASIC_TYPE,		{ .str = T_BOOL } },
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
	{ "nil",		L_NIL,				NOLVAL },
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

SV *
amd_type_lookup(const char *str)
{
	SV      **svp;

	svp = hv_fetch(amd_typetab, str, strlen(str), FALSE);
	if (svp)
		return *svp;

	croak("Type %s not found in registry!\n", str);
	return &PL_sv_undef;
	return sv_2mortal(sv_bless(
			newRV_noinc(newSVpv(str, 0)),
					gv_stashpv(_AMD "::Compiler::Type", TRUE)));

}


#define CS(x) do { code[0] = C_ ## x; \
			sv = newSVpv(code, 0); \
			sv = newRV_noinc(sv); \
			sv_bless(sv, stash); \
			hv_store(amd_typetab, code, strlen(code), sv, 0); \
			newCONSTSUB(stash, "T_" #x, sv); \
				} while(0);

MODULE = Anarres::Mud::Driver::Compiler	PACKAGE = Anarres::Mud::Driver::Compiler

PROTOTYPES: ENABLE

BOOT:
{
	{
		SV			*sv;
		SV			*pv;
		int			 size;
		int			 i;

		size = sizeof(keywords) / sizeof(keywords[0]);

		/* Don't put this into Perl-space or it can get fucked with. */
		/* One day we might want to allow that. */
		amd_kwtab = newHV();
		amd_lvaltab = newHV();

		for (i = 0; i < size; i++) {
			hv_store(amd_kwtab,
				keywords[i].keyword, strlen(keywords[i].keyword),
				newSViv(keywords[i].token), 0);
			if (keywords[i].lval.number) {
				sv = newSViv(PTR2IV((void *)(&keywords[i].lval) ));
				pv = newRV_noinc(sv);
				hv_store(amd_lvaltab,
					keywords[i].keyword, strlen(keywords[i].keyword),
					pv, 0);
			}
		}
	}

	if (0) {
		AV	*nodetypes;

		nodetypes = get_av(_AMD "::Compiler::Node::NODETYPES", FALSE);
		if (!nodetypes)
			croak("No nodetypes!\n");
	}

	{
		HV	*stash;
		SV	*sv;
		char code[2];

		printf("Creating constant subs for type\n");

		stash = gv_stashpv(_AMD "::Compiler::Type", TRUE);
		code[1] = '\0';

		amd_typetab = newHV();

		CS(VOID);
		CS(NIL);
		CS(UNKNOWN);
		CS(BOOL);
		CS(CLOSURE);
		CS(INTEGER);
		CS(OBJECT);
		CS(STRING);
		CS(M_ARRAY);
		CS(M_MAPPING);
		CS(M_CLASS);

		CS(FAILED);

		sv = sv_bless(newRV_noinc(newSVpv(T_ARRAY, 2)), stash);
		hv_store(amd_typetab, T_ARRAY, strlen(T_ARRAY), sv, 0);
		newCONSTSUB(stash, "T_ARRAY", sv);

		sv = sv_bless(newRV_noinc(newSVpv(T_MAPPING, 2)), stash);
		hv_store(amd_typetab, T_MAPPING, strlen(T_MAPPING), sv, 0);
		newCONSTSUB(stash, "T_MAPPING", sv);
	}

	{
		/* And having set up much of the 'type' stuff: */
		amd_require(_AMD "::Compiler::Type");
		amd_require(_AMD "::Compiler::Node");
		amd_require(_AMD "::Program");
	}
}

Anarres::Mud::Driver::Compiler
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
		amd_yyparser_parse(prog, str);
		RETVAL = 0;
	OUTPUT:
		RETVAL

void
DESTROY(self)
	Anarres::Mud::Driver::Compiler	self
	CODE:
		Safefree(self);

MODULE = Anarres::Mud::Driver::Compiler	PACKAGE = Anarres::Mud::Driver::Compiler::Type

void
compatible(self, arg)
	Anarres::Mud::Driver::Compiler::Type	self
	Anarres::Mud::Driver::Compiler::Type	arg
	CODE:
		{
			/* This actually returns a boolean */

			if (!*arg)
				croak("arg is not a valid type: it is empty");

			while (*self) {
				if (*arg == *self) {
					self++;
					arg++;
					continue;
				}
				else if (*arg == C_UNKNOWN) {
					XSRETURN_YES;
				}
				else {	/* Including !*arg */
					XSRETURN_NO;
				}
			}

			/* If we get here, then the two types were identical.
			 * However, a class name may be an initial substring of
			 * another class name, therefore we must check identity
			 * here. */

			if (*arg)
				XSRETURN_NO;

			XSRETURN_YES;
		}

SV *
unify(self, arg)
	Anarres::Mud::Driver::Compiler::Type	self
	Anarres::Mud::Driver::Compiler::Type	arg
	CODE:
		{
			int		 len;
			SV		*out;

			len = 0;
			while (self[len]) {
				if (self[len] == arg[len])
					len++;
				else
					break;
			}

			if (self[len] == C_NIL) {
				/* Anything unifies with a 'nil' */
				out = newSVpv(arg, 0);
			}
			else if (arg[len] == C_NIL) {
				/* Anything unifies with a 'nil' */
				out = newSVpv(self, 0);
			}
			else if ((arg[len] == C_BOOL || arg[len] == C_INTEGER) &&
					(self[len] == C_BOOL || self[len] == C_INTEGER)) {
				out = newSVpvn(self, len);
				sv_catpvn(out, T_INTEGER, strlen(T_INTEGER));
			}
			else if (!self[len]) {
				/* The two types were equal? Or the serialised
				 * class 'self' was a substring of 'arg', which is
				 * probably also fine depending on the format. */
				out = newSVpvn(self, len);
			}
			else {
				out = newSVpvn(self, len);
				/* This is not correct for a class. */
				sv_catpvn(out, T_UNKNOWN, strlen(T_UNKNOWN));
			}

			RETVAL = sv_bless(newRV_noinc(out),
							gv_stashpv(_AMD "::Compiler::Type", TRUE));
		}
	OUTPUT:
		RETVAL
