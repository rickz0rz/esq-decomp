BEGIN {
    has_label = 0
    has_sprintf = 0
    has_setapen = 0
    has_setdrmd = 0
    has_rectfill = 0
    has_textlength = 0
    has_move = 0
    has_text = 0
    has_blit = 0
    has_short_days = 0
    has_short_months = 0
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

    if (uline ~ /^RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY:/) has_label = 1
    if (uline ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVOSETDRMD/) has_setdrmd = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /LVOTEXTLENGTH/) has_textlength = 1
    if (uline ~ /LVOMOVE/) has_move = 1
    if (uline ~ /LVOTEXT([^A-Z]|$)/) has_text = 1
    if (uline ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/) has_blit = 1
    if (uline ~ /GLOBAL_JMPTBL_SHORT_DAYS_OF_WEEK/) has_short_days = 1
    if (uline ~ /GLOBAL_JMPTBL_SHORT_MONTHS/) has_short_months = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_BLIT=" has_blit
    print "HAS_SHORT_DAYS=" has_short_days
    print "HAS_SHORT_MONTHS=" has_short_months
}
