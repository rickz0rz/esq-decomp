BEGIN {
    has_ctrl_h = 0
    has_prev = 0
    has_gate_flag = 0
    has_pending = 0
    has_counter = 0
    has_snapshot = 0
    has_clock_ref = 0
    has_call = 0
    has_const_16 = 0
    has_const_3 = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /CTRLH/) has_ctrl_h = 1
    if (n ~ /CTRLHPREVIOUSSAMPLE/) has_prev = 1
    if (n ~ /PARSEINICTRLHCHANGEGATEFLAG/) has_gate_flag = 1
    if (n ~ /PARSEINICTRLHCHANGEPENDINGFLAG/) has_pending = 1
    if (n ~ /PARSEINICTRLHCHANGEGATECOUNTER/) has_counter = 1
    if (n ~ /PARSEINICTRLHCLOCKSNAPSHOT/) has_snapshot = 1
    if (n ~ /GLOBALREFCLOCKDATASTRUCT/) has_clock_ref = 1
    if (n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/) has_call = 1
    if (u ~ /[^0-9]16[^0-9]/ || u ~ /^16$/) has_const_16 = 1
    if (u ~ /[^0-9]3[^0-9]/ || u ~ /^3$/) has_const_3 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_CTRL_H=" has_ctrl_h
    print "HAS_PREV=" has_prev
    print "HAS_GATE_FLAG=" has_gate_flag
    print "HAS_PENDING=" has_pending
    print "HAS_COUNTER=" has_counter
    print "HAS_SNAPSHOT=" has_snapshot
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_CALL=" has_call
    print "HAS_CONST_16=" has_const_16
    print "HAS_CONST_3=" has_const_3
    print "HAS_TERMINAL=" has_terminal
}
