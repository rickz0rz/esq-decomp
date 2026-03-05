BEGIN {
    has_entry=0
    has_setpen=0
    has_rectfill=0
    has_column_start_x=0
    has_const35=0
    has_const36=0
    has_const695=0
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

    if (u ~ /^NEWGRID_FILLGRIDRECTS:/ || u ~ /^NEWGRID_FILLGRIDRECT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOSETAPEN/) has_setpen=1
    if (n ~ /LVORECTFILL/) has_rectfill=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/) has_column_start_x=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /\(\$23\)/ || u ~ /35\.[Ww]/) has_const35=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /\(\$24\)/ || u ~ /36\.[Ww]/) has_const36=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /\$2B7/) has_const695=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETAPEN_CALL="has_setpen
    print "HAS_RECTFILL_CALL="has_rectfill
    print "HAS_COLUMN_START_X="has_column_start_x
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_695="has_const695
    print "HAS_RETURN="has_return
}
