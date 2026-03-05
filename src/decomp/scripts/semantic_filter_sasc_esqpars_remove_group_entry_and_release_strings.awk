BEGIN {
    has_entry = 0
    has_reset_ctrl = 0
    has_clear_line = 0
    has_group_select = 0
    has_entry_loop = 0
    has_title_slot_loop = 0
    has_slot_string_free = 0
    has_title_table_free = 0
    has_free_entry_resources = 0
    has_entry_free = 0
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

    if (u ~ /^ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS:/ || u ~ /^ESQPARS_REMOVEGROUPENTRYANDRELEA[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "RESETCTRLCONTEXTANDCLEARSTATUSLINE") > 0 || index(u, "RESETCTRLCONTEXTANDCLEARSTA") > 0 || index(u, "RESETCTRLC") > 0) has_reset_ctrl = 1
    if (index(u, "ESQIFF2_CLEARLINEHEADTAILBYMODE") > 0 || index(u, "CLEARLINEHEADTAILBYMODE") > 0) has_clear_line = 1
    if (index(u, "TEXTDISP_SECONDARYGROUPENTRYCOUNT") > 0 || index(u, "TEXTDISP_PRIMARYGROUPENTRYCOUNT") > 0) has_group_select = 1
    if (u ~ /^TST\.[WL] D[0-7]$/ || u ~ /^BMI\.[SWB] ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS_RETURN$/ || u ~ /^SUBQ\.[WL] #\$1,D[0-7]$/ || u ~ /^SUBQ\.[WL] #1,D[0-7]$/) has_entry_loop = 1
    if (u ~ /^CMP\.[WL] #\$31,D[0-7]$/ || u ~ /^CMP\.[WL] #49,D[0-7]$/ || u ~ /^MOVEQ\.L #\$31,D[0-7]$/ || u ~ /^MOVEQ\.L #49,D[0-7]$/ || u ~ /^CMP\.[WL] D[0-7],D[0-7]$/ || index(u, "RELEASE_TITLE_SLOT_LOOP") > 0) has_title_slot_loop = 1
    if (index(u, "GLOBAL_STR_ESQPARS_C_2") > 0 || (index(u, "DEALLOCATEM") > 0 && index(u, "1025") > 0)) has_slot_string_free = 1
    if (index(u, "GLOBAL_STR_ESQPARS_C_3") > 0 || (index(u, "DEALLOCATEM") > 0 && index(u, "1031") > 0)) has_title_table_free = 1
    if (index(u, "COI_FREEENTRYRESOURCES") > 0 || index(u, "FREEENTRYRESOURCES") > 0 || index(u, "FREEENTRYRESO") > 0) has_free_entry_resources = 1
    if (index(u, "GLOBAL_STR_ESQPARS_C_4") > 0 || (index(u, "DEALLOCATEM") > 0 && index(u, "1040") > 0)) has_entry_free = 1
    if (u ~ /^BRA\.[SWB] ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS_RETURN$/ || u ~ /^BMI\.[SWB] ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS_RETURN$/ || u ~ /^JMP ESQPARS_REMOVEGROUPENTRYANDRELEASESTRINGS_RETURN$/ || u ~ /^BMI\.[SWB] ___ESQPARS_REMOVEGROUPENTRYANDRELEA/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET_CTRL=" has_reset_ctrl
    print "HAS_CLEAR_LINE=" has_clear_line
    print "HAS_GROUP_SELECT=" has_group_select
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_TITLE_SLOT_LOOP=" has_title_slot_loop
    print "HAS_SLOT_STRING_FREE=" has_slot_string_free
    print "HAS_TITLE_TABLE_FREE=" has_title_table_free
    print "HAS_FREE_ENTRY_RESOURCES=" has_free_entry_resources
    print "HAS_ENTRY_FREE=" has_entry_free
    print "HAS_RETURN=" has_return
}
