BEGIN {
    has_entry = 0
    has_select_slot = 0
    has_build_ctx = 0
    has_divs = 0
    has_begin_banner = 0
    has_plane_mask = 0
    has_run_rise = 0
    has_run_drop = 0
    has_set_apen = 0
    has_set_rast = 0
    has_copy_mem = 0
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

    if (uline ~ /^ESQIFF_SHOWEXTERNALASSETWITHCOPPERFX:/ ||
        uline ~ /^ESQIFF_SHOWEXTERNALASSETWITHC[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHS/ ||
        uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/) has_select_slot = 1
    if (uline ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLA/ ||
        uline ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/) has_build_ctx = 1
    if (uline ~ /ESQIFF_JMPTBL_MATH_DIVS32/) has_divs = 1
    if (uline ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNER/ ||
        uline ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNERCHARTRANSITION/) has_begin_banner = 1
    if (uline ~ /ESQPARS_JMPTBL_BRUSH_PLANEMASKFO/ ||
        uline ~ /ESQPARS_JMPTBL_BRUSH_PLANEMASKFORINDEX/) has_plane_mask = 1
    if (uline ~ /ESQIFF_RUNCOPPERRISETRANSITION/) has_run_rise = 1
    if (uline ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) has_run_drop = 1
    if (uline ~ /_LVOSETAPEN/) has_set_apen = 1
    if (uline ~ /_LVOSETRAST/) has_set_rast = 1
    if (uline ~ /_LVOCOPYMEM/) has_copy_mem = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SELECT_SLOT=" has_select_slot
    print "HAS_BUILD_CTX=" has_build_ctx
    print "HAS_DIVS=" has_divs
    print "HAS_BEGIN_BANNER=" has_begin_banner
    print "HAS_PLANE_MASK=" has_plane_mask
    print "HAS_RUN_RISE=" has_run_rise
    print "HAS_RUN_DROP=" has_run_drop
    print "HAS_SET_APEN=" has_set_apen
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_COPY_MEM=" has_copy_mem
}
