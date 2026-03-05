BEGIN {
    has_entry = 0
    has_replace_owned = 0
    has_primary_copy = 0
    has_secondary_copy = 0
    has_runtime_gate = 0
    has_active_group = 0
    has_shadow_copy = 0
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

    if (u ~ /^SCRIPT_LOADCTRLCONTEXTSNAPSHOT:/) has_entry = 1
    if (index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPROTO_JMPTBL_ESQPARS_REPLACEO") > 0) has_replace_owned = 1
    if (index(u, "TEXTDISP_PRIMARYSEARCHTEXT") > 0) has_primary_copy = 1
    if (index(u, "TEXTDISP_SECONDARYSEARCHTEXT") > 0) has_secondary_copy = 1
    if (index(u, "SCRIPT_RUNTIMEMODE") > 0) has_runtime_gate = 1
    if (index(u, "TEXTDISP_ACTIVEGROUPID") > 0 || index(u, "426(A3)") > 0 || index(u, "$1AA(A3)") > 0) has_active_group = 1
    if (index(u, "$1AC") > 0 || index(u, "$1B0") > 0 || index(u, "TEXTDISP_BANNERFALLBACKENTRYINDEX") > 0 || index(u, "TEXTDISP_BANNERSELECTEDENTRYINDEX") > 0) has_shadow_copy = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_PRIMARY_COPY=" has_primary_copy
    print "HAS_SECONDARY_COPY=" has_secondary_copy
    print "HAS_RUNTIME_GATE=" has_runtime_gate
    print "HAS_ACTIVE_GROUP=" has_active_group
    print "HAS_SHADOW_COPY=" has_shadow_copy
    print "HAS_RETURN=" has_return
}
