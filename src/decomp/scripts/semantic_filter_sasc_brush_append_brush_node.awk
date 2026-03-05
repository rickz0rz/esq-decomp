BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_offset_368 = 0
    has_cond_branch = 0
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

    if (u ~ /TST\.L/ || u ~ /CMP\.L/ || u ~ /CMPI\.L/ || u ~ /BEQ/ || u ~ /BNE/ || u ~ /JEQ/ || u ~ /JNE/) has_null_guard = 1
    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_offset_368 = 1
    if (u ~ /(^|[[:space:]])B(EQ|NE|RA|HI|LS|GE|GT|LE|LT)([[:space:]]|$)/) has_cond_branch = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_NEXT_OFFSET_368=" has_offset_368
    print "HAS_BRANCH_FLOW=" has_cond_branch
    print "HAS_RTS=" has_rts
}
