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

    if (uline ~ /^ESQDISP_MIRRORPRIMARYENTRIESTOSECONDARYIFEMPTY:/ || uline ~ /^ESQDISP_MIRRORPRIMARYENTRIESTOSE[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOU/) has_guard = 1
    if (uline ~ /ESQSHARED_CREATEGROUPENTRYANDTITLE/ || uline ~ /ESQSHARED_CREATEGROUPENTRYANDT/) has_create = 1
    if (uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFIELDS/ || uline ~ /ESQDISP_FILLPROGRAMINFOHEADERFI/) has_fill = 1
    if ((uline ~ /ESQDISP_PRIMARYSECONDARYMIRRORFLAG/ || uline ~ /ESQDISP_PRIMARYSECONDARYMIRRORFL/) && (uline ~ /#1/ || uline ~ /#\$1/)) has_flag_set = 1
    if (uline ~ /^CLR\.W ESQDISP_PRIMARYSECONDARYMIRRORFLAG/ || uline ~ /^CLR\.L ESQDISP_PRIMARYSECONDARYMIRRORFLAG/ || uline ~ /^CLR\.W ESQDISP_PRIMARYSECONDARYMIRRORFL/ || uline ~ /^CLR\.L ESQDISP_PRIMARYSECONDARYMIRRORFL/ || ((uline ~ /ESQDISP_PRIMARYSECONDARYMIRRORFLAG/ || uline ~ /ESQDISP_PRIMARYSECONDARYMIRRORFL/) && uline ~ /#0/)) has_flag_clear = 1
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
