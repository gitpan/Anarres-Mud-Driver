package Anarres::Mud::Driver::Compiler;

use strict;
use warnings;
use vars qw($VERSION @ISA);

require DynaLoader;

$VERSION = 0.10;
@ISA = qw(DynaLoader);

bootstrap Anarres::Mud::Driver::Compiler;

1;
