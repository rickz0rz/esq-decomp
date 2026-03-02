BEGIN {
    has_get = 0
    has_head = 0
    has_active = 0
    has_target = 0
    has_delta = 0
    has_budget = 0
    has_sign = 0
    has_neg1 = 0
    has_pos1 = 0
    has_compare = 0
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

    if (n ~ /SCRIPT3JMPTBLGCOMMANDGETBANNERCHAR/) has_get = 1
    if (n ~ /CONFIGBANNERCOPPERHEADBYTE/) has_head = 1
    if (n ~ /SCRIPTBANNERTRANSITIONACTIVE/) has_active = 1
    if (n ~ /SCRIPTBANNERTRANSITIONTARGETCHAR/) has_target = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPDELTA/) has_delta = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPBUDGET/) has_budget = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPSIGN/) has_sign = 1
    if (u ~ /-1/) has_neg1 = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_pos1 = 1
    if (u ~ /CMP|TST|BEQ|BNE|BGE|BLT/) has_compare = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_GET=" has_get
    print "HAS_HEAD=" has_head
    print "HAS_ACTIVE=" has_active
    print "HAS_TARGET=" has_target
    print "HAS_DELTA=" has_delta
    print "HAS_BUDGET=" has_budget
    print "HAS_SIGN=" has_sign
    print "HAS_NEG1=" has_neg1
    print "HAS_POS1=" has_pos1
    print "HAS_COMPARE=" has_compare
    print "HAS_TERMINAL=" has_terminal
}
