BEGIN {
    has_prologue = 0
    has_ptr_load = 0
    has_byte_load = 0
    has_class_table = 0
    has_bit3_test = 0
    has_ptr_advance = 0
    has_return_ptr = 0
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

    if (u ~ /^(MOVE\.L A[0-7],-\((A7|SP)\)|MOVEM\.L|LINK\.W)/) has_prologue = 1
    if (u ~ /^MOVEA?\.L [0-9]+\((A7|SP)\),A[0-7]$/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),A[0-7]$/) has_ptr_load = 1
    if (u ~ /^MOVE\.B \(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_byte_load = 1
    if (u ~ /GLOBAL_CHARCLASSTABLE/) has_class_table = 1
    if (u ~ /^BTST #3,/ || u ~ /^AND\.B #8,D[0-7]$/) has_bit3_test = 1
    if (u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^LEA \(1,A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_ptr_advance = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/) has_return_ptr = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (!has_prologue && has_ptr_load) has_prologue = 1
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_PTR_LOAD=" has_ptr_load
    print "HAS_BYTE_LOAD=" has_byte_load
    print "HAS_CLASS_TABLE=" has_class_table
    print "HAS_BIT3_TEST=" has_bit3_test
    print "HAS_PTR_ADVANCE=" has_ptr_advance
    print "HAS_RETURN_PTR=" has_return_ptr
    print "HAS_RTS=" has_rts
}
