BEGIN {
    has_entry = 0
    has_table_ref = 0
    has_call = 0
    has_stack_fix = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^GCOMMAND_INITPRESETDEFAULTS:/) has_entry = 1
    if (index(uline, "GCOMMAND_DEFAULTPRESETTABLE") > 0) has_table_ref = 1
    if ((uline ~ /^BSR(\.[A-Z]+)? / || uline ~ /^JSR /) && (index(uline, "GCOMMAND_INITPRESETTABLEFROMPALETTE") > 0 || index(uline, "GCOMMAND_INITPRESETTABLEFROMPALE") > 0)) has_call = 1
    if (uline ~ /^ADDQ\.[WL] #(\$)?4,A7$/ || uline ~ /^LEA 4\(A7\),A7$/) has_stack_fix = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TABLE_REF=" has_table_ref
    print "HAS_CALL=" has_call
    print "HAS_STACK_FIX=" has_stack_fix
    print "HAS_RTS=" has_rts
}
