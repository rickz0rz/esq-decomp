BEGIN {
    has_entry=0
    has_getptr=0
    has_present=0
    has_count=0
    has_btst2=0
    has_btst7=0
    has_const1=0
    has_const4=0
    has_constm1=0
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

    if (u ~ /^NEWGRID_FINDNEXTENTRYWITHFLAGS:/ || u ~ /^NEWGRID_FINDNEXTENTRYWITHFLAG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_getptr=1
    if (n ~ /TEXTDISPPRIMARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPPRIMARYGROUPPRESENTF/) has_present=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCO/) has_count=1
    if (n ~ /BTST22FA0/ || n ~ /BTST22FA5/ || n ~ /BTST247/) has_btst2=1
    if (n ~ /BTST728A0/ || n ~ /BTST728A5/ || n ~ /BTST740/) has_btst7=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/ || n ~ /MOVEQLFFD6/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GETPTR_CALL="has_getptr
    print "HAS_PRESENT_GLOBAL="has_present
    print "HAS_COUNT_GLOBAL="has_count
    print "HAS_BTST2="has_btst2
    print "HAS_BTST7="has_btst7
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
