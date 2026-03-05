BEGIN {
    has_entry = 0
    has_slot_guard = 0
    has_source_check = 0
    has_flag_gate = 0
    has_copy_loop = 0
    has_find_quote = 0
    has_find_delim = 0
    has_terminate = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /CMP\.[BWL] #\$?31/ || line ~ /CMP\.[BWL] #\$?49/ || line ~ /BLE(\.[A-Z]+)? / || line ~ /BGE(\.[A-Z]+)? /) has_slot_guard = 1
    if (line ~ /^TST\.[BWL] / || line ~ /^MOVE\.[BWL] .*,-12\(A5\)/ || line ~ /^BEQ(\.[A-Z]+)? /) has_source_check = 1
    if (line ~ /^BTST #1,/ || line ~ /^BTST #4,/ || line ~ /BTST #\$1,/ || line ~ /BTST #\$4,/) has_flag_gate = 1
    if (line ~ /^MOVE\.B \(A0\)\+,\(A1\)\+/ || line ~ /^BNE(\.[A-Z]+)? .*COPY/) has_copy_loop = 1
    if (line ~ /STR_FINDCHARPTR/ || line ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/) has_find_quote = 1
    if (line ~ /STR_FINDANYCHARPTR/ || line ~ /GROUP_AH_JMPTBL_STR_FINDANYCHARPTR/ || line ~ /GROUP_AH_JMPTBL_STR_FINDANYCHARP/) has_find_delim = 1
    if (line ~ /^CLR\.B /) has_terminate = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SLOT_GUARD=" has_slot_guard
    print "HAS_SOURCE_CHECK=" has_source_check
    print "HAS_FLAG_GATE=" has_flag_gate
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_FIND_QUOTE=" has_find_quote
    print "HAS_FIND_DELIM=" has_find_delim
    print "HAS_TERMINATE=" has_terminate
}
