BEGIN {
    has_entry = 0
    has_get = 0
    has_div = 0
    has_mulu = 0
    has_active = 0
    has_target = 0
    has_delta = 0
    has_budget = 0
    has_sign = 0
    has_pending_speed = 0
    has_lrbn = 0
    has_return = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_BEGINBANNERCHARTRANSITION:/ || u ~ /^SCRIPT_BEGINBANNERCHARTRANS[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPT3JMPTBLGCOMMANDGETBANNERCHAR/ || n ~ /SCRIPT3JMPTBLGCOMMANDGETBAN/ ||
        n ~ /GCOMMANDGETBANNERCHAR/ || n ~ /GCOMMANDGETBAN/) has_get = 1
    if (n ~ /SCRIPT3JMPTBLMATHDIVS32/) has_div = 1
    if (n ~ /SCRIPT3JMPTBLMATHMULU32/) has_mulu = 1
    if (n ~ /SCRIPTBANNERTRANSITIONACTIVE/) has_active = 1
    if (n ~ /SCRIPTBANNERTRANSITIONTARGETCHAR/ || n ~ /SCRIPTBANNERTRANSITIONTARGETCHA/) has_target = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPDELTA/) has_delta = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPBUDGET/ || n ~ /SCRIPTBANNERTRANSITIONSTEPBUDGE/) has_budget = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPSIGN/) has_sign = 1
    if (n ~ /SCRIPTPENDINGBANNERSPEEDMS/ || n ~ /SCRIPTPENDINGBANNERSPEEDM/) has_pending_speed = 1
    if (n ~ /CONFIGLRBNFLAGCHAR/ || n ~ /CONFIGLRBNFLAGCHA/) has_lrbn = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET=" has_get
    print "HAS_DIV=" has_div
    print "HAS_MULU=" has_mulu
    print "HAS_ACTIVE=" has_active
    print "HAS_TARGET=" has_target
    print "HAS_DELTA=" has_delta
    print "HAS_BUDGET=" has_budget
    print "HAS_SIGN=" has_sign
    print "HAS_PENDING_SPEED=" has_pending_speed
    print "HAS_LRBN_FLAG=" has_lrbn
    print "HAS_RETURN=" has_return
}
