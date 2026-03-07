BEGIN {
    has_entry=0
    has_brush_lookup=0
    has_replace_owned=0
    has_text_scan=0
    has_delim_split=0
    has_segment_clamp=0
    has_dealloc=0
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

    if (u ~ /^ESQIFF_DRAWWEATHERSTATUSOVERLAYINTOBRUSH:/ || u ~ /^ESQIFF_DRAWWEATHERSTATUSOVERLAYINTOBRUS[A-Z0-9_]*:/ || u ~ /^ESQIFF_DRAWWEATHERSTATUSOVERLAYI[A-Z0-9_]*:/) has_entry=1
    if (n ~ /FINDBRUSHBYPREDICATE/ || n ~ /FINDBRUSHBYP/) has_brush_lookup=1
    if (n ~ /REPLACEOWNEDSTRING/) has_replace_owned=1
    if (n ~ /TSTBA0/ || n ~ /TSTB0A2D7L/ || n ~ /SCANTEXTEND/ || n ~ /ADDQL1D1/ || n ~ /ADDQL1D7/ || n ~ /LEN/) has_text_scan=1
    if (n ~ /MOVEQ(L)?18D1/ || n ~ /CMPBD1D0/ || n ~ /18/ && n ~ /CLRB/ || n ~ /SEGMENTCOUNT/) has_delim_split=1
    if (n ~ /CMPL10/ || n ~ /SEGMENTCLAMP/) has_segment_clamp=1
    if (n ~ /DEALLOCATEMEMORY/ || n ~ /DEALLOCATEM/) has_dealloc=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_TEXT_SCAN=" has_text_scan
    print "HAS_DELIM_SPLIT=" has_delim_split
    print "HAS_SEGMENT_CLAMP=" has_segment_clamp
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_RTS=" has_rts
}
