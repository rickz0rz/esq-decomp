BEGIN {
    has_entry = 0
    has_save_a6 = 0
    has_load_lib = 0
    has_load_arg = 0
    has_checkdate_call = 0
    has_restore_a6 = 0
    has_rts = 0
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

    if (u ~ /^CLOCK_CHECKDATEORSECONDSFROMEPOCH:$/ || u ~ /^CLOCK_CHECKDATEORSECONDSFROMEPOC:$/) has_entry = 1
    if (u ~ /^MOVE\.L A6,-\(A7\)$/ || u ~ /^MOVE\.L A5,-\(A7\)$/ || u ~ /^MOVEM\.L A6,-\(A7\)$/ || u ~ /^MOVEM\.L A5,-\(A7\)$/) has_save_a6 = 1
    if (u ~ /GLOBAL_REF_UTILITY_LIBRARY/ && (u ~ /^MOVEA?\.L / || u ~ /^MOVE\.L /)) has_load_lib = 1
    if (u ~ /^MOVEA?\.L .*A0$/ && (u ~ /A7/ || u ~ /A5/)) has_load_arg = 1
    if (u ~ /^MOVE\.L [0-9]+\((A7|A5)\),A5$/ || u ~ /^MOVE\.L \$[0-9A-F]+\((A7|A5)\),A5$/) has_load_arg = 1
    if (u ~ /_LVOCHECKDATE/) has_checkdate_call = 1
    if (u ~ /^MOVEA?\.L \(A7\)\+,A6$/ || u ~ /^MOVEA?\.L \(A7\)\+,A5$/ || u ~ /^MOVEM\.L \(A7\)\+,A6$/ || u ~ /^MOVEM\.L \(A7\)\+,A5$/ || u ~ /^MOVE\.L \(A7\)\+,A5$/) has_restore_a6 = 1
    if (u ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE_A6=" has_save_a6
    print "HAS_LOAD_LIB=" has_load_lib
    print "HAS_LOAD_ARG=" has_load_arg
    print "HAS_CHECKDATE_CALL=" has_checkdate_call
    print "HAS_RESTORE_A6=" has_restore_a6
    print "HAS_RTS=" has_rts
}
