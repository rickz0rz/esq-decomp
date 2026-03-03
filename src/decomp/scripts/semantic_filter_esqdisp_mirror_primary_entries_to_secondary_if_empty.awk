BEGIN {
    has_entry = 0
    has_guard = 0
    has_create = 0
    has_fill = 0
    has_flag_set = 0
    has_flag_clear = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_MIRRORPRIMARYENTRIESTOSECONDARYIFEMPTY:/) has_entry = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/ && uline ~ /BNE(\.[A-Z]+)? \.MARK_NO_MIRROR_NEEDED/) has_guard = 1
    if (uline ~ /ESQSHARED_CREATEGROUPENTRYANDTITLE/) has_create = 1
    if (uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIELDS/) has_fill = 1
    if (uline ~ /MOVE\.W #1,ESQDISP_PRIMARYSECONDARYMIRRORFLAG/) has_flag_set = 1
    if (uline ~ /CLR\.W ESQDISP_PRIMARYSECONDARYMIRRORFLAG/) has_flag_clear = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_CREATE=" has_create
    print "HAS_FILL=" has_fill
    print "HAS_FLAG_SET=" has_flag_set
    print "HAS_FLAG_CLEAR=" has_flag_clear
    print "HAS_RETURN=" has_return
}
