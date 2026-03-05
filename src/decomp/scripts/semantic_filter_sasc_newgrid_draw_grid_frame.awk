BEGIN {
    has_entry=0
    has_setrowcolor=0
    has_fillgridrects=0
    has_const_neg1=0
    has_offset60=0
    has_const0=0
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

    if (u ~ /^NEWGRID_DRAWGRIDFRAME:/ || u ~ /^NEWGRID_DRAWGRIDFRAM[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSETROWCOLOR/) has_setrowcolor=1
    if (n ~ /NEWGRIDFILLGRIDRECTS/) has_fillgridrects=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FFFFFFFF/) has_const_neg1=1
    if (u ~ /60\([A-Z][0-7]\)/ || u ~ /\(60,/ || u ~ /#\$3C/ || u ~ /\$3C\([A-Z][0-7]\)/) has_offset60=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETROWCOLOR_CALL="has_setrowcolor
    print "HAS_FILLGRIDRECTS_CALL="has_fillgridrects
    print "HAS_CONST_NEG1="has_const_neg1
    print "HAS_OFFSET_60="has_offset60
    print "HAS_CONST_0="has_const0
    print "HAS_RETURN="has_return
}
