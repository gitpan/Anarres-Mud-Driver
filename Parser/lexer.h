#ifndef __LEXER_H__
#define __LEXER_H__

#include <stdarg.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "amd.h"

	/* Provided by Parser.xs */
void amdp_dump(const char *prefix, SV *sv);
void amdp_peek(const char *prefix, SV *sv);
void amdp_require(const char *package);

HV		*amdp_kwtab;
HV		*amdp_lvaltab;



	/* Provided by lexer.yy */
void amdp_yylex_init(const char *str);
void amdp_yyunput_map_end();
void amdp_yywarnv(const char *fmt, va_list args);
void amdp_yywarnf(const char *fmt, ...)
				__attribute__((format(printf, 1, 2)));
void amdp_yyerror(const char *str);
void amdp_yyerrorf(const char *str, ...)
				__attribute__((format(printf, 1, 2)));



	/* Provided by parser.y */
const char * amdp_yytokname(int i);
int amdp_yyparser_parse(SV *program, const char *str);

typedef struct __amdp_parse_param_t {
	SV	*program;
	HV	*symtab;
} amdp_parse_param_t;

#define AMDP_PROGRAM(x) (((amdp_parse_param_t *)(x))->program)


	/* Random others */
int test_lexer(const char *str);

#endif
