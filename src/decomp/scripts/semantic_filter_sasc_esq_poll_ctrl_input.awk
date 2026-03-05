BEGIN {
    has_entry = 0
    has_call_bit4 = 0
    has_gate_char = 0
    has_call_bit3 = 0
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

    if (l ~ /ESQ_CAPTURECTRLBIT4STREAM/) has_call_bit4 = 1
    if (l ~ /#"N"/ || l ~ /#78/ || l ~ /#\$4E/ || l ~ /ESQ_STATUSPACKET__BIT3CAPTUREGATECHAR/ || l ~ /ESQ_STR_B\+\$12/) has_gate_char = 1
    if (l ~ /ESQ_CAPTURECTRLBIT3STREAM/) has_call_bit3 = 1
    if (l ~ /#\$?100/ || l ~ /#256/ || l ~ /INTREQ/) has_intreq_write = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CALL_BIT4=" has_call_bit4
    print "HAS_GATE_CHAR_TEST=" has_gate_char
    print "HAS_CALL_BIT3=" has_call_bit3
    print "HAS_INTREQ_WRITE=" has_intreq_write
    print "HAS_RETURN=" has_return
}
