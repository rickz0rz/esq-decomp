BEGIN {
    has_entry=0
    has_skipclass3=0
    has_btst_5=0
    has_offset19=0
    has_offset1=0
    has_offset27=0
    has_const0=0
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

    if (u ~ /^NEWGRID_SHOULDOPENEDITOR:/ || u ~ /^NEWGRID_SHOULDOPENEDITO[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHA/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CH/) has_skipclass3=1
    if (u ~ /BTST[[:space:]]+#5/ || u ~ /BTST.*#\$05/ || u ~ /BTST.*#\$5([^0-9A-F]|$)/ || u ~ /LSR\.[LW][[:space:]]+#5/) has_btst_5=1
    if (u ~ /\(19,/ || u ~ /19\([A-Z][0-7]\)/ || u ~ /\+19/ || u ~ /\$13\([A-Z][0-7]\)/) has_offset19=1
    if (u ~ /\(1,/ || u ~ /1\([A-Z][0-7]\)/ || u ~ /\+1/) has_offset1=1
    if (u ~ /27\([A-Z][0-7]\)/ || u ~ /\+27/ || u ~ /\(27,/ || u ~ /\$1B\([A-Z][0-7]\)/) has_offset27=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/) has_const1=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SKIPCLASS3_CALL="has_skipclass3
    print "HAS_BTST_5="has_btst_5
    print "HAS_OFFSET_19="has_offset19
    print "HAS_OFFSET_1="has_offset1
    print "HAS_OFFSET_27="has_offset27
    print "HAS_CONST_0="has_const0
    print "HAS_CONST_1="has_const1
    print "HAS_RETURN="has_return
}
