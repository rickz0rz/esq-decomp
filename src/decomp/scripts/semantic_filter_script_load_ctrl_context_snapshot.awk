BEGIN {
    has_replace = 0
    has_cmd_ptr = 0
    has_primary_text = 0
    has_secondary_text = 0
    has_runtime = 0
    has_runtime_cmp2 = 0
    has_runtime_cmp0 = 0
    has_saved_mode_cmp3 = 0
    has_saved_mode_cmp1 = 0
    has_active_group = 0
    has_fallback = 0
    has_selected = 0
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

    if (n ~ /ESQPROTOJMPTBLESQPARSREPLACEOWNEDSTRING/) has_replace = 1
    if (n ~ /SCRIPTCOMMANDTEXTPTR/) has_cmd_ptr = 1
    if (n ~ /TEXTDISPPRIMARYSEARCHTEXT/) has_primary_text = 1
    if (n ~ /TEXTDISPSECONDARYSEARCHTEXT/) has_secondary_text = 1
    if (n ~ /SCRIPTRUNTIMEMODE/) has_runtime = 1
    if (u ~ /#2/ || u ~ /[^0-9]2[^0-9]/) has_runtime_cmp2 = 1
    if (u ~ /[^0-9]0[^0-9]/ || u ~ /^0$/) has_runtime_cmp0 = 1
    if (u ~ /#3/ || u ~ /[^0-9]3[^0-9]/) has_saved_mode_cmp3 = 1
    if (u ~ /#1/ || u ~ /[^0-9]1[^0-9]/) has_saved_mode_cmp1 = 1
    if (n ~ /TEXTDISPACTIVEGROUPID/) has_active_group = 1
    if (n ~ /TEXTDISPBANNERFALLBACKENTRYINDEX/) has_fallback = 1
    if (n ~ /TEXTDISPBANNERSELECTEDENTRYINDEX/) has_selected = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_REPLACE=" has_replace
    print "HAS_CMD_PTR=" has_cmd_ptr
    print "HAS_PRIMARY_TEXT=" has_primary_text
    print "HAS_SECONDARY_TEXT=" has_secondary_text
    print "HAS_RUNTIME=" has_runtime
    print "HAS_RUNTIME_CMP2=" has_runtime_cmp2
    print "HAS_RUNTIME_CMP0=" has_runtime_cmp0
    print "HAS_SAVED_MODE_CMP3=" has_saved_mode_cmp3
    print "HAS_SAVED_MODE_CMP1=" has_saved_mode_cmp1
    print "HAS_ACTIVE_GROUP=" has_active_group
    print "HAS_FALLBACK=" has_fallback
    print "HAS_SELECTED=" has_selected
    print "HAS_TERMINAL=" has_terminal
}
