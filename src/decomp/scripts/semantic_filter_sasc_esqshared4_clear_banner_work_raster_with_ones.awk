BEGIN {
    has_entry = 0
    has_raster_ptr = 0
    has_149 = 0
    has_ffffffff_store = 0
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

    if (uline ~ /^ESQSHARED4_CLEARBANNERWORKRASTERWITHONES:/ || uline ~ /^ESQSHARED4_CLEARBANNERWORKRASTER[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "WDISP_BANNERWORKRASTERPTR") > 0 || index(uline, "WDISP_BANNERWORKRASTER") > 0) has_raster_ptr = 1
    if (uline ~ /#(\$)?149/ || uline ~ /#329/) has_149 = 1
    if (uline ~ /#(\$)?FFFFFFFF/ || uline ~ /#-1/ || (uline ~ /^MOVEQ\.L #(\$)?FF,D[0-7]/) || (uline ~ /^MOVE\.L D[0-7],\(A[0-7]\)\+/)) has_ffffffff_store = 1
    if (uline ~ /^DBF / || uline ~ /^DBRA / || uline ~ /^BNE(\.[BWL])? / || uline ~ /^BHI(\.[BWL])? / || uline ~ /^BRA(\.[BWL])? / || uline ~ /^ADDQ\.W #(\$)?1,D[0-7]/ || uline ~ /^SUBQ\.W #(\$)?1,D[0-7]/) has_loop = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RASTER_PTR=" has_raster_ptr
    print "HAS_149_CONST=" has_149
    print "HAS_FFFFFFFF_STORE=" has_ffffffff_store
    print "HAS_LOOP=" has_loop
    print "HAS_RTS=" has_rts
}
