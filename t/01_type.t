use strict;
use Data::Dumper;
use Test::More tests => 21;

my ($t, $u, $v, $w);

BEGIN { use_ok('Anarres::Mud::Driver::Compiler::Type'); }

$t = T_STRING;
ok($$t eq 's', 'Construct T_STRING (from cache)');

$t = new Anarres::Mud::Driver::Compiler::Type("*s");
ok($$t eq '*s', 'Construct string pointer');

$t = new Anarres::Mud::Driver::Compiler::Type("*s");
ok($$t eq '*s', 'Construct string pointer from cache');

$t = T_CLASS(T_STRING);
ok($$t =~ m/^{/, 'Construct T_CLASS');
ok($t->dump eq '{s}', 'Class dump looks OK');

$t = T_CLASS(T_STRING, T_INTEGER, T_CLASS(T_STRING, T_INTEGER));
ok($$t =~ m/^{/, 'Construct complex T_CLASS');
# print STDERR $t->dump, "\n";
ok($t->dump eq '{si{si}}', 'Complex class dump looks OK');

my $cond = 1;
my $cache = \%Anarres::Mud::Driver::Compiler::Type::CACHE;
foreach (keys %$cache) {
	$cond = 0 unless $_ eq ${$cache->{$_}};
}
ok($cond, 'Cache integrity check');

$t = T_CLASS(T_STRING, T_INTEGER, T_CLASS(T_STRING, T_INTEGER));
$u = T_CLASS(T_STRING, T_INTEGER, T_CLASS(T_STRING));

ok(T_NIL->compatible(T_INTEGER), 'Can assign NIL to INTEGER');
ok(T_BOOL->compatible(T_INTEGER), 'Can assign BOOL to INTEGER');
ok(!(T_INTEGER->compatible(T_NIL)), 'Cannot assign INTEGER to NIL');
ok(!(T_INTEGER->compatible(T_BOOL)), 'Cannot assign INTEGER to BOOL');
ok(T_NIL->compatible(T_CLASS(T_INTEGER)), 'Can assign NIL to class');
ok($t->compatible($t), 'Can assign $t to itself');
ok(!($t->compatible($u)), 'Cannot assign simple class to complex');
ok(!($u->compatible($t)), 'Cannot assign complex class to simple');

ok(T_NIL->unify(T_INTEGER)->equals(T_INTEGER), 'U(n, i) = i');
ok(T_INTEGER->unify(T_INTEGER)->equals(T_INTEGER), 'U(i, i) = i');
ok(T_STRING->unify(T_INTEGER)->equals(T_UNKNOWN), 'U(s, i) = ?');

# print $t->dump . "->unify(" . $u->dump . ") = " . $t->unify($u)->dump, "\n";
ok($t->unify($u)->dump eq '{si{s}}', 'Complex class unification');

if (0) {
	$t = new Anarres::Mud::Driver::Compiler::Type("*s");
	$u = new Anarres::Mud::Driver::Compiler::Type("**s");
	print $t->unify($u)->dump;
	print $u->unify($t)->dump;
}
