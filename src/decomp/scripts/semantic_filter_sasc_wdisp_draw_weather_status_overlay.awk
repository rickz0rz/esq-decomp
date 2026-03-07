BEGIN {
    has_entry=0
    has_fallback_gate=0
    has_brush_lookup=0
    has_overlay_dup=0
    has_split_loop=0
    has_clamp=0
    has_cleanup_dealloc=0
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

    if (u ~ /^WDISP_DRAWWEATHERSTATUSOVERLAY:/ || u ~ /^WDISP_DRAWWEATHERSTATUSOVERLA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /WEATHERSTATUSCOUNTDOWN/ || n ~ /WEATHERSTATUSDIGITCHAR/ || n ~ /FALLBACK/) has_fallback_gate=1
    if (n ~ /FINDBRUSHBYPREDICATE/ || n ~ /FINDBRUSHBYPR/ || n ~ /BRUSHINDEX/ && n ~ /ESQFUNC/) has_brush_lookup=1
    if (n ~ /REPLACEOWNEDSTRING/ || n ~ /REPLACEO/) has_overlay_dup=1
    if (n ~ /24/ && n ~ /CLRB/ || n ~ /ADDQL1/ && n ~ /LINECOUNT/) has_split_loop=1
    if (n ~ /CMPI.*A/ || n ~ /MOVEQ10D0/ || n ~ /CLAMP/) has_clamp=1
    if (n ~ /DEALLOCATEMEMORY/) has_cleanup_dealloc=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FALLBACK_GATE=" has_fallback_gate
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_OVERLAY_DUP=" has_overlay_dup
    print "HAS_SPLIT_LOOP=" has_split_loop
    print "HAS_CLAMP=" has_clamp
    print "HAS_CLEANUP_DEALLOC=" has_cleanup_dealloc
    print "HAS_RTS=" has_rts
}
