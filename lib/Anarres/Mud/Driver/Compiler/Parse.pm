####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Anarres::Mud::Driver::Compiler::Parse;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "Parse.yp"

# Use: yapp -m 'Anarres::Mud::Driver::Compiler::Parse' \
# 		-o Parse.pm Parse.yp
# to generate the Parse module.
#line 7 "Parse.yp"

use strict;
use Data::Dumper;
use Anarres::Mud::Driver::Compiler::Lex qw(%TYPETAB);
use Anarres::Mud::Driver::Program::Variable;
use Anarres::Mud::Driver::Program::Method;
use Anarres::Mud::Driver::Program::Node qw(@NODETYPES);

sub PROG_INHERITS	() { 0 }
sub PROG_GLOBALS	() { 1 }
sub PROG_FUNCTIONS	() { 2 }

# This will not be on the exam.
BEGIN {
	no strict qw(refs);
	my $package = __PACKAGE__;
	foreach (@NODETYPES) {
		# print " $_";
		# We don't necessarily call all of these in the tree -
		# only the generic type (nonsemantic) nodes.
		my $subname = "n_" . lc $_;
		eval qq{
			sub $subname {
				new Anarres::Mud::Driver::Program::Node::$_(\@_);
			}
		}; die $@ if $@;
	}
	# print "\n";
}



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -3,
		GOTOS => {
			'all' => 1,
			'program' => 2
		}
	},
	{#State 1
		ACTIONS => {
			'' => 3
		}
	},
	{#State 2
		ACTIONS => {
			'' => -1,
			'L_TYPE_MODIFIER' => 7,
			'L_INHERIT' => 4
		},
		DEFAULT => -155,
		GOTOS => {
			'function' => 8,
			'type_modifier_list' => 10,
			'global_decl' => 9,
			'prototype' => 11,
			'inheritance' => 5,
			'definition' => 12,
			'function_prologue' => 6
		}
	},
	{#State 3
		DEFAULT => -0
	},
	{#State 4
		ACTIONS => {
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_INTEGER' => 15
		},
		GOTOS => {
			'string' => 13,
			'integer' => 14,
			'string_const' => 16
		}
	},
	{#State 5
		DEFAULT => -4
	},
	{#State 6
		ACTIONS => {
			"{" => 21,
			";" => 20
		},
		GOTOS => {
			'block' => 22
		}
	},
	{#State 7
		ACTIONS => {
			'L_TYPE_MODIFIER' => 7
		},
		DEFAULT => -155,
		GOTOS => {
			'type_modifier_list' => 23
		}
	},
	{#State 8
		DEFAULT => -6
	},
	{#State 9
		DEFAULT => -5
	},
	{#State 10
		ACTIONS => {
			'L_BASIC_TYPE' => 24,
			'L_VOID' => 26
		},
		GOTOS => {
			'type_specifier' => 25
		}
	},
	{#State 11
		DEFAULT => -7
	},
	{#State 12
		DEFAULT => -2
	},
	{#State 13
		ACTIONS => {
			'L_STRING' => 27
		},
		DEFAULT => -162
	},
	{#State 14
		DEFAULT => -165
	},
	{#State 15
		DEFAULT => -168
	},
	{#State 16
		ACTIONS => {
			"." => 30,
			"+" => 28,
			";" => 29
		}
	},
	{#State 17
		DEFAULT => -166
	},
	{#State 18
		DEFAULT => -170
	},
	{#State 19
		DEFAULT => -169
	},
	{#State 20
		DEFAULT => -19
	},
	{#State 21
		DEFAULT => -21,
		GOTOS => {
			'@1-1' => 31
		}
	},
	{#State 22
		DEFAULT => -20
	},
	{#State 23
		DEFAULT => -156
	},
	{#State 24
		DEFAULT => -157
	},
	{#State 25
		DEFAULT => -159,
		GOTOS => {
			'variable_declarator_list' => 34,
			'star_list' => 33,
			'function_declarator' => 32,
			'variable_declarator' => 35
		}
	},
	{#State 26
		DEFAULT => -158
	},
	{#State 27
		DEFAULT => -167
	},
	{#State 28
		ACTIONS => {
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_INTEGER' => 15
		},
		GOTOS => {
			'string' => 13,
			'integer' => 14,
			'string_const' => 36
		}
	},
	{#State 29
		DEFAULT => -8
	},
	{#State 30
		ACTIONS => {
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_INTEGER' => 15
		},
		GOTOS => {
			'string' => 13,
			'integer' => 14,
			'string_const' => 37
		}
	},
	{#State 31
		DEFAULT => -145,
		GOTOS => {
			'local_decls' => 38
		}
	},
	{#State 32
		DEFAULT => -18
	},
	{#State 33
		ACTIONS => {
			"*" => 39,
			'L_IDENTIFIER' => 41,
			"#" => 40
		},
		GOTOS => {
			'identifier' => 42
		}
	},
	{#State 34
		ACTIONS => {
			";" => 43,
			"," => 44
		}
	},
	{#State 35
		DEFAULT => -12
	},
	{#State 36
		DEFAULT => -164
	},
	{#State 37
		ACTIONS => {
			"+" => 28
		},
		DEFAULT => -163
	},
	{#State 38
		ACTIONS => {
			'L_VOID' => 26,
			'L_BASIC_TYPE' => 24
		},
		DEFAULT => -22,
		GOTOS => {
			'@2-3' => 47,
			'local_decl' => 45,
			'type_specifier' => 46
		}
	},
	{#State 39
		DEFAULT => -160
	},
	{#State 40
		DEFAULT => -161
	},
	{#State 41
		DEFAULT => -9
	},
	{#State 42
		ACTIONS => {
			"(" => 48
		},
		DEFAULT => -11
	},
	{#State 43
		DEFAULT => -144
	},
	{#State 44
		DEFAULT => -159,
		GOTOS => {
			'star_list' => 49,
			'variable_declarator' => 50
		}
	},
	{#State 45
		DEFAULT => -146
	},
	{#State 46
		DEFAULT => -159,
		GOTOS => {
			'variable_declarator_list_init' => 51,
			'variable_declarator_init' => 52,
			'star_list' => 49,
			'variable_declarator' => 53
		}
	},
	{#State 47
		ACTIONS => {
			'L_DEFAULT' => -24,
			'L_MAP_START' => -24,
			"\$" => -24,
			'L_STRING' => -24,
			'L_DO' => -24,
			"(" => -24,
			'L_RETURN' => -24,
			'L_INTEGER' => -24,
			";" => -24,
			'L_RLIMITS' => -24,
			"{" => -24,
			'error' => 54,
			"}" => -24,
			'L_FOREACH' => -24,
			'L_CONTINUE' => -24,
			'L_INC' => -24,
			'L_COLONCOLON' => -24,
			"!" => -24,
			'L_FOR' => -24,
			'L_WHILE' => -24,
			'L_CHARACTER' => -24,
			'L_CASE' => -24,
			'L_ARRAY_START' => -24,
			'L_BREAK' => -24,
			'L_NIL' => -24,
			'L_IF' => -24,
			'L_SSCANF' => -24,
			'L_EFUN' => -24,
			"+" => -24,
			"-" => -24,
			'L_HEXINTEGER' => -24,
			'L_CATCH' => -24,
			'L_DEC' => -24,
			'L_IDENTIFIER' => -24,
			'L_PARAMETER' => -24,
			'L_FUNCTION_START' => -24,
			'L_TRY' => -24,
			"~" => -24,
			'L_SWITCH' => -24
		},
		GOTOS => {
			'statement_list' => 55
		}
	},
	{#State 48
		ACTIONS => {
			'L_BASIC_TYPE' => 24,
			'L_VOID' => 60
		},
		DEFAULT => -148,
		GOTOS => {
			'arguments' => 56,
			'type_specifier' => 57,
			'argument_list' => 58,
			'argument' => 59
		}
	},
	{#State 49
		ACTIONS => {
			"*" => 39,
			'L_IDENTIFIER' => 41,
			"#" => 40
		},
		GOTOS => {
			'identifier' => 61
		}
	},
	{#State 50
		DEFAULT => -13
	},
	{#State 51
		ACTIONS => {
			";" => 62,
			"," => 63
		}
	},
	{#State 52
		DEFAULT => -16
	},
	{#State 53
		ACTIONS => {
			"=" => 64
		},
		DEFAULT => -14
	},
	{#State 54
		ACTIONS => {
			";" => 65
		}
	},
	{#State 55
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			"}" => 81,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			"~" => 116,
			'L_TRY' => 115,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'compare_exp' => 93,
			'logical_exp' => 92,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 77,
			'postfix_exp' => 109,
			'exp' => 108,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 56
		ACTIONS => {
			")" => 118
		}
	},
	{#State 57
		DEFAULT => -159,
		GOTOS => {
			'star_list' => 49,
			'variable_declarator' => 119
		}
	},
	{#State 58
		ACTIONS => {
			'L_ELLIPSIS' => 121,
			"," => 120
		},
		DEFAULT => -150
	},
	{#State 59
		DEFAULT => -152
	},
	{#State 60
		ACTIONS => {
			")" => -149
		},
		DEFAULT => -158
	},
	{#State 61
		DEFAULT => -11
	},
	{#State 62
		DEFAULT => -147
	},
	{#State 63
		DEFAULT => -159,
		GOTOS => {
			'variable_declarator_init' => 122,
			'star_list' => 49,
			'variable_declarator' => 53
		}
	},
	{#State 64
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 123,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 65
		DEFAULT => -26
	},
	{#State 66
		ACTIONS => {
			":" => 125
		}
	},
	{#State 67
		ACTIONS => {
			'L_RSH' => 126,
			"%" => 129,
			"*" => 127,
			"+" => 130,
			'L_LSH' => 131,
			"-" => 132,
			"." => 128,
			"/" => 133
		},
		DEFAULT => -97
	},
	{#State 68
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -70,
		GOTOS => {
			'assoc_arg_list' => 134,
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'opt_assoc_arg_list_comma' => 135,
			'closure' => 104,
			'integer' => 105,
			'assoc_exp' => 136,
			'exp' => 137,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 69
		ACTIONS => {
			"(" => 138
		}
	},
	{#State 70
		DEFAULT => -123
	},
	{#State 71
		DEFAULT => -30,
		GOTOS => {
			'@3-1' => 139
		}
	},
	{#State 72
		DEFAULT => -104
	},
	{#State 73
		DEFAULT => -78
	},
	{#State 74
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 140,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 75
		ACTIONS => {
			'L_STRING' => 27
		},
		DEFAULT => -129
	},
	{#State 76
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -58,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 142,
			'closure' => 104,
			'integer' => 105,
			'opt_nv_list_exp' => 141,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 77
		DEFAULT => -25
	},
	{#State 78
		DEFAULT => -50
	},
	{#State 79
		ACTIONS => {
			"(" => 144
		}
	},
	{#State 80
		ACTIONS => {
			"(" => 145
		}
	},
	{#State 81
		DEFAULT => -23
	},
	{#State 82
		ACTIONS => {
			"(" => 146
		}
	},
	{#State 83
		ACTIONS => {
			"(" => -73,
			'L_COLONCOLON' => 147
		},
		DEFAULT => -134
	},
	{#State 84
		ACTIONS => {
			";" => 148
		}
	},
	{#State 85
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 149,
			'array' => 101
		}
	},
	{#State 86
		ACTIONS => {
			'L_IDENTIFIER' => 41
		},
		GOTOS => {
			'identifier' => 151
		}
	},
	{#State 87
		ACTIONS => {
			'L_MINUS_EQ' => 160,
			'L_PLUS_EQ' => 158,
			'L_AND_EQ' => 157,
			'L_TIMES_EQ' => 161,
			'L_DIV_EQ' => 152,
			'L_XOR_EQ' => 153,
			'L_DOT_EQ' => 155,
			"=" => 156,
			'L_OR_EQ' => 154,
			'L_MOD_EQ' => 159
		}
	},
	{#State 88
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 162,
			'array' => 101
		}
	},
	{#State 89
		ACTIONS => {
			'L_DIV_EQ' => -77,
			'L_XOR_EQ' => -77,
			'L_OR_EQ' => -77,
			'L_ARROW' => 163,
			"[" => 164,
			'L_DOT_EQ' => -77,
			"=" => -77,
			'L_AND_EQ' => -77,
			'L_PLUS_EQ' => -77,
			'L_MOD_EQ' => -77,
			'L_MINUS_EQ' => -77,
			'L_TIMES_EQ' => -77
		},
		DEFAULT => -120
	},
	{#State 90
		DEFAULT => -132
	},
	{#State 91
		ACTIONS => {
			"(" => 165
		}
	},
	{#State 92
		ACTIONS => {
			'L_LAND' => 168,
			"&" => 166,
			'L_LOR' => 169,
			"|" => 170,
			"^" => 171,
			"?" => 167
		},
		DEFAULT => -89
	},
	{#State 93
		ACTIONS => {
			'L_GE' => 174,
			'L_EQ' => 175,
			'L_LE' => 172,
			'L_NE' => 173,
			"<" => 176,
			">" => 177
		},
		DEFAULT => -91
	},
	{#State 94
		DEFAULT => -28
	},
	{#State 95
		ACTIONS => {
			"(" => 178
		}
	},
	{#State 96
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 179,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 97
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -64,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'arg_list' => 180,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 181,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83,
			'opt_arg_list_comma' => 182
		}
	},
	{#State 98
		DEFAULT => -128
	},
	{#State 99
		ACTIONS => {
			";" => 183
		}
	},
	{#State 100
		ACTIONS => {
			"(" => 184
		}
	},
	{#State 101
		DEFAULT => -131
	},
	{#State 102
		ACTIONS => {
			"(" => 185
		}
	},
	{#State 103
		ACTIONS => {
			'L_COLONCOLON' => 186
		}
	},
	{#State 104
		DEFAULT => -133
	},
	{#State 105
		DEFAULT => -130
	},
	{#State 106
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 187,
			'array' => 101
		}
	},
	{#State 107
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 188,
			'array' => 101
		}
	},
	{#State 108
		DEFAULT => -53
	},
	{#State 109
		ACTIONS => {
			'L_DEC' => 190,
			'L_INC' => 189
		},
		DEFAULT => -113
	},
	{#State 110
		ACTIONS => {
			"{" => 21,
			"(" => 191
		},
		GOTOS => {
			'block' => 192
		}
	},
	{#State 111
		ACTIONS => {
			";" => 193,
			"," => 194
		}
	},
	{#State 112
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 195,
			'array' => 101
		}
	},
	{#State 113
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 196,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 114
		DEFAULT => -135
	},
	{#State 115
		ACTIONS => {
			"{" => 21
		},
		GOTOS => {
			'block' => 197
		}
	},
	{#State 116
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'prefix_exp' => 198,
			'array' => 101
		}
	},
	{#State 117
		ACTIONS => {
			"(" => 199
		}
	},
	{#State 118
		DEFAULT => -10
	},
	{#State 119
		DEFAULT => -154
	},
	{#State 120
		ACTIONS => {
			'L_BASIC_TYPE' => 24,
			'L_VOID' => 26
		},
		GOTOS => {
			'type_specifier' => 57,
			'argument' => 200
		}
	},
	{#State 121
		DEFAULT => -151
	},
	{#State 122
		DEFAULT => -17
	},
	{#State 123
		DEFAULT => -15
	},
	{#State 124
		ACTIONS => {
			"(" => 191
		}
	},
	{#State 125
		DEFAULT => -46
	},
	{#State 126
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 201,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 127
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 202,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 128
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 203,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 129
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 204,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 130
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 205,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 131
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 206,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 132
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 207,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 133
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'postfix_exp' => 109,
			'arith_exp' => 208,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90,
			'prefix_exp' => 72
		}
	},
	{#State 134
		ACTIONS => {
			"," => 209
		},
		DEFAULT => -71
	},
	{#State 135
		ACTIONS => {
			'L_MAP_END' => 210
		}
	},
	{#State 136
		DEFAULT => -68
	},
	{#State 137
		ACTIONS => {
			":" => 211
		}
	},
	{#State 138
		ACTIONS => {
			'L_IDENTIFIER' => 41
		},
		GOTOS => {
			'identifier' => 212
		}
	},
	{#State 139
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 213,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 140
		ACTIONS => {
			")" => 214,
			"," => 194
		}
	},
	{#State 141
		ACTIONS => {
			";" => 215
		}
	},
	{#State 142
		DEFAULT => -59
	},
	{#State 143
		DEFAULT => -57
	},
	{#State 144
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 216,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 145
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -62,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'arg_list' => 218,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 181,
			'postfix_exp' => 109,
			'opt_arg_list' => 217,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 146
		ACTIONS => {
			'L_INTEGER' => 15,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_CATCH' => 124,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'lvalue' => 219,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 220,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90
		}
	},
	{#State 147
		ACTIONS => {
			'L_IDENTIFIER' => 41
		},
		GOTOS => {
			'identifier' => 221
		}
	},
	{#State 148
		DEFAULT => -48
	},
	{#State 149
		DEFAULT => -114
	},
	{#State 150
		ACTIONS => {
			'L_ARROW' => 163,
			"[" => 164
		},
		DEFAULT => -120
	},
	{#State 151
		DEFAULT => -74
	},
	{#State 152
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 222,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 153
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 223,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 154
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 224,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 155
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 225,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 156
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 226,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 157
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 227,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 158
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 228,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 159
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 229,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 160
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 230,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 161
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 231,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 162
		DEFAULT => -116
	},
	{#State 163
		ACTIONS => {
			'L_IDENTIFIER' => 41
		},
		GOTOS => {
			'identifier' => 232
		}
	},
	{#State 164
		ACTIONS => {
			"<" => 234
		},
		DEFAULT => -126,
		GOTOS => {
			'opt_endrange' => 233
		}
	},
	{#State 165
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -55,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'opt_list_exp' => 235,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 236,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 166
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 237,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 167
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 238,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 168
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 239,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 169
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 240,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 170
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 241,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 171
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 242,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 172
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 243,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 173
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 244,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 174
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 245,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 175
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 246,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 176
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 247,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 177
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'compare_exp' => 248,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72
		}
	},
	{#State 178
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 249,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 179
		ACTIONS => {
			'L_RANGE' => 251,
			":" => 250
		}
	},
	{#State 180
		ACTIONS => {
			"," => 252
		},
		DEFAULT => -65
	},
	{#State 181
		DEFAULT => -60
	},
	{#State 182
		ACTIONS => {
			'L_ARRAY_END' => 253
		}
	},
	{#State 183
		DEFAULT => -47
	},
	{#State 184
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 254,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 185
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 255,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 186
		ACTIONS => {
			'L_IDENTIFIER' => 41
		},
		GOTOS => {
			'identifier' => 256
		}
	},
	{#State 187
		DEFAULT => -118
	},
	{#State 188
		DEFAULT => -119
	},
	{#State 189
		DEFAULT => -121
	},
	{#State 190
		DEFAULT => -122
	},
	{#State 191
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 257,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 192
		DEFAULT => -41
	},
	{#State 193
		DEFAULT => -27
	},
	{#State 194
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 258,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 195
		DEFAULT => -115
	},
	{#State 196
		ACTIONS => {
			'L_FUNCTION_END' => 259,
			"," => 194
		}
	},
	{#State 197
		ACTIONS => {
			'L_CATCH' => 260
		}
	},
	{#State 198
		DEFAULT => -117
	},
	{#State 199
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 261,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 200
		DEFAULT => -153
	},
	{#State 201
		ACTIONS => {
			"%" => 129,
			"*" => 127,
			"+" => 130,
			"-" => 132,
			"." => 128,
			"/" => 133
		},
		DEFAULT => -106
	},
	{#State 202
		DEFAULT => -110
	},
	{#State 203
		ACTIONS => {
			"%" => 129,
			"*" => 127,
			"+" => 130,
			"-" => 132,
			"/" => 133
		},
		DEFAULT => -107
	},
	{#State 204
		DEFAULT => -112
	},
	{#State 205
		ACTIONS => {
			"%" => 129,
			"*" => 127,
			"/" => 133
		},
		DEFAULT => -108
	},
	{#State 206
		ACTIONS => {
			"%" => 129,
			"*" => 127,
			"+" => 130,
			"-" => 132,
			"." => 128,
			"/" => 133
		},
		DEFAULT => -105
	},
	{#State 207
		ACTIONS => {
			"%" => 129,
			"*" => 127,
			"/" => 133
		},
		DEFAULT => -109
	},
	{#State 208
		DEFAULT => -111
	},
	{#State 209
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -72,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'assoc_exp' => 262,
			'exp' => 137,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 210
		DEFAULT => -172
	},
	{#State 211
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 263,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 212
		ACTIONS => {
			")" => 264
		}
	},
	{#State 213
		DEFAULT => -31,
		GOTOS => {
			'@4-3' => 265
		}
	},
	{#State 214
		DEFAULT => -137
	},
	{#State 215
		DEFAULT => -49
	},
	{#State 216
		ACTIONS => {
			";" => 266
		}
	},
	{#State 217
		ACTIONS => {
			")" => 267
		}
	},
	{#State 218
		ACTIONS => {
			"," => 268
		},
		DEFAULT => -63
	},
	{#State 219
		ACTIONS => {
			'L_IN' => 269
		}
	},
	{#State 220
		ACTIONS => {
			"[" => 164,
			'L_ARROW' => 163
		},
		DEFAULT => -77
	},
	{#State 221
		DEFAULT => -75
	},
	{#State 222
		DEFAULT => -82
	},
	{#State 223
		DEFAULT => -87
	},
	{#State 224
		DEFAULT => -86
	},
	{#State 225
		DEFAULT => -88
	},
	{#State 226
		DEFAULT => -79
	},
	{#State 227
		DEFAULT => -85
	},
	{#State 228
		DEFAULT => -80
	},
	{#State 229
		DEFAULT => -84
	},
	{#State 230
		DEFAULT => -81
	},
	{#State 231
		DEFAULT => -83
	},
	{#State 232
		ACTIONS => {
			"(" => 270
		}
	},
	{#State 233
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 271,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 234
		DEFAULT => -127
	},
	{#State 235
		ACTIONS => {
			";" => 272
		}
	},
	{#State 236
		ACTIONS => {
			"," => 194
		},
		DEFAULT => -56
	},
	{#State 237
		DEFAULT => -96
	},
	{#State 238
		ACTIONS => {
			":" => 273,
			"," => 194
		}
	},
	{#State 239
		ACTIONS => {
			"&" => 166,
			"|" => 170,
			"^" => 171
		},
		DEFAULT => -93
	},
	{#State 240
		ACTIONS => {
			'L_LAND' => 168,
			"&" => 166,
			"|" => 170,
			"^" => 171
		},
		DEFAULT => -92
	},
	{#State 241
		ACTIONS => {
			"&" => 166,
			"^" => 171
		},
		DEFAULT => -94
	},
	{#State 242
		ACTIONS => {
			"&" => 166
		},
		DEFAULT => -95
	},
	{#State 243
		DEFAULT => -102
	},
	{#State 244
		ACTIONS => {
			'L_GE' => 174,
			'L_LE' => 172,
			"<" => 176,
			">" => 177
		},
		DEFAULT => -99
	},
	{#State 245
		DEFAULT => -103
	},
	{#State 246
		ACTIONS => {
			'L_GE' => 174,
			'L_LE' => 172,
			"<" => 176,
			">" => 177
		},
		DEFAULT => -98
	},
	{#State 247
		DEFAULT => -100
	},
	{#State 248
		DEFAULT => -101
	},
	{#State 249
		ACTIONS => {
			")" => 274
		}
	},
	{#State 250
		DEFAULT => -44
	},
	{#State 251
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 275,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 252
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -66,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 276,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 253
		DEFAULT => -171
	},
	{#State 254
		DEFAULT => -142,
		GOTOS => {
			'lvalue_list' => 277
		}
	},
	{#State 255
		ACTIONS => {
			")" => 278
		}
	},
	{#State 256
		DEFAULT => -76
	},
	{#State 257
		ACTIONS => {
			")" => 279,
			"," => 194
		}
	},
	{#State 258
		DEFAULT => -54
	},
	{#State 259
		DEFAULT => -173
	},
	{#State 260
		ACTIONS => {
			"(" => 280
		}
	},
	{#State 261
		ACTIONS => {
			")" => 281
		}
	},
	{#State 262
		DEFAULT => -69
	},
	{#State 263
		DEFAULT => -67
	},
	{#State 264
		DEFAULT => -136
	},
	{#State 265
		ACTIONS => {
			'L_WHILE' => 282
		}
	},
	{#State 266
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 283,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 267
		DEFAULT => -138
	},
	{#State 268
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 276,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 269
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 284,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 270
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -62,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'arg_list' => 218,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 181,
			'postfix_exp' => 109,
			'opt_arg_list' => 285,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 271
		ACTIONS => {
			'L_RANGE' => 287,
			"]" => 286
		}
	},
	{#State 272
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -58,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 142,
			'closure' => 104,
			'integer' => 105,
			'opt_nv_list_exp' => 288,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 273
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'arith_exp' => 67,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 150,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'postfix_exp' => 109,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 289
		}
	},
	{#State 274
		DEFAULT => -33,
		GOTOS => {
			'@5-4' => 290
		}
	},
	{#State 275
		ACTIONS => {
			":" => 291
		}
	},
	{#State 276
		DEFAULT => -61
	},
	{#State 277
		ACTIONS => {
			")" => 293,
			"," => 292
		}
	},
	{#State 278
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 294,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 279
		DEFAULT => -140
	},
	{#State 280
		ACTIONS => {
			'L_INTEGER' => 15,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_CATCH' => 124,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'lvalue' => 295,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 220,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90
		}
	},
	{#State 281
		DEFAULT => -42,
		GOTOS => {
			'@8-4' => 296
		}
	},
	{#State 282
		ACTIONS => {
			"(" => 297
		}
	},
	{#State 283
		ACTIONS => {
			")" => 298
		}
	},
	{#State 284
		ACTIONS => {
			")" => 299
		}
	},
	{#State 285
		ACTIONS => {
			")" => 300
		}
	},
	{#State 286
		DEFAULT => -124
	},
	{#State 287
		ACTIONS => {
			"<" => 234
		},
		DEFAULT => -126,
		GOTOS => {
			'opt_endrange' => 301
		}
	},
	{#State 288
		ACTIONS => {
			";" => 302
		}
	},
	{#State 289
		DEFAULT => -90
	},
	{#State 290
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 303,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 291
		DEFAULT => -45
	},
	{#State 292
		ACTIONS => {
			'L_INTEGER' => 15,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_HEXINTEGER' => 19,
			'L_CHARACTER' => 18,
			'L_CATCH' => 124,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'string' => 75,
			'lvalue' => 304,
			'integer' => 105,
			'closure' => 104,
			'array_exp' => 220,
			'function_name' => 80,
			'basic_exp' => 70,
			'identifier' => 83,
			'array' => 101,
			'mapping' => 90
		}
	},
	{#State 293
		DEFAULT => -139
	},
	{#State 294
		ACTIONS => {
			'L_ELSE' => 305
		},
		DEFAULT => -51,
		GOTOS => {
			'opt_else' => 306
		}
	},
	{#State 295
		ACTIONS => {
			")" => 307
		}
	},
	{#State 296
		ACTIONS => {
			"{" => 21
		},
		GOTOS => {
			'block' => 308
		}
	},
	{#State 297
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 309,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 298
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 310,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 299
		DEFAULT => -37,
		GOTOS => {
			'@7-6' => 311
		}
	},
	{#State 300
		DEFAULT => -141
	},
	{#State 301
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'nv_list_exp' => 312,
			'closure' => 104,
			'integer' => 105,
			'exp' => 143,
			'postfix_exp' => 109,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 302
		ACTIONS => {
			"!" => 88,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_CHARACTER' => 18,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_INTEGER' => 15,
			"+" => 106,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 124,
			'L_DEC' => 112,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			"~" => 116,
			'L_INC' => 85,
			'L_COLONCOLON' => 86
		},
		DEFAULT => -55,
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'opt_list_exp' => 313,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 236,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 303
		DEFAULT => -34
	},
	{#State 304
		DEFAULT => -143
	},
	{#State 305
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 314,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 306
		DEFAULT => -29
	},
	{#State 307
		ACTIONS => {
			"{" => 21
		},
		GOTOS => {
			'block' => 315
		}
	},
	{#State 308
		DEFAULT => -43
	},
	{#State 309
		ACTIONS => {
			")" => 316
		}
	},
	{#State 310
		DEFAULT => -39
	},
	{#State 311
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 317,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 312
		ACTIONS => {
			"]" => 318
		}
	},
	{#State 313
		ACTIONS => {
			")" => 319
		}
	},
	{#State 314
		DEFAULT => -52
	},
	{#State 315
		DEFAULT => -40
	},
	{#State 316
		ACTIONS => {
			";" => 320
		}
	},
	{#State 317
		DEFAULT => -38
	},
	{#State 318
		DEFAULT => -125
	},
	{#State 319
		DEFAULT => -35,
		GOTOS => {
			'@6-8' => 321
		}
	},
	{#State 320
		DEFAULT => -32
	},
	{#State 321
		ACTIONS => {
			'L_DEFAULT' => 66,
			"!" => 88,
			'L_FOR' => 91,
			'L_MAP_START' => 68,
			"\$" => 69,
			'L_STRING' => 17,
			'L_WHILE' => 95,
			'L_CHARACTER' => 18,
			'L_CASE' => 96,
			'L_BREAK' => 99,
			'L_NIL' => 98,
			'L_ARRAY_START' => 97,
			'L_DO' => 71,
			'L_IF' => 102,
			'L_SSCANF' => 100,
			'L_EFUN' => 103,
			"(" => 74,
			'L_RETURN' => 76,
			"+" => 106,
			'L_INTEGER' => 15,
			";" => 78,
			'L_RLIMITS' => 79,
			"{" => 21,
			"-" => 107,
			'L_HEXINTEGER' => 19,
			'L_CATCH' => 110,
			'L_DEC' => 112,
			'L_FOREACH' => 82,
			'L_IDENTIFIER' => 41,
			'L_PARAMETER' => 114,
			'L_FUNCTION_START' => 113,
			'L_CONTINUE' => 84,
			'L_TRY' => 115,
			"~" => 116,
			'L_INC' => 85,
			'L_SWITCH' => 117,
			'L_COLONCOLON' => 86
		},
		GOTOS => {
			'lvalue' => 87,
			'arith_exp' => 67,
			'array_exp' => 89,
			'mapping' => 90,
			'logical_exp' => 92,
			'compare_exp' => 93,
			'block' => 94,
			'basic_exp' => 70,
			'array' => 101,
			'prefix_exp' => 72,
			'cond_exp' => 73,
			'string' => 75,
			'closure' => 104,
			'integer' => 105,
			'statement' => 322,
			'exp' => 108,
			'postfix_exp' => 109,
			'list_exp' => 111,
			'function_name' => 80,
			'identifier' => 83
		}
	},
	{#State 322
		DEFAULT => -36
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'all', 1,
sub
#line 82 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 2
		 'program', 2,
sub
#line 89 "Parse.yp"
{
			# push(@{$_[1]}, $_[2]); $_[1];
			undef;
		}
	],
	[#Rule 3
		 'program', 0,
sub
#line 94 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 4
		 'definition', 1,
sub
#line 101 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 5
		 'definition', 1,
sub
#line 105 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 6
		 'definition', 1,
sub
#line 109 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 7
		 'definition', 1,
sub
#line 113 "Parse.yp"
{
			undef;
		}
	],
	[#Rule 8
		 'inheritance', 3,
sub
#line 120 "Parse.yp"
{
			$_[0]->YYData->{Program}->inherit($_[2]);
		}
	],
	[#Rule 9
		 'identifier', 1, undef
	],
	[#Rule 10
		 'function_declarator', 5,
sub
#line 133 "Parse.yp"
{
			return [ $_[1], $_[2], $_[4] ];
		}
	],
	[#Rule 11
		 'variable_declarator', 2,
sub
#line 141 "Parse.yp"
{
			return [ $_[1], $_[2] ];
		}
	],
	[#Rule 12
		 'variable_declarator_list', 1,
sub
#line 148 "Parse.yp"
{
			return [ $_[1] ];
		}
	],
	[#Rule 13
		 'variable_declarator_list', 3,
sub
#line 152 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 14
		 'variable_declarator_init', 1,
sub
#line 159 "Parse.yp"
{
			push(@{$_[1]}, undef); $_[1];
		}
	],
	[#Rule 15
		 'variable_declarator_init', 3,
sub
#line 163 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 16
		 'variable_declarator_list_init', 1,
sub
#line 170 "Parse.yp"
{
			return [ $_[1] ];
		}
	],
	[#Rule 17
		 'variable_declarator_list_init', 3,
sub
#line 174 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 18
		 'function_prologue', 3,
sub
#line 183 "Parse.yp"
{
			my $type = $_[2];
			$type = $type->pointer($_[3]->[0]) if $_[3]->[0];
			my $method = new Anarres::Mud::Driver::Program::Method(
					Type	=> $type,
					Name	=> $_[3]->[1],
					Args	=> $_[3]->[2],
						);
			$_[0]->YYData->{Program}->method($method, $_[1]);
			return $method;
		}
	],
	[#Rule 19
		 'prototype', 2, undef
	],
	[#Rule 20
		 'function', 2,
sub
#line 202 "Parse.yp"
{
			# print "Parse code is $_[2]\n";
			$_[1]->code($_[2]);	# Add code to the method
		}
	],
	[#Rule 21
		 '@1-1', 0,
sub
#line 210 "Parse.yp"
{
				my $program = $_[0]->YYData->{Program};
				# $program->scope_start;
				$program;		# Into $_[2]
			}
	],
	[#Rule 22
		 '@2-3', 0,
sub
#line 216 "Parse.yp"
{
				foreach (@{$_[3]}) {
					# $_[2]->local($_);
				}
			}
	],
	[#Rule 23
		 'block', 6,
sub
#line 222 "Parse.yp"
{
			# $_[2]->scope_end;
			return n_block($_[3], $_[5]);
		}
	],
	[#Rule 24
		 'statement_list', 0,
sub
#line 230 "Parse.yp"
{
			return [ ];
		}
	],
	[#Rule 25
		 'statement_list', 2,
sub
#line 234 "Parse.yp"
{
			push(@{$_[1]}, $_[2]) if $_[2]; $_[1];
		}
	],
	[#Rule 26
		 'statement_list', 2,
sub
#line 238 "Parse.yp"
{
			push(@{$_[1]}, 'ERROR'); $_[1];
		}
	],
	[#Rule 27
		 'statement', 2,
sub
#line 245 "Parse.yp"
{ n_stmtexp $_[1] }
	],
	[#Rule 28
		 'statement', 1, undef
	],
	[#Rule 29
		 'statement', 6,
sub
#line 248 "Parse.yp"
{ n_stmtif $_[3], $_[5], $_[6] }
	],
	[#Rule 30
		 '@3-1', 0,
sub
#line 250 "Parse.yp"
{
				# XXX Set loop context
			}
	],
	[#Rule 31
		 '@4-3', 0,
sub
#line 254 "Parse.yp"
{
				# XXX Unset loop context
			}
	],
	[#Rule 32
		 'statement', 9,
sub
#line 258 "Parse.yp"
{ n_stmtdo $_[7], $_[3] }
	],
	[#Rule 33
		 '@5-4', 0,
sub
#line 260 "Parse.yp"
{
				# XXX Set loop context
			}
	],
	[#Rule 34
		 'statement', 6,
sub
#line 264 "Parse.yp"
{ n_stmtwhile $_[3], $_[6] }
	],
	[#Rule 35
		 '@6-8', 0,
sub
#line 268 "Parse.yp"
{
				# XXX Set loop context
			}
	],
	[#Rule 36
		 'statement', 10,
sub
#line 272 "Parse.yp"
{ n_stmtfor $_[3], $_[5], $_[7], $_[10]; }
	],
	[#Rule 37
		 '@7-6', 0,
sub
#line 274 "Parse.yp"
{
				# XXX Set loop context
			}
	],
	[#Rule 38
		 'statement', 8,
sub
#line 278 "Parse.yp"
{ n_stmtforeach $_[3], $_[5], $_[8]; }
	],
	[#Rule 39
		 'statement', 7,
sub
#line 280 "Parse.yp"
{ n_stmtrlimits $_[3], $_[5], $_[7] }
	],
	[#Rule 40
		 'statement', 7,
sub
#line 282 "Parse.yp"
{ n_stmttry $_[2], $_[5], $_[7] }
	],
	[#Rule 41
		 'statement', 2,
sub
#line 285 "Parse.yp"
{ n_stmtcatch $_[2] }
	],
	[#Rule 42
		 '@8-4', 0,
sub
#line 288 "Parse.yp"
{
				# XXX Set switch context
			}
	],
	[#Rule 43
		 'statement', 6,
sub
#line 292 "Parse.yp"
{ n_stmtswitch $_[3], $_[6]; }
	],
	[#Rule 44
		 'statement', 3,
sub
#line 294 "Parse.yp"
{ n_stmtcase $_[2], undef }
	],
	[#Rule 45
		 'statement', 5,
sub
#line 296 "Parse.yp"
{ n_stmtcase $_[2], $_[4] }
	],
	[#Rule 46
		 'statement', 2,
sub
#line 298 "Parse.yp"
{ n_stmtdefault }
	],
	[#Rule 47
		 'statement', 2,
sub
#line 300 "Parse.yp"
{ n_stmtbreak }
	],
	[#Rule 48
		 'statement', 2,
sub
#line 302 "Parse.yp"
{ n_stmtcontinue }
	],
	[#Rule 49
		 'statement', 3,
sub
#line 304 "Parse.yp"
{ n_stmtreturn $_[2] }
	],
	[#Rule 50
		 'statement', 1,
sub
#line 306 "Parse.yp"
{ n_stmtnull; }
	],
	[#Rule 51
		 'opt_else', 0,
sub
#line 311 "Parse.yp"
{
			return undef;
		}
	],
	[#Rule 52
		 'opt_else', 2,
sub
#line 315 "Parse.yp"
{
			return $_[2];
		}
	],
	[#Rule 53
		 'list_exp', 1,
sub
#line 331 "Parse.yp"
{
			return $_[1];
		}
	],
	[#Rule 54
		 'list_exp', 3,
sub
#line 335 "Parse.yp"
{
			return [ 'COMMA', $_[1], $_[3] ];
		}
	],
	[#Rule 55
		 'opt_list_exp', 0,
sub
#line 342 "Parse.yp"
{ n_expnull }
	],
	[#Rule 56
		 'opt_list_exp', 1, undef
	],
	[#Rule 57
		 'nv_list_exp', 1, undef
	],
	[#Rule 58
		 'opt_nv_list_exp', 0,
sub
#line 352 "Parse.yp"
{ n_expnull }
	],
	[#Rule 59
		 'opt_nv_list_exp', 1, undef
	],
	[#Rule 60
		 'arg_list', 1,
sub
#line 358 "Parse.yp"
{
			return [ $_[1] ];
		}
	],
	[#Rule 61
		 'arg_list', 3,
sub
#line 362 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 62
		 'opt_arg_list', 0,
sub
#line 369 "Parse.yp"
{
			return [];
		}
	],
	[#Rule 63
		 'opt_arg_list', 1, undef
	],
	[#Rule 64
		 'opt_arg_list_comma', 0,
sub
#line 377 "Parse.yp"
{
			return [];
		}
	],
	[#Rule 65
		 'opt_arg_list_comma', 1, undef
	],
	[#Rule 66
		 'opt_arg_list_comma', 2, undef
	],
	[#Rule 67
		 'assoc_exp', 3,
sub
#line 386 "Parse.yp"
{
			return [ $_[1], $_[3] ];
		}
	],
	[#Rule 68
		 'assoc_arg_list', 1,
sub
#line 394 "Parse.yp"
{
			return $_[1];
		}
	],
	[#Rule 69
		 'assoc_arg_list', 3,
sub
#line 398 "Parse.yp"
{
			push(@{$_[1]}, @{$_[3]}); $_[1];
		}
	],
	[#Rule 70
		 'opt_assoc_arg_list_comma', 0,
sub
#line 405 "Parse.yp"
{ [ ] }
	],
	[#Rule 71
		 'opt_assoc_arg_list_comma', 1, undef
	],
	[#Rule 72
		 'opt_assoc_arg_list_comma', 2, undef
	],
	[#Rule 73
		 'function_name', 1,
sub
#line 412 "Parse.yp"
{
			# print "Finding function name $_[1]\n";
			$_[0]->YYData->{Program}->method($_[1]);
		}
	],
	[#Rule 74
		 'function_name', 2,
sub
#line 417 "Parse.yp"
{
			# inherited lfun
			# return [ 'inherited_function', $_[2], undef ];
			$_[0]->YYData->{Program}->method('::' . $_[2]);
		}
	],
	[#Rule 75
		 'function_name', 3,
sub
#line 423 "Parse.yp"
{
			# specified inherited lfun
			# return [ 'inherited_function', $_[3], $_[1] ];
			$_[0]->YYData->{Program}->method($_[1] . '::' . $_[3]);
		}
	],
	[#Rule 76
		 'function_name', 3,
sub
#line 429 "Parse.yp"
{
			# treat this as an inherited function
			$_[0]->YYData->{Program}->method('::' . $_[3]);
		}
	],
	[#Rule 77
		 'lvalue', 1, undef
	],
	[#Rule 78
		 'exp', 1, undef
	],
	[#Rule 79
		 'exp', 3,
sub
#line 445 "Parse.yp"
{ n_assign $_[1], $_[3] }
	],
	[#Rule 80
		 'exp', 3,
sub
#line 447 "Parse.yp"
{ n_assign($_[1], n_add($_[1], $_[3])) }
	],
	[#Rule 81
		 'exp', 3,
sub
#line 449 "Parse.yp"
{ n_assign($_[1], n_sub($_[1], $_[3])) }
	],
	[#Rule 82
		 'exp', 3,
sub
#line 451 "Parse.yp"
{ n_assign($_[1], n_div($_[1], $_[3])) }
	],
	[#Rule 83
		 'exp', 3,
sub
#line 453 "Parse.yp"
{ n_assign($_[1], n_mul($_[1], $_[3])) }
	],
	[#Rule 84
		 'exp', 3,
sub
#line 455 "Parse.yp"
{ n_assign($_[1], n_mod($_[1], $_[3])) }
	],
	[#Rule 85
		 'exp', 3,
sub
#line 457 "Parse.yp"
{ n_assign($_[1], n_and($_[1], $_[3])) }
	],
	[#Rule 86
		 'exp', 3,
sub
#line 459 "Parse.yp"
{ n_assign($_[1], n_or($_[1], $_[3])) }
	],
	[#Rule 87
		 'exp', 3,
sub
#line 461 "Parse.yp"
{ n_assign($_[1], n_xor($_[1], $_[3])) }
	],
	[#Rule 88
		 'exp', 3,
sub
#line 463 "Parse.yp"
{ n_assign($_[1], n_stradd($_[1], $_[3])) }
	],
	[#Rule 89
		 'cond_exp', 1, undef
	],
	[#Rule 90
		 'cond_exp', 5,
sub
#line 469 "Parse.yp"
{ n_expcond $_[1], $_[3], $_[5] }
	],
	[#Rule 91
		 'logical_exp', 1, undef
	],
	[#Rule 92
		 'logical_exp', 3,
sub
#line 474 "Parse.yp"
{ n_logor	$_[1], $_[3] }
	],
	[#Rule 93
		 'logical_exp', 3,
sub
#line 475 "Parse.yp"
{ n_logand	$_[1], $_[3] }
	],
	[#Rule 94
		 'logical_exp', 3,
sub
#line 476 "Parse.yp"
{ n_or		$_[1], $_[3] }
	],
	[#Rule 95
		 'logical_exp', 3,
sub
#line 477 "Parse.yp"
{ n_xor		$_[1], $_[3] }
	],
	[#Rule 96
		 'logical_exp', 3,
sub
#line 478 "Parse.yp"
{ n_and		$_[1], $_[3] }
	],
	[#Rule 97
		 'compare_exp', 1, undef
	],
	[#Rule 98
		 'compare_exp', 3,
sub
#line 483 "Parse.yp"
{ n_eq $_[1], $_[3] }
	],
	[#Rule 99
		 'compare_exp', 3,
sub
#line 484 "Parse.yp"
{ n_ne $_[1], $_[3] }
	],
	[#Rule 100
		 'compare_exp', 3,
sub
#line 485 "Parse.yp"
{ n_lt $_[1], $_[3] }
	],
	[#Rule 101
		 'compare_exp', 3,
sub
#line 486 "Parse.yp"
{ n_gt $_[1], $_[3] }
	],
	[#Rule 102
		 'compare_exp', 3,
sub
#line 487 "Parse.yp"
{ n_le $_[1], $_[3] }
	],
	[#Rule 103
		 'compare_exp', 3,
sub
#line 488 "Parse.yp"
{ n_ge $_[1], $_[3] }
	],
	[#Rule 104
		 'arith_exp', 1, undef
	],
	[#Rule 105
		 'arith_exp', 3,
sub
#line 493 "Parse.yp"
{ n_lsh $_[1], $_[3] }
	],
	[#Rule 106
		 'arith_exp', 3,
sub
#line 494 "Parse.yp"
{ n_rsh $_[1], $_[3] }
	],
	[#Rule 107
		 'arith_exp', 3,
sub
#line 495 "Parse.yp"
{ n_stradd $_[1], $_[3] }
	],
	[#Rule 108
		 'arith_exp', 3,
sub
#line 496 "Parse.yp"
{ n_add $_[1], $_[3] }
	],
	[#Rule 109
		 'arith_exp', 3,
sub
#line 497 "Parse.yp"
{ n_sub $_[1], $_[3] }
	],
	[#Rule 110
		 'arith_exp', 3,
sub
#line 498 "Parse.yp"
{ n_mul $_[1], $_[3] }
	],
	[#Rule 111
		 'arith_exp', 3,
sub
#line 499 "Parse.yp"
{ n_div $_[1], $_[3] }
	],
	[#Rule 112
		 'arith_exp', 3,
sub
#line 500 "Parse.yp"
{ n_mod $_[1], $_[3] }
	],
	[#Rule 113
		 'prefix_exp', 1, undef
	],
	[#Rule 114
		 'prefix_exp', 2,
sub
#line 505 "Parse.yp"
{ n_preinc $_[2] }
	],
	[#Rule 115
		 'prefix_exp', 2,
sub
#line 506 "Parse.yp"
{ n_predec $_[2] }
	],
	[#Rule 116
		 'prefix_exp', 2,
sub
#line 507 "Parse.yp"
{ n_unot $_[2] }
	],
	[#Rule 117
		 'prefix_exp', 2,
sub
#line 508 "Parse.yp"
{ n_tilde $_[2] }
	],
	[#Rule 118
		 'prefix_exp', 2,
sub
#line 509 "Parse.yp"
{ n_plus $_[2] }
	],
	[#Rule 119
		 'prefix_exp', 2,
sub
#line 510 "Parse.yp"
{ n_minus $_[2] }
	],
	[#Rule 120
		 'postfix_exp', 1, undef
	],
	[#Rule 121
		 'postfix_exp', 2,
sub
#line 515 "Parse.yp"
{ n_postinc $_[1] }
	],
	[#Rule 122
		 'postfix_exp', 2,
sub
#line 516 "Parse.yp"
{ n_postdec $_[1] }
	],
	[#Rule 123
		 'array_exp', 1, undef
	],
	[#Rule 124
		 'array_exp', 5,
sub
#line 522 "Parse.yp"
{
			n_index $_[1], $_[4];
		}
	],
	[#Rule 125
		 'array_exp', 8,
sub
#line 528 "Parse.yp"
{
			# XXX Correct for ends of range
			n_range $_[1], $_[4], $_[7];
		}
	],
	[#Rule 126
		 'opt_endrange', 0,
sub
#line 536 "Parse.yp"
{
			undef
		}
	],
	[#Rule 127
		 'opt_endrange', 1,
sub
#line 540 "Parse.yp"
{
			1
		}
	],
	[#Rule 128
		 'basic_exp', 1,
sub
#line 546 "Parse.yp"
{ n_nil }
	],
	[#Rule 129
		 'basic_exp', 1,
sub
#line 547 "Parse.yp"
{ n_string $_[1] }
	],
	[#Rule 130
		 'basic_exp', 1,
sub
#line 548 "Parse.yp"
{ n_integer $_[1] }
	],
	[#Rule 131
		 'basic_exp', 1,
sub
#line 549 "Parse.yp"
{ n_array @{ $_[1] } }
	],
	[#Rule 132
		 'basic_exp', 1,
sub
#line 550 "Parse.yp"
{ n_mapping @{ $_[1] } }
	],
	[#Rule 133
		 'basic_exp', 1,
sub
#line 551 "Parse.yp"
{ n_closure $_[1] }
	],
	[#Rule 134
		 'basic_exp', 1,
sub
#line 552 "Parse.yp"
{ n_variable $_[1] }
	],
	[#Rule 135
		 'basic_exp', 1,
sub
#line 554 "Parse.yp"
{
			# XXX Check in closure context?
			n_parameter $_[1]
		}
	],
	[#Rule 136
		 'basic_exp', 4,
sub
#line 559 "Parse.yp"
{
			# XXX A variable by value... closures only
			n_variable $_[3]
		}
	],
	[#Rule 137
		 'basic_exp', 3,
sub
#line 563 "Parse.yp"
{ $_[2] }
	],
	[#Rule 138
		 'basic_exp', 4,
sub
#line 565 "Parse.yp"
{
			n_funcall $_[1], @{ $_[3] };
		}
	],
	[#Rule 139
		 'basic_exp', 5,
sub
#line 569 "Parse.yp"
{
			n_sscanf $_[3], @{ $_[4] };		# XXX Expand later
		}
	],
	[#Rule 140
		 'basic_exp', 4,
sub
#line 573 "Parse.yp"
{
			n_catch $_[3];
		}
	],
	[#Rule 141
		 'basic_exp', 6,
sub
#line 577 "Parse.yp"
{
			n_callother $_[1], $_[3], @{ $_[5] };
		}
	],
	[#Rule 142
		 'lvalue_list', 0,
sub
#line 584 "Parse.yp"
{
			[]
		}
	],
	[#Rule 143
		 'lvalue_list', 3,
sub
#line 588 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 144
		 'global_decl', 4,
sub
#line 603 "Parse.yp"
{
			foreach (@{$_[3]}) {
				my $type = $_[2];
				$type = $type->pointer($_->[0]) if $_->[0];
				my $var = new Anarres::Mud::Driver::Program::Variable(
								Type	=> $type,
								Name	=> $_->[1],
									);
				$_[0]->YYData->{Program}->global($var, $_[1]);
			}
			return undef;
		}
	],
	[#Rule 145
		 'local_decls', 0,
sub
#line 619 "Parse.yp"
{
			return [];
		}
	],
	[#Rule 146
		 'local_decls', 2,
sub
#line 623 "Parse.yp"
{
			push(@{$_[1]}, @{$_[2]}); $_[1];
		}
	],
	[#Rule 147
		 'local_decl', 3,
sub
#line 630 "Parse.yp"
{
			my @out = ();
			foreach (@{$_[2]}) {
				my $type = $_[1];
				$type = $type->pointer($_->[0]) if $_->[0];
				my $var = new Anarres::Mud::Driver::Program::Variable(
								Type	=> $type,
								Name	=> $_->[1],
									);
				# XXX Deal with the init in $_->[2]
				push(@out, $var);
			}
			return \@out;
		}
	],
	[#Rule 148
		 'arguments', 0,
sub
#line 648 "Parse.yp"
{ return []; }
	],
	[#Rule 149
		 'arguments', 1,
sub
#line 650 "Parse.yp"
{ return []; }
	],
	[#Rule 150
		 'arguments', 1, undef
	],
	[#Rule 151
		 'arguments', 2, undef
	],
	[#Rule 152
		 'argument_list', 1,
sub
#line 658 "Parse.yp"
{
			return [ $_[1] ];
		}
	],
	[#Rule 153
		 'argument_list', 3,
sub
#line 662 "Parse.yp"
{
			push(@{$_[1]}, $_[3]); $_[1];
		}
	],
	[#Rule 154
		 'argument', 2,
sub
#line 669 "Parse.yp"
{
			my $type = $_[1];
			$type = $type->pointer($_[2]->[0]) if $_[2]->[0];
			return new Anarres::Mud::Driver::Program::Variable(
							Type	=> $type,
							Name	=> $_[2]->[1],
								);
		}
	],
	[#Rule 155
		 'type_modifier_list', 0,
sub
#line 681 "Parse.yp"
{ 
			return 0;
		}
	],
	[#Rule 156
		 'type_modifier_list', 2,
sub
#line 685 "Parse.yp"
{
			# XXX Check for multiple access modifiers
			return $_[1] | $_[2];
		}
	],
	[#Rule 157
		 'type_specifier', 1, undef
	],
	[#Rule 158
		 'type_specifier', 1, undef
	],
	[#Rule 159
		 'star_list', 0,
sub
#line 699 "Parse.yp"
{
			return 0;
		}
	],
	[#Rule 160
		 'star_list', 2,
sub
#line 703 "Parse.yp"
{
			# XXX Check for too deep.
			return $_[1] + 1;
		}
	],
	[#Rule 161
		 'star_list', 2,
sub
#line 708 "Parse.yp"
{
			# A mapping (hash!)
			# We could "#define mapping mixed #" for compatability.
			# XXX This is wrong. It doesn't preserve ordering.
			return $_[1] + 65536;
		}
	],
	[#Rule 162
		 'string_const', 1, undef
	],
	[#Rule 163
		 'string_const', 3,
sub
#line 723 "Parse.yp"
{ return $_[1] . $_[3] }
	],
	[#Rule 164
		 'string_const', 3,
sub
#line 724 "Parse.yp"
{ return $_[1] . $_[3] }
	],
	[#Rule 165
		 'string_const', 1,
sub
#line 725 "Parse.yp"
{ return "$_[1]" }
	],
	[#Rule 166
		 'string', 1, undef
	],
	[#Rule 167
		 'string', 2,
sub
#line 732 "Parse.yp"
{ return $_[1] . $_[2] }
	],
	[#Rule 168
		 'integer', 1,
sub
#line 736 "Parse.yp"
{ 0 + $_[1] }
	],
	[#Rule 169
		 'integer', 1,
sub
#line 737 "Parse.yp"
{ hex($_[1]) }
	],
	[#Rule 170
		 'integer', 1,
sub
#line 738 "Parse.yp"
{ 0 + $_[1] }
	],
	[#Rule 171
		 'array', 3,
sub
#line 752 "Parse.yp"
{ $_[2] }
	],
	[#Rule 172
		 'mapping', 3,
sub
#line 757 "Parse.yp"
{ $_[2] }
	],
	[#Rule 173
		 'closure', 3,
sub
#line 763 "Parse.yp"
{ $_[2] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 766 "Parse.yp"


sub yyerror {
	my ($self) = @_;

	my $currtok = $_[0]->YYCurtok;
	my $lexer = $self->YYData->{Lexer};

	if ($currtok eq 'L_MAP_END') {
		# print "Convert L_MAP_END to ']' ')'\n";
		$_[0]->YYCurtok(']');
		$_[0]->YYCurval(']');
		# $lexer->unput(')');
		$lexer->rewind(1);	# length ')'
		$_[0]->YYErrok;
		return undef;
	}

	my $at = $lexer->at;
	my $tok = $self->YYCurtok;
	my $val = $self->YYCurval;
	$val = defined $val ? $val : "[no token value]";
	my $expect = "'" . join("', '", sort $self->YYExpect) . "'";

	print "Parse error at $at\n" .
		"Got $tok ($val)\n" .
		"Expected one of $expect\n";

	die "Byebye.";
}

sub yyparse {
	my ($self, $prog, $lexer) = @_;

	$self->YYData->{Lexer} = $lexer;
	$self->YYData->{Program} = $prog;

	$self->YYParse(
					# yylex	=> $lexer->can('lex_debug'),
					# yylex	=> $lexer->can('lex'),
					yylex	=> sub { $lexer->lex },
					yyerror	=> \&yyerror,
						);
}

1;

1;
