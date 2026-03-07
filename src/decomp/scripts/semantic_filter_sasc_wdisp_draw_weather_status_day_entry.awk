BEGIN {
    has_entry=0
    has_day_guard=0
    has_mul_stride=0
    has_brush_lookup=0
    has_restore_palette=0
    has_high_temp_format=0
    has_low_temp_format=0
    has_append=0
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
    if (n ~ /MATHMULU32/ || n ~ /20/) has_mul_stride=1
    if (n ~ /FINDBRUSHBYPREDICATE/ || n ~ /FINDBRUSHBYP/) has_brush_lookup=1
    if (n ~ /RESTOREBASEPALETTETRIPLES/ || n ~ /RESTOREBASEP/) has_restore_palette=1
    if (n ~ /PERCENTDSLASH/ || n ~ /UNKNOWNNUMWITHSLASH/ || n ~ /SPRINTF/) has_high_temp_format=1
    if (n ~ /PERCENTD/ || n ~ /UNKNOWNNUM/ || n ~ /SPRINTF/) has_low_temp_format=1
    if (n ~ /APPENDATNULL/) has_append=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DAY_GUARD=" has_day_guard
    print "HAS_MUL_STRIDE=" has_mul_stride
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_HIGH_TEMP_FORMAT=" has_high_temp_format
    print "HAS_LOW_TEMP_FORMAT=" has_low_temp_format
    print "HAS_APPEND=" has_append
    print "HAS_RTS=" has_rts
}
