BEGIN {
    has_entry=0
    has_loop_bound_4=0
    has_store_row_color_slot=0
    has_store_slot_base_36=0
    has_zero_store=0
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

    if (u ~ /^NEWGRID_RESETROWTABLE:/ || u ~ /^NEWGRID_RESETROWTAB[A-Z0-9_]*:/) has_entry=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /\(\$4\)/) has_loop_bound_4=1
    if (u ~ /55\(A3/ || u ~ /55\(A5/ || u ~ /\$37\(A5/ || u ~ /\$37\(A3/) has_store_row_color_slot=1
    if (u ~ /36\(A3/ || u ~ /36\(A5/ || u ~ /\$24\(A0/ || u ~ /LEA \$24\(A0\),A1/) has_store_slot_base_36=1
    if (u ~ /^CLR\.L / || u ~ /MOVEQ\.L #\$0/ || u ~ /MOVEQ #0/) has_zero_store=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LOOP_BOUND_4="has_loop_bound_4
    print "HAS_STORE_ROW_COLOR_SLOT="has_store_row_color_slot
    print "HAS_STORE_SLOT_BASE_36="has_store_slot_base_36
    print "HAS_ZERO_STORE="has_zero_store
    print "HAS_RTS="has_rts
}
