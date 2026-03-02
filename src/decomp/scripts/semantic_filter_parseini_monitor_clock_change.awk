BEGIN {
    has_h = 0
    has_t = 0
    has_clock_ref = 0
    has_snapshot = 0
    has_active = 0
    has_counter = 0
    has_call = 0
    has_const_1 = 0
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

    if (n ~ /GLOBALWORDHVALUE/) has_h = 1
    if (n ~ /GLOBALWORDTVALUE/) has_t = 1
    if (n ~ /GLOBALREFCLOCKDATASTRUCT/) has_clock_ref = 1
    if (n ~ /PARSEINICLOCKSECONDSSNAPSHOT/) has_snapshot = 1
    if (n ~ /PARSEINICLOCKCHANGEACTIVEFLAG/) has_active = 1
    if (n ~ /PARSEINICLOCKCHANGESAMPLECOUNTER/) has_counter = 1
    if (n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/) has_call = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_const_1 = 1
    if (u ~ /[^0-9]3[^0-9]/ || u ~ /^3$/) has_const_3 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_H=" has_h
    print "HAS_T=" has_t
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_SNAPSHOT=" has_snapshot
    print "HAS_ACTIVE=" has_active
    print "HAS_COUNTER=" has_counter
    print "HAS_CALL=" has_call
    print "HAS_CONST_1=" has_const_1
    print "HAS_CONST_3=" has_const_3
    print "HAS_TERMINAL=" has_terminal
}
