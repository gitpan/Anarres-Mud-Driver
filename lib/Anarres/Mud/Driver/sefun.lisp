(program
	([m] var PL_v_irregular_pres)
	([s] var strwstrip_last_in)
	([m] var PL_v_ambiguous_pres)
	([Ps] var PL_sb_U_um_a)
	([s] var strwstrip_last_out)
	([Ps] var PL_v_ambiguous_non_pres)
	([s] var strdstrip_last_out)
	([m] var PL_v_map)
	([m] var english_o_val)
	([Pi] var ctype_data_punct)
	([m] var CJ_v_irregular_past)
	([m] var PL_pron_nom)
	([Ps] var PL_sb_general)
	([Ps] var PL_sb_U_a_ae)
	([s] var strtrim_last_in)
	([Ps] var PL_sb_U_ex_ices)
	([m] var PL_sb_irregular)
	([Ps] var PL_sb_C_us_us)
	([Ps] var PL_sb_C_on_a)
	([Ps] var PL_sb_uninflected)
	([m] var PL_v_tails)
	([i] var perror_errno)
	([Ps] var PL_sb_C_i)
	([Ps] var BodyLib)
	([m] var PL_sb_tails)
	([Ps] var PL_sb_singular_s)
	([Ps] var PL_sb_C_us_i)
	([m] var english_o_mult)
	([m] var PL_sb_map)
	([Ps] var PL_sb_U_o_os)
	([Ps] var PL_sb_uninflected_s)
	([Ps] var PL_sb_military)
	([m] var CJ_v_irregular_pres)
	([Ps] var PL_v_irregular_non_pres)
	([Ps] var PL_sb_U_man_mans)
	([m] var english_article)
	([P_] var call_outs)
	([m] var english_c_val)
	([Ps] var PL_sb_U_on_a)
	([m] var CJ_v_map)
	([m] var PL_pron_map)
	([m] var config_boolean)
	([s] var strdstrip_last_in)
	([s] var strcstrip_last_out)
	([Ps] var PL_sb_C_um_a)
	([Ps] var PL_prep)
	([Ps] var PL_sb_C_en_ina)
	([Ps] var PL_sb_U_us_i)
	([f] var call_out_func)
	([Ps] var PL_sb_C_a_ae)
	([m] var PL_sb_irregular_s)
	([m] var PL_pron_acc)
	([s] var strcstrip_last_in)
	([s] var strtrim_last_out)
	([m] var english_c_mult)
	([i] var call_out_handle)
	([Pi] var ctype_data_space)
	([m] var CJ_v_tails)
	([Ps] var PL_sb_C_ex_ices)
	([Ps] var PL_sb_C_im)
	([Pi] var ctype_data_alpha)
	([Pi] var ctype_data_alnum)
	([Ps] var PL_sb_C_o_i)
	([Ps] var PL_sb_C_a_ata)
	([Pi] var ctype_data)
	([s] method file_name_base
		(args ([o] var ob))
		([V] block
			([s] var name)
			([s] var base)
			([i] var id)
			([V] stmtexp ([s] assign ([s] variable 'name') ([s] funcall 'file_name' ([o] variable 'ob'))))
			([V] stmtif ([i] inteq ([i] sscanf ([s] variable 'name') "%s#%d" ([s] variable 'base') ([i] variable 'id')) 2) ([V] stmtreturn ([s] variable 'base')) [undef])
			([V] stmtreturn ([s] variable 'name'))))
	([s] method english_parse_number_key
		(args ([s] var str) ([m] var m) ([m] var n))
		([V] block
			([s] var key)
			([V] stmtforeach ([s] variable 'key') ([Ps] funcall 'keys' ([m] variable 'm')) ([V] block
				([V] stmtif ([i] inteq ([i] funcall 'strsrch' ([s] variable 'str') ([s] variable 'key')) 0) ([V] stmtreturn ([s] variable 'key')) [undef])))
			([V] stmtforeach ([s] variable 'key') ([Ps] funcall 'keys' ([m] variable 'n')) ([V] block
				([V] stmtif ([i] inteq ([i] funcall 'strsrch' ([s] variable 'str') ([s] variable 'key')) 0) ([V] stmtreturn ([s] variable 'key')) [undef])))
			([V] stmtreturn 0)))
	([s] method english_consolidate
		(args ([i] var i) ([s] var str))
		([V] block
			([V] stmtswitch ([i] variable 'i') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtreturn ([i] plus "no " ([s] funcall 'english_remove_article' ([s] variable 'str'))))
				([V] stmtcase 1 [undef])
				([V] stmtreturn ([s] variable 'str'))
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'english_remove_article' ([s] variable 'str'))))
				([V] stmtreturn ([i] plus ([i] plus ([s] funcall 'english_cardinal' ([i] variable 'i')) " ") ([s] funcall 'english_pluralise' ([s] variable 'str'))))))))
	([V] method call_out_create
		(args)
		([V] block
			([V] stmtexp ([P_] assign ([P_] variable 'call_outs') ([PP_] array)))
			([V] stmtexp ([i] assign ([i] variable 'call_out_handle') 0))
			([V] stmtexp ([f] assign ([f] variable 'call_out_func') ([f] closure ([V] funcall 'run_call_outs' ([_] parameter 1)))))))
	([V] method remove_interactive
		(args ([o] var ob))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No remove_interactive"))))
	([i] method isprint
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 16534))))))
	([s] method english_pluralise
		(args ([_] var arg))
		([V] block
			([s] var str)
			([V] stmtexp ([i] funcall 'set_errno' 0))
			([V] stmtif ([b] funcall 'objectp' ([_] variable 'arg')) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'str') ([s] assert ([_] callother ([_] variable 'arg') -> 'GetCapName' 0 args))))
				([V] stmtif ([i] unot ([s] variable 'str')) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus "Object " ([s] funcall 'file_name' ([_] variable 'arg'))) " has no key name for english_pluralise")))
					([V] stmtexp ([i] funcall 'set_errno' 61))
					([V] stmtreturn 0)) [undef])) ([V] stmtif ([b] funcall 'stringp' ([_] variable 'arg')) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'str') ([_] variable 'arg')))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "english_pluralise expects object or string argument, got " ([s] funcall 'typeof' ([_] variable 'arg')))))
				([V] stmtexp ([i] funcall 'set_errno' 22))
				([V] stmtreturn 0))))
			([V] stmtreturn ([s] funcall 'pluralise_noun' ([s] variable 'str')))))
	([i] method dir_exists
		(args ([s] var dir))
		([V] block
			([V] stmtreturn ([i] inteq ([i] funcall 'file_size' ([s] variable 'dir')) ([i] uplus 2)))))
	([o] method bodies
		(args)
		([V] block
			([V] stmtreturn ([i] minus ([i] assert ([_] callother ([_] callother "/usr/libexec/sys/user" -> 'GetUsers' 0 args) -> 'GetCurrentBody' 0 args)) ([Pi] array 0)))))
	([i] method check_privs
		(args ([s] var str))
		([V] block
			([V] stmtreturn ([_] callother "/usr/libexec/auth/security" -> 'CheckPrivilege' 2 args))))
	([s] method strerror
		(args ([i] var x))
		([V] block
			([s] var str)
			([V] stmtswitch ([i] variable 'x') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Success"))
				([V] stmtbreak)
				([V] stmtcase 1 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation not permitted"))
				([V] stmtbreak)
				([V] stmtcase 2 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No such file or directory"))
				([V] stmtbreak)
				([V] stmtcase 3 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No such process"))
				([V] stmtbreak)
				([V] stmtcase 4 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Interrupted system call"))
				([V] stmtbreak)
				([V] stmtcase 5 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "I/O error"))
				([V] stmtbreak)
				([V] stmtcase 6 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No such device or address"))
				([V] stmtbreak)
				([V] stmtcase 7 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Arg list too long"))
				([V] stmtbreak)
				([V] stmtcase 8 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Exec format error"))
				([V] stmtbreak)
				([V] stmtcase 9 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Bad file number"))
				([V] stmtbreak)
				([V] stmtcase 10 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No child processes"))
				([V] stmtbreak)
				([V] stmtcase 11 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Try again"))
				([V] stmtbreak)
				([V] stmtcase 12 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Out of memory"))
				([V] stmtbreak)
				([V] stmtcase 13 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Permission denied"))
				([V] stmtbreak)
				([V] stmtcase 14 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Bad address"))
				([V] stmtbreak)
				([V] stmtcase 15 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Block device required"))
				([V] stmtbreak)
				([V] stmtcase 16 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Device or resource busy"))
				([V] stmtbreak)
				([V] stmtcase 17 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "File exists"))
				([V] stmtbreak)
				([V] stmtcase 18 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Cross-device link"))
				([V] stmtbreak)
				([V] stmtcase 19 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No such device"))
				([V] stmtbreak)
				([V] stmtcase 20 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Not a directory"))
				([V] stmtbreak)
				([V] stmtcase 21 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Is a directory"))
				([V] stmtbreak)
				([V] stmtcase 22 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Invalid argument"))
				([V] stmtbreak)
				([V] stmtcase 23 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "File table overflow"))
				([V] stmtbreak)
				([V] stmtcase 24 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Too many open files"))
				([V] stmtbreak)
				([V] stmtcase 25 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Not a typewriter"))
				([V] stmtbreak)
				([V] stmtcase 26 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Text file busy"))
				([V] stmtbreak)
				([V] stmtcase 27 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "File too large"))
				([V] stmtbreak)
				([V] stmtcase 28 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No space left on device"))
				([V] stmtbreak)
				([V] stmtcase 29 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Illegal seek"))
				([V] stmtbreak)
				([V] stmtcase 30 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Read-only file system"))
				([V] stmtbreak)
				([V] stmtcase 31 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Too many links"))
				([V] stmtbreak)
				([V] stmtcase 32 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Broken pipe"))
				([V] stmtbreak)
				([V] stmtcase 33 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Math argument out of domain of func"))
				([V] stmtbreak)
				([V] stmtcase 34 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Math result not representable"))
				([V] stmtbreak)
				([V] stmtcase 35 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Resource deadlock would occur"))
				([V] stmtbreak)
				([V] stmtcase 36 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "File name too long"))
				([V] stmtbreak)
				([V] stmtcase 37 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No record locks available"))
				([V] stmtbreak)
				([V] stmtcase 38 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Function not implemented"))
				([V] stmtbreak)
				([V] stmtcase 39 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Directory not empty"))
				([V] stmtbreak)
				([V] stmtcase 40 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Too many symbolic links encountered"))
				([V] stmtbreak)
				([V] stmtcase 11 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation would block"))
				([V] stmtbreak)
				([V] stmtcase 42 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No message of desired type"))
				([V] stmtbreak)
				([V] stmtcase 43 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Identifier removed"))
				([V] stmtbreak)
				([V] stmtcase 44 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Channel number out of range"))
				([V] stmtbreak)
				([V] stmtcase 45 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Level 2 not synchronized"))
				([V] stmtbreak)
				([V] stmtcase 46 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Level 3 halted"))
				([V] stmtbreak)
				([V] stmtcase 47 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Level 3 reset"))
				([V] stmtbreak)
				([V] stmtcase 48 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Link number out of range"))
				([V] stmtbreak)
				([V] stmtcase 49 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol driver not attached"))
				([V] stmtbreak)
				([V] stmtcase 50 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No CSI structure available"))
				([V] stmtbreak)
				([V] stmtcase 51 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Level 2 halted"))
				([V] stmtbreak)
				([V] stmtcase 52 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Invalid exchange"))
				([V] stmtbreak)
				([V] stmtcase 53 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Invalid request descriptor"))
				([V] stmtbreak)
				([V] stmtcase 54 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Exchange full"))
				([V] stmtbreak)
				([V] stmtcase 55 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No anode"))
				([V] stmtbreak)
				([V] stmtcase 56 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Invalid request code"))
				([V] stmtbreak)
				([V] stmtcase 57 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Invalid slot"))
				([V] stmtbreak)
				([V] stmtcase 59 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Bad font file format"))
				([V] stmtbreak)
				([V] stmtcase 60 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Device not a stream"))
				([V] stmtbreak)
				([V] stmtcase 61 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No data available"))
				([V] stmtbreak)
				([V] stmtcase 62 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Timer expired"))
				([V] stmtbreak)
				([V] stmtcase 63 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Out of streams resources"))
				([V] stmtbreak)
				([V] stmtcase 64 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Machine is not on the network"))
				([V] stmtbreak)
				([V] stmtcase 65 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Package not installed"))
				([V] stmtbreak)
				([V] stmtcase 66 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Object is remote"))
				([V] stmtbreak)
				([V] stmtcase 67 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Link has been severed"))
				([V] stmtbreak)
				([V] stmtcase 68 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Advertise error"))
				([V] stmtbreak)
				([V] stmtcase 69 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Srmount error"))
				([V] stmtbreak)
				([V] stmtcase 70 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Communication error on send"))
				([V] stmtbreak)
				([V] stmtcase 71 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol error"))
				([V] stmtbreak)
				([V] stmtcase 72 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Multihop attempted"))
				([V] stmtbreak)
				([V] stmtcase 73 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "RFS specific error"))
				([V] stmtbreak)
				([V] stmtcase 74 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Not a data message"))
				([V] stmtbreak)
				([V] stmtcase 75 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Value too large for defined data type"))
				([V] stmtbreak)
				([V] stmtcase 76 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Name not unique on network"))
				([V] stmtbreak)
				([V] stmtcase 77 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "File descriptor in bad state"))
				([V] stmtbreak)
				([V] stmtcase 78 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Remote address changed"))
				([V] stmtbreak)
				([V] stmtcase 79 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Can not access a needed shared library"))
				([V] stmtbreak)
				([V] stmtcase 80 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Accessing a corrupted shared library"))
				([V] stmtbreak)
				([V] stmtcase 81 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') ".lib section in a.out corrupted"))
				([V] stmtbreak)
				([V] stmtcase 82 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Attempting to link in too many shared libraries"))
				([V] stmtbreak)
				([V] stmtcase 83 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Cannot exec a shared library directly"))
				([V] stmtbreak)
				([V] stmtcase 84 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Illegal byte sequence"))
				([V] stmtbreak)
				([V] stmtcase 85 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Interrupted system call should be restarted"))
				([V] stmtbreak)
				([V] stmtcase 86 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Streams pipe error"))
				([V] stmtbreak)
				([V] stmtcase 87 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Too many users"))
				([V] stmtbreak)
				([V] stmtcase 88 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket operation on non-socket"))
				([V] stmtbreak)
				([V] stmtcase 89 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Destination address required"))
				([V] stmtbreak)
				([V] stmtcase 90 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Message too long"))
				([V] stmtbreak)
				([V] stmtcase 91 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol wrong type for socket"))
				([V] stmtbreak)
				([V] stmtcase 92 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol not available"))
				([V] stmtbreak)
				([V] stmtcase 93 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol not supported"))
				([V] stmtbreak)
				([V] stmtcase 94 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket type not supported"))
				([V] stmtbreak)
				([V] stmtcase 95 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation not supported on transport endpoint"))
				([V] stmtbreak)
				([V] stmtcase 96 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Protocol family not supported"))
				([V] stmtbreak)
				([V] stmtcase 97 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Address family not supported by protocol"))
				([V] stmtbreak)
				([V] stmtcase 98 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Address already in use"))
				([V] stmtbreak)
				([V] stmtcase 99 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Cannot assign requested address"))
				([V] stmtbreak)
				([V] stmtcase 100 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Network is down"))
				([V] stmtbreak)
				([V] stmtcase 101 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Network is unreachable"))
				([V] stmtbreak)
				([V] stmtcase 102 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Network dropped connection because of reset"))
				([V] stmtbreak)
				([V] stmtcase 103 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Software caused connection abort"))
				([V] stmtbreak)
				([V] stmtcase 104 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Connection reset by peer"))
				([V] stmtbreak)
				([V] stmtcase 105 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No buffer space available"))
				([V] stmtbreak)
				([V] stmtcase 106 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Transport endpoint is already connected"))
				([V] stmtbreak)
				([V] stmtcase 107 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Transport endpoint is not connected"))
				([V] stmtbreak)
				([V] stmtcase 108 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Cannot send after transport endpoint shutdown"))
				([V] stmtbreak)
				([V] stmtcase 109 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Too many references: cannot splice"))
				([V] stmtbreak)
				([V] stmtcase 110 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Connection timed out"))
				([V] stmtbreak)
				([V] stmtcase 111 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Connection refused"))
				([V] stmtbreak)
				([V] stmtcase 112 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Host is down"))
				([V] stmtbreak)
				([V] stmtcase 113 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No route to host"))
				([V] stmtbreak)
				([V] stmtcase 114 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation already in progress"))
				([V] stmtbreak)
				([V] stmtcase 115 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation now in progress"))
				([V] stmtbreak)
				([V] stmtcase 116 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Stale NFS file handle"))
				([V] stmtbreak)
				([V] stmtcase 117 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Structure needs cleaning"))
				([V] stmtbreak)
				([V] stmtcase 118 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Not a XENIX named type file"))
				([V] stmtbreak)
				([V] stmtcase 119 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No XENIX semaphores available"))
				([V] stmtbreak)
				([V] stmtcase 120 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Is a named type file"))
				([V] stmtbreak)
				([V] stmtcase 121 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Remote I/O error"))
				([V] stmtbreak)
				([V] stmtcase 122 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Quota exceeded"))
				([V] stmtbreak)
				([V] stmtcase 123 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No medium found"))
				([V] stmtbreak)
				([V] stmtcase 124 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Wrong medium type"))
				([V] stmtbreak)
				([V] stmtcase 1 [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Call was successful"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 1) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem creating socket"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 2) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with setsockopt"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 3) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem setting non-blocking mode"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 4) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "No more available efun sockets"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 5) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Descriptor out of range"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 6) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Descriptor is invalid"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 7) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Security violation attempted"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 8) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket is already bound"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 9) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Address already in use"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 10) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with bind"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 11) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with getsockname"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 12) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket mode not supported"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 13) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket not bound to an address"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 14) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket is already connected"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 15) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with listen"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 16) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket not listening"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 17) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation would block"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 18) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Interrupted system call"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 19) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with accept"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 20) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket is listening"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 21) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with address format"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 22) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Operation already in progress"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 23) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Connection refused"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 24) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with connect"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 25) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket not connected"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 26) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Object type not supported"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 27) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with sendto"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 28) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Problem with send"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 29) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Wait for callback"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 30) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket already released"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 31) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Socket not released"))
				([V] stmtbreak)
				([V] stmtcase ([i] uplus 32) [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') "Sending data with too many nested levels"))
				([V] stmtbreak)
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([s] assign ([s] variable 'str') ([i] plus "Unknown error " ([i] variable 'x'))))
				([V] stmtbreak)))
			([V] stmtreturn ([i] plus ([i] plus ([i] plus "(" ([i] variable 'x')) ") ") ([s] variable 'str')))))
	([s] method get_dir
		(args ([s] var dir))
		([V] block
			([Ps] var arr)
			([V] stmtif ([b] funcall 'arrayp' ([Ps] assign ([Ps] variable 'arr') ([s] funcall 'get_dir' ([s] variable 'dir')))) ([V] stmtexp ([Ps] assign ([Ps] variable 'arr') ([i] minus ([Ps] variable 'arr') ([Ps] array "CVS")))) [undef])
			([V] stmtreturn ([Ps] variable 'arr'))))
	([s] method english_reflexive_pronoun
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] plus ([s] funcall 'english_accusative_pronoun' ([o] variable 'ob')) "self"))))
	([s] method mud_lib
		(args)
		([V] block
			([V] stmtreturn "Anarres II")))
	([V] method set_living_name
		(args ([s] var str))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No set_living_name"))))
	([V] method conjugate_verb_build_tails
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'CJ_v_tails') ([m] mapping)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "ay") ([P_] array "ays" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "ey") ([P_] array "eys" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "iy") ([P_] array "iys" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "oy") ([P_] array "oys" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "uy") ([P_] array "uys" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "ch") ([P_] array "ches" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "sh") ([P_] array "shes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "az") ([P_] array "azzes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "ez") ([P_] array "ezzes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "iz") ([P_] array "izzes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "oz") ([P_] array "ozzes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "uz") ([P_] array "uzzes" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "y") ([P_] array "ies" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "s") ([P_] array "ses" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'CJ_v_tails') "z") ([P_] array "zes" 90)))))
	([s] method exit_type
		(args ([i] var n))
		([V] block
			([s] var s)
			([V] stmtswitch ([i] variable 'n') ([V] block
				([V] stmtcase ([i] lsh 1 0) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "go"))
				([V] stmtcase ([i] lsh 1 1) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "climb"))
				([V] stmtcase ([i] lsh 1 2) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "jump"))
				([V] stmtcase ([i] lsh 1 3) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "crawl"))
				([V] stmtcase ([i] lsh 1 4) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "swim"))
				([V] stmtcase ([i] lsh 1 5) [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "fly"))
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([s] assign ([s] variable 's') "%^RED%^ERROR%^RESET%^"))))
			([V] stmtreturn ([s] variable 's'))))
	([V] method conjugate_verb_build_arrays
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'CJ_v_irregular_pres') ([m] mapping "" ([Ps] array "" "" "" "") "be" ([Ps] array "am" "are" "is" "are") "can" ([Ps] array "can" "can" "can" "can") "cannot" ([Ps] array "cannot" "cannot" "cannot" "cannot") "do" ([Ps] array "do" "do" "does" "do") "go" ([Ps] array "go" "go" "goes" "go") "have" ([Ps] array "have" "have" "has" "have") "may" ([Ps] array "may" "may" "might" "may") "would" ([Ps] array "would" "would" "would" "would"))))
			([V] stmtexp ([m] assign ([m] variable 'CJ_v_irregular_past') ([m] mapping "arise" "arose" "awake" "awaked" "be" "was" "bear" "bore" "beat" "beat" "become" "became" "begin" "began" "behold" "beheld" "bend" "bent" "beset" "beset" "bet" "bet" "bid" "bid" "bind" "bound" "bite" "bit" "bleed" "bled" "blow" "blew" "break" "broke" "breed" "bred" "bring" "brought" "build" "built" "burn" "burnt" "burst" "burst" "buy" "bought" "can" "could" "cast" "cast" "catch" "caught" "choose" "chose" "cling" "clung" "come" "came" "cost" "cost" "creep" "crept" "cut" "cut" "deal" "dealt" "dig" "dug" "do" "did" "draw" "drew" "dream" "dreamt" "drink" "drank" "drive" "drove" "dwell" "dwelt" "eat" "ate" "fall" "fell" "feed" "fed" "feel" "felt" "fight" "bought" "find" "found" "flee" "fled" "fling" "flung" "fly" "flew" "forbid" "forbade" "forecast" "forecast" "forget" "forgot" "forgive" "forgave" "forsake" "forsook" "freeze" "froze" "get" "got" "give" "gave" "go" "went" "grind" "ground" "grow" "grew" "hang" "hung" "have" "had" "hear" "heard" "hide" "hid" "hit" "hit")))))
	([o] method find_player
		(args ([s] var s))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No find_player, use USER_D"))))
	([_] method array_rescale
		(args ([P_] var arr) ([i] var size))
		([V] block
			([P_] var out)
			([i] var low)
			([i] var mult)
			([i] var ptr)
			([i] var i)
			([i] var j)
			([V] stmtif ([i] intle ([i] variable 'size') 0) ([V] stmtreturn ([PP_] array)) [undef])
			([V] stmtif ([i] intlt ([i] variable 'size') ([i] funcall 'sizeof' ([P_] variable 'arr'))) ([V] stmtreturn ([P_] range ([P_] variable 'arr') 0 ([i] minus ([i] variable 'size') 1))) [undef])
			([V] stmtif ([i] inteq ([i] variable 'size') ([i] funcall 'sizeof' ([P_] variable 'arr'))) ([V] stmtreturn ([P_] variable 'arr')) [undef])
			([V] stmtexp ([P_] assign ([P_] variable 'out') ([P_] funcall 'allocate' ([i] variable 'size') 4)))
			([V] stmtexp ([i] assign ([i] variable 'mult') ([i] divide ([i] variable 'size') ([i] funcall 'sizeof' ([P_] variable 'arr')))))
			([V] stmtexp ([i] assign ([i] variable 'low') ([i] minus ([i] variable 'size') ([i] mult ([i] variable 'mult') ([i] funcall 'sizeof' ([P_] variable 'arr'))))))
			([V] stmtexp ([i] assign ([i] variable 'ptr') 0))
			([V] stmtexp ([i] postinc ([i] variable 'mult')))
			([V] stmtfor ([i] assign ([i] variable 'i') 0) ([i] intlt ([i] variable 'i') ([i] variable 'low')) ([i] postinc ([i] variable 'i')) ([V] stmtfor ([i] assign ([i] variable 'j') 0) ([i] intlt ([i] variable 'j') ([i] variable 'mult')) ([i] postinc ([i] variable 'j')) ([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'out') ([i] postinc ([i] variable 'ptr'))) ([_] indexarray ([P_] variable 'arr') ([i] variable 'i'))))))
			([V] stmtexp ([i] postdec ([i] variable 'mult')))
			([V] stmtfor [undef] ([i] intlt ([i] variable 'i') ([i] funcall 'sizeof' ([P_] variable 'arr'))) ([i] postinc ([i] variable 'i')) ([V] stmtfor ([i] assign ([i] variable 'j') 0) ([i] intlt ([i] variable 'j') ([i] variable 'mult')) ([i] postinc ([i] variable 'j')) ([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'out') ([i] postinc ([i] variable 'ptr'))) ([_] indexarray ([P_] variable 'arr') ([i] variable 'i'))))))
			([V] stmtreturn ([P_] variable 'out'))))
	([i] method globmatch
		(args ([s] var glob) ([s] var str))
		([V] block
			([V] stmtreturn ([i] funcall 'regmatch' ([s] funcall 'glob2regex' ([s] variable 'glob')) ([s] variable 'str')))))
	([o] method get_object
		(args ([s] var arg) ([_] var rel))
		([V] block
			([s] var err)
			([o] var ob)
			([V] stmtexp ([s] assign ([s] variable 'arg') ([s] funcall 'get_object_path' ([s] variable 'arg') ([_] variable 'rel'))))
			([V] stmtif ([o] assign ([o] variable 'ob') ([o] funcall 'find_object' ([s] variable 'arg'))) ([V] stmtreturn ([o] variable 'ob')) [undef])
			([V] stmtif ([i] logor ([i] intlt ([i] funcall 'strlen' ([s] variable 'arg')) 2) ([s] strne ([s] range ([s] variable 'arg') 2 1) ".c")) ([V] stmtexp ([s] assign ([s] variable 'arg') ([i] plus ([s] variable 'arg') ".c"))) [undef])
			([V] stmtif ([i] intlt ([i] funcall 'file_size' ([s] variable 'arg')) 0) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 4 "sefun" ([i] plus "Could not find file " ([s] variable 'arg'))))
				([V] stmtexp ([i] funcall 'set_errno' 2))
				([V] stmtreturn 0)) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'err') ([s] catch ([o] assign ([o] variable 'ob') ([o] funcall 'load_object' ([s] variable 'arg'))))))
				([V] stmtif ([s] variable 'err') ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "get_object: " ([s] variable 'err'))))
					([V] stmtexp ([i] funcall 'set_errno' 61))
					([V] stmtreturn 0)) ([V] stmtif ([i] unot ([b] funcall 'objectp' ([o] variable 'ob'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus "get_object: Got 0 object (" ([s] variable 'arg')) ")")))
					([V] stmtexp ([i] funcall 'set_errno' 61))
					([V] stmtreturn 0)) [undef]))))
			([V] stmtreturn ([o] variable 'ob'))))
	([s] method english_remove_article
		(args ([s] var str))
		([V] block
			([Ps] var words)
			([s] var word)
			([i] var i)
			([V] stmtexp ([Ps] assign ([Ps] variable 'words') ([Ps] funcall 'explode' ([s] variable 'str') " ")))
			([V] stmtexp ([i] assign ([i] variable 'i') 0))
			([V] stmtforeach ([s] variable 'word') ([Ps] variable 'words') ([V] block
				([V] stmtif ([i] unot ([i] assert ([_] indexmap ([m] variable 'english_article') ([s] funcall 'lower_case' ([s] variable 'word'))))) ([V] stmtbreak) [undef])
				([V] stmtexp ([i] postinc ([i] variable 'i')))))
			([V] stmtreturn ([s] funcall 'implode' ([Ps] range ([Ps] variable 'words') ([i] variable 'i') 1) " "))))
	([i] method regmatch
		(args ([s] var preg) ([s] var str))
		([V] block
			([V] stmtreturn ([i] unot ([i] funcall 'regexp' ([s] variable 'str') ([s] variable 'preg'))))))
	([i] method itemp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([s] funcall 'inherits' "/lib/item" ([o] variable 'ob')))))))
	([s] method english_item_list
		(args ([P_] var items))
		([V] block
			([m] var counts)
			([m] var descs)
			([Ps] var list)
			([_] var item)
			([s] var str)
			([V] stmtforeach ([_] variable 'item') ([P_] variable 'items') ([V] block
				([V] stmtif ([i] unot ([b] funcall 'objectp' ([_] variable 'item'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 4 "sefun" ([i] plus ([i] plus "Bad type " ([s] funcall 'typeof' ([_] variable 'item'))) " in item_list")))
					([V] stmtcontinue)) ([V] stmtif ([s] assign ([s] variable 'str') ([s] assert ([_] callother ([_] variable 'item') -> 'GetCapName' 0 args))) ([V] block
					([V] stmtexp ([i] postinc ([i] assert ([_] indexmap ([m] variable 'counts') ([s] variable 'str')))))) ([V] stmtif ([s] assign ([s] variable 'str') ([s] assert ([_] callother ([_] variable 'item') -> 'GetShort' 0 args))) ([V] block
					([V] stmtexp ([i] postinc ([i] assert ([_] indexmap ([m] variable 'counts') ([s] variable 'str')))))) ([V] block
					([V] stmtexp ([i] postinc ([i] assert ([_] indexmap ([m] variable 'counts') ([s] funcall 'file_name' ([_] variable 'item'))))))))))))
			([V] stmtexp ([m] assign ([m] variable 'descs') ([P_] funcall 'map' ([m] variable 'counts') ([f] closure ([s] funcall 'english_consolidate' ([_] parameter 2) ([_] parameter 1))))))
			([V] stmtswitch ([i] funcall 'sizeof' ([m] variable 'descs')) ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtreturn "")
				([V] stmtcase 1 [undef])
				([V] stmtreturn ([_] indexarray ([P_] funcall 'values' ([m] variable 'descs')) 0))
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([Ps] assign ([Ps] variable 'list') ([P_] funcall 'values' ([m] variable 'descs'))))
				([V] stmtreturn ([i] plus ([i] plus ([s] funcall 'implode' ([Ps] range ([Ps] variable 'list') 0 2) ", ") " and ") ([s] indexarray ([Ps] variable 'list') 1)))))))
	([s] method mud_version
		(args)
		([V] block
			([V] stmtreturn "1.3.0-login")))
	([V] method memory_summary
		(args)
		([V] block
			([V] stmtexp ([s] funcall 'error' "No memory_summary"))))
	([V] method english_create
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'english_c_val') ([m] mapping "zero" 0 "one" 1 "two" 2 "three" 3 "four" 4 "five" 5 "six" 6 "seven" 7 "eight" 8 "nine" 9 "ten" 10 "eleven" 11 "twelve" 12 "thirteen" 13 "fourteen" 14 "fifteen" 15 "sixteen" 16 "seventeen" 17 "eighteen" 18 "nineteen" 19 "twenty" 20 "thirty" 30 "forty" 40 "fifty" 50 "sixty" 60 "seventy" 70 "eighty" 80 "ninty" 90)))
			([V] stmtexp ([m] assign ([m] variable 'english_c_mult') ([m] mapping "dozen" 12 "score" 20 "hundred" 100 "thousand" 1000 "million" 1000000)))
			([V] stmtexp ([m] assign ([m] variable 'english_o_val') ([m] mapping "zeroeth" 0 "first" 1 "second" 2 "third" 3 "fourth" 4 "fifth" 5 "sixth" 6 "seventh" 7 "eighth" 8 "ninth" 9 "tenth" 10 "eleventh" 11 "twelfth" 12 "thirteenth" 13 "fourteenth" 14 "fifteenth" 15 "sixteenth" 16 "seventeenth" 17 "eighteenth" 18 "nineteenth" 19 "twentieth" 20 "thirtieth" 30 "fortieth" 40 "fiftieth" 50 "sixtieth" 60 "seventieth" 70 "eightieth" 80 "nintieth" 90)))
			([V] stmtexp ([m] assign ([m] variable 'english_o_mult') ([m] mapping "dozenth" 12 "hundredth" 100 "thousandth" 1000 "millionth" 1000000)))
			([V] stmtexp ([m] assign ([m] variable 'english_article') ([m] mapping "" 1 "a" 1 "an" 1 "that" 1 "the" 1 "this" 1)))))
	([s] method english_accusative_pronoun
		(args ([o] var ob))
		([V] block
			([i] var sex)
			([V] stmtswitch ([i] variable 'sex') ([V] block
				([V] stmtcase 1 [undef])
				([V] stmtreturn "him")
				([V] stmtcase 2 [undef])
				([V] stmtreturn "her")
				([V] stmtcase [undef] [undef])
				([V] stmtreturn "it")))))
	([s] method pluralize
		(args ([s] var s))
		([V] block
			([V] stmtexp ([s] funcall 'error' "Please use pluralise"))))
	([V] method player_create
		(args)
		([V] block
			([V] stmtexp ([Ps] assign ([Ps] variable 'BodyLib') ([Ps] array "/lib/body")))))
	([o] method get_clone
		(args ([_] var arg) ([_] var rel) ([s] var data))
		([V] block
			([s] var err)
			([o] var ob)
			([V] stmtexp ([o] assign ([o] variable 'ob') ([o] funcall 'get_object' ([_] variable 'arg') ([_] variable 'rel'))))
			([V] stmtif ([i] unot ([o] variable 'ob')) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "get_clone got 0 from get_object"))
				([V] stmtreturn 0)) [undef])
			([V] stmtexp ([s] assign ([s] variable 'err') ([s] catch ([o] assign ([o] variable 'ob') ([o] funcall 'clone_object' ([s] funcall 'file_name' ([o] variable 'ob')))))))
			([V] stmtif ([s] variable 'err') ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "get_clone: " ([s] variable 'err'))))
				([V] stmtexp ([i] funcall 'set_errno' 61))
				([V] stmtreturn 0)) ([V] stmtif ([i] unot ([b] funcall 'objectp' ([o] variable 'ob'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "get_clone got 0 from clone_object"))
				([V] stmtreturn 0)) [undef]))
			([V] stmtif ([s] variable 'data') ([V] block
				([V] stmtif ([i] unot ([b] funcall 'stringp' ([s] variable 'data'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "get_clone: unserialise data not string: returning raw object"))) ([V] block
					([V] stmtexp ([_] callother ([o] variable 'ob') -> 'unserialise' 1 args))))) [undef])
			([V] stmtexp ([_] callother ([o] variable 'ob') -> 'SetDataLock' 1 args))
			([V] stmtreturn ([o] variable 'ob'))))
	([i] method eval_cost
		(args)
		([V] block
			([V] stmtreturn ([i] funcall 'eval_cost'))))
	([i] method iscntrl
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 206696))))))
	([i] method isalnum
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] indexarray ([Pi] variable 'ctype_data_alnum') ([i] variable 'x')))))
	([i] method isalpha
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] indexarray ([Pi] variable 'ctype_data_alpha') ([i] variable 'x')))))
	([V] method syslog_privs
		(args)
		([V] block
			([Po] var obs)
			([o] var ob)
			([Ps] var out)
			([V] stmtexp ([Po] assign ([Po] variable 'obs') ([o] funcall 'previous_object' ([i] uplus 1))))
			([V] stmtexp ([Ps] assign ([Ps] variable 'out') ([PP_] array)))
			([V] stmtforeach ([o] variable 'ob') ([Po] variable 'obs') ([V] block
				([V] stmtexp ([Ps] assign ([Ps] variable 'out') ([i] plus ([Ps] variable 'out') ([Pi] array ([i] plus ([i] plus ([i] plus ([s] funcall 'file_name' ([o] variable 'ob')) "(") ([i] assert ([_] callother ([o] variable 'ob') -> 'GetPrivilege' 0 args))) ")")))))))
			([V] stmtexp ([V] funcall 'syslog' 7 "PRIVS" ([s] funcall 'implode' ([Ps] variable 'out') " -==- ")))))
	([V] method reload_object
		(args ([o] var ob))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No reload_object"))))
	([V] method pluralise_verb_build_tails
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_v_tails') ([m] mapping)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "ches") ([P_] array "ch" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "shes") ([P_] array "sh" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "zzes") ([P_] array "zz" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "xes") ([P_] array "x" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "ses") ([P_] array "s" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "ies") ([P_] array "y" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "oes") ([P_] array "o" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_tails') "s") ([P_] array "" 80)))))
	([o] method set_this_player
		(args ([s] var s))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No set_this_player"))))
	([V] method ctype_create
		(args)
		([V] block
			([V] stmtexp ([Pi] assign ([Pi] variable 'ctype_data') ([Pi] array 299346 299346 299346 299346 299346 299346 299346 299346 299346 301344 300644 300644 300644 300644 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 299346 135752 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 169622 165764 165764 165764 165764 165764 165764 165764 165764 165764 165764 169622 169622 169622 169622 169622 169622 169622 165745 165745 165745 165745 165745 165745 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 165689 169622 169622 169622 169622 169622 169622 165747 165747 165747 165747 165747 165747 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 165697 169622 169622 169622 169622 299346 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696 206696)))
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([Pi] assign ([Pi] variable 'ctype_data_alpha') ([P_] funcall 'map' ([Pi] variable 'ctype_data') ([f] closure ([i] unot ([i] unot ([i] bitand ([i] assert ([_] parameter 1)) 1)))))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([Pi] assign ([Pi] variable 'ctype_data_alnum') ([P_] funcall 'map' ([Pi] variable 'ctype_data') ([f] closure ([i] unot ([i] unot ([i] bitand ([i] assert ([_] parameter 1)) 100)))))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([Pi] assign ([Pi] variable 'ctype_data_space') ([P_] funcall 'map' ([Pi] variable 'ctype_data') ([f] closure ([i] unot ([i] unot ([i] bitand ([i] assert ([_] parameter 1)) 1298)))))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([Pi] assign ([Pi] variable 'ctype_data_punct') ([P_] funcall 'map' ([Pi] variable 'ctype_data') ([f] closure ([i] unot ([i] unot ([i] bitand ([i] assert ([_] parameter 1)) 4132)))))))))
			(undef)))
	([s] method absolute_path
		(args ([s] var base) ([s] var path))
		([V] block
			([Ps] var tmp)
			([i] var i)
			([i] var j)
			([i] var sz)
			([V] stmtif ([i] unot ([i] funcall 'strlen' ([s] variable 'path'))) ([V] stmtexp ([s] assign ([s] variable 'path') ([i] plus "/" ([s] variable 'base')))) ([V] stmtif ([i] intne ([i] indexarray ([s] variable 'path') 0) 47) ([V] stmtexp ([s] assign ([s] variable 'path') ([i] plus ([i] plus ([i] plus "/" ([s] variable 'base')) "/") ([s] variable 'path')))) [undef]))
			([V] stmtexp ([s] assign ([s] variable 'path') ([s] funcall 'replace_string_all' ([s] variable 'path') "//" "/")))
			([V] stmtif ([i] inteq ([i] funcall 'strsrch' ([s] variable 'path') "/.") ([i] uplus 1)) ([V] block
				([V] stmtreturn ([s] variable 'path'))) [undef])
			([V] stmtexp ([Ps] assign ([Ps] variable 'tmp') ([Ps] funcall 'explode' ([s] range ([s] variable 'path') 1 1) "/")))
			([V] stmtexp ([i] assign ([i] variable 'sz') ([i] funcall 'sizeof' ([Ps] variable 'tmp'))))
			([V] stmtexp ([i] assign ([i] variable 'j') ([i] uplus 1)))
			([V] stmtfor ([i] assign ([i] variable 'i') 0) ([i] intlt ([i] variable 'i') ([i] variable 'sz')) ([i] postinc ([i] variable 'i')) ([V] block
				([V] stmtswitch ([s] indexarray ([Ps] variable 'tmp') ([i] variable 'i')) ([V] block
					([V] stmtcase "" [undef])
					([V] stmtbreak)
					([V] stmtcase "." [undef])
					([V] stmtbreak)
					([V] stmtcase ".." [undef])
					([V] stmtif ([i] intge ([i] variable 'j') 0) ([V] stmtexp ([i] postdec ([i] variable 'j'))) [undef])
					([V] stmtbreak)
					([V] stmtcase [undef] [undef])
					([V] stmtexp ([s] assign ([s] indexarray ([Ps] variable 'tmp') ([i] preinc ([i] variable 'j'))) ([s] indexarray ([Ps] variable 'tmp') ([i] variable 'i'))))
					([V] stmtbreak)))))
			([V] stmtreturn ([i] plus "/" ([s] funcall 'implode' ([Ps] range ([Ps] variable 'tmp') 0 ([i] variable 'j')) "/")))))
	([V] method reset_eval_cost
		(args)
		([V] block
			([V] stmtreturn [undef])))
	([i] method creatorp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] logand ([i] funcall 'userp' ([o] variable 'ob')) ([_] callother "/usr/libexec/auth/privs" -> 'higher_privs' 2 args)))))
	([V] method pluralise_noun_build_map
		(args)
		([V] block
			([s] var e)
			([i] var n)
			([V] stmtexp ([m] assign ([m] variable 'PL_sb_map') ([i] plus ([i] plus ([i] plus ([P_] funcall 'map' ([m] variable 'PL_sb_irregular_s') ([f] closure ([s] funcall 'pluralise_split' ([_] parameter 2)))) ([P_] funcall 'map' ([m] variable 'PL_sb_irregular') ([f] closure ([s] funcall 'pluralise_split' ([_] parameter 2))))) ([m] variable 'PL_pron_map')) ([m] mapping "" ""))))
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "a") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_a_ata') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ata")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "a") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_a_ae') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ae")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "a") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_a_ae') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ae")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "en") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_en_ina') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ina")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "um") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_um_a') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "a")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "um") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_um_a') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "a")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "us") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_us_i') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "i")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "us") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_us_i') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "i")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "on") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_on_a') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "a")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "on") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_on_a') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "a")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "o") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_o_i') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "i")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "o") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_o_os') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "os")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "ex") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_ex_ices') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ices")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "ex") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_ex_ices') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "ices")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_i') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "i")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_C_im') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "im")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "man") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_U_man_mans') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "mans")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_uninflected_s') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_uninflected') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_singular_s') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "es")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' " general") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_general') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "s general")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "-general") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_sb_general') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "s-general")))))))
			(undef)))
	([s] method english_posessive
		(args ([o] var ob))
		([V] block
			([s] var n)
			([V] stmtif ([i] logor ([i] unot ([b] funcall 'stringp' ([s] variable 'n'))) ([i] unot ([i] funcall 'strlen' ([s] variable 'n')))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "posessive: Object has no CapName: " ([s] funcall 'file_name' ([o] variable 'ob')))))
				([V] stmtreturn "object's")) [undef])
			([V] stmtreturn ([i] plus ([s] variable 'n') "'s"))))
	([i] method userp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] logand ([i] unot ([i] funcall 'strsrch' ([s] funcall 'file_name' ([o] variable 'ob')) "/lib/user#")) ([_] callother ([o] variable 'ob') -> 'GetInteractive' 0 args)))))
	([s] method replace_string_all
		(args ([s] var s) ([s] var f) ([s] var r))
		([V] block
			([s] var o)
			([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'r') ([s] variable 'f')) ([i] uplus 1)) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus ([i] plus "replace_string_all: nontermination condition detected (f `" ([s] variable 'f')) "' r `") ([s] variable 'r')) "'")))
				([V] stmtreturn ([s] variable 's'))) [undef])
			([V] stmtdo ([s] strne ([s] variable 'o') ([s] variable 's')) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'o') ([s] variable 's')))
				([V] stmtexp ([s] assign ([s] variable 's') ([s] funcall 'replace_string' ([s] variable 's') ([s] variable 'f') ([s] variable 'r'))))))
			(undef)
			([V] stmtreturn ([s] variable 's'))))
	([s] method format_object
		(args ([o] var d))
		([V] block
			([s] var str)
			([V] stmtif ([b] funcall 'clonep' ([o] variable 'd')) ([V] block
				([V] stmtif ([_] callother ([o] variable 'd') -> 'GetCapName' 0 args) ([V] stmtexp ([s] assign ([s] variable 'str') ([s] assert ([_] callother ([o] variable 'd') -> 'GetCapName' 0 args)))) ([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'basename' ([s] funcall 'file_name_base' ([o] variable 'd'))))))) ([V] stmtexp ([s] assign ([s] variable 'str') ([i] plus ([i] plus "[" ([s] funcall 'basename' ([s] funcall 'file_name_base' ([o] variable 'd')))) "]"))))
			([V] stmtreturn ([s] variable 'str'))))
	([s] method strrtrim
		(args ([s] var s))
		([V] block
			([i] var i)
			([V] stmtexp ([i] assign ([i] variable 'i') ([i] minus ([i] funcall 'strlen' ([s] variable 's')) 1)))
			([V] stmtwhile ([i] logand ([i] intge ([i] variable 'i') 0) ([i] funcall 'isspace' ([i] indexarray ([s] variable 's') ([i] variable 'i')))) ([V] stmtexp ([i] postdec ([i] variable 'i'))))
			([V] stmtreturn ([s] range ([s] variable 's') 0 ([i] variable 'i')))))
	([i] method isxdigit
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 50))))))
	([i] method rmdir
		(args ([s] var dir))
		([V] block
			([V] stmtif ([i] funcall 'rmdir' ([s] variable 'dir')) ([V] block
				([V] stmtexp ([_] callother "/usr/libexec/auth/security" -> 'UnSetPrivs' 1 args))
				([V] stmtreturn 1)) [undef])
			([V] stmtreturn 0)))
	([i] method user_exists
		(args ([s] var name))
		([V] block
			([V] stmtreturn ([i] intgt ([i] funcall 'file_size' ([i] plus ([i] plus ([i] plus ([i] plus ([i] plus "/var/save/users/" ([s] range ([s] funcall 'strcstrip' ([s] variable 'name')) 0 0)) "/") ([s] funcall 'strcstrip' ([s] variable 'name'))) "/user") ".o")) 0))))
	([V] method tell_room
		(args ([o] var ob) ([s] var str))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No tell_room()"))))
	([s] method strtrim
		(args ([s] var s))
		([V] block
			([i] var j)
			([i] var i)
			([V] stmtif ([s] streq ([s] variable 's') ([s] variable 'strtrim_last_in')) ([V] stmtreturn ([s] variable 'strtrim_last_out')) [undef])
			([V] stmtexp ([s] assign ([s] variable 'strtrim_last_in') ([s] variable 's')))
			([V] stmtexp ([i] assign ([i] variable 'i') 0))
			([V] stmtexp ([i] assign ([i] variable 'j') ([i] minus ([i] funcall 'strlen' ([s] variable 's')) 1)))
			([V] stmtwhile ([i] logand ([i] intle ([i] variable 'i') ([i] variable 'j')) ([i] funcall 'isspace' ([i] indexarray ([s] variable 's') ([i] variable 'i')))) ([V] stmtexp ([i] postinc ([i] variable 'i'))))
			([V] stmtwhile ([i] logand ([i] intle ([i] variable 'i') ([i] variable 'j')) ([i] funcall 'isspace' ([i] indexarray ([s] variable 's') ([i] variable 'j')))) ([V] stmtexp ([i] postdec ([i] variable 'j'))))
			([V] stmtexp ([s] assign ([s] variable 'strtrim_last_out') ([s] range ([s] variable 's') ([i] variable 'i') ([i] variable 'j'))))
			([V] stmtreturn ([s] range ([s] variable 's') ([i] variable 'i') ([i] variable 'j')))))
	([i] method sys_port
		(args)
		([V] block
			([V] stmtreturn 5000)))
	([i] method atol
		(args ([s] var str))
		([V] block
			([V] stmtif ([i] unot ([b] funcall 'stringp' ([s] variable 'str'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "atol: str not string"))
				([V] stmtreturn 0)) [undef])
			([V] stmtreturn ([i] funcall 'to_int' ([s] variable 'str')))))
	([s] method sys_version
		(args)
		([V] block
			([V] stmtreturn "2.95.3 20010315 (SuSE)")))
	([s] method expand_flag
		(args ([o] var viewer) ([P_] var obs) ([s] var fmt) ([s] var str) ([i] var value) ([i] var flags))
		([V] block
			([_] var ob)
			([s] var out)
			([o] var user)
			([V] stmtif ([i] inteq ([i] variable 'value') ([i] uplus 1)) ([V] block
				([V] stmtif ([i] intne ([i] funcall 'strsrch' "NnVvUu" ([s] variable 'fmt')) ([i] uplus 1)) ([V] stmtexp ([i] assign ([i] variable 'value') 0)) ([V] stmtexp ([i] assign ([i] variable 'value') 1)))) [undef])
			([V] stmtif ([i] intge ([i] variable 'value') ([i] funcall 'sizeof' ([P_] variable 'obs'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus "expand_flag: " ([i] variable 'value')) " > sizeof(obs) for format ") ([s] variable 'fmt'))))
				([V] stmtreturn "ERROR(BAD_VALUE)")) [undef])
			([V] stmtexp ([_] assign ([_] variable 'ob') ([_] indexarray ([P_] variable 'obs') ([i] variable 'value'))))
			([V] stmtswitch ([s] variable 'fmt') ([V] block
				([V] stmtcase "$" [undef])
				([V] stmtbreak)
				([V] stmtcase "W" [undef])
				([V] stmtcase "w" [undef])
				([V] stmtif ([b] funcall 'stringp' ([_] variable 'ob')) ([V] stmtbreak) [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus ([i] plus "expand_flag: type " ([s] funcall 'typeof' ([_] variable 'ob'))) " illegal for format `") ([s] variable 'fmt')) "'")))
				([V] stmtreturn "ERROR(BAD_TYPE)")
				(undef)
				([V] stmtcase "I" [undef])
				([V] stmtcase "i" [undef])
				([V] stmtif ([b] funcall 'intp' ([_] variable 'ob')) ([V] stmtbreak) [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus ([i] plus "expand_flag: type " ([s] funcall 'typeof' ([_] variable 'ob'))) " illegal for format `") ([s] variable 'fmt')) "'")))
				([V] stmtreturn "ERROR(BAD_TYPE)")
				(undef)
				([V] stmtcase [undef] [undef])
				([V] stmtif ([b] funcall 'objectp' ([_] variable 'ob')) ([V] stmtbreak) [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus ([i] plus "expand_flag: type " ([s] funcall 'typeof' ([_] variable 'ob'))) " illegal for format `") ([s] variable 'fmt')) "'")))
				([V] stmtreturn "ERROR(BAD_TYPE)")
				(undef)))
			([V] stmtswitch ([s] variable 'fmt') ([V] block
				([V] stmtcase "U" [undef])
				([V] stmtcase "u" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtif ([o] assign ([o] variable 'user') ([o] assert ([_] callother ([_] variable 'ob') -> 'GetInterface' 0 args))) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([o] variable 'user') -> 'GetCapName' 0 args)))) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'file_name' ([_] variable 'ob'))))))
				([V] stmtbreak)
				([V] stmtcase "N" [undef])
				([V] stmtcase "n" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtif ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([_] variable 'ob') -> 'GetCapName' 0 args))) [undef] ([V] stmtexp ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([_] variable 'ob') -> 'GetShort' 0 args))))))
				([V] stmtbreak)
				([V] stmtcase "T" [undef])
				([V] stmtcase "t" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([_] indexarray ([P_] variable 'obs') 0)) ([V] block
					([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "yourself")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_reflexive_pronoun' ([_] variable 'ob')))))) ([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtif ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([_] variable 'ob') -> 'GetCapName' 0 args))) [undef] ([V] stmtexp ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([_] variable 'ob') -> 'GetShort' 0 args)))))))
				([V] stmtbreak)
				([V] stmtcase "Q" [undef])
				([V] stmtcase "q" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "your")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_posessive' ([_] variable 'ob')))))
				([V] stmtbreak)
				([V] stmtcase "D" [undef])
				([V] stmtcase "d" [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] assert ([_] callother ([_] variable 'ob') -> 'GetShort' 0 args))))
				([V] stmtbreak)
				([V] stmtcase "V" [undef])
				([V] stmtcase "v" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'conjugate_verb' ([s] variable 'str') 2))) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'conjugate_verb' ([s] variable 'str') 3))))
				([V] stmtbreak)
				([V] stmtcase "S" [undef])
				([V] stmtcase "s" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_nominative_pronoun' ([_] variable 'ob')))))
				([V] stmtbreak)
				([V] stmtcase "O" [undef])
				([V] stmtcase "o" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([_] indexarray ([P_] variable 'obs') 0)) ([V] block
					([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "yourself")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_reflexive_pronoun' ([_] variable 'ob')))))) ([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_accusative_pronoun' ([_] variable 'ob'))))))
				([V] stmtbreak)
				([V] stmtcase "P" [undef])
				([V] stmtcase "p" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "your")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_posessive_pronoun' ([_] variable 'ob')))))
				([V] stmtbreak)
				([V] stmtcase "R" [undef])
				([V] stmtcase "r" [undef])
				([V] stmtif ([i] inteq ([_] variable 'ob') ([_] indexarray ([P_] variable 'obs') 0)) ([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "yourself")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_reflexive_pronoun' ([_] variable 'ob'))))) ([V] stmtif ([i] inteq ([_] variable 'ob') ([o] variable 'viewer')) ([V] stmtexp ([s] assign ([s] variable 'out') "you")) ([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_nominative_pronoun' ([_] variable 'ob'))))))
				([V] stmtbreak)
				([V] stmtcase "A" [undef])
				([V] stmtcase "a" [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_item_list' ([P_] range ([P_] variable 'obs') 1 1))))
				([V] stmtbreak)
				([V] stmtcase "W" [undef])
				([V] stmtcase "w" [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([_] variable 'ob')))
				([V] stmtbreak)
				([V] stmtcase "I" [undef])
				([V] stmtcase "i" [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus "" ([_] variable 'ob'))))
				([V] stmtbreak)
				([V] stmtcase "$" [undef])
				([V] stmtreturn "$")
				([V] stmtbreak)
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus "expand_flag: Bad format flag `" ([s] variable 'fmt')) "'")))
				([V] stmtreturn "ERROR(BAD_FORMAT)")))
			([V] stmtswitch ([i] bitand ([i] variable 'flags') 3) ([V] block
				([V] stmtcase 2 [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_add_article' ([s] variable 'out') "a")))
				([V] stmtbreak)
				([V] stmtcase 1 [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_add_article' ([s] variable 'out') "the")))
				([V] stmtbreak)
				([V] stmtcase 3 [undef])
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'english_remove_article' ([s] variable 'out'))))
				([V] stmtbreak)))
			([V] stmtif ([i] bitand ([i] variable 'flags') 4) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'upper_case' ([s] variable 'out'))))) ([V] stmtif ([i] bitand ([i] variable 'flags') 8) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'out') ([s] funcall 'lower_case' ([s] variable 'out'))))) [undef]))
			([V] stmtif ([i] funcall 'isupper' ([i] indexarray ([s] variable 'fmt') 0)) ([V] stmtreturn ([s] funcall 'capitalize' ([s] variable 'out'))) [undef])
			([V] stmtreturn ([s] variable 'out'))))
	([i] method isupper
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 2))))))
	([i] method living
		(args ([o] var o))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No living, use bodyp"))))
	([_] method unguarded
		(args ([s] var privs) ([f] var f))
		([V] block
			([o] var ob)
			([_] var out)
			([s] var err)
			([V] stmtif ([s] variable 'privs') ([V] block
				([V] stmtif ([i] unot ([b] funcall 'stringp' ([s] variable 'privs'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "unguarded: Privs not string"))
					([V] stmtreturn 0)) [undef])
				([V] stmtif ([i] unot ([b] funcall 'functionp' ([f] variable 'f'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "unguarded: f not function"))
					([V] stmtreturn 0)) [undef])
				([V] stmtexp ([s] assign ([s] variable 'err') ([s] catch ([o] assign ([o] variable 'ob') ([o] funcall 'clone_object' "/lib/unguarded")))))
				([V] stmtif ([s] variable 'err') ([V] block
					([V] stmtexp ([s] funcall 'debug_message' ([i] plus "Failed to load LIB_UNGUARDED: " ([s] variable 'err'))))
					([V] stmtreturn 0)) [undef])
				([V] stmtexp ([s] assign ([s] variable 'err') ([s] catch ([_] assign ([_] variable 'out') ([_] assert ([_] callother ([o] variable 'ob') -> 'apply' 2 args))))))
				([V] stmtif ([o] variable 'ob') ([V] stmtexp ([_] callother ([o] variable 'ob') -> 'eventDestruct' 0 args)) [undef])
				([V] stmtif ([o] variable 'ob') ([V] stmtexp ([i] funcall 'destruct' ([o] variable 'ob'))) [undef])) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'err') ([s] catch ([_] assign ([_] variable 'out') ([_] funcall 'evaluate' ([f] variable 'f'))))))))
			([V] stmtif ([s] variable 'err') ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "unguarded: evaluate error: " ([s] variable 'err'))))
				([V] stmtreturn 0)) [undef])
			([V] stmtreturn ([_] variable 'out'))))
	([s] method sexplode
		(args ([s] var data) ([s] var sep))
		([V] block
			([V] stmtreturn ([Ps] funcall 'explode' ([s] variable 'data') ([s] variable 'sep')))))
	([s] method mud_name
		(args)
		([V] block
			([V] stmtreturn "AnarresPerl")))
	([V] method create
		(args)
		([V] block
			([V] stmtexp ([s] funcall 'debug_message' "TRAP_CRASHES must be defined."))
			([V] stmtexp ([s] funcall 'error' "Configuration error, please edit local_options and rebuild the driver."))
			(undef)
			([V] stmtexp ([s] funcall 'debug_message' "MUDLIB_ERROR_HANDLER must be defined."))
			([V] stmtexp ([s] funcall 'error' "Configuration error, please edit local_options and rebuild the driver."))
			(undef)
			([V] stmtexp ([i] funcall 'set_pulse' ([i] divide 1000000 10)))
			([V] stmtexp ([i] funcall 'trace' 0))
			([V] stmtexp ([V] funcall 'pluralise_create'))
			([V] stmtexp ([V] funcall 'ctype_create'))
			([V] stmtexp ([V] funcall 'player_create'))
			([V] stmtexp ([V] funcall 'english_create'))
			([V] stmtexp ([V] funcall 'call_out_create'))
			([V] stmtexp ([V] funcall 'conjugate_create'))))
	([i] method find_call_out_by_handle
		(args ([i] var search_handle) ([i] var remove))
		([V] block
			([P_] var c)
			([V] stmtdo 0 ([V] block))
			(undef)
			([V] stmtforeach ([P_] variable 'c') ([P_] variable 'call_outs') ([V] block
				([V] stmtif ([i] inteq ([_] indexarray ([P_] variable 'c') 0) ([i] variable 'search_handle')) ([V] block
					([V] stmtif ([i] inteq ([_] indexarray ([P_] variable 'c') 3) ([o] funcall 'previous_object' 0)) ([V] block
						([V] stmtif ([i] variable 'remove') ([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 3) ([N] nil))) [undef])
						([V] stmtreturn ([i] minus ([_] indexarray ([P_] variable 'c') 1) ([i] funcall 'time')))) [undef])) [undef])))
			([V] stmtdo 0 ([V] block))
			(undef)
			([V] stmtreturn ([i] uplus 1))))
	([o] method find_body
		(args ([s] var str))
		([V] block
			([o] var ob)
			([V] stmtif ([i] unot ([b] funcall 'stringp' ([s] variable 'str'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "find_body: arg not string"))
				([V] stmtreturn 0)) [undef])
			([V] stmtif ([s] strne ([s] variable 'str') ([s] funcall 'strcstrip' ([s] variable 'str'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 7 "sefun" ([i] plus "find_body: nonstripped call in " ([s] funcall 'file_name' ([o] funcall 'previous_object' 0)))))
				([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'strcstrip' ([s] variable 'str'))))) [undef])
			([V] stmtforeach ([o] variable 'ob') ([o] funcall 'bodies') ([V] block
				([V] stmtif ([s] streq ([s] assert ([_] callother ([o] variable 'ob') -> 'GetKeyName' 0 args)) ([s] variable 'str')) ([V] stmtreturn ([o] variable 'ob')) [undef])))
			([V] stmtreturn 0)))
	([s] method format
		(args ([_] var d))
		(nocode))
	([V] method pluralise_pronoun_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'pluralise_pronoun_build_arrays'))
			([V] stmtexp ([V] funcall 'pluralise_pronoun_build_map'))
			([V] stmtexp ([V] funcall 'pluralise_pronoun_build_tails'))
			([V] stmtdo 0 ([V] block))
			(undef)))
	([V] method pluralise_verb_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'pluralise_verb_build_arrays'))
			([V] stmtexp ([V] funcall 'pluralise_verb_build_map'))
			([V] stmtexp ([V] funcall 'pluralise_verb_build_tails'))
			([V] stmtdo 0 ([V] block))
			(undef)))
	([s] method get_object_path
		(args ([_] var arg) ([_] var rel))
		([V] block
			([s] var path)
			([V] stmtif ([b] funcall 'objectp' ([_] variable 'arg')) ([V] stmtreturn ([s] funcall 'file_name_base' ([_] variable 'arg'))) ([V] stmtif ([i] unot ([b] funcall 'stringp' ([_] variable 'arg'))) ([V] stmtexp ([_] assign ([_] variable 'arg') "")) [undef]))
			([V] stmtif ([b] funcall 'objectp' ([_] variable 'rel')) ([V] stmtexp ([s] assign ([s] variable 'path') ([s] funcall 'dirname' ([s] funcall 'file_name_base' ([_] variable 'rel'))))) ([V] stmtif ([b] funcall 'stringp' ([_] variable 'rel')) ([V] stmtexp ([s] assign ([s] variable 'path') ([_] variable 'rel'))) ([V] stmtexp ([s] assign ([s] variable 'path') ""))))
			([V] stmtreturn ([s] funcall 'absolute_path' ([s] variable 'path') ([_] variable 'arg')))))
	([s] method english_ordinal
		(args ([i] var i))
		([V] block
			([s] var out)
			([i] var j)
			([i] var k)
			([V] stmtif ([i] intlt ([i] variable 'i') 0) ([V] stmtexp ([s] assign ([s] variable 'out') "negative ")) ([V] stmtexp ([s] assign ([s] variable 'out') "")))
			([V] stmtswitch ([i] variable 'i') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtreturn "zeroeth")
				([V] stmtcase 1 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "first"))
				([V] stmtcase 2 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "second"))
				([V] stmtcase 3 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "third"))
				([V] stmtcase 4 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fourth"))
				([V] stmtcase 5 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fifth"))
				([V] stmtcase 6 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "sixth"))
				([V] stmtcase 7 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seventh"))
				([V] stmtcase 8 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eighth"))
				([V] stmtcase 9 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "ninth"))
				([V] stmtcase 10 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "tenth"))
				([V] stmtcase 11 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eleventh"))
				([V] stmtcase 12 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "twelfth"))
				([V] stmtcase 13 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "thirteenth"))
				([V] stmtcase 14 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fourteenth"))
				([V] stmtcase 15 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fifteenth"))
				([V] stmtcase 16 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "sixteenth"))
				([V] stmtcase 17 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seventeenth"))
				([V] stmtcase 18 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eighteenth"))
				([V] stmtcase 19 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "nineteenth"))
				([V] stmtcase 20 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "twentieth"))
				([V] stmtcase 30 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "thirtieth"))
				([V] stmtcase 40 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fortieth"))
				([V] stmtcase 50 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fiftieth"))
				([V] stmtcase 60 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "sixtieth"))
				([V] stmtcase 70 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seventieth"))
				([V] stmtcase 80 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eightieth"))
				([V] stmtcase 90 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "ninetieth"))
				([V] stmtcase [undef] [undef])
				([V] stmtif ([i] intgt ([i] variable 'i') 1000000) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 1000000)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 1000000)))
					([V] stmtif ([i] variable 'k') ([V] stmtreturn ([i] plus ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " million ") ([s] funcall 'english_ordinal' ([i] variable 'k')))) ([V] stmtreturn ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " millionth")))) ([V] stmtif ([i] intgt ([i] variable 'i') 1000) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 1000)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 1000)))
					([V] stmtif ([i] variable 'k') ([V] stmtreturn ([i] plus ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " thousand ") ([s] funcall 'english_ordinal' ([i] variable 'k')))) ([V] stmtreturn ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " thousandth")))) ([V] stmtif ([i] intgt ([i] variable 'i') 100) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 100)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 100)))
					([V] stmtif ([i] variable 'k') ([V] stmtreturn ([i] plus ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " hundred and ") ([s] funcall 'english_ordinal' ([i] variable 'k')))) ([V] stmtreturn ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) " hundredth")))) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 10)))
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] minus ([i] variable 'i') ([i] variable 'k'))))
					([V] stmtreturn ([i] plus ([i] plus ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j'))) "-") ([s] funcall 'english_ordinal' ([i] variable 'k'))))))))))))
	([s] method pluralise_verb
		(args ([s] var str))
		([V] block
			([V] stmtreturn ([s] funcall 'postprocess' ([s] variable 'str') ([s] funcall '_PL_verb' ([s] variable 'str'))))))
	([s] method expand_message
		(args ([o] var viewer) ([s] var msg) ([P_] var obs))
		([V] block
			([i] var state)
			([i] var len)
			([i] var i)
			([i] var value)
			([s] var str)
			([i] var flags)
			([i] var start)
			([s] var out)
			([V] stmtexp ([i] assign ([i] variable 'start') 0))
			([V] stmtexp ([s] assign ([s] variable 'out') ""))
			([V] stmtexp ([i] assign ([i] variable 'value') ([i] uplus 1)))
			([V] stmtexp ([i] assign ([i] variable 'len') ([i] funcall 'strlen' ([s] variable 'msg'))))
			([V] stmtfor ([i] assign ([i] variable 'i') 0) ([i] intlt ([i] variable 'i') ([i] variable 'len')) ([i] postinc ([i] variable 'i')) ([V] block
				([V] stmtswitch ([i] variable 'state') ([V] block
					([V] stmtcase 0 [undef])
					([V] stmtswitch ([i] indexarray ([s] variable 'msg') ([i] variable 'i')) ([V] block
						([V] stmtcase 36 [undef])
						([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([s] range ([s] variable 'msg') ([i] variable 'start') ([i] minus ([i] variable 'i') 1)))))
						([V] stmtexp ([s] assign ([s] variable 'str') ""))
						([V] stmtexp ([i] assign ([i] variable 'value') ([i] uplus 1)))
						([V] stmtexp ([i] assign ([i] variable 'flags') 0))
						([V] stmtexp ([i] assign ([i] variable 'state') 1))
						([V] stmtbreak)
						([V] stmtcase [undef] [undef])
						([V] stmtexp ([i] assign ([i] variable 'value') ([i] funcall 'strsrch' ([s] range ([s] variable 'msg') ([i] variable 'i') 1) "$")))
						([V] stmtif ([i] intne ([i] variable 'value') ([i] uplus 1)) ([V] stmtexp ([i] assign ([i] variable 'i') ([i] minus ([i] plus ([i] variable 'i') ([i] variable 'value')) 1))) ([V] stmtexp ([i] assign ([i] variable 'i') ([i] variable 'len'))))
						([V] stmtbreak)))
					([V] stmtbreak)
					([V] stmtcase 1 [undef])
					([V] stmtcase 2 [undef])
					([V] stmtswitch ([i] indexarray ([s] variable 'msg') ([i] variable 'i')) ([V] block
						([V] stmtcase 48 [undef])
						([V] stmtexp ([i] assign ([i] variable 'state') 2))
						([V] stmtif ([i] inteq ([i] variable 'value') ([i] uplus 1)) ([V] stmtexp ([i] assign ([i] variable 'value') ([i] minus ([i] indexarray ([s] variable 'msg') ([i] variable 'i')) 48))) ([V] stmtexp ([i] assign ([i] variable 'value') ([i] plus ([i] mult ([i] variable 'value') 10) ([i] minus ([i] indexarray ([s] variable 'msg') ([i] variable 'i')) 48)))))
						([V] stmtbreak)
						([V] stmtcase 92 [undef])
						([V] stmtexp ([i] assign ([i] variable 'start') ([i] plus ([i] variable 'i') 1)))
						([V] stmtexp ([i] assign ([i] variable 'state') 3))
						([V] stmtbreak)
						([V] stmtcase 63 [undef])
						([V] stmtexp ([i] assign ([i] variable 'flags') ([i] bitor ([i] variable 'flags') 2)))
						([V] stmtbreak)
						([V] stmtcase 33 [undef])
						([V] stmtexp ([i] assign ([i] variable 'flags') ([i] bitor ([i] variable 'flags') 1)))
						([V] stmtbreak)
						([V] stmtcase 43 [undef])
						([V] stmtexp ([i] assign ([i] variable 'flags') ([i] bitor ([i] variable 'flags') 4)))
						([V] stmtbreak)
						([V] stmtcase 45 [undef])
						([V] stmtexp ([i] assign ([i] variable 'flags') ([i] bitor ([i] variable 'flags') 8)))
						([V] stmtbreak)
						([V] stmtcase [undef] [undef])
						([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([s] funcall 'expand_flag' ([o] variable 'viewer') ([P_] variable 'obs') ([s] range ([s] variable 'msg') ([i] variable 'i') ([i] variable 'i')) ([s] variable 'str') ([i] variable 'value') ([i] variable 'flags')))))
						([V] stmtexp ([i] assign ([i] variable 'start') ([i] plus ([i] variable 'i') 1)))
						([V] stmtexp ([i] assign ([i] variable 'state') 0))
						([V] stmtbreak)))
					([V] stmtbreak)
					([V] stmtcase 3 [undef])
					([V] stmtswitch ([i] indexarray ([s] variable 'msg') ([i] variable 'i')) ([V] block
						([V] stmtcase 92 [undef])
						([V] stmtexp ([s] assign ([s] variable 'str') ([s] range ([s] variable 'msg') ([i] variable 'start') ([i] minus ([i] variable 'i') 1))))
						([V] stmtexp ([i] assign ([i] variable 'state') 1))
						([V] stmtbreak)
						([V] stmtcase [undef] [undef])
						([V] stmtbreak)))
					([V] stmtbreak)
					([V] stmtcase [undef] [undef])
					([V] stmtexp ([s] funcall 'error' "Bad state in lexer"))
					([V] stmtbreak)))))
			([V] stmtswitch ([i] variable 'state') ([V] block
				([V] stmtcase 1 [undef])
				([V] stmtcase 2 [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus "expand_message: Missing flag in \"" ([s] variable 'msg')) "\" at end of string")))
				([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') "ERROR(MISSING_FLAG)")))
				([V] stmtbreak)
				([V] stmtcase 3 [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus ([i] plus ([i] plus "expand_message: Mismatched quote in \"" ([s] variable 'msg')) "\" at character ") ([i] variable 'start'))))
				([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') "ERROR(MISMATCHED_QUOTE)")))
				([V] stmtbreak)))
			([V] stmtreturn ([i] plus ([s] variable 'out') ([s] range ([s] variable 'msg') ([i] variable 'start') 1)))))
	([i] method isdigit
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 22))))))
	([i] method access
		(args ([s] var file) ([i] var how))
		([V] block
			([V] stmtdo 0 ([V] block
				([V] stmtif ([i] unot ([b] funcall 'stringp' ([s] variable 'file'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "access: " "file not string")))
					([V] stmtexp ([i] funcall 'set_errno' 22))
					([V] stmtreturn 0)) [undef])))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtif ([i] unot ([b] funcall 'intp' ([i] variable 'how'))) ([V] block
					([V] stmtexp ([V] funcall 'syslog' 3 "sefun" ([i] plus "access: " "how not integer")))
					([V] stmtexp ([i] funcall 'set_errno' 22))
					([V] stmtreturn 0)) [undef])))
			(undef)
			([V] stmtif ([i] unot ([i] assert ([_] callother "/usr/libexec/auth/security" -> 'GetAccess' 2 args))) ([V] block
				([V] stmtexp ([i] funcall 'set_errno' 13))
				([V] stmtreturn ([i] uplus 1))) [undef])
			([V] stmtif ([i] inteq ([i] funcall 'file_size' ([s] variable 'file')) ([i] uplus 1)) ([V] block
				([V] stmtexp ([i] funcall 'set_errno' 2))
				([V] stmtreturn ([i] uplus 1))) [undef])
			([V] stmtreturn 0)))
	([s] method pluralise_noun_build_tails
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_sb_tails') ([m] mapping)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ois") ([P_] array "ois" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "deer") ([P_] array "deer" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "sheep") ([P_] array "sheep" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "fish") ([P_] array "fish" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "pox") ([P_] array "pox" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "umbra") ([P_] array "umbrae" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "man") ([P_] array "men" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "mouse") ([P_] array "mice" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "louse") ([P_] array "lice" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "goose") ([P_] array "geese" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "tooth") ([P_] array "teeth" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "foot") ([P_] array "feet" 100)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ceps") ([P_] array "ceps" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "zoon") ([P_] array "zoa" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "cis") ([P_] array "ces" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "sis") ([P_] array "ses" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "xis") ([P_] array "xes" 90)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "trix") ([P_] array "trices" 80)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "eau") ([P_] array "eaux" 80)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ieu") ([P_] array "ieux" 80)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ss") ([P_] array "sses" 70)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "us") ([P_] array "uses" 70)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ch") ([P_] array "ches" 60)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "sh") ([P_] array "shes" 60)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "x") ([P_] array "xes" 60)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "z") ([P_] array "zes" 60)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "alf") ([P_] array "alves" 50)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "elf") ([P_] array "elves" 50)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "olf") ([P_] array "olves" 50)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "deaf") ([P_] array "deafs" 50)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "eaf") ([P_] array "eaves" 45)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "life") ([P_] array "lives" 45)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "nife") ([P_] array "nives" 45)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "wife") ([P_] array "wives" 45)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "arf") ([P_] array "arves" 45)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ay") ([P_] array "ays" 40)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ey") ([P_] array "eys" 40)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "iy") ([P_] array "iys" 40)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "oy") ([P_] array "oys" 40)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "uy") ([P_] array "uys" 40)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "y") ([P_] array "ies" 30)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "ao") ([P_] array "oas" 20)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "eo") ([P_] array "oes" 20)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "io") ([P_] array "ois" 20)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "oo") ([P_] array "oos" 20)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "uo") ([P_] array "ous" 20)))
			([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_sb_tails') "o") ([P_] array "oes" 15)))))
	([V] method configfile_create
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'config_boolean') ([m] mapping "1" 1 "on" 1 "true" 1 "yes" 1 "0" 0 "off" 0 "false" 0 "no" 0)))))
	([V] method register_body
		(args)
		([V] block
			([o] var ob)
			([V] stmtif ([b] funcall 'clonep' ([o] variable 'ob')) ([V] stmtreturn [undef]) [undef])
			([V] stmtif ([i] unot ([s] funcall 'inherits' "/lib/body" ([o] variable 'ob'))) ([V] stmtreturn [undef]) [undef])
			([V] stmtexp ([Ps] assign ([Ps] variable 'BodyLib') ([i] bitor ([Ps] variable 'BodyLib') ([Ps] array ([s] funcall 'file_name' ([o] variable 'ob'))))))))
	([i] method set_pulse
		(args ([i] var timer))
		([V] block
			([V] stmtif ([i] unot ([i] funcall 'check_privs' "root")) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "set_pulse denied"))
				([V] stmtexp ([V] funcall 'syslog_stack'))
				([V] stmtreturn ([i] funcall 'set_errno' 13))) [undef])
			([V] stmtreturn ([i] funcall 'set_pulse' ([i] variable 'timer')))))
	([i] method english_parse_number_part
		(args ([s] var str))
		([V] block
			([s] var key)
			([i] var val)
			([i] var mult)
			([V] stmtif ([s] assign ([s] variable 'key') ([s] funcall 'english_parse_number_key' ([s] variable 'str') ([m] variable 'english_c_val') ([m] variable 'english_o_val'))) ([V] block
				([V] stmtexp ([i] assign ([i] variable 'val') ([i] logor ([_] indexmap ([m] variable 'english_c_val') ([s] variable 'key')) ([_] indexmap ([m] variable 'english_o_val') ([s] variable 'key')))))
				([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'stritrim' ([s] range ([s] variable 'str') ([i] funcall 'strlen' ([s] variable 'key')) 1))))) ([V] block
				([V] stmtreturn ([i] uplus 1))))
			([V] stmtwhile ([s] assign ([s] variable 'key') ([s] funcall 'english_parse_number_key' ([s] variable 'str') ([m] variable 'english_c_mult') ([m] variable 'english_o_mult'))) ([V] block
				([V] stmtexp ([i] assign ([i] variable 'mult') ([i] logor ([_] indexmap ([m] variable 'english_c_mult') ([s] variable 'key')) ([_] indexmap ([m] variable 'english_o_mult') ([s] variable 'key')))))
				([V] stmtexp ([i] assign ([i] variable 'val') ([i] mult ([i] variable 'val') ([i] variable 'mult'))))
				([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'stritrim' ([s] range ([s] variable 'str') ([i] funcall 'strlen' ([s] variable 'key')) 1))))))
			([V] stmtreturn ([i] variable 'val'))))
	([i] method isblank
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 598))))))
	([_] method callout_new
		(args ([f] var f) ([i] var delay) ([P_] var args))
		([V] block
			([P_] var c)
			([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 0) ([i] preinc ([i] variable 'call_out_handle'))))
			([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 1) ([i] plus ([i] funcall 'time') ([i] variable 'delay'))))
			([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 2) ([f] variable 'f')))
			([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 3) ([o] funcall 'previous_object' 0)))
			([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 4) ([P_] variable 'args')))
			([V] stmtif ([i] inteq ([i] variable 'call_out_handle') ([i] lsh 1 30)) ([V] stmtexp ([i] assign ([i] variable 'call_out_handle') 0)) [undef])
			([V] stmtdo 0 ([V] block))
			(undef)
			([V] stmtreturn ([P_] variable 'c'))))
	([i] method get_errno
		(args)
		([V] block
			([V] stmtreturn ([i] variable 'perror_errno'))))
	([s] method read_config_file
		(args ([s] var path) ([s] var logclass) ([i] var flags))
		([V] block
			([s] var content)
			([Ps] var lines)
			([i] var lineno)
			([V] stmtif ([i] unot ([i] funcall 'file_exists' ([s] variable 'path'))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 ([s] variable 'logclass') ([i] plus ([i] plus ([i] plus ([i] plus ([i] plus ([i] plus ([s] variable 'path') ":") ([i] variable 'lineno')) ": ") "Could not open `") ([s] variable 'path')) "' for reading - File does not exist.\n")))
				([V] stmtexp ([i] funcall 'set_errno' 2))
				([V] stmtreturn 0)) [undef])
			([V] stmtif ([i] unot ([s] assign ([s] variable 'content') ([s] funcall 'read_file' ([s] variable 'path')))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 ([s] variable 'logclass') ([i] plus ([i] plus ([i] plus ([i] plus ([i] plus ([i] plus ([s] variable 'path') ":") ([i] variable 'lineno')) ": ") "Could not open `") ([s] variable 'path')) "' for reading - File could not be read.\n")))
				([V] stmtreturn 0)) [undef])
			([V] stmtexp ([Ps] assign ([Ps] variable 'lines') ([Ps] funcall 'explode' ([s] variable 'content') "\n")))
			([V] stmtif ([i] bitand ([i] variable 'flags') 1) ([V] block
				([V] stmtexp ([Ps] assign ([Ps] variable 'lines') ([P_] funcall 'map' ([Ps] variable 'lines') ([f] closure ([i] indexarray ([s] funcall 'rexplode' ([_] parameter 1) "#") 0)))))
				([V] stmtexp ([i] assign ([i] variable 'flags') ([i] bitor ([i] variable 'flags') 4)))) [undef])
			([V] stmtif ([i] bitand ([i] variable 'flags') 4) ([V] stmtexp ([Ps] assign ([Ps] variable 'lines') ([P_] funcall 'map' ([Ps] variable 'lines') ([f] closure ([s] funcall 'strtrim' ([_] parameter 1)))))) [undef])
			([V] stmtif ([i] bitand ([i] variable 'flags') 2) ([V] stmtexp ([Ps] assign ([Ps] variable 'lines') ([i] minus ([Ps] variable 'lines') ([Ps] array "")))) [undef])
			([V] stmtreturn ([Ps] variable 'lines'))))
	([i] method interfacep
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([s] funcall 'inherits' "/lib/interface" ([o] variable 'ob')))))))
	([s] method _PL_verb
		(args ([s] var orig))
		([V] block
			([s] var word)
			([s] var value)
			([i] var i)
			([i] var priority)
			([i] var chop)
			([s] var tail)
			([P_] var values)
			([V] stmtexp ([s] assign ([s] variable 'word') ([s] funcall 'lower_case' ([s] variable 'orig'))))
			([V] stmtexp ([s] assign ([s] variable 'value') ([s] assert ([_] indexmap ([m] variable 'PL_v_map') ([s] variable 'word')))))
			([V] stmtif ([s] variable 'value') ([V] stmtreturn ([s] variable 'value')) [undef])
			([V] stmtexp ([i] assign ([i] variable 'priority') 0))
			([V] stmtexp ([i] assign ([i] variable 'chop') 0))
			([V] stmtexp ([s] assign ([s] variable 'tail') ""))
			([V] stmtfor ([i] assign ([i] variable 'i') 4) ([i] variable 'i') ([i] postdec ([i] variable 'i')) ([V] block
				([V] stmtif ([P_] assign ([P_] variable 'values') ([P_] assert ([_] indexmap ([m] variable 'PL_v_tails') ([s] range ([s] variable 'word') ([i] variable 'i') 1)))) ([V] block
					([V] stmtif ([i] intgt ([_] indexarray ([P_] variable 'values') 1) ([i] variable 'priority')) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'priority') ([_] indexarray ([P_] variable 'values') 1)))
						([V] stmtexp ([s] assign ([s] variable 'tail') ([_] indexarray ([P_] variable 'values') 0)))
						([V] stmtexp ([i] assign ([i] variable 'chop') ([i] variable 'i')))) [undef])) [undef])))
			([V] stmtswitch ([i] variable 'priority') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtif ([i] intgt ([i] funcall 'strlen' ([s] variable 'orig')) 4) ([V] stmtif ([s] streq ([s] range ([s] variable 'word') 1 1) "ies") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 1 1)) "y")) [undef]) [undef])
				(undef)))
			([V] stmtexp ([i] postinc ([i] variable 'chop')))
			([V] stmtreturn ([i] plus ([s] range ([s] variable 'orig') 0 ([i] variable 'chop')) ([s] variable 'tail')))))
	([V] method message
		(args ([_] var c) ([_] var m) ([_] var t) ([_] var e))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No message()"))))
	([s] method format_mapping
		(args ([m] var m))
		([V] block
			([Ps] var arr)
			([_] var k)
			([V] stmtexp ([Ps] assign ([Ps] variable 'arr') ([PP_] array)))
			([V] stmtforeach ([_] variable 'k') ([Ps] funcall 'keys' ([m] variable 'm')) ([V] block
				([V] stmtexp ([Ps] assign ([Ps] variable 'arr') ([i] plus ([Ps] variable 'arr') ([Pi] array ([i] plus ([i] plus ([s] funcall 'format' ([_] variable 'k')) " : ") ([s] funcall 'format' ([_] indexmap ([m] variable 'm') ([_] variable 'k'))))))))))
			([V] stmtreturn ([s] funcall 'format_array' ([Ps] variable 'arr')))))
	([V] method pluralise_pronoun_build_map
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_pron_map') ([i] plus ([m] variable 'PL_pron_nom') ([m] variable 'PL_pron_acc'))))))
	([s] method english_cardinal
		(args ([i] var i))
		([V] block
			([s] var out)
			([i] var j)
			([i] var k)
			([V] stmtif ([i] intlt ([i] variable 'i') 0) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'out') "negative "))
				([V] stmtexp ([i] assign ([i] variable 'i') ([i] condexp ([i] intge ([i] variable 'i') 0) ([i] variable 'i') ([i] uplus ([i] variable 'i')))))) ([V] block
				([V] stmtexp ([s] assign ([s] variable 'out') ""))))
			([V] stmtswitch ([i] variable 'i') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtreturn "zero")
				([V] stmtcase 1 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "one"))
				([V] stmtcase 2 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "two"))
				([V] stmtcase 3 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "three"))
				([V] stmtcase 4 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "four"))
				([V] stmtcase 5 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "five"))
				([V] stmtcase 6 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "six"))
				([V] stmtcase 7 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seven"))
				([V] stmtcase 8 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eight"))
				([V] stmtcase 9 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "nine"))
				([V] stmtcase 10 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "ten"))
				([V] stmtcase 11 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eleven"))
				([V] stmtcase 12 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "twelve"))
				([V] stmtcase 13 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "thirteen"))
				([V] stmtcase 14 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fourteen"))
				([V] stmtcase 15 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fifteen"))
				([V] stmtcase 16 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "sixteen"))
				([V] stmtcase 17 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seventeen"))
				([V] stmtcase 18 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eighteen"))
				([V] stmtcase 19 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "nineteen"))
				([V] stmtcase 20 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "twenty"))
				([V] stmtcase 30 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "thirty"))
				([V] stmtcase 40 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "forty"))
				([V] stmtcase 50 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "fifty"))
				([V] stmtcase 60 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "sixty"))
				([V] stmtcase 70 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "seventy"))
				([V] stmtcase 80 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "eighty"))
				([V] stmtcase 90 [undef])
				([V] stmtreturn ([i] plus ([s] variable 'out') "ninety"))
				([V] stmtcase [undef] [undef])
				([V] stmtif ([i] intge ([i] variable 'i') 1000000) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 1000000)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 1000000)))
					([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus ([s] funcall 'english_cardinal' ([i] variable 'j')) " million"))))
					([V] stmtif ([i] variable 'k') ([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus " " ([s] funcall 'english_cardinal' ([i] variable 'k')))))) [undef])
					([V] stmtreturn ([s] variable 'out'))) ([V] stmtif ([i] intge ([i] variable 'i') 1000) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 1000)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 1000)))
					([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus ([s] funcall 'english_cardinal' ([i] variable 'j')) " thousand"))))
					([V] stmtif ([i] variable 'k') ([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus " " ([s] funcall 'english_cardinal' ([i] variable 'k')))))) [undef])
					([V] stmtreturn ([s] variable 'out'))) ([V] stmtif ([i] intge ([i] variable 'i') 100) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] divide ([i] variable 'i') 100)))
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 100)))
					([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus ([s] funcall 'english_cardinal' ([i] variable 'j')) " hundred"))))
					([V] stmtif ([i] variable 'k') ([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus " and " ([s] funcall 'english_cardinal' ([i] variable 'k')))))) [undef])
					([V] stmtreturn ([s] variable 'out'))) ([V] block
					([V] stmtexp ([i] assign ([i] variable 'k') ([i] mod ([i] variable 'i') 10)))
					([V] stmtexp ([i] assign ([i] variable 'j') ([i] minus ([i] variable 'i') ([i] variable 'k'))))
					([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([s] funcall 'english_cardinal' ([i] variable 'j')))))
					([V] stmtif ([i] variable 'k') ([V] stmtexp ([s] assign ([s] variable 'out') ([i] plus ([s] variable 'out') ([i] plus " " ([s] funcall 'english_cardinal' ([i] variable 'k')))))) [undef])
					([V] stmtreturn ([s] variable 'out'))))))
				([V] stmtbreak)))))
	([V] method shadow
		(args ([P_] var args))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No shadow"))))
	([s] method strstrip
		(args ([s] var s))
		([V] block
			([V] stmtreturn ([s] funcall 'replace_string' ([P_] funcall 'map' ([s] variable 's') ([f] closure ([_] condexp ([i] indexarray ([Pi] variable 'ctype_data_alpha') ([i] assert ([_] parameter 1))) ([_] parameter 1) 42))) "*" ""))))
	([V] method prune_call_outs
		(args)
		([V] block
			([V] stmtexp ([P_] assign ([P_] variable 'call_outs') ([P_] funcall 'filter' ([P_] variable 'call_outs') ([f] closure ([i] unot ([i] logor ([i] unot ([_] indexarray ([P_] assert ([_] parameter 1)) 3)) ([i] bitand ([b] funcall 'functionp' ([_] indexarray ([P_] assert ([_] parameter 1)) 2)) 50)))))))))
	([s] method basename
		(args ([s] var path))
		([V] block
			([i] var i)
			([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'path') "/" ([i] uplus 1))))
			([V] stmtexp ([s] assign ([s] variable 'path') ([s] range ([s] variable 'path') ([i] plus ([i] variable 'i') 1) 1)))
			([V] stmtreturn ([s] variable 'path'))))
	([V] method exec
		(args ([P_] var args))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No exec"))))
	([i] method rm
		(args ([s] var file))
		([V] block
			([V] stmtif ([i] funcall 'rm' ([s] variable 'file')) ([V] block
				([V] stmtexp ([_] callother "/usr/libexec/auth/security" -> 'UnSetPrivs' 1 args))
				([V] stmtreturn 1)) [undef])
			([V] stmtreturn 0)))
	([i] method max_eval_cost
		(args)
		([V] block
			([V] stmtreturn ([i] funcall 'max_eval_cost'))))
	([V] method shout
		(args ([s] var str))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No shout()"))))
	([i] method playerp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] funcall 'userp' ([o] variable 'ob')))))
	([i] method roomp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([s] funcall 'inherits' "/lib/subroom" ([o] variable 'ob')))))))
	([o] method rooms
		(args)
		([V] block
			([V] stmtreturn ([P_] funcall 'filter' ([Po] funcall 'objects') ([f] closure ([i] funcall 'roomp' ([_] parameter 1)))))))
	([V] method conjugate_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'conjugate_verb_create'))))
	([i] method bodyp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([s] funcall 'inherits' "/lib/body" ([o] variable 'ob')))))))
	([_] method flat_unique_array
		(args ([P_] var arr))
		([V] block
			([V] stmtreturn ([P_] funcall 'map' ([PP_] funcall 'unique_array' ([P_] variable 'arr') ([f] closure ([_] parameter 1))) ([f] closure ([_] indexarray ([P_] assert ([_] parameter 1)) 0))))))
	([s] method pluralise_noun
		(args ([s] var str))
		([V] block
			([V] stmtreturn ([s] funcall 'postprocess' ([s] variable 'str') ([s] funcall '_PL_noun' ([s] variable 'str'))))))
	([V] method conjugate_verb_build_map
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'CJ_v_map') ([m] variable 'CJ_v_irregular_pres')))))
	([i] method remove_call_out
		(args ([i] var handle_or_name))
		([V] block
			([P_] var c)
			([V] stmtif ([b] funcall 'undefinedp' ([i] variable 'handle_or_name')) ([V] block
				([V] stmtforeach ([P_] variable 'c') ([P_] variable 'call_outs') ([V] block
					([V] stmtif ([i] inteq ([_] indexarray ([P_] variable 'c') 3) ([o] funcall 'previous_object' 0)) ([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 3) ([N] nil))) [undef])))
				([V] stmtreturn 0)) [undef])
			([V] stmtif ([i] unot ([b] funcall 'intp' ([i] variable 'handle_or_name'))) ([V] stmtexp ([s] funcall 'error' "Bad argument 1 to remove_call_out")) [undef])
			([V] stmtreturn ([i] funcall 'find_call_out_by_handle' ([i] variable 'handle_or_name') 1))))
	([V] method enable_commands
		(args)
		([V] block
			([V] stmtexp ([s] funcall 'error' "No enable_commands"))))
	([s] method english_add_article
		(args ([s] var str) ([s] var art))
		([V] block
			([V] stmtif ([i] funcall 'isupper' ([i] indexarray ([s] variable 'str') 0)) ([V] stmtreturn ([s] variable 'str')) [undef])
			([V] stmtexp ([s] assign ([s] variable 'str') ([s] funcall 'english_remove_article' ([s] variable 'str'))))
			([V] stmtif ([s] strne ([s] variable 'art') "a") ([V] stmtreturn ([i] plus ([i] plus ([s] variable 'art') " ") ([s] variable 'str'))) [undef])
			([V] stmtif ([i] intne ([i] funcall 'strsrch' "aeiou" ([i] indexarray ([s] variable 'str') 0)) ([i] uplus 1)) ([V] stmtreturn ([i] plus "an " ([s] variable 'str'))) [undef])
			([V] stmtreturn ([i] plus "a " ([s] variable 'str')))))
	([o] method all_bodies
		(args)
		([V] block
			([V] stmtreturn ([s] funcall 'implode' ([P_] funcall 'map' ([Ps] variable 'BodyLib') ([f] closure ([Po] funcall 'children' ([_] parameter 1)))) ([f] closure ([i] plus ([i] assert ([_] parameter 1)) ([i] assert ([_] parameter 2))))))))
	([s] method english_posessive_pronoun
		(args ([o] var ob))
		([V] block
			([i] var sex)
			([V] stmtswitch ([i] variable 'sex') ([V] block
				([V] stmtcase 1 [undef])
				([V] stmtreturn "his")
				([V] stmtcase 2 [undef])
				([V] stmtreturn "her")
				([V] stmtcase [undef] [undef])
				([V] stmtreturn "its")))))
	([V] method bind
		(args ([P_] var args))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No bind"))))
	([s] method gethostname
		(args)
		([V] block
			([s] var tmp)
			([V] stmtexp ([s] assign ([s] variable 'tmp') ([s] funcall 'mud_name')))
			([V] stmtexp ([s] assign ([s] variable 'tmp') ([s] funcall 'replace_string' ([s] variable 'tmp') "\t" " ")))
			([V] stmtexp ([s] assign ([s] variable 'tmp') ([s] indexarray ([Ps] funcall 'explode' ([s] variable 'tmp') " ") 0)))
			([V] stmtreturn ([s] funcall 'lower_case' ([s] variable 'tmp')))))
	([i] method random
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] condexp ([i] intlt ([i] variable 'x') ([i] lsh 1 10)) ([i] rsh ([i] funcall 'random' ([i] lsh ([i] variable 'x') 10)) 10) ([i] funcall 'random' ([i] variable 'x'))))))
	([i] method isspace
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] indexarray ([Pi] variable 'ctype_data_space') ([i] variable 'x')))))
	([V] method pluralise_noun_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'pluralise_noun_build_arrays'))
			([V] stmtexp ([V] funcall 'pluralise_noun_build_map'))
			([V] stmtexp ([s] funcall 'pluralise_noun_build_tails'))
			([V] stmtdo 0 ([V] block))
			(undef)))
	([m] method expand_keys
		(args ([m] var m))
		([V] block
			([m] var out)
			([_] var key)
			([_] var data)
			([_] var subkey)
			([V] stmtexp ([m] assign ([m] variable 'out') ([m] mapping)))
			([V] stmtforeach ([_] variable 'key') ([Ps] funcall 'keys' ([m] variable 'm')) ([V] block
				([V] stmtif ([b] funcall 'arrayp' ([_] variable 'key')) ([V] block
					([V] stmtexp ([_] assign ([_] variable 'data') ([_] assert ([_] indexmap ([m] variable 'm') ([_] variable 'key')))))
					([V] stmtforeach ([_] variable 'subkey') ([_] variable 'key') ([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'out') ([_] variable 'subkey')) ([_] variable 'data'))))) ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'out') ([_] variable 'key')) ([_] assert ([_] indexmap ([m] variable 'm') ([_] variable 'key')))))))))
			([V] stmtreturn ([m] variable 'out'))))
	([i] method set_eval_limit
		(args ([i] var limit))
		([V] block
			([V] stmtif ([i] unot ([i] funcall 'check_privs' "root")) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "set_eval_limit denied"))
				([V] stmtexp ([V] funcall 'syslog_stack'))
				([V] stmtreturn ([i] funcall 'set_errno' 13))) [undef])
			([V] stmtreturn ([i] funcall 'set_eval_limit' ([i] variable 'limit')))))
	([i] method boolean
		(args ([_] var d))
		([V] block
			([V] stmtif ([b] funcall 'intp' ([_] variable 'd')) ([V] block
				([V] stmtreturn ([i] intne ([_] variable 'd') 0))) ([V] stmtif ([b] funcall 'stringp' ([_] variable 'd')) ([V] block
				([V] stmtexp ([_] assign ([_] variable 'd') ([s] funcall 'lower_case' ([_] variable 'd'))))
				([V] stmtreturn ([i] intne ([i] funcall 'member_array' ([_] variable 'd') ([Ps] array "1" "true" "yes" "on")) ([i] uplus 1)))) ([V] stmtif ([b] funcall 'functionp' ([_] variable 'd')) ([V] block
				([V] stmtreturn ([i] condexp ([_] funcall 'evaluate' ([_] variable 'd')) 1 0))) ([V] stmtif ([i] logor ([b] funcall 'arrayp' ([_] variable 'd')) ([b] funcall 'mapp' ([_] variable 'd'))) ([V] block
				([V] stmtreturn ([i] condexp ([i] funcall 'sizeof' ([_] variable 'd')) 1 0))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "boolean: unknown type"))
				([V] stmtreturn 0))))))))
	([s] method get_domain_dir
		(args ([s] var name))
		([V] block
			([s] var dir)
			([V] stmtexp ([s] assign ([s] variable 'name') ([s] funcall 'strcstrip' ([s] variable 'name'))))
			([V] stmtexp ([s] assign ([s] variable 'dir') ([i] plus ([i] plus "/domains" "/") ([s] variable 'name'))))
			([V] stmtif ([i] inteq ([i] funcall 'file_size' ([s] variable 'dir')) ([i] uplus 2)) ([V] stmtreturn ([s] variable 'dir')) [undef])
			([V] stmtreturn 0)))
	([i] method file_exists
		(args ([s] var file))
		([V] block
			([V] stmtreturn ([i] intge ([i] funcall 'file_size' ([s] variable 'file')) 0))))
	([i] method verbp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([s] funcall 'inherits' "/lib/verb" ([o] variable 'ob')))))))
	([i] method isascii
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 91012))))))
	([i] method livings
		(args ([o] var o))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No livings"))))
	([i] method isgraph
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 33170))))))
	([V] method pluralise_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'pluralise_pronoun_create'))
			([V] stmtexp ([V] funcall 'pluralise_noun_create'))
			([V] stmtexp ([V] funcall 'pluralise_verb_create'))))
	([s] method _PL_noun
		(args ([s] var orig))
		([V] block
			([s] var word)
			([s] var value)
			([i] var i)
			([i] var priority)
			([i] var chop)
			([s] var tail)
			([P_] var values)
			([V] stmtexp ([s] assign ([s] variable 'word') ([s] funcall 'lower_case' ([s] variable 'orig'))))
			([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " " ([i] uplus 1))))
			([V] stmtexp ([s] assign ([s] variable 'value') ([s] assert ([_] indexmap ([m] variable 'PL_sb_map') ([s] range ([s] variable 'word') ([i] plus ([i] variable 'i') 1) 1)))))
			([V] stmtif ([s] variable 'value') ([V] stmtreturn ([i] plus ([s] range ([s] variable 'orig') 0 ([i] variable 'i')) ([s] variable 'value'))) [undef])
			([V] stmtexp ([i] assign ([i] variable 'priority') 0))
			([V] stmtexp ([i] assign ([i] variable 'chop') 0))
			([V] stmtexp ([s] assign ([s] variable 'tail') "s"))
			([V] stmtfor ([i] assign ([i] variable 'i') 5) ([i] variable 'i') ([i] postdec ([i] variable 'i')) ([V] block
				([V] stmtif ([P_] assign ([P_] variable 'values') ([P_] assert ([_] indexmap ([m] variable 'PL_sb_tails') ([s] range ([s] variable 'word') ([i] variable 'i') 1)))) ([V] block
					([V] stmtif ([i] intgt ([_] indexarray ([P_] variable 'values') 1) ([i] variable 'priority')) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'priority') ([_] indexarray ([P_] variable 'values') 1)))
						([V] stmtexp ([s] assign ([s] variable 'tail') ([_] indexarray ([P_] variable 'values') 0)))
						([V] stmtexp ([i] assign ([i] variable 'chop') ([i] variable 'i')))) [undef])) [undef])))
			([V] stmtswitch ([i] variable 'priority') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtcase 10 [undef])
				([V] stmtif ([i] funcall 'isupper' ([i] indexarray ([s] variable 'orig') 0)) ([V] stmtif ([s] streq ([s] range ([s] variable 'word') 1 1) "y") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 1 1)) "ys")) [undef]) [undef])
				(undef)
				([V] stmtcase 36 [undef])
				([V] stmtif ([i] funcall 'isupper' ([i] indexarray ([s] variable 'orig') 0)) ([V] stmtif ([s] streq ([s] range ([s] variable 'word') 1 1) "s") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 1 1)) "ses")) [undef]) [undef])
				(undef)
				([V] stmtcase 66 [undef])
				([V] stmtif ([i] intgt ([i] funcall 'strlen' ([s] variable 'word')) 4) ([V] block
					([V] stmtif ([s] streq ([s] range ([s] variable 'word') 3 1) "ynx") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 3 1)) "ynges")) [undef])
					(undef)
					([V] stmtif ([s] streq ([s] range ([s] variable 'word') 3 1) "inx") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 3 1)) "inges")) [undef])
					(undef)
					([V] stmtif ([s] streq ([s] range ([s] variable 'word') 3 1) "anx") ([V] stmtreturn ([i] plus ([s] range ([s] variable 'word') 0 ([i] plus 3 1)) "anges")) [undef])
					(undef)) [undef])
				([V] stmtcase 76 [undef])
				([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " ") ([i] uplus 1)) ([V] block
					([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " of ") ([i] uplus 1)) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " of ")))
						([V] stmtreturn ([i] plus ([s] funcall '_PL_noun' ([s] funcall 'strrtrim' ([s] range ([s] variable 'orig') 0 ([i] minus ([i] variable 'i') 1)))) ([s] range ([s] variable 'orig') ([i] variable 'i') 1)))) [undef])
					([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " in ") ([i] uplus 1)) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " in ")))
						([V] stmtreturn ([i] plus ([s] funcall '_PL_noun' ([s] funcall 'strrtrim' ([s] range ([s] variable 'orig') 0 ([i] minus ([i] variable 'i') 1)))) ([s] range ([s] variable 'orig') ([i] variable 'i') 1)))) [undef])
					([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " to ") ([i] uplus 1)) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " to ")))
						([V] stmtreturn ([i] plus ([s] funcall '_PL_noun' ([s] funcall 'strrtrim' ([s] range ([s] variable 'orig') 0 ([i] minus ([i] variable 'i') 1)))) ([s] range ([s] variable 'orig') ([i] variable 'i') 1)))) [undef])
					([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " at ") ([i] uplus 1)) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " at ")))
						([V] stmtreturn ([i] plus ([s] funcall '_PL_noun' ([s] funcall 'strrtrim' ([s] range ([s] variable 'orig') 0 ([i] minus ([i] variable 'i') 1)))) ([s] range ([s] variable 'orig') ([i] variable 'i') 1)))) [undef])
					([V] stmtif ([i] intne ([i] funcall 'strsrch' ([s] variable 'word') " de ") ([i] uplus 1)) ([V] block
						([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'word') " de ")))
						([V] stmtreturn ([i] plus ([s] funcall '_PL_noun' ([s] funcall 'strrtrim' ([s] range ([s] variable 'orig') 0 ([i] minus ([i] variable 'i') 1)))) ([s] range ([s] variable 'orig') ([i] variable 'i') 1)))) [undef])) [undef])))
			([V] stmtexp ([i] postinc ([i] variable 'chop')))
			([V] stmtreturn ([i] plus ([s] range ([s] variable 'orig') 0 ([i] variable 'chop')) ([s] variable 'tail')))))
	([o] method verbs
		(args)
		([V] block
			([V] stmtreturn ([P_] funcall 'filter' ([Po] funcall 'objects') ([f] closure ([i] funcall 'verbp' ([_] parameter 1)))))))
	([i] method linkp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([i] logand ([i] unot ([i] funcall 'strsrch' ([s] funcall 'file_name' ([o] variable 'ob')) "/lib/link#")) ([_] callother ([o] variable 'ob') -> 'GetAuthenticated' 0 args)))))
	([V] method pluralise_pronoun_build_arrays
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_pron_nom') ([m] mapping "i" "we" "myself" "ourselves" "you" "you" "yourself" "yourselves" "she" "they" "herself" "themselves" "he" "they" "himself" "themselves" "it" "they" "itself" "themselves" "they" "they" "themself" "themselves" "mine" "ours" "yours" "yours" "hers" "theirs" "his" "theirs" "its" "theirs" "theirs" "theirs")))
			([V] stmtexp ([m] assign ([m] variable 'PL_pron_acc') ([m] mapping "me" "us" "myself" "ourselves" "you" "you" "yourself" "yourselves" "her" "them" "herself" "themselves" "him" "them" "himself" "themselves" "it" "them" "itself" "themselves" "them" "them" "themself" "themselves")))))
	([V] method pluralise_noun_build_arrays
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_sb_irregular_s') ([m] mapping "ephemeris" "ephemerides" "iris" "irises|irides" "clitoris" "clitorises|clitorides" "rhinoceros" "rhinoceroses|rhinocerotes" "corpus" "corpuses|corpora" "opus" "opuses|opera" "genus" "genera" "mythos" "mythoi" "penis" "penises|penes" "testis" "testes")))
			([V] stmtexp ([m] assign ([m] variable 'PL_sb_irregular') ([m] mapping "brother" "brothers|brethren" "child" "children" "die" "dice" "loaf" "loaves" "hoof" "hoofs|hooves" "beef" "beefs|beeves" "money" "monies" "mongoose" "mongooses" "ox" "oxen" "cow" "cows|kine" "soliloquy" "soliloquies" "graffito" "graffiti" "prima donna" "prima donnas|prime donne" "octopus" "octopuses|octopodes" "genie" "genies|genii" "ganglion" "ganglions|ganglia" "trilby" "trilbys" "turf" "turfs|turves" "vax" "vaxes|vaxen")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_a_ata') ([Ps] array "anathema" "bema" "carcinoma" "charisma" "diploma" "dogma" "drama" "edema" "enema" "enigma" "lemma" "lymphoma" "magma" "melisma" "miasma" "oedema" "sarcoma" "schema" "soma" "stigma" "stoma" "trauma" "gumma" "pragma")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_a_ae') ([Ps] array "alumna" "alga" "vertebra" "larva")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_a_ae') ([Ps] array "amoeba" "antenna" "formula" "hyperbola" "medusa" "nebula" "parabola" "abscissa" "hydra" "nova" "lacuna" "aurora" "persona")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_en_ina') ([Ps] array "stamen" "foramen" "lumen")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_um_a') ([Ps] array "bacterium" "agendum" "desideratum" "erratum" "stratum" "datum" "ovum" "extremum" "candelabrum" "forum")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_um_a') ([Ps] array "maximum" "minimum" "momentum" "optimum" "quantum" "cranium" "curriculum" "dictum" "phylum" "aquarium" "compendium" "emporium" "enconium" "gymnasium" "honorarium" "interregnum" "lustrum" "memorandum" "millenium" "rostrum" "spectrum" "speculum" "stadium" "trapezium" "ultimatum" "medium" "vacuum" "velum" "consortium")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_us_i') ([Ps] array "alumnus" "alveolus" "bacillus" "bronchus" "locus" "nucleus" "stimulus" "meniscus" "hippopotamus" "cactus")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_us_i') ([Ps] array "focus" "radius" "genius" "incubus" "succubus" "nimbus" "fungus" "nucleolus" "stylus" "torus" "umbilicus" "uterus")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_us_us') ([Ps] array "status" "apparatus" "prospectus" "sinus" "hiatus" "impetus" "plexus")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_on_a') ([Ps] array "criterion" "perihelion" "aphelion" "phenomenon" "prolegomenon" "noumenon" "organon" "asyndeton" "hyperbaton")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_on_a') ([Ps] array "oxymoron")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_o_i') ([Ps] array "solo" "soprano" "basso" "alto" "contralto" "tempo")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_o_os') ([Ps] array "albino" "archipelago" "armadillo" "commando" "crescendo" "fiasco" "ditto" "dynamo" "embryo" "ghetto" "guano" "inferno" "jumbo" "lumbago" "magneto" "manifesto" "medico" "octavo" "photo" "pro" "quarto" "canto" "lingo" "generalissimo" "stylo" "rhino" "piano")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_ex_ices') ([Ps] array "codex" "murex" "silex")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_ex_ices') ([Ps] array "vortex" "vertex" "cortex" "latex" "pontifex" "apex" "index" "simplex")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_i') ([Ps] array "afrit" "afreet" "efreet")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_C_im') ([Ps] array "goy" "seraph" "cherub")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_U_man_mans') ([Ps] array "human" "Alabaman" "Bahaman" "Burman" "German" "Hiroshiman" "Liman" "Nakayaman" "Oklahoman" "Panaman" "Selman" "Sonaman" "Tacoman" "Yakiman" "Yokohaman" "Yuman")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_uninflected_s') ([Ps] array "breeches" "britches" "clippers" "gallows" "hijinks" "headquarters" "pliers" "scissors" "testes" "herpes" "pincers" "shears" "proceedings" "trousers" "measles" "cantus" "coitus" "nexus" "contretemps" "corps" "debris" "mumps" "diabetes" "jackanapes" "series" "species" "rabies" "chassis" "innings" "news" "mews" "fracas" "means" "aircraft" "spacecraft")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_uninflected') ([Ps] array "tuna" "salmon" "mackerel" "trout" "bream" "sea bass" "sea-bass" "carp" "cod" "flounder" "whiting" "wildebeest" "swine" "eland" "bison" "moose" "elk" "Portuguese" "Japanese" "Chinese" "Vietnamese" "Burmese" "Lebanese" "Siamese" "Senegalese" "Bhutanese" "Sinhalese" "graffiti" "djinn")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_singular_s') ([Ps] array "acropolis" "aegis" "alias" "arthritis" "asbestos" "atlas" "bathos" "bias" "bronchitis" "bursitis" "caddis" "cannabis" "canvas" "chaos" "cosmos" "dais" "digitalis" "encephalitis" "epidermis" "ethos" "gas" "glottis" "hepatitis" "hubris" "ibis" "lens" "mantis" "marquis" "metropolis" "neuritis" "pathos" "pelvis" "polis" "sassafras" "tonsillitis" "trellis")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_military') ([Ps] array "major" "lieutenant" "brigadier" "adjutant" "quartermaster")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_sb_general') ([i] plus ([P_] funcall 'map' ([Ps] variable 'PL_sb_military') ([f] closure ([i] plus ([i] assert ([_] parameter 1)) "-general"))) ([P_] funcall 'map' ([Ps] variable 'PL_sb_military') ([f] closure ([i] plus ([i] assert ([_] parameter 1)) " general"))))))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_prep') ([Ps] array "about" "above" "across" "after" "among" "around" "at" "athwart" "before" "behind" "below" "beneath" "beside" "besides" "between" "betwixt" "beyond" "but" "by" "during" "except" "for" "from" "in" "into" "near" "of" "off" "on" "onto" "out" "over" "since" "till" "to" "under" "until" "unto" "upon" "with")))))
	([o] method find_living
		(args ([s] var s))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No find_living, use find_body"))))
	([s] method get_user_dir
		(args ([s] var name))
		([V] block
			([s] var dir)
			([V] stmtexp ([s] assign ([s] variable 'name') ([s] funcall 'strcstrip' ([s] variable 'name'))))
			([V] stmtexp ([s] assign ([s] variable 'dir') ([i] plus ([i] plus "/home" "/") ([s] variable 'name'))))
			([V] stmtif ([i] inteq ([i] funcall 'file_size' ([s] variable 'dir')) ([i] uplus 2)) ([V] stmtreturn ([s] variable 'dir')) [undef])
			([V] stmtreturn 0)))
	([i] method call_out
		(args ([_] var callback) ([i] var delay) ([_] var args))
		([V] block
			([P_] var c)
			([i] var sz)
			([i] var t)
			([V] stmtif ([i] unot ([b] funcall 'functionp' ([_] variable 'callback'))) ([V] stmtexp ([s] funcall 'error' "Bad argument 1 to call_out")) [undef])
			([V] stmtif ([i] unot ([b] funcall 'intp' ([i] variable 'delay'))) ([V] stmtexp ([s] funcall 'error' "Bad argument 2 to call_out")) [undef])
			([V] stmtexp ([P_] assign ([P_] variable 'c') ([_] funcall 'callout_new' ([_] variable 'callback') ([i] variable 'delay') ([_] variable 'args'))))
			([V] stmtexp ([i] assign ([i] variable 'sz') ([i] funcall 'sizeof' ([P_] variable 'call_outs'))))
			([V] stmtexp ([i] assign ([i] variable 't') ([_] indexarray ([P_] variable 'c') 1)))
			([V] stmtwhile ([i] postdec ([i] variable 'sz')) ([V] block
				([V] stmtif ([i] intge ([i] variable 't') ([_] indexarray ([_] indexarray ([P_] variable 'call_outs') ([i] variable 'sz')) 1)) ([V] stmtbreak) [undef])))
			([V] stmtexp ([P_] assign ([P_] variable 'call_outs') ([i] plus ([i] plus ([P_] range ([P_] variable 'call_outs') 0 ([i] variable 'sz')) ([PP_] array ([P_] variable 'c'))) ([P_] range ([P_] variable 'call_outs') ([i] plus ([i] variable 'sz') 1) 1))))
			([V] stmtreturn ([_] indexarray ([P_] variable 'c') 0))))
	([s] method strdstrip
		(args ([s] var s))
		([V] block
			([s] var n)
			([Ps] var arr)
			([V] stmtif ([s] streq ([s] variable 's') ([s] variable 'strdstrip_last_in')) ([V] stmtreturn ([s] variable 'strdstrip_last_out')) [undef])
			([V] stmtexp ([s] assign ([s] variable 'strdstrip_last_in') ([s] variable 's')))
			([V] stmtexp ([Ps] assign ([Ps] variable 'arr') ([i] minus ([P_] funcall 'map' ([Ps] funcall 'explode' ([s] variable 's') ".") ([f] closure ([s] funcall 'strstrip' ([_] parameter 1)))) ([Ps] array ""))))
			([V] stmtexp ([s] assign ([s] variable 'n') ([s] funcall 'lower_case' ([s] funcall 'implode' ([Ps] variable 'arr') "."))))
			([V] stmtreturn ([s] assign ([s] variable 'strdstrip_last_out') ([s] variable 'n')))))
	([s] method format_array
		(args ([P_] var a))
		([V] block
			([V] stmtswitch ([i] funcall 'sizeof' ([P_] variable 'a')) ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtreturn "NOTHING")
				([V] stmtcase 1 [undef])
				([V] stmtreturn ([s] funcall 'format' ([_] indexarray ([P_] variable 'a') 0)))
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([P_] assign ([P_] variable 'a') ([P_] funcall 'map' ([P_] variable 'a') ([f] closure ([s] funcall 'format' ([_] parameter 1))))))
				([V] stmtreturn ([i] plus ([i] plus ([s] funcall 'implode' ([P_] range ([P_] variable 'a') 0 2) ", ") " and ") ([_] indexarray ([P_] variable 'a') 1)))))))
	([V] method pluralise_pronoun_build_tails
		(args)
		([V] block))
	([V] method pluralise_verb_build_map
		(args)
		([V] block
			([s] var e)
			([i] var n)
			([V] stmtexp ([m] assign ([m] variable 'PL_v_map') ([i] plus ([i] plus ([m] variable 'PL_v_irregular_pres') ([m] variable 'PL_v_ambiguous_pres')) ([m] mapping "" ""))))
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_v_irregular_non_pres') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "")))))))
			(undef)
			([V] stmtdo 0 ([V] block
				([V] stmtexp ([i] assign ([i] variable 'n') ([i] plus ([i] funcall 'strlen' "") 1)))
				([V] stmtforeach ([s] variable 'e') ([Ps] variable 'PL_v_ambiguous_non_pres') ([V] block
					([V] stmtexp ([_] assign ([_] indexmap ([m] variable 'PL_v_map') ([s] variable 'e')) ([i] plus ([s] range ([s] variable 'e') 0 ([i] variable 'n')) "")))))))
			(undef)))
	([V] method tell_object
		(args ([o] var ob) ([s] var str))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No tell_object()"))))
	([i] method guestp
		(args ([o] var ob))
		([V] block
			([V] stmtreturn ([_] callother ([o] variable 'ob') -> 'GetGuest' 0 args))))
	([s] method time_string
		(args ([i] var i))
		([V] block
			([V] stmtreturn ([s] condexp ([i] intge ([i] variable 'i') 86400) ([s] funcall 'sprintf' "%dd %dh" ([i] divide ([i] variable 'i') 86400) ([i] mod ([i] divide ([i] variable 'i') 3600) 24)) ([s] condexp ([i] intge ([i] variable 'i') 3600) ([s] funcall 'sprintf' "%dh %dm" ([i] divide ([i] variable 'i') 3600) ([i] mod ([i] divide ([i] variable 'i') 60) 60)) ([s] condexp ([i] intge ([i] variable 'i') 60) ([s] funcall 'sprintf' "%dm %ds" ([i] divide ([i] variable 'i') 60) ([i] mod ([i] variable 'i') 60)) ([s] funcall 'sprintf' "%ds" ([i] variable 'i'))))))))
	([o] method sefun
		(args)
		([V] block
			([V] stmtreturn ([o] funcall 'this_object'))))
	([i] method vseek
		(args ([i] var val) ([i] var max) ([i] var arg) ([i] var opt))
		([V] block
			([V] stmtswitch ([i] variable 'opt') ([V] block
				([V] stmtcase 0 [undef])
				([V] stmtexp ([i] assign ([i] variable 'val') ([i] variable 'arg')))
				([V] stmtbreak)
				([V] stmtcase 1 [undef])
				([V] stmtexp ([i] assign ([i] variable 'val') ([i] plus ([i] variable 'val') ([i] variable 'arg'))))
				([V] stmtbreak)
				([V] stmtcase 2 [undef])
				([V] stmtif ([i] intge ([i] variable 'max') 0) ([V] stmtexp ([i] assign ([i] variable 'val') ([i] minus ([i] variable 'max') ([i] variable 'arg')))) ([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "vseek: SEEK_END invalid with no maximum value")))
				([V] stmtcase [undef] [undef])
				([V] stmtexp ([V] funcall 'syslog' 3 "sefun" "vseek: invalid command"))))
			([V] stmtif ([i] intlt ([i] variable 'val') 0) ([V] stmtreturn 0) ([V] stmtif ([i] logand ([i] intge ([i] variable 'max') 0) ([i] intgt ([i] variable 'val') ([i] variable 'max'))) ([V] stmtreturn ([i] variable 'max')) [undef]))
			([V] stmtreturn ([i] variable 'val'))))
	([o] method this_thread
		(args)
		([V] block
			([V] stmtreturn 0)))
	([s] method english_nominative_pronoun
		(args ([o] var ob))
		([V] block
			([i] var sex)
			([V] stmtswitch ([i] variable 'sex') ([V] block
				([V] stmtcase 1 [undef])
				([V] stmtreturn "he")
				([V] stmtcase 2 [undef])
				([V] stmtreturn "she")
				([V] stmtcase [undef] [undef])
				([V] stmtreturn "it")))))
	([V] method set_hide
		(args ([i] var flag))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No set_hide"))))
	([V] method disable_commands
		(args)
		([V] block
			([V] stmtexp ([s] funcall 'error' "No disable_commands"))))
	([i] method ispunct
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] indexarray ([Pi] variable 'ctype_data_punct') ([i] variable 'x')))))
	([s] method postprocess
		(args ([s] var orig) ([s] var inflected))
		([V] block
			([V] stmtreturn ([s] condexp ([i] funcall 'isupper' ([i] indexarray ([s] variable 'orig') 0)) ([s] condexp ([s] streq ([s] variable 'orig') "I") ([s] variable 'inflected') ([s] condexp ([s] streq ([s] variable 'orig') ([s] funcall 'upper_case' ([s] variable 'orig'))) ([s] funcall 'upper_case' ([s] variable 'inflected')) ([i] plus ([s] funcall 'upper_case' ([s] range ([s] variable 'inflected') 0 0)) ([s] range ([s] variable 'inflected') 1 1)))) ([s] variable 'inflected')))))
	([s] method rexplode
		(args ([s] var data) ([s] var sep))
		([V] block
			([V] stmtreturn ([Ps] funcall 'explode' ([i] plus ([i] plus ([s] variable 'sep') ([s] variable 'data')) ([s] variable 'sep')) ([s] variable 'sep')))))
	([s] method strwstrip
		(args ([s] var s))
		([V] block
			([Ps] var arr)
			([V] stmtif ([s] streq ([s] variable 's') ([s] variable 'strwstrip_last_in')) ([V] stmtreturn ([s] variable 'strwstrip_last_out')) [undef])
			([V] stmtexp ([s] assign ([s] variable 'strwstrip_last_in') ([s] variable 's')))
			([V] stmtexp ([s] assign ([s] variable 's') ([s] funcall 'replace_string' ([s] funcall 'replace_string' ([s] variable 's') "\n" " ") "\t" " ")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'arr') ([i] minus ([P_] funcall 'map' ([Ps] funcall 'explode' ([s] variable 's') " ") ([f] closure ([s] funcall 'replace_string' ([P_] funcall 'map' ([_] parameter 1) ([f] closure ([_] condexp ([i] indexarray ([Pi] variable 'ctype_data_alnum') ([i] assert ([_] parameter 1))) ([_] parameter 1) 42))) "*" ""))) ([Ps] array ""))))
			([V] stmtreturn ([s] assign ([s] variable 'strwstrip_last_out') ([s] funcall 'implode' ([Ps] variable 'arr') " ")))))
	([s] method conjugate_verb
		(args ([s] var infinitive) ([i] var person))
		([V] block
			([Ps] var irr)
			([s] var word)
			([i] var i)
			([i] var priority)
			([i] var chop)
			([s] var tail)
			([P_] var values)
			([V] stmtexp ([s] assign ([s] variable 'word') ([s] funcall 'lower_case' ([s] variable 'infinitive'))))
			([V] stmtif ([Ps] assign ([Ps] variable 'irr') ([Ps] assert ([_] indexmap ([m] variable 'CJ_v_irregular_pres') ([s] variable 'word')))) ([V] block
				([V] stmtif ([i] intgt ([i] variable 'person') 4) ([V] stmtexp ([i] assign ([i] variable 'person') 4)) [undef])
				([V] stmtexp ([s] assign ([s] variable 'word') ([s] indexarray ([Ps] variable 'irr') ([i] condexp ([i] intgt ([i] variable 'person') 4) 3 ([i] minus ([i] variable 'person') 1)))))
				([V] stmtif ([s] streq ([s] variable 'infinitive') ([s] funcall 'upper_case' ([s] variable 'infinitive'))) ([V] stmtreturn ([s] funcall 'upper_case' ([s] variable 'word'))) ([V] stmtreturn ([s] variable 'word')))) [undef])
			([V] stmtexp ([i] assign ([i] variable 'priority') 0))
			([V] stmtexp ([i] assign ([i] variable 'chop') 0))
			([V] stmtexp ([s] assign ([s] variable 'tail') "s"))
			([V] stmtswitch ([i] variable 'person') ([V] block
				([V] stmtcase 3 [undef])
				([V] stmtfor ([i] assign ([i] variable 'i') 2) ([i] variable 'i') ([i] postdec ([i] variable 'i')) ([V] block
					([V] stmtif ([P_] assign ([P_] variable 'values') ([P_] assert ([_] indexmap ([m] variable 'CJ_v_tails') ([s] range ([s] variable 'word') ([i] variable 'i') 1)))) ([V] block
						([V] stmtif ([i] intgt ([_] indexarray ([P_] variable 'values') 1) ([i] variable 'priority')) ([V] block
							([V] stmtexp ([i] assign ([i] variable 'priority') ([_] indexarray ([P_] variable 'values') 1)))
							([V] stmtexp ([s] assign ([s] variable 'tail') ([_] indexarray ([P_] variable 'values') 0)))
							([V] stmtexp ([i] assign ([i] variable 'chop') ([i] variable 'i')))) [undef])) [undef])))
				([V] stmtexp ([i] postinc ([i] variable 'chop')))
				([V] stmtexp ([s] assign ([s] variable 'word') ([i] plus ([s] range ([s] variable 'infinitive') 0 ([i] variable 'chop')) ([s] variable 'tail'))))
				([V] stmtif ([s] streq ([s] variable 'infinitive') ([s] funcall 'upper_case' ([s] variable 'infinitive'))) ([V] stmtreturn ([s] funcall 'upper_case' ([s] variable 'word'))) ([V] stmtreturn ([s] variable 'word')))
				([V] stmtcase [undef] [undef])
				([V] stmtreturn ([s] variable 'infinitive'))))))
	([s] method stritrim
		(args ([s] var s))
		([V] block
			([i] var j)
			([i] var i)
			([V] stmtexp ([i] assign ([i] variable 'i') 0))
			([V] stmtexp ([i] assign ([i] variable 'j') ([i] funcall 'strlen' ([s] variable 's'))))
			([V] stmtwhile ([i] logand ([i] intlt ([i] variable 'i') ([i] variable 'j')) ([i] funcall 'isspace' ([i] indexarray ([s] variable 's') ([i] variable 'i')))) ([V] stmtexp ([i] postinc ([i] variable 'i'))))
			([V] stmtreturn ([s] range ([s] variable 's') ([i] variable 'i') 1))))
	([V] method conjugate_verb_create
		(args)
		([V] block
			([V] stmtexp ([V] funcall 'conjugate_verb_build_arrays'))
			([V] stmtexp ([V] funcall 'conjugate_verb_build_map'))
			([V] stmtexp ([V] funcall 'conjugate_verb_build_tails'))
			([V] stmtdo 0 ([V] block))
			(undef)))
	([V] method say
		(args ([s] var str) ([_] var s))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No say()"))))
	([s] method strcstrip
		(args ([s] var s))
		([V] block
			([V] stmtif ([s] streq ([s] variable 's') ([s] variable 'strcstrip_last_in')) ([V] stmtreturn ([s] variable 'strcstrip_last_out')) [undef])
			([V] stmtreturn ([s] assign ([s] variable 'strcstrip_last_out') ([s] funcall 'lower_case' ([s] funcall 'strstrip' ([s] assign ([s] variable 'strcstrip_last_in') ([s] variable 's'))))))))
	([i] method islower
		(args ([i] var x))
		([V] block
			([V] stmtreturn ([i] unot ([i] unot ([i] bitand ([i] indexarray ([Pi] variable 'ctype_data') ([i] variable 'x')) 4))))))
	([s] method pluralise_split
		(args ([s] var s))
		([V] block
			([i] var n)
			([V] stmtreturn ([s] condexp ([i] intne ([i] assign ([i] variable 'n') ([i] funcall 'strsrch' ([s] variable 's') "|")) ([i] uplus 1)) ([s] range ([s] variable 's') ([i] plus ([i] variable 'n') 1) 1) ([s] variable 's')))))
	([i] method find_call_out
		(args ([i] var handle_or_name))
		([V] block
			([V] stmtif ([i] unot ([b] funcall 'intp' ([i] variable 'handle_or_name'))) ([V] stmtexp ([s] funcall 'error' "Bad argument 1 to find_call_out")) [undef])
			([V] stmtreturn ([i] funcall 'find_call_out_by_handle' ([i] variable 'handle_or_name') 0))))
	([s] method glob2regex
		(args ([s] var glob))
		([V] block
			([V] stmtexp ([s] assign ([s] variable 'glob') ([s] funcall 'replace_string' ([s] variable 'glob') "\\" "\\\\")))
			([V] stmtexp ([s] assign ([s] variable 'glob') ([s] funcall 'replace_string' ([s] variable 'glob') "." "\\.")))
			([V] stmtexp ([s] assign ([s] variable 'glob') ([s] funcall 'replace_string' ([s] variable 'glob') "?" ".")))
			([V] stmtexp ([s] assign ([s] variable 'glob') ([s] funcall 'replace_string' ([s] variable 'glob') "*" ".*")))
			([V] stmtexp ([s] assign ([s] variable 'glob') ([i] plus ([i] plus "^" ([s] variable 'glob')) "$")))
			([V] stmtreturn ([s] variable 'glob'))))
	([i] method object_exists
		(args ([s] var obj))
		([V] block
			([V] stmtreturn ([i] intge ([i] funcall 'file_size' ([i] plus ([s] variable 'obj') ".c")) 0))))
	([o] method master
		(args)
		([V] block
			([V] stmtreturn ([o] funcall 'find_object' "/usr/libexec/master"))))
	([s] method english_ordinal_suffix
		(args ([i] var i))
		([V] block
			([V] stmtif ([i] logand ([i] intgt ([i] variable 'i') 10) ([i] intlt ([i] variable 'i') 14)) ([V] stmtexp ([i] assign ([i] variable 'i') 4)) ([V] stmtexp ([i] assign ([i] variable 'i') ([i] mod ([i] variable 'i') 10))))
			([V] stmtswitch ([i] variable 'i') ([V] block
				([V] stmtcase 1 [undef])
				([V] stmtreturn "st")
				([V] stmtcase 2 [undef])
				([V] stmtreturn "nd")
				([V] stmtcase 3 [undef])
				([V] stmtreturn "rd")
				([V] stmtcase [undef] [undef])
				([V] stmtreturn "th")))))
	([V] method syslog_stack
		(args)
		([V] block
			([Ps] var arr0)
			([Ps] var arr2)
			([Ps] var out)
			([i] var i)
			([V] stmtexp ([Ps] assign ([Ps] variable 'arr0') ([Ps] funcall 'call_stack' 0)))
			([V] stmtexp ([Ps] assign ([Ps] variable 'arr2') ([Ps] funcall 'call_stack' 2)))
			([V] stmtexp ([Ps] assign ([Ps] variable 'out') ([PP_] array)))
			([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'sizeof' ([Ps] variable 'arr0'))))
			([V] stmtwhile ([i] postdec ([i] variable 'i')) ([V] stmtexp ([Ps] assign ([Ps] variable 'out') ([i] plus ([Ps] variable 'out') ([Pi] array ([i] plus ([i] plus ([i] plus ([s] indexarray ([Ps] variable 'arr0') ([i] variable 'i')) "::") ([s] indexarray ([Ps] variable 'arr2') ([i] variable 'i'))) "()"))))))
			([V] stmtexp ([V] funcall 'syslog' 7 "STACK" ([s] funcall 'implode' ([Ps] variable 'out') " -==- ")))))
	([V] method set_light
		(args ([i] var flag))
		([V] block
			([V] stmtexp ([s] funcall 'error' "No set_light"))))
	([V] method run_call_outs
		(args ([i] var hb))
		([V] block
			([P_] var c)
			([f] var f)
			([V] stmtif ([i] intne ([o] funcall 'previous_object' 0) ([o] funcall 'master')) ([V] block
				([V] stmtexp ([s] funcall 'error' "run_call_outs: not called from master"))
				([V] stmtreturn [undef])) [undef])
			([V] stmtforeach ([P_] variable 'c') ([P_] variable 'call_outs') ([V] block
				([V] stmtif ([i] intgt ([i] minus ([_] indexarray ([P_] variable 'c') 1) ([i] funcall 'time')) 0) ([V] block
					([V] stmtbreak)) [undef])
				([V] stmtif ([i] logor ([i] unot ([_] indexarray ([P_] variable 'c') 3)) ([i] bitand ([b] funcall 'functionp' ([_] indexarray ([P_] variable 'c') 2)) 50)) ([V] block
					([V] stmtdo 0 ([V] block))
					(undef)
					([V] stmtcontinue)) [undef])
				([V] stmtexp ([f] assign ([f] variable 'f') ([_] indexarray ([P_] variable 'c') 2)))
				([V] stmtdo 0 ([V] block))
				(undef)
				([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'c') 3) ([N] nil)))
				([V] stmtcatch ([V] block
					([V] stmtif ([_] indexarray ([P_] variable 'c') 4) ([V] stmtexp ([_] funcall 'evaluate' ([f] variable 'f') ([_] indexarray ([P_] variable 'c') 4))) ([V] stmtexp ([_] funcall 'evaluate' ([f] variable 'f'))))))
				(undef)))
			([V] stmtexp ([V] funcall 'prune_call_outs'))))
	([V] method pluralise_verb_build_arrays
		(args)
		([V] block
			([V] stmtexp ([m] assign ([m] variable 'PL_v_irregular_pres') ([m] mapping "am" "are" "are" "are" "is" "are" "was" "were" "were" "were" "was" "were" "have" "have" "have" "have" "has" "have")))
			([V] stmtexp ([m] assign ([m] variable 'PL_v_ambiguous_pres') ([m] mapping "act" "act" "act" "act" "acts" "act" "blame" "blame" "blame" "blame" "blames" "blame" "can" "can" "can" "can" "can" "can" "must" "must" "must" "must" "must" "must" "fly" "fly" "fly" "fly" "flies" "fly" "copy" "copy" "copy" "copy" "copies" "copy" "drink" "drink" "drink" "drink" "drinks" "drink" "fight" "fight" "fight" "fight" "fights" "fight" "fire" "fire" "fire" "fire" "fires" "fire" "like" "like" "like" "like" "likes" "like" "look" "look" "look" "look" "looks" "look" "make" "make" "make" "make" "makes" "make" "reach" "reach" "reach" "reach" "reaches" "reach" "run" "run" "run" "run" "runs" "run" "sink" "sink" "sink" "sink" "sinks" "sink" "sleep" "sleep" "sleep" "sleep" "sleeps" "sleep" "view" "view" "view" "view" "views" "view")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_v_irregular_non_pres') ([Ps] array "did" "had" "ate" "made" "put" "spent" "fought" "sank" "gave" "sought" "shall" "could" "ought" "should")))
			([V] stmtexp ([Ps] assign ([Ps] variable 'PL_v_ambiguous_non_pres') ([Ps] array "thought" "saw" "bent" "will" "might" "cut")))))
	([s] method sys_arch
		(args)
		([V] block
			([V] stmtreturn "UNDEFINED")))
	([_] method call_out_info
		(args)
		([V] block
			([P_] var c)
			([i] var i)
			([_] var func)
			([P_] var result)
			([o] var ob)
			([V] stmtexp ([V] funcall 'prune_call_outs'))
			([V] stmtexp ([P_] assign ([P_] variable 'result') ([P_] funcall 'allocate' ([i] funcall 'sizeof' ([P_] variable 'call_outs')))))
			([V] stmtexp ([i] assign ([i] variable 'i') 0))
			([V] stmtforeach ([P_] variable 'c') ([P_] variable 'call_outs') ([V] block
				([V] stmtexp ([o] assign ([o] variable 'ob') ([_] indexarray ([P_] variable 'c') 3)))
				([V] stmtexp ([_] assign ([_] variable 'func') "<function>"))
				([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'result') ([i] postinc ([i] variable 'i'))) ([P_] array ([o] variable 'ob') ([_] variable 'func') ([i] minus ([_] indexarray ([P_] variable 'c') 1) ([i] funcall 'time')))))))
			([V] stmtreturn ([P_] variable 'result'))))
	([i] method check_previous_privs
		(args ([s] var str))
		([V] block
			([V] stmtreturn ([_] callother "/usr/libexec/auth/security" -> 'CheckPrivilege' 2 args))))
	([_] method array_reverse
		(args ([P_] var arr))
		([V] block
			([P_] var out)
			([i] var len)
			([i] var i)
			([V] stmtexp ([i] assign ([i] variable 'len') ([i] funcall 'sizeof' ([P_] variable 'arr'))))
			([V] stmtexp ([P_] assign ([P_] variable 'out') ([P_] funcall 'allocate' ([i] variable 'len'))))
			([V] stmtfor ([i] assign ([i] variable 'i') 0) ([i] intlt ([i] variable 'i') ([i] variable 'len')) ([i] postinc ([i] variable 'i')) ([V] stmtexp ([_] assign ([_] indexarray ([P_] variable 'out') ([i] minus ([i] minus ([i] variable 'len') ([i] variable 'i')) 1)) ([_] indexarray ([P_] variable 'arr') ([i] variable 'i')))))
			([V] stmtreturn ([P_] variable 'out'))))
	([i] method set_errno
		(args ([i] var x))
		([V] block
			([V] stmtexp ([i] assign ([i] variable 'perror_errno') ([i] variable 'x')))
			([V] stmtreturn ([i] unot ([i] variable 'x')))))
	([V] method syslog
		(args ([i] var priority) ([s] var type) ([s] var message))
		([V] block
			([o] var ob)
			([s] var str)
			([V] stmtexp ([o] assign ([o] variable 'ob') ([o] funcall 'find_object' "/usr/libexec/sys/syslog")))
			([V] stmtexp ([s] assign ([s] variable 'str') ([i] plus ([i] plus ([i] plus "[" ([s] funcall 'file_name' ([o] funcall 'previous_object' 0))) "] ") ([s] variable 'message'))))
			([V] stmtif ([o] variable 'ob') ([V] stmtexp ([_] callother ([o] variable 'ob') -> 'eventLog' 3 args)) ([V] stmtexp ([s] funcall 'debug_message' ([i] plus "[syslog] (!SYSLOG_D) " ([s] variable 'str')))))))
	([s] method dirname
		(args ([s] var path))
		([V] block
			([i] var i)
			([V] stmtexp ([i] assign ([i] variable 'i') ([i] funcall 'strsrch' ([s] variable 'path') "/" ([i] uplus 1))))
			([V] stmtif ([i] intlt ([i] variable 'i') 1) ([V] stmtreturn "/") [undef])
			([V] stmtreturn ([s] range ([s] variable 'path') 0 ([i] minus ([i] variable 'i') 1)))))
	([o] method object_array
		(args ([_] var arg))
		([V] block
			([V] stmtif ([i] unot ([_] variable 'arg')) ([V] stmtexp ([_] assign ([_] variable 'arg') ([PP_] array))) ([V] stmtif ([b] funcall 'objectp' ([_] variable 'arg')) ([V] stmtexp ([_] assign ([_] variable 'arg') ([P_] array ([_] variable 'arg')))) ([V] stmtif ([b] funcall 'arrayp' ([_] variable 'arg')) ([V] stmtexp ([_] assign ([_] variable 'arg') ([P_] funcall 'filter' ([_] variable 'arg') ([f] closure ([b] funcall 'objectp' ([_] parameter 1)))))) ([V] block
				([V] stmtexp ([V] funcall 'syslog' 4 "sefun" ([i] plus "object_array got type " ([s] funcall 'typeof' ([_] variable 'arg')))))
				([V] stmtexp ([i] funcall 'set_errno' 22))
				([V] stmtexp ([_] assign ([_] variable 'arg') ([PP_] array)))))))
			([V] stmtreturn ([_] variable 'arg'))))
	([s] method conjugate_verb_for
		(args ([s] var verb) ([o] var actor) ([o] var viewer))
		([V] block
			([V] stmtreturn ([s] funcall 'conjugate_verb' ([s] variable 'verb') ([i] minus 3 ([i] inteq ([o] variable 'actor') ([o] variable 'viewer')))))))
)

---

1
Time taken: 138.986042976379 seconds
