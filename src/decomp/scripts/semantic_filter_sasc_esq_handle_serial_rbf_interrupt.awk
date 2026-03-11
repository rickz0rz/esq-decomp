BEGIN {
    has_entry = 0
    has_head_load = 0
    has_error_bit_test = 0
    has_head_wrap = 0
    has_overflow_gate = 0
    has_mode_set = 0
    has_intreq_write = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /GLOBAL_WORD_H_VALUE/) has_head_load = 1
    if (l ~ /BTST #15/ || l ~ /BTST #\$F/ || l ~ /AND\.W #\$?8000/ || l ~ /AND\.L #\$?8000/ || l ~ /^TST\.W \(24,A0\)$/ || l ~ /^TST\.W D[0-7]$/ || l ~ /^JLT / || l ~ /^BMI / || l ~ /^BPL /) has_error_bit_test = 1
    if (l ~ /#\$?FA00/ || l ~ /#64000/ || l ~ /#-1536/) has_head_wrap = 1
    if (l ~ /#\$?DAC0/ || l ~ /FFFFDAC0/ || l ~ /#56000/ || l ~ /#-9536/) has_overflow_gate = 1
    if (l ~ /#\$?102/ || l ~ /#258/ || l ~ /ESQPARS2_READMODEFLAGS/) has_mode_set = 1
    if (l ~ /#\$?800/ || l ~ /#2048/ || l ~ /156\(A0\)/) has_intreq_write = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_HEAD_LOAD=" has_head_load
    print "HAS_ERROR_BIT_TEST=" has_error_bit_test
    print "HAS_HEAD_WRAP_CONST=" has_head_wrap
    print "HAS_OVERFLOW_GATE_CONST=" has_overflow_gate
    print "HAS_MODE_SET_MARKERS=" has_mode_set
    print "HAS_INTREQ_WRITE=" has_intreq_write
    print "HAS_RETURN=" has_return
}
