BEGIN {
    has_entry=0
    has_move=0
    draw_calls=0
    has_dims_read=0
    has_shift3=0
    has_sub1=0
    has_graphics_base=0
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

    if (u ~ /^TLIBA3_DRAWOUTERFRAMEBORDER:/ || u ~ /^TLIBA3_DRAWOUTERFRAMEBORDE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVODRAW/) draw_calls++
    if (u ~ /4\(A3\)/ || u ~ /2\(A0\)/ || u ~ /\(A0\)/) has_dims_read=1
    if (u ~ /ASL\.L #3/ || u ~ /LSL\.L #3/ || u ~ /ASL\.L #\$3/ || u ~ /LSL\.L #\$3/) has_shift3=1
    if (u ~ /SUBQ\.L #1/ || u ~ /SUBQ\.W #1/ || u ~ /SUBQ\.L #\$1/ || u ~ /SUBQ\.W #\$1/) has_sub1=1
    if (n ~ /GLOBALREFGRAPHICSLIBRARY/) has_graphics_base=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MOVE_CALL="has_move
    print "HAS_DRAW_CALLS_GE_4="(draw_calls >= 4 ? 1 : 0)
    print "HAS_DIMS_READ="has_dims_read
    print "HAS_SHIFT3="has_shift3
    print "HAS_SUB1="has_sub1
    print "HAS_GRAPHICS_BASE="has_graphics_base
    print "HAS_RTS="has_rts
}
