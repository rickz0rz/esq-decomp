BEGIN {
    has_call_bit4 = 0
    has_gate_char = 0
    has_call_bit3 = 0
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

    if (uline ~ /ESQ_CAPTURECTRLBIT4STREAM/) has_call_bit4 = 1
    if (uline ~ /#\"N\"/ || uline ~ /#78/ || uline ~ /ESQ_STATUSPACKET__BIT3CAPTUREGATECHAR/) has_gate_char = 1
    if (uline ~ /ESQ_CAPTURECTRLBIT3STREAM/) has_call_bit3 = 1
    if (uline ~ /#\$?100/ || uline ~ /#256/ || uline ~ /INTREQ/) has_intreq_write = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_CALL_BIT4=" has_call_bit4
    print "HAS_GATE_CHAR_TEST=" has_gate_char
    print "HAS_CALL_BIT3=" has_call_bit3
    print "HAS_INTREQ_WRITE=" has_intreq_write
    print "HAS_RTS=" has_rts
}

