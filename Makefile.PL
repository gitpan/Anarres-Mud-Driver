use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME          => 'Anarres::Mud::Driver',
    VERSION_FROM  => 'lib/Anarres/Mud/Driver.pm', # finds $VERSION
    ABSTRACT_FROM => 'lib/Anarres/Mud/Driver.pm', # finds $VERSION
    AUTHOR        => 'Shevek (cpan@anarres.org)',
    # ABSTRACT      => 'Module abstract'
	PREREQ_PM     => {
					String::Escape		=> 2002.001,
					Parse::Yapp::Driver	=> 1.05,
					File::Basename		=> 2.6,
					Storable			=> 1.014,
					Time::HiRes			=> 0,
				}, # e.g., Module::Name => 1.1

);
