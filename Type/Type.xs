#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "amd.h"

#define CS(x) do { SV *sv = newSVpv(T_ ## x, 1); \
			sv = newRV_noinc(sv); \
			sv_bless(sv, stash); \
			hv_store(amdp_typetab, T_ ## x, 1, sv, 0); \
			newCONSTSUB(stash, #x, sv); \
				} while(0);

static HV *amdp_typetab;

SV *
amdp_type_lookup(char *str)
{
	SV	**svp;

	svp = hv_fetch(amdp_typetab, str, strlen(str), FALSE);
	if (svp)
		return *svp;
	return &PL_sv_undef;
}

MODULE = Anarres::Mud::Driver::Program::Type PACKAGE = Anarres::Mud::Driver::Program::Type

PROTOTYPES: ENABLE

BOOT:
{
	HV	*stash = gv_stashpv(_AMD "::Program::Type", TRUE);

	amdp_typetab = newHV();

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

	printf("AMDP::Type loaded\n");
	fflush(stdout);

	amdp_type_lookup(T_ARRAY);
}

SV *
compatible(self, arg)
	char *	self
	char *	arg
	CODE:
		{
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

			/* If we get here, then the two types were identical
			 * since no valid type is an initial substring of
			 * another valid type. */

			XSRETURN_YES;
		}
