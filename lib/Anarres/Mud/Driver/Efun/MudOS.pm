package Anarres::Mud::Driver::Efun::MudOS;

use strict;
use vars qw(@ISA);
use Anarres::Mud::Driver::Program::Type qw(:types);
use Anarres::Mud::Driver::Program::Method qw(:flags);
use Anarres::Mud::Driver::Program::Efun qw(register);

# Efuns need to be normal functions in a program symbol table but
# will not issue a warning if multiply defined as efuns.
# In fact, they probably won't inherit at all. They only resolve at
# link time.

# Note that we don't actually register all available efuns. We
# register only those which are visible as efuns to the LPC code.
# We may have more efuns, an individual efun typecheck_call method
# may decide to rebless the node into a different efun class.
# For example, map => map_array or map_mapping. In this way we
# can use the Perl object oriented dispatch mechanism to speed up
# many operations where a pure Perl conditional would be slower.

@ISA = qw(Anarres::Mud::Driver::Program::Efun);

{
	# As traditional, [ flags, return type, argtype .... ]
	my $pflags = M_PURE | M_NOMASK;	# This just lets me format nicely.
	my %efuns = (
		# Object stuff

		this_object		=> [ 0,		T_OBJECT, ],
		previous_object	=> [ 0,		T_OBJECT, T_INTEGER, ],
		all_previous_objects	=>[ 0, T_OBJECT->pointer ],
		file_name		=> [ M_PURE,	T_STRING, T_OBJECT, ],
		find_object		=> [ M_PURE,	T_OBJECT, T_STRING, ],
		load_object		=> [ M_PURE,	T_OBJECT, T_STRING, ],
		clone_object	=> [ M_PURE,	T_OBJECT, T_STRING, ],
		destruct		=> [ 0,		T_INTEGER, T_OBJECT, ],
		children		=> [ 0,		T_OBJECT->pointer, T_STRING, ],
		objects			=> [ 0,		T_OBJECT->pointer, ],

		# String stuff

		implode		=> [ M_PURE, T_STRING, T_STRING->pointer, T_STRING ],
		explode		=> [ M_PURE, T_STRING->pointer, T_STRING, T_STRING ],
		lower_case		=> [ M_PURE, T_STRING, T_STRING, ],
		upper_case		=> [ M_PURE, T_STRING, T_STRING, ],
		strlen			=> [ M_PURE, T_INTEGER, T_STRING, ],
		replace_string	=> [ M_PURE, T_STRING, T_STRING, T_STRING, T_STRING, ],
		capitalize		=> [ M_PURE, T_STRING, T_STRING, ],
		strsrch			=> [ M_PURE, T_INTEGER, T_STRING, T_STRING, ],
		regexp			=> [ M_PURE, T_INTEGER, T_STRING, T_STRING, ],

		sprintf			=> [ M_PURE, T_STRING, T_STRING, T_ARRAY, ],
		sscanf			=> [ M_PURE, T_STRING, T_STRING, T_ARRAY, ],

		# Array stuff

		member_array	=> [ M_PURE, T_INTEGER, T_MIXED, T_ARRAY, ],
		unique_array	=> [ M_PURE, T_ARRAY->pointer, T_MIXED, T_ARRAY],
			# XXX We can map mappings. :-(
		map				=> [ 0,		T_ARRAY, T_ARRAY, T_CLOSURE, ],
		filter			=> [ 0,		T_ARRAY, T_ARRAY, T_CLOSURE, ],
		allocate		=> [ 0,		T_ARRAY, T_INTEGER, T_MIXED, ],

		# Mapping stuff

		keys			=> [ M_PURE,	T_STRING->pointer, T_MAPPING, ],
		values			=> [ M_PURE,	T_ARRAY, T_MAPPING, ],

		# Type stuff

		to_int			=> [ M_PURE,	T_INTEGER, T_STRING, ],
		to_string		=> [ M_PURE,	T_STRING, T_INTEGER, ],
		typeof			=> [ M_PURE,	T_STRING, T_MIXED, ],
		sizeof			=> [ M_PURE,	T_INTEGER, T_MIXED, ],

		intp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		stringp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		arrayp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		mapp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		functionp		=> [ $pflags,	T_BOOL, T_MIXED, ],
		classp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		objectp			=> [ $pflags,	T_BOOL, T_MIXED, ],
		clonep			=> [ M_PURE,	T_BOOL, T_MIXED, ],
		undefinedp		=> [ M_PURE,	T_BOOL, T_MIXED, ],

		# Closure stuff

		evaluate		=> [ 0,		T_MIXED, T_CLOSURE, ],

		# Reflection

		function_exists	=> [ 0,		T_OBJECT, T_STRING, T_INTEGER, ],
		functions		=> [ 0,		T_OBJECT, T_INTEGER, ],
		variables		=> [ 0,		T_OBJECT, T_INTEGER, ],
		inherits		=> [ M_PURE,	T_INTEGER, T_STRING, T_OBJECT, ],
		call_stack		=> [ 0,		T_STRING->pointer, T_INTEGER, ],

		# File stuff

		file_size		=> [ 0,		T_INTEGER, T_STRING, ],
		read_file		=> [ 0,		T_STRING, T_STRING, ],
		write_file		=> [ 0,		T_INTEGER, T_STRING, T_STRING, ],

		# System stuff

		time			=> [ 0,		T_INTEGER, ],

		debug_message	=> [ 0,		T_STRING, T_STRING, ],
		error			=> [ 0,		T_MIXED, T_STRING, ],
		shutdown		=> [ 0,		T_INTEGER, ],

		trace			=> [ 0,		T_INTEGER, T_INTEGER, ],
			);

	# We call this as an exported function since ISA isn't yet set up.
	foreach (keys %efuns) {
		register(__PACKAGE__ . "::" . $_, @{ $efuns{$_} });
	}
}

{
	package Anarres::Mud::Driver::Efun::MudOS::debug_message;
	sub generate_call { "print STDERR $_[1], '\\n'" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::previous_object;
	sub invoke { undef }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::file_name;
	sub generate_call {
		"Anarres::Mud::Driver::Program::package_to_path(ref($_[1]))"
	}
}

{
	package Anarres::Mud::Driver::Efun::MudOS::find_object;
	# sub generate_call { "undef" }
	sub invoke { undef }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::to_string;
	# XXX This only works for CONSTANT integers, of course.
	# sub generate_call { '"' . $_[1] . '"' }
	# This works for any integer which is about to be evaluated as
	# a string by Perl. 6 . 7 == "67";
	sub generate_call { ('' . $_[1]) }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::strlen;
	sub generate_call { "length($_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::error;
	sub generate_call { "die('LPC: ' . $_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::implode;
	sub generate_call { "join($_[2], \@{ $_[1] })" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::explode;
	# XXX This probably has to become an XSUB for compatability.
	sub generate_call { "split(quotemeta($_[2]), $_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::replace_string;
	# XXX This probably has to become an XSUB for compatability.
}

{
	package Anarres::Mud::Driver::Efun::MudOS::intp;
	sub generate_call { "(defined($_[1]) && !ref($_[1]))" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::stringp;
	sub generate_call { "(defined($_[1]) && !ref($_[1]))" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::arrayp;
	sub generate_call { "ref($_[1]) eq 'ARRAY'" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::mapp;
	sub generate_call { "ref($_[1]) eq 'HASH'" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::objectp;
	sub generate_call { "ref($_[1]) =~ /::/" }	# XXX
}

{
	package Anarres::Mud::Driver::Efun::MudOS::clonep;
	sub generate_call { "ref($_[1]) =~ /::/" }	# XXX
}

{
	package Anarres::Mud::Driver::Efun::MudOS::keys;
	sub generate_call { "keys(\%{$_[1]})" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::values;
	sub generate_call { "values(\%{$_[1]})" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::regexp;
	sub generate_call { "XXX($_[1] =~ /$_[2]/)" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::clone_object;
	sub generate_call { "$_[1]\->new()" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::this_object;
	sub generate_call { '$self' }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::strsrch;
	sub generate_call { "index($_[1], $_[2])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::lower_case;
	sub generate_call { "lc($_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::upper_case;
	sub generate_call { "uc($_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::capitalize;
	sub generate_call { "ucfirst($_[1])" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::allocate;
	sub generate_call {
		my $val = defined $_[2] ? $_[2] : 'undef';
		return "[ ($val) x $_[1] ]"
	}
}

{
	package Anarres::Mud::Driver::Efun::MudOS::to_int;
	sub generate_call { "(0 + ($_[1]))" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::inherits;
	sub generate_call { "($_[2])->isa(XXX_to_package($_[1]))" }
}

{
	package Anarres::Mud::Driver::Efun::MudOS::sizeof;
	sub generate_call {
		# XXX Arse - use typechecking info!
		# XXX Deal with ints
		'do { my $__a = ' . $_[1] . '; my $r = ref($__a); ' .
				# ($#$__a + 1) ?
				'$__r eq "ARRAY" ? scalar(@{$__a}) : ' .
				'$__r eq "HASH" ? scalar(keys %{$__a}) : ' .
				'$__r eq "" ? length($__a) : ' .
				'die "Cannot take sizeof($__r)"; }';
	}
}

{
	package Anarres::Mud::Driver::Efun::MudOS::file_size;
	use Fcntl qw(:mode);
	sub invoke {
		my @stat = stat($_[1]);
		return -1 unless @stat;
		return -2 if ($stat[2] & S_IFDIR);
		return $stat[2];
	}
}

{
	package Anarres::Mud::Driver::Efun::MudOS::map;
	use Anarres::Mud::Driver::Program::Type qw(:types);
	sub foo_typecheck_call {
		my ($self, $program, $values, @rest) = @_;
		my $val = $values->[1];
		my $func = $values->[2];

		$func = $func->infer(T_CLOSURE);
		unless ($func) {
			$program->error("Argument 2 to map must be a closure.");
		}

		if (my $arr = $val->infer(T_ARRAY)) {
			# $values->[0] = "(pointer to map_array)";
			$values->[1] = $arr;
			$arr->typecheck($program, undef, @rest) unless $arr == $val;
			return $arr->type;
		}
		elsif (my $map = $val->infer(T_MAPPING)) {
			# $values->[0] = "(pointer to map_mapping)";
			$values->[1] = $map;
			$map->typecheck($program, undef, @rest) unless $map == $val;
			return $map->type;
		}
		else {
			$program->error("Argument 1 to map must be a mapping " .
							"or an array.");
			return undef;
		}
	}
}

1;
