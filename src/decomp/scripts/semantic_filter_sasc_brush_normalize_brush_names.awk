BEGIN {
    has_entry = 0
    has_loop = 0
    has_next_offset = 0
    has_find_sep_call = 0
    has_copy_flow = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /BRA\.[BWL]? .*LOOP/ || u ~ /BNE\.[BWL]? .*COPY/ || u ~ /JNE .*L[0-9]/ || u ~ /BEQ|BNE|BRA/) has_loop = 1
    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_next_offset = 1
    if (u ~ /GCOMMAND_FINDPATHSEPARATOR/ || u ~ /_GROUP_AA_JMPTBL_GCOMMAND_FINDPATHSEPARATOR/ || u ~ /GROUP_AA_JMPTBL_GCOMMAND_FINDPATHSEPAR/ || u ~ /_GROUP_AA_JMPTBL_GCOMMAND_FINDPATHSEPAR/ || u ~ /GROUP_AA_JMPTBL_GCOMMAND_FINDPAT/ || u ~ /_GROUP_AA_JMPTBL_GCOMMAND_FINDPAT/) has_find_sep_call = 1
    if (u ~ /MOVE\.B .*A0|MOVE\.B .*A1|MOVE\.B .*A2|\(A0\)\+|\(A1\)\+|\(A2\)\+/) has_copy_flow = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_FLOW=" has_loop
    print "HAS_NEXT_OFFSET_368=" has_next_offset
    print "HAS_FIND_SEPARATOR_CALL=" has_find_sep_call
    print "HAS_COPY_FLOW=" has_copy_flow
    print "HAS_RTS=" has_rts
}
