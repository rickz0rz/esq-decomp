BEGIN {
    has_entry = 0
    has_primary = 0
    has_secondary = 0
    has_zero = 0
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

    if (u ~ /^TEXTDISP_GETGROUPENTRYCOUNT:/ || u ~ /^TEXTDISP_GETGROUPENTRYCO[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_PRIMARYGROUPENTRYCOUNT") > 0) has_primary = 1
    if (index(u, "TEXTDISP_SECONDARYGROUPENTRYCOUNT") > 0 || index(u, "TEXTDISP_SECONDARYGROUPENTRYCOUN") > 0) has_secondary = 1
    if (u ~ /MOVEQ #0,/ || index(u, "MOVEQ.L #$0,") > 0 || index(u, "CLR") > 0) has_zero = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PRIMARY=" has_primary
    print "HAS_SECONDARY=" has_secondary
    print "HAS_ZERO=" has_zero
    print "HAS_RETURN=" has_return
}
