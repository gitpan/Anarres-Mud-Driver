require 5.006001;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME			=> 'Anarres::Mud::Driver::Program::Type',
    VERSION_FROM	=> 'Type.pm', # finds $VERSION
    AUTHOR			=> 'Shevek (cpan@anarres.org)',
	INC				=> '-I../include',
);
