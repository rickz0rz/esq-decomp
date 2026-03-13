BEGIN {
    has_entry=0
    has_primary_count=0
    has_secondary_count=0
    has_primary_present=0
    has_secondary_present=0
    get_entry_calls=0
    get_aux_calls=0
    has_btst4=0
    has_bclr5=0
    has_not_mask=0
    has_and_mask=0
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

    if (u ~ /^NEWGRID_CLEARENTRYMARKERBITS:/ || u ~ /^NEWGRID_CLEARENTRYMARKERBIT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/) has_primary_count=1
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUN/) has_secondary_count=1
    if (n ~ /TEXTDISPPRIMARYGROUPPRESENTFLAG/) has_primary_present=1
    if (n ~ /TEXTDISPSECONDARYGROUPPRESENTFL/) has_secondary_present=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && (n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/ || n ~ /ESQDISPGETENTRYPOINTERBYMODE/ || n ~ /ESQDISPGETENTRYAUXPOINTERBYMODE/)) {
        get_entry_calls++
        get_aux_calls++
    }
    if (u ~ /BTST #\$?4,/) has_btst4=1
    if (u ~ /BCLR #\$?5,/ || u ~ /AND\.B .*#\$DF/) has_bclr5=1
    if (u ~ /NOT\.B D[0-7]/) has_not_mask=1
    if (u ~ /AND\.L D[0-7],D[0-7]/) has_and_mask=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PRIMARY_COUNT_GLOBAL="has_primary_count
    print "HAS_SECONDARY_COUNT_GLOBAL="has_secondary_count
    print "HAS_PRIMARY_PRESENT_GLOBAL="has_primary_present
    print "HAS_SECONDARY_PRESENT_GLOBAL="has_secondary_present
    print "GET_ENTRY_CALLS="(get_entry_calls > 1 ? 1 : 0)
    print "GET_AUX_CALLS="(get_aux_calls > 1 ? 1 : 0)
    print "HAS_BTST_BIT4="has_btst4
    if (has_bclr5 == 0 && has_not_mask == 1 && has_and_mask == 1) has_bclr5=1
    print "HAS_CLEAR_BIT5="has_bclr5
    print "HAS_RTS="has_rts
}
