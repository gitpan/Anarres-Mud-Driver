#ifndef __AMDP_COMPILER_H__
#define __AMDP_COMPILER_H__

#include <stdarg.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "amd.h"


#define C_VOID			'v'
#define C_NIL			'n'
#define C_UNKNOWN		'?'
#define C_BOOL			'b'
#define C_CLOSURE		'f'
#define C_INTEGER		'i'
#define C_OBJECT		'o'
#define C_STRING		's'
#define C_M_CLASS		'$'
#define C_M_ARRAY		'*'
#define C_M_MAPPING		'#'

#define C_FAILED		'!'



	/* Provided by utils.c */
void amd_dump(const char *prefix, SV *sv);
void amd_peek(const char *prefix, SV *sv);
void amd_require(const char *package);



	/* Provided by Compiler.xs */
SV *amd_type_lookup(const char *str);

HV		*amd_kwtab;
HV		*amd_lvaltab;
HV		*amd_typetab;



	/* Provided by lexer.yy */
void amd_yylex_init(const char *str);
void amd_yyunput_map_end();
void amd_yywarnv(const char *fmt, va_list args);
void amd_yywarnf(const char *fmt, ...)
				__attribute__((format(printf, 1, 2)));
void amd_yyerror(const char *str);
void amd_yyerrorf(const char *str, ...)
				__attribute__((format(printf, 1, 2)));



	/* Provided by parser.y */
const char * amd_yytokname(int i);
int amd_yyparser_parse(SV *program, const char *str);

typedef struct __amd_parse_param_t {
	SV	*program;
	HV	*symtab;
} amd_parse_param_t;

#define AMDP_PROGRAM(x) (((amd_parse_param_t *)(x))->program)


	/* Random others */
int test_lexer(const char *str);

#endif
