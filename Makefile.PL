require 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME          => 'Anarres::Mud::Driver',
    VERSION_FROM  => 'lib/Driver.pm', # finds $VERSION
    ABSTRACT_FROM => 'lib/Driver.pm',
    AUTHOR        => 'Shevek (cpan@anarres.org)',
    # ABSTRACT      => 'Module abstract'
	PREREQ_PM     => {
					# 5.006001			=> 0,
					String::Escape		=> 2002.001,
					Parse::Yapp::Driver	=> 1.05,
					File::Basename		=> 0,
					Storable			=> 1.014,
					Time::HiRes			=> 0,
				}, # e.g., Module::Name => 1.1
	DIR				=> [ qw(lib Compiler Interpreter Efun) ],
	OPTIMIZE		=> '-O2 -g -Wall',
);
