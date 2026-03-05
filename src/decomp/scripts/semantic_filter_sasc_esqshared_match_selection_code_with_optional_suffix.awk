BEGIN {
    has_entry = 0
    has_parse_dot = 0
    has_parse_colon = 0
    has_suffix_gate = 0
    has_split_store = 0
    has_main_match = 0
    has_suffix_match = 0
    has_final_gate = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^ESQSHARED_MATCHSELECTIONCODEWITHOPTIONALSUFFIX:/ || u ~ /^ESQSHARED_MATCHSELECTIONCODEWITH[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^SUBI\.[WL] #\$2E,D[0-7]$/ || u ~ /^CMPI\.[WL] #\$2E,D[0-7]$/ || u ~ /^CMPI\.[WL] #46,D[0-7]$/ || u ~ /^MOVEQ\.L #\$2E,D[0-7]$/ || u ~ /^MOVEQ\.L #46,D[0-7]$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_parse_dot = 1
    if (u ~ /^SUBI\.[WL] #12,D[0-7]$/ || u ~ /^CMPI\.[WL] #\$3A,D[0-7]$/ || u ~ /^CMPI\.[WL] #58,D[0-7]$/ || u ~ /^MOVEQ\.L #\$3A,D[0-7]$/ || u ~ /^MOVEQ\.L #58,D[0-7]$/) has_parse_colon = 1
    if (index(u, "ESQ_STR_A") > 0 || u ~ /^MOVEQ\.L #\$3F,D[0-7]$/ || u ~ /^MOVEQ\.L #63,D[0-7]$/ || u ~ /^MOVEQ\.L #\$2A,D[0-7]$/ || u ~ /^MOVEQ\.L #42,D[0-7]$/) has_suffix_gate = 1
    if (u ~ /^MOVE\.B D[0-7],-[0-9]+\(A5,D[0-7]\.[WL]\)$/ || u ~ /^MOVE\.B D[0-7],-[0-9]+\(A5\)$/ || u ~ /^MOVE\.B D[0-7],\$[0-9A-F]+\((A[0-7]),D[0-7]\.[WL]\)$/ || u ~ /^MOVE\.B D[0-7],\$[0-9A-F]+\((A[0-7])\)$/) has_split_store = 1
    if (index(u, "ESQ_SELECTCODEBUFFER") > 0 || (index(u, "WILDCARDMATCH") > 0 && index(u, "SELECTIONSUFFIXBUFFER") == 0)) has_main_match = 1
    if (index(u, "ESQPARS_SELECTIONSUFFIXBUFFER") > 0) has_suffix_match = 1
    if (u ~ /^TST\.[WL] D7$/ || u ~ /^TST\.[WL] D5$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_final_gate = 1
    if (u ~ /^BRA\.[SWB] ESQSHARED_MATCHSELECTIONCODEWITHOPTIONALSUFFIX_RETURN$/ || u ~ /^BEQ\.[SWB] ESQSHARED_MATCHSELECTIONCODEWITHOPTIONALSUFFIX_RETURN$/ || u ~ /^JMP ESQSHARED_MATCHSELECTIONCODEWITHOPTIONALSUFFIX_RETURN$/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PARSE_DOT=" has_parse_dot
    print "HAS_PARSE_COLON=" has_parse_colon
    print "HAS_SUFFIX_GATE=" has_suffix_gate
    print "HAS_SPLIT_STORE=" has_split_store
    print "HAS_MAIN_MATCH=" has_main_match
    print "HAS_SUFFIX_MATCH=" has_suffix_match
    print "HAS_FINAL_GATE=" has_final_gate
    print "HAS_RETURN=" has_return
}
