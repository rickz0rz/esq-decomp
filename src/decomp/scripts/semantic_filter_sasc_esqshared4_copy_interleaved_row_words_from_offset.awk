BEGIN {
    has_entry = 0
    has_base_offset = 0
    has_tail_offset = 0
    has_add_20 = 0
    has_copy_6 = 0
    has_copy_10 = 0
    has_copy_14 = 0
    has_loop = 0
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

    if (uline ~ /^ESQSHARED4_COPYINTERLEAVEDROWWORDSFROMOFFSET:/ || uline ~ /^ESQSHARED4_COPYINTERLEAVEDROWWOR[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "ESQSHARED4_INTERLEAVECOPYBASEOFFSET") > 0 || index(uline, "ESQSHARED4_INTERLEAVECOPYBASEOFF") > 0 || index(uline, "INTERLEAVECOPYBASE") > 0) has_base_offset = 1
    if (index(uline, "ESQSHARED4_INTERLEAVECOPYTAILOFFSETCURRENT") > 0 || index(uline, "ESQSHARED4_INTERLEAVECOPYTAILOFF") > 0 || index(uline, "INTERLEAVECOPYTAIL") > 0) has_tail_offset = 1
    if (uline ~ /#(\$)?20/ || uline ~ /#32/) has_add_20 = 1
    if (uline ~ /6\(A[0-7]\)/ || uline ~ /\$6\(A[0-7]\)/) has_copy_6 = 1
    if (uline ~ /10\(A[0-7]\)/ || uline ~ /\$A\(A[0-7]\)/) has_copy_10 = 1
    if (uline ~ /14\(A[0-7]\)/ || uline ~ /\$E\(A[0-7]\)/) has_copy_14 = 1
    if (uline ~ /^DBF / || uline ~ /^DBRA / || uline ~ /^BNE(\.[BWL])? / || uline ~ /^BHI(\.[BWL])? / || uline ~ /^BGE(\.[BWL])? / || uline ~ /^BRA(\.[BWL])? / || uline ~ /^ADDQ\.[WL] #(\$)?1,D[0-7]/ || uline ~ /^CMP\.[WL] / || uline ~ /^CMPI\.[WL] /) has_loop = 1
    if (uline == "RTS") has_rts = 1
}

END {
    if (has_copy_6 && has_copy_10 && has_copy_14) {
        has_loop = 1
    }
    print "HAS_ENTRY=" has_entry
    print "HAS_BASE_OFFSET=" has_base_offset
    print "HAS_TAIL_OFFSET=" has_tail_offset
    print "HAS_ADD_20=" has_add_20
    print "HAS_COPY_6=" has_copy_6
    print "HAS_COPY_10=" has_copy_10
    print "HAS_COPY_14=" has_copy_14
    print "HAS_LOOP=" has_loop
    print "HAS_RTS=" has_rts
}
