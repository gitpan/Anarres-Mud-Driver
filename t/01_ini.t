# t/01_ini.t; just to load Anarres::Mud::Driver by using it

$|++; 
print "1..1
";
my($test) = 1;

# 1 load
use Anarres::Mud::Driver;
my($loaded) = 1;
$loaded ? print "ok $test
" : print "not ok $test
";
$test++;

# end of t/01_ini.t

