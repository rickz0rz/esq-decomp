BEGIN {
    has_entry = 0
    has_get_banner = 0
    has_target = 0
    has_delta = 0
    has_sign = 0
    has_active = 0
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

    if (u ~ /^SCRIPT_PRIMEBANNERTRANSITIONFROMHEXCODE:/ || u ~ /^SCRIPT_PRIMEBANNERTRANSITIONFROMHEX[A-Z0-9_]*:/ || u ~ /^SCRIPT_PRIMEBANNERTRANSITIONFROM[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNERCHAR") > 0 ||
        index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNERC") > 0 ||
        index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNE") > 0 ||
        index(u, "GCOMMAND_GETBANNERCHAR") > 0 ||
        index(u, "GCOMMAND_GETBANNERC") > 0 ||
        index(u, "GCOMMAND_GETBANNE") > 0) has_get_banner = 1
    if (index(u, "SCRIPT_BANNERTRANSITIONTARGETCHAR") > 0 || index(u, "SCRIPT_BANNERTRANSITIONTARGETCHA") > 0) has_target = 1
    if (index(u, "SCRIPT_BANNERTRANSITIONSTEPDELTA") > 0 || index(u, "SCRIPT_BANNERTRANSITIONSTEPDELT") > 0) has_delta = 1
    if (index(u, "SCRIPT_BANNERTRANSITIONSTEPSIGN") > 0 || index(u, "SCRIPT_BANNERTRANSITIONSTEPSIG") > 0) has_sign = 1
    if (index(u, "SCRIPT_BANNERTRANSITIONACTIVE") > 0 || index(u, "SCRIPT_BANNERTRANSITIONACTIV") > 0 || index(u, "SCRIPT_BANNERTRANSITIONSTEPBUDGE") > 0) has_active = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET_BANNER=" has_get_banner
    print "HAS_TARGET=" has_target
    print "HAS_DELTA=" has_delta
    print "HAS_SIGN=" has_sign
    print "HAS_ACTIVE=" has_active
    print "HAS_RETURN=" has_return
}
