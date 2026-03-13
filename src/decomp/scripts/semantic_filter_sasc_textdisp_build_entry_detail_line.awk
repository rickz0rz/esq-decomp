BEGIN {
    has_entry = 0
    has_reset = 0
    has_get_aux = 0
    has_get_entry = 0
    has_build_short = 0
    has_skip_codes = 0
    has_append = 0
    has_sprintf = 0
    has_find_sub = 0
    has_find_char = 0
    has_format_time = 0
    has_trim = 0
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

    if (u ~ /^TEXTDISP_BUILDENTRYDETAILLINE:/ || u ~ /^TEXTDISP_BUILDENTRYDETAILLI[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP_RESETSELECTIONSTATE") > 0 || index(u, "TEXTDISP_RESETSELECTIO") > 0) has_reset = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAU") > 0 || index(u, "ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0 || index(u, "ESQDISP_GETENTRYAUXPOINTERB") > 0) has_get_aux = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPO") > 0 || index(u, "ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "ESQDISP_GETENTRYPOINTERB") > 0) has_get_entry = 1
    if (index(u, "TEXTDISP_BUILDENTRYSHORTNAME") > 0 || index(u, "TEXTDISP_BUILDENTRYSHOR") > 0) has_build_short = 1
    if (index(u, "TEXTDISP_SKIPCONTROLCODES") > 0 || index(u, "TEXTDISP_SKIPCONTROLC") > 0) has_skip_codes = 1
    if (index(u, "STRING_APPENDATNULL") > 0) has_append = 1
    if (index(u, "WDISP_SPRINTF") > 0 || index(u, "WDISP_SPRI") > 0) has_sprintf = 1
    if (index(u, "TLIBA1_JMPTBL_ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "TLIBA1_JMPTBL_ESQ_FINDSUB") > 0 || index(u, "ESQ_FINDSUBSTRINGCASEFOLD") > 0 || index(u, "ESQ_FINDSUBSTRINGCASEF") > 0) has_find_sub = 1
    if (index(u, "STR_FINDCHARPTR") > 0 || index(u, "STR_FINDCHARP") > 0) has_find_char = 1
    if (index(u, "TEXTDISP_FORMATENTRYTIMEFORINDEX") > 0 || index(u, "TEXTDISP_FORMATENTRYTIMEF") > 0) has_format_time = 1
    if (index(u, "TEXTDISP_TRIMTEXTTOPIXELWIDTH") > 0 || index(u, "TEXTDISP_TRIMTEXTTOPIXE") > 0) has_trim = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET=" has_reset
    print "HAS_GET_AUX=" has_get_aux
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_BUILD_SHORT=" has_build_short
    print "HAS_SKIP_CODES=" has_skip_codes
    print "HAS_APPEND=" has_append
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_FIND_SUB=" has_find_sub
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_FORMAT_TIME=" has_format_time
    print "HAS_TRIM=" has_trim
    print "HAS_RETURN=" has_return
}
