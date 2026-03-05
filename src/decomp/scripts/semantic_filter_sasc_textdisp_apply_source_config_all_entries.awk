BEGIN {
    has_entry = 0
    has_primary_count = 0
    has_secondary_count = 0
    has_get_entry = 0
    has_apply_entry = 0
    has_loop_inc = 0
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

    if (u ~ /^TEXTDISP_APPLYSOURCECONFIGALLENTRIES:/ || u ~ /^TEXTDISP_APPLYSOURCECONFIGALLENTR[A-Z0-9_]*:|^TEXTDISP_APPLYSOURCECONFIGALLENT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_PRIMARYGROUPENTRYCOUNT") > 0) has_primary_count = 1
    if (index(u, "TEXTDISP_SECONDARYGROUPENTRYCOUNT") > 0 || index(u, "TEXTDISP_SECONDARYGROUPENTRYCOUN") > 0) has_secondary_count = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOI") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPO") > 0) has_get_entry = 1
    if (index(u, "TEXTDISP_APPLYSOURCECONFIGTOENTRY") > 0 || index(u, "TEXTDISP_APPLYSOURCECONFIGTOENTR") > 0) has_apply_entry = 1
    if (u ~ /ADDQ\.L #1/ || index(u, "ADDQ.L #$1") > 0) has_loop_inc = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PRIMARY_COUNT=" has_primary_count
    print "HAS_SECONDARY_COUNT=" has_secondary_count
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_APPLY_ENTRY=" has_apply_entry
    print "HAS_LOOP_INC=" has_loop_inc
    print "HAS_RETURN=" has_return
}
