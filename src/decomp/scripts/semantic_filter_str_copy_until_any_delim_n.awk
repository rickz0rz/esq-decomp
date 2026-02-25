BEGIN {
    has_prologue = 0
    has_maxlen_guard = 0
    has_src_guard = 0
    has_delim_guard = 0
    has_delim_compare = 0
    has_delim_advance = 0
    has_copy_store = 0
    has_copy_advance = 0
    has_dst_terminator = 0
    has_return_ptr = 0
    has_rts = 0
    jeq_count = 0
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

    if (u ~ /^(LINK\.W|MOVEM\.L|MOVE\.L [DA][0-7],-\((A7|SP)\)$)/) has_prologue = 1

    if (u ~ /SUBQ\.L #1,D[0-7]/ || u ~ /SUBI?\.L #1,D[0-7]/ || u ~ /CMPI?\.L #1,D[0-7]/) has_maxlen_guard = 1
    if (u ~ /^CMP\.L D[0-7],D[0-7]$/ || u ~ /^CMP\.L [DA][0-7],D[0-7]$/ || u ~ /^CMP\.L D[0-7],[DA][0-7]$/) {
        if (!has_maxlen_guard) has_maxlen_guard = 1
    }

    if (u ~ /^TST\.B 0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B 0?\(A[0-7](,D[0-7]\.L)?\),D[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_src_guard = 1
    if (u ~ /^TST\.B 0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_delim_guard = 1
    if (u ~ /^(BEQ|BEQ\.S|JEQ|JEQ\.S) /) jeq_count++

    if (u ~ /^CMP\.B 0?\(A[0-7](,D[0-7]\.L)?\),D[0-7]$/ || u ~ /^CMP\.B D[0-7],0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^CMP\.B D[0-7],D[0-7]$/) has_delim_compare = 1

    if (u ~ /^ADDQ\.L #1,D[0-7]$/ || u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_delim_advance = 1
    if (u ~ /^MOVE\.B D[0-7],0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B 0?\(A[0-7](,D[0-7]\.L)?\),0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_copy_store = 1
    if (u ~ /^ADDQ\.L #1,D[0-7]$/ || u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_copy_advance = 1

    if (u ~ /^CLR\.B 0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B #0,0?\(A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^CLR\.B \([0-9]*,A[0-7](,D[0-7]\.L)?\)$/ || u ~ /^MOVE\.B #0,\([0-9]*,A[0-7](,D[0-7]\.L)?\)$/) has_dst_terminator = 1

    if (u ~ /^MOVEA?\.L A[0-7],A0$/ || u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^LEA \(A[0-7],D[0-7]\.L\),A0$/ || u ~ /^ADDA?\.L D[0-7],A0$/ || u ~ /^ADD\.L D[0-7],D0$/) has_return_ptr = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (jeq_count >= 2) {
        has_src_guard = 1
        has_delim_guard = 1
    }
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_MAXLEN_GUARD=" has_maxlen_guard
    print "HAS_SRC_GUARD=" has_src_guard
    print "HAS_DELIM_GUARD=" has_delim_guard
    print "HAS_DELIM_COMPARE=" has_delim_compare
    print "HAS_DELIM_ADVANCE=" has_delim_advance
    print "HAS_COPY_STORE=" has_copy_store
    print "HAS_COPY_ADVANCE=" has_copy_advance
    print "HAS_DST_TERMINATOR=" has_dst_terminator
    print "HAS_RETURN_PTR=" has_return_ptr
    print "HAS_RTS=" has_rts
}
