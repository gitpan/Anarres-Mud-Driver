#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include "type.h"

/* Apparently we are expected to provide this type as named. */

typedef char *Anarres__Mud__Driver__Compiler__Type;

HV			*amd_typecache;

#define define_T_(x) static const char	T_## x[]	= { C_ ## x, 0 }

// define_T_(VOID);
// define_T_(NIL);
define_T_(UNKNOWN);
// define_T_(BOOL);
// define_T_(CLOSURE);
define_T_(INTEGER);
// define_T_(OBJECT);
// define_T_(STRING);
// define_T_(M_ARRAY);
// define_T_(M_MAPPING);
// define_T_(FAILED);

static const char T_ARRAY[]	= { C_M_ARRAY, C_UNKNOWN, 0 };
static const char T_MAPPING[]	= { C_M_MAPPING, C_UNKNOWN, 0 };
static const char T_M_ENDCLASS[] = { C_M_ENDCLASS, 0 };

SV *
amd_type_new(const char *str)
{
	SV      **svp;
	SV		 *sv;
	SV		 *bsv;
	STRLEN	  len;

	len = strlen(str);

	svp = hv_fetch(amd_typecache, str, len, FALSE);
	if (svp)
		return *svp;

	sv = newSVpvn(str, len);
	bsv = sv_bless(
			newRV_noinc(sv),
					gv_stashpv(_AMD "::Compiler::Type", TRUE));
	hv_store(amd_typecache, str, len, bsv, 0);
	return bsv;
}

#define TYPE_CS(x) do { code[0] = C_ ## x; \
			sv = amd_type_new(code); \
			newCONSTSUB(stash, "T_" #x, sv); \
			av_push(export, newSVpv("T_" #x, strlen(#x) + 2)); \
				} while(0)

#define STR_CS(x) do { code[0] = C_ ## x; \
			newCONSTSUB(stash, "T_" #x, newSVpvn(code, 1)); \
			av_push(export, newSVpv("T_" #x, strlen(#x) + 2)); \
				} while(0)

#define VAR_CS(x) do { \
			newCONSTSUB(stash, #x, newSViv(x)); \
			av_push(export, newSVpv(#x, strlen(#x))); \
				} while(0)

MODULE = Anarres::Mud::Driver::Compiler	PACKAGE = Anarres::Mud::Driver::Compiler

PROTOTYPES: ENABLE

BOOT:
{
	{
		amd_typecache = get_hv(_AMD "::Compiler::Type::CACHE", TRUE);
	}

	{
		HV	*stash;
		AV	*export;
		SV	*sv;
		char code[2];

		// fprintf(stderr, _AMD "::Compiler::Type: Building %%CACHE\n");

		stash = gv_stashpv(_AMD "::Compiler::Type", TRUE);
		export = get_av(_AMD "::Compiler::Type::EXPORT", TRUE);
		code[1] = '\0';

		TYPE_CS(VOID);
		TYPE_CS(NIL);
		TYPE_CS(UNKNOWN);
		TYPE_CS(BOOL);
		TYPE_CS(CLOSURE);
		TYPE_CS(INTEGER);
		TYPE_CS(OBJECT);
		TYPE_CS(STRING);

		TYPE_CS(FAILED);

		sv = amd_type_new(T_ARRAY);
		newCONSTSUB(stash, "T_ARRAY", sv);
		av_push(export, newSVpv("T_ARRAY", strlen("T_ARRAY")));

		sv = amd_type_new(T_MAPPING);
		newCONSTSUB(stash, "T_MAPPING", sv);
		av_push(export, newSVpv("T_MAPPING", strlen("T_MAPPING")));

		STR_CS(M_ARRAY);
		STR_CS(M_MAPPING);
		STR_CS(M_BEGINCLASS);
		STR_CS(M_ENDCLASS);

	}
	
	{
		HV	*stash;
		AV	*export;

		stash = gv_stashpv(_AMD "::Compiler::Type", TRUE);
		export = get_av(_AMD "::Compiler::Type::EXPORT", TRUE);

		VAR_CS(M_NOMASK);
		VAR_CS(M_NOSAVE);
		VAR_CS(M_STATIC);
		VAR_CS(M_PRIVATE);
		VAR_CS(M_PROTECTED);
		VAR_CS(M_PUBLIC);
		VAR_CS(M_VARARGS);
		VAR_CS(M_EFUN);
		VAR_CS(M_APPLY);
		VAR_CS(M_INHERITED);
		VAR_CS(M_HIDDEN);
		VAR_CS(M_UNKNOWN);
		VAR_CS(M_PURE);
	}
}

MODULE = Anarres::Mud::Driver::Compiler::Type	PACKAGE = Anarres::Mud::Driver::Compiler::Type

SV *
new(self, code)
	SV *	self
	char *	code
	CODE:
		RETVAL = amd_type_new(code);
		/* This is automatically mortalised, which isn't strictly
		 * necessary since we know that we always have a ref to it. */
		SvREFCNT_inc(RETVAL);
	OUTPUT:
		RETVAL

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
					/* We can assign anything to a mixed. */
					XSRETURN_YES;
				}
				else if (*self == C_NIL) {
					/* We can assign a NIL to anything. */
					XSRETURN_YES;
				}
				else if (*self == C_BOOL && *arg == C_INTEGER) {
					/* We can assign a BOOL to INTEGER */
					XSRETURN_YES;
				}
#if 0
				else if (*self == C_M_ENDCLASS) {
					int	 depth;
					/* We can just drop the rest of the input data */
					self++;
					arg++;
					depth = 0;
					while (depth > -1) {
						if (*arg == C_M_BEGINCLASS)
							depth++;
						else if (*arg == C_M_ENDCLASS)
							depth--;
						arg++;
					}
				}
#endif
				else {	/* Including !*arg, which should never happen */
					XSRETURN_NO;
				}
			}

			/* If we get here, then the two types were identical.
			 * However, a class name may be an initial substring of
			 * another class name, therefore we must check identity
			 * here. */
			/* Actually, it can't be since classes are in braces */

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
			int		 depth;
			char	 incomplete;

			len = 0;
			depth = 0;
			incomplete = 1;	/* We haven't got anything yet */
			while (self[len]) {
				if (self[len] != arg[len])
					break;
				if (self[len] == C_M_BEGINCLASS)
					depth++;
				else if (self[len] == C_M_ENDCLASS)
					{ depth--; incomplete = 0; }
				else if (self[len] == C_M_MAPPING)
					incomplete = 1;
				else if (self[len] == C_M_ARRAY)
					incomplete = 1;
				else
					incomplete = 0;
				len++;
			}

			/* Now we have to exploit that information. */
			/* XXX I'm not at all sure that the use of 'incomplete'
			 * is bug free; we might need a couple of extra cases
			 * in this conditional to deal with entering and leaving
			 * classes. */

			if (!self[len]) {
				/* The two types were equal. */
				out = newSVpvn(self, len);
			}
			else if (self[len] == C_NIL) {
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
				/* We might still be in a class. */
				while (depth--)
					sv_catpvn(out, T_M_ENDCLASS, 1);
			}
			else {
				out = newSVpvn(self, len);
				/* If the last matched character was { } * or # */
				if (incomplete)
					sv_catpvn(out, T_UNKNOWN, strlen(T_UNKNOWN));
				while (depth--)
					sv_catpvn(out, T_M_ENDCLASS, 1);
			}

			RETVAL = amd_type_new(SvPV_nolen(out));
			SvREFCNT_inc(RETVAL);
			SvREFCNT_dec(out);
		}
	OUTPUT:
		RETVAL
