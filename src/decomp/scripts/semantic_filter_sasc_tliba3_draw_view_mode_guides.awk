BEGIN {
    has_entry=0
    has_setfont=0
    has_setapen=0
    has_setdrmd=0
    has_topaz=0
    has_prevuec=0
    has_width_shift=0
    has_height_half=0
    has_vertical=0
    has_horizontal=0
    has_outer=0
    has_inner=0
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

    if (u ~ /^TLIBA3_DRAWVIEWMODEGUIDES:/ || u ~ /^TLIBA3_DRAWVIEWMODEGUIDE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOSETFONT/) has_setfont=1
    if (n ~ /LVOSETAPEN/) has_setapen=1
    if (n ~ /LVOSETDRMD/) has_setdrmd=1
    if (n ~ /GLOBALHANDLETOPAZFONT/) has_topaz=1
    if (n ~ /GLOBALHANDLEPREVUECFONT/) has_prevuec=1
    if (u ~ /ASL\.L #3/ || u ~ /LSL\.L #3/ || u ~ /ASL\.L #\$3/ || u ~ /LSL\.L #\$3/) has_width_shift=1
    if (u ~ /ASR\.L #1/ || u ~ /ASR\.L #\$1/ || u ~ />>= 1/) has_height_half=1
    if (n ~ /TLIBA3DRAWVERTICALSCALETICKS/) has_vertical=1
    if (n ~ /TLIBA3DRAWHORIZONTALSCALETICKS/) has_horizontal=1
    if (n ~ /TLIBA3DRAWOUTERFRAMEBORDER/) has_outer=1
    if (n ~ /TLIBA3DRAWINNERFRAMEBORDER/) has_inner=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETFONT="has_setfont
    print "HAS_SETAPEN="has_setapen
    print "HAS_SETDRMD="has_setdrmd
    print "HAS_TOPAZ_FONT="has_topaz
    print "HAS_PREVUEC_FONT="has_prevuec
    print "HAS_WIDTH_SHIFT="has_width_shift
    print "HAS_HEIGHT_HALF="has_height_half
    print "HAS_VERTICAL_CALL="has_vertical
    print "HAS_HORIZONTAL_CALL="has_horizontal
    print "HAS_OUTER_CALL="has_outer
    print "HAS_INNER_CALL="has_inner
    print "HAS_RTS="has_rts
}
