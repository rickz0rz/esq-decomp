BEGIN {
    has_entry=0
    has_setpen=0
    has_rectfill=0
    has_const7=0
    has_const695=0
    has_const1=0
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

    if (u ~ /^NEWGRID_DRAWTOPBORDERLINE:/ || u ~ /^NEWGRID_DRAWTOPBORDERLIN[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOSETAPEN/) has_setpen=1
    if (n ~ /LVORECTFILL/) has_rectfill=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7([^0-9A-F]|$)/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /\$2B7/) has_const695=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /\(\$1\)/) has_const1=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETAPEN="has_setpen
    print "HAS_RECTFILL="has_rectfill
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_1="has_const1
    print "HAS_RETURN="has_return
}
