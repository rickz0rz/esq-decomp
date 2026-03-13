BEGIN {
    has_entry = 0
    has_get = 0
    has_adjust = 0
    has_active = 0
    has_cursor = 0
    has_delta = 0
    has_budget = 0
    has_sign = 0
    has_target = 0
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

    if (u ~ /^SCRIPT_UPDATEBANNERCHARTRANSITION:/ || u ~ /^SCRIPT_UPDATEBANNERCHARTRANS[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /SCRIPT3JMPTBLGCOMMANDGETBANNERCHAR/ || n ~ /SCRIPT3JMPTBLGCOMMANDGETBAN/ ||
        n ~ /GCOMMANDGETBANNERCHAR/ || n ~ /GCOMMANDGETBAN/) has_get = 1
    if (n ~ /SCRIPT3JMPTBLGCOMMANDADJUSTBANNERCOPPEROFFSET/ || n ~ /SCRIPT3JMPTBLGCOMMANDADJUSTBA/ ||
        n ~ /GCOMMANDADJUSTBANNERCOPPEROFFSET/ || n ~ /GCOMMANDADJUSTBA/) has_adjust = 1
    if (n ~ /SCRIPTBANNERTRANSITIONACTIVE/) has_active = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPCURSOR/ || n ~ /SCRIPTBANNERTRANSITIONSTEPCURSO/) has_cursor = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPDELTA/) has_delta = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPBUDGET/ || n ~ /SCRIPTBANNERTRANSITIONSTEPBUDGE/) has_budget = 1
    if (n ~ /SCRIPTBANNERTRANSITIONSTEPSIGN/) has_sign = 1
    if (n ~ /SCRIPTBANNERTRANSITIONTARGETCHAR/ || n ~ /SCRIPTBANNERTRANSITIONTARGETCHA/) has_target = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET=" has_get
    print "HAS_ADJUST=" has_adjust
    print "HAS_ACTIVE=" has_active
    print "HAS_CURSOR=" has_cursor
    print "HAS_DELTA=" has_delta
    print "HAS_BUDGET=" has_budget
    print "HAS_SIGN=" has_sign
    print "HAS_TARGET=" has_target
    print "HAS_RETURN=" has_return
}
