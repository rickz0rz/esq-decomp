BEGIN {
    has_entry=0
    has_day_guard=0
    has_panel_div=0
    has_panel_stride=0
    has_brush_lookup=0
    has_mode_branch=0
    has_temp_append=0
    has_weekday_lookup=0
    has_restore_palette=0
    has_high_temp_format=0
    has_low_temp_format=0
    has_wrapped_draw=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^WDISP_DRAWWEATHERSTATUSDAYENTRY:/ || u ~ /^WDISP_DRAWWEATHERSTATUSDAYENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /CMPL4D7/ || n ~ /BMI/ || n ~ /BGE/ || n ~ /DAYINDEX/) has_day_guard=1
    if (n ~ /MATHDIVS32/ || n ~ /PEA3W/ || n ~ /MOVEQ3D1/) has_panel_div=1
    if (n ~ /MATHMULU32/ || n ~ /CXD33/ || n ~ /WDISPSTATUSDAYENTRY0/) has_panel_stride=1
    if (n ~ /FINDBRUSHBYPREDICATE/ || n ~ /FINDBRUSHBYP/) has_brush_lookup=1
    if (n ~ /TSTL16A0/ || n ~ /MODE/ || n ~ /WEATHERFORECASTMSGPTR/) has_mode_branch=1
    if (n ~ /APPENDATNULL/) has_temp_append=1
    if (n ~ /GLOBALJMPTBLDAYSOFWEEK/ || n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) has_weekday_lookup=1
    if (n ~ /RESTOREBASEPALETTETRIPLES/ || n ~ /RESTOREBASEP/) has_restore_palette=1
    if (n ~ /PERCENTDSLASH/ || n ~ /UNKNOWNNUMWITHSLASH/ || n ~ /SPRINTF/) has_high_temp_format=1
    if (n ~ /PERCENTD/ || n ~ /UNKNOWNNUM/ || n ~ /SPRINTF/) has_low_temp_format=1
    if (n ~ /DRAWWRAPPEDTEXT/ || n ~ /WRAPPED/) has_wrapped_draw=1
    if (u == "RTS") has_rts=1

    prev2=prev
    prev=u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DAY_GUARD=" has_day_guard
    print "HAS_PANEL_DIV=" has_panel_div
    print "HAS_PANEL_STRIDE=" has_panel_stride
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_MODE_BRANCH=" has_mode_branch
    print "HAS_TEMP_APPEND=" has_temp_append
    print "HAS_WEEKDAY_LOOKUP=" has_weekday_lookup
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_HIGH_TEMP_FORMAT=" has_high_temp_format
    print "HAS_LOW_TEMP_FORMAT=" has_low_temp_format
    print "HAS_WRAPPED_DRAW=" has_wrapped_draw
    print "HAS_RTS=" has_rts
}
