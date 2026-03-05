BEGIN {
    has_entry=0
    has_disable=0
    has_enable=0
    has_reset=0
    has_setpen=0
    has_rectfill=0
    has_const7=0
    has_const68=0
    has_const695=0
    has_const267=0
    has_return=0
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

    if (u ~ /^NEWGRID_CLEARHIGHLIGHTAREA:/ || u ~ /^NEWGRID_CLEARHIGHLIGHTARE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVODISABLE/) has_disable=1
    if (n ~ /LVOENABLE/) has_enable=1
    if (n ~ /GCOMMANDRESETHIGHLIGHTMESSAGES/ || n ~ /GCOMMANDRESETHIGHLIGHTMESSA/) has_reset=1
    if (n ~ /LVOSETAPEN/) has_setpen=1
    if (n ~ /LVORECTFILL/) has_rectfill=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7([^0-9A-F]|$)/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#68([^0-9]|$)/ || u ~ /#\$44/ || u ~ /\(\$44\)/) has_const68=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /\$2B7/) has_const695=1
    if (u ~ /#267/ || u ~ /#\$10B/ || u ~ /\$10B/) has_const267=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DISABLE_CALL="has_disable
    print "HAS_ENABLE_CALL="has_enable
    print "HAS_RESET_HILITE_CALL="has_reset
    print "HAS_SETAPEN_CALL="has_setpen
    print "HAS_RECTFILL_CALL="has_rectfill
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_68="has_const68
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_267="has_const267
    print "HAS_RETURN="has_return
}
