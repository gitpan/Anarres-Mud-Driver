#!/usr/bin/perl

while (<>) {
	unless (m/^#line/) {
		s/\byy/amdp_yy/g;
		s/YYSTYPE/AMDP_YYSTYPE/g;
	}
}
continue {
	print;
}
