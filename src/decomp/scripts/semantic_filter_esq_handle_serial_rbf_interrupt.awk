BEGIN {
    has_head_load = 0
    has_error_bit_test = 0
    has_head_wrap = 0
    has_overflow_gate = 0
    has_mode_set = 0
    has_intreq_write = 0
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

    if (uline ~ /GLOBAL_WORD_H_VALUE/) has_head_load = 1
    if (uline ~ /BTST #15/ || uline ~ /AND\.W #\$?8000/ || uline ~ /AND\.L #\$?8000/ || uline ~ /^TST\.W \(24,A0\)$/ || uline ~ /^JLT /) has_error_bit_test = 1
    if (uline ~ /#\$?FA00/ || uline ~ /#64000/ || uline ~ /#-1536/) has_head_wrap = 1
    if (uline ~ /#\$?DAC0/ || uline ~ /#56000/ || uline ~ /#-9536/) has_overflow_gate = 1
    if (uline ~ /#\$?102/ || uline ~ /#258/ || uline ~ /ESQPARS2_READMODEFLAGS/) has_mode_set = 1
    if (uline ~ /#\$?800/ || uline ~ /#2048/ || uline ~ /156\(A0\)/) has_intreq_write = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_HEAD_LOAD=" has_head_load
    print "HAS_ERROR_BIT_TEST=" has_error_bit_test
    print "HAS_HEAD_WRAP_CONST=" has_head_wrap
    print "HAS_OVERFLOW_GATE_CONST=" has_overflow_gate
    print "HAS_MODE_SET_MARKERS=" has_mode_set
    print "HAS_INTREQ_WRITE=" has_intreq_write
    print "HAS_RTS=" has_rts
}
