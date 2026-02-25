BEGIN {
    has_prologue = 0
    has_input_ptr_load = 0
    has_loop_guard = 0
    has_byte_load = 0
    has_upper_logic = 0
    has_byte_store = 0
    has_ptr_increment = 0
    has_return_input_ptr = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^(LINK\.W|MOVEM\.L)/ || u ~ /^MOVE\.L D[0-7],-\((SP|A7)\)$/) has_prologue = 1
    if (u ~ /^MOVEA?\.L [0-9]+\((A7|SP)\),A[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,(SP|A7)\),A[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,(SP|A7)\),D0$/) has_input_ptr_load = 1

    if (u ~ /^TST\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/ || u ~ /^TST\.B D[0-7]$/) has_loop_guard = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+?,D[0-7]$/ || u ~ /^MOVE\.B D[0-7],D[0-7]$/) has_byte_load = 1

    if (u ~ /GLOBAL_CHARCLASSTABLE/ || u ~ /^BTST #1,/ || u ~ /^SUB\.L D[0-7],D[0-7]$/ || u ~ /^SUBI?\.B #\$20,D[0-7]$/ || u ~ /^CMPI\.B #'A',D[0-7]$/ || u ~ /^CMPI\.B #'Z',D[0-7]$/) {
        has_upper_logic = 1
    }

    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_byte_store = 1
    if (u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)\+$/) has_ptr_increment = 1

    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVE\.L \([0-9]+,(SP|A7)\),D0$/) has_return_input_ptr = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_INPUT_PTR_LOAD=" has_input_ptr_load
    print "HAS_LOOP_GUARD=" has_loop_guard
    print "HAS_BYTE_LOAD=" has_byte_load
    print "HAS_UPPER_LOGIC=" has_upper_logic
    print "HAS_BYTE_STORE=" has_byte_store
    print "HAS_PTR_INCREMENT=" has_ptr_increment
    print "HAS_RETURN_INPUT_PTR=" has_return_input_ptr
    print "HAS_RTS=" has_rts
}
