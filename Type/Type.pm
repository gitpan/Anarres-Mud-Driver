package Anarres::Mud::Driver::Program::Type;

use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);
use Exporter;

require DynaLoader;

$VERSION = 0.10;
@ISA = qw(Exporter DynaLoader);
@EXPORT_OK = qw(

				T_BOOL
				T_CLOSURE
				T_INTEGER
				T_MAPPING
				T_NIL
				T_OBJECT
				T_STRING
				T_UNKNOWN
				T_VOID

				T_ARRAY T_MAPPING

				TM_ARRAY TM_MAPPING
								);

%EXPORT_TAGS = (
	types	=> \@EXPORT_OK,
		);

bootstrap Anarres::Mud::Driver::Program::Type;

my @keys = keys %Anarres::Mud::Driver::Program::Type:: ;
print "Type loaded: @keys\n";

1;
