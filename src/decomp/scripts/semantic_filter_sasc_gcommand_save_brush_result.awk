BEGIN {
    has_entry = 0
    has_state_byte_read = 0
    has_populate = 0
    has_state4_check = 0
    has_state5_check = 0
    has_state6_check = 0
    has_forbid = 0
    has_permit = 0
    has_append = 0
    has_logo_ref = 0
    has_gads_ref = 0
    has_weather_ref = 0
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

    if (u ~ /^GCOMMAND_SAVEBRUSHRESULT[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVE\.B 190\(A[0-7]\),D[0-7]$/ || u ~ /^MOVE\.B \$BE\(A[0-7]\),D[0-7]$/ || index(u, "CTASKS_IFFTASKSTATE") > 0) has_state_byte_read = 1

    if (index(u, "GROUP_AU_JMPTBL_BRUSH_POPULATEBRUSHLIST") > 0 ||
        index(u, "GROUP_AU_JMPTBL_BRUSH_POPULATEB") > 0 ||
        index(u, "BRUSH_POPULATEBRUSHLIST") > 0) has_populate = 1

    if (u ~ /^SUBQ\.W #4,D[0-7]$/ || u ~ /^SUBQ\.W #\$4,D[0-7]$/ || u ~ /^CMPI\.W #4,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W #4,D[0-7]$/ || u ~ /^CMPI\.W #\$4,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W D5,D[0-7]$/) has_state4_check = 1
    if (u ~ /^SUBQ\.W #5,D[0-7]$/ || u ~ /^SUBQ\.W #\$5,D[0-7]$/ || u ~ /^CMPI\.W #5,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W #5,D[0-7]$/ || u ~ /^CMPI\.W #\$5,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W D4,D[0-7]$/) has_state5_check = 1
    if (u ~ /^SUBQ\.W #6,D[0-7]$/ || u ~ /^SUBQ\.W #\$6,D[0-7]$/ || u ~ /^CMPI\.W #6,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W #6,D[0-7]$/ || u ~ /^CMPI\.W #\$6,CTASKS_IFFTASKSTATE/ || u ~ /^CMP\.W \$1C\(A7\),D[0-7]$/) has_state6_check = 1

    if (index(u, "_LVOFORBID") > 0) has_forbid = 1
    if (index(u, "_LVOPERMIT") > 0) has_permit = 1

    if (index(u, "GROUP_AU_JMPTBL_BRUSH_APPENDBRUSHNODE") > 0 ||
        index(u, "GROUP_AU_JMPTBL_BRUSH_APPENDBRU") > 0 ||
        index(u, "BRUSH_APPENDBRUSHNODE") > 0) has_append = 1

    if (index(u, "ESQIFF_LOGOBRUSHLISTHEAD") > 0 || index(u, "ESQIFF_LOGOBRUSHLISTCOUNT") > 0 || index(u, "ESQIFF_LOGOBRUSHLIST") > 0) has_logo_ref = 1
    if (index(u, "ESQIFF_GADSBRUSHLISTHEAD") > 0 || index(u, "ESQIFF_GADSBRUSHLISTCOUNT") > 0 || index(u, "ESQIFF_GADSBRUSHLIST") > 0) has_gads_ref = 1
    if (index(u, "WDISP_WEATHERSTATUSBRUSHLISTHEAD") > 0 || index(u, "WDISP_WEATHERSTATUSBRUSHLIST") > 0) has_weather_ref = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATE_BYTE_READ=" has_state_byte_read
    print "HAS_POPULATE=" has_populate
    print "HAS_STATE4_CHECK=" has_state4_check
    print "HAS_STATE5_CHECK=" has_state5_check
    print "HAS_STATE6_CHECK=" has_state6_check
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_APPEND=" has_append
    print "HAS_LOGO_REF=" has_logo_ref
    print "HAS_GADS_REF=" has_gads_ref
    print "HAS_WEATHER_REF=" has_weather_ref
    print "HAS_RETURN=" has_return
}
