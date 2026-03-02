BEGIN {
    has_execute = 0
    has_open = 0
    has_readline = 0
    has_findsep = 0
    has_alloc = 0
    has_free = 0
    has_cmp = 0
    has_append = 0
    has_finalize = 0
    has_list_cmd = 0
    has_path_df0 = 0
    has_path_ram = 0
    has_delete_prefix = 0
    has_c4 = 0
    has_c5 = 0
    has_c6 = 0
    has_c7 = 0
    has_100 = 0
    has_99 = 0
    has_terminal = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)

    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /LVOEXECUTE/) has_execute = 1
    if (n ~ /PARSEINIJMPTBLHANDLEOPENWITHMODE/) has_open = 1
    if (n ~ /PARSEINIJMPTBLSTREAMREADLINEWITHLIMIT/) has_readline = 1
    if (n ~ /PARSEINIJMPTBLGCOMMANDFINDPATHSEPARATOR/) has_findsep = 1
    if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/) has_alloc = 1
    if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMORY/) has_free = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_cmp = 1
    if (n ~ /PARSEINIJMPTBLSTRINGAPPENDATNULL/) has_append = 1
    if (n ~ /PARSEINIJMPTBLUNKNOWN36FINALIZEREQUEST/) has_finalize = 1
    if (n ~ /GLOBALSTRLISTRAMLOGODIRTXTDH2LOGOSNOHEADQUICK/) has_list_cmd = 1
    if (n ~ /PARSEINIPATHDF0COLONLOGODOTLST/) has_path_df0 = 1
    if (n ~ /PARSEINIPATHRAMCOLONLOGODIRDOTTXT/) has_path_ram = 1
    if (n ~ /GLOBALSTRDELETENILDH2LOGOS/) has_delete_prefix = 1
    if (n ~ /GLOBALSTRPARSEINIC4/) has_c4 = 1
    if (n ~ /GLOBALSTRPARSEINIC5/) has_c5 = 1
    if (n ~ /GLOBALSTRPARSEINIC6/) has_c6 = 1
    if (n ~ /GLOBALSTRPARSEINIC7/) has_c7 = 1
    if (u ~ /[^0-9]100[^0-9]/ || u ~ /^100$/) has_100 = 1
    if (u ~ /[^0-9]99[^0-9]/ || u ~ /^99$/) has_99 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_EXECUTE=" has_execute
    print "HAS_OPEN=" has_open
    print "HAS_READLINE=" has_readline
    print "HAS_FINDSEP=" has_findsep
    print "HAS_ALLOC=" has_alloc
    print "HAS_FREE=" has_free
    print "HAS_CMP=" has_cmp
    print "HAS_APPEND=" has_append
    print "HAS_FINALIZE=" has_finalize
    print "HAS_LIST_CMD=" has_list_cmd
    print "HAS_PATH_DF0=" has_path_df0
    print "HAS_PATH_RAM=" has_path_ram
    print "HAS_DELETE_PREFIX=" has_delete_prefix
    print "HAS_C4=" has_c4
    print "HAS_C5=" has_c5
    print "HAS_C6=" has_c6
    print "HAS_C7=" has_c7
    print "HAS_100=" has_100
    print "HAS_99=" has_99
    print "HAS_TERMINAL=" has_terminal
}
