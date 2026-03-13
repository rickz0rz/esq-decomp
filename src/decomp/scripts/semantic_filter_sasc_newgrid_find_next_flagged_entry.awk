BEGIN {
    has_entry=0
    has_getptr=0
    has_present=0
    has_count=0
    has_btst0=0
    has_btst7=0
    has_const1=0
    has_const3=0
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

    if (u ~ /^NEWGRID_FINDNEXTFLAGGEDENTRY:/ || u ~ /^NEWGRID_FINDNEXTFLAGGEDENTR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ ||
        n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYM/ ||
        n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/ ||
        n ~ /ESQDISPGETENTRYPOINTERBYMODE/ ||
        n ~ /ESQDISPGETENTRYPOINTERBYM/) has_getptr=1
    if (n ~ /TEXTDISPPRIMARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPPRIMARYGROUPPRESENTF/) has_present=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCO/) has_count=1
    if (n ~ /BTST0/) has_btst0=1
    if (n ~ /BTST7/) has_btst7=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/ || u ~ /SUBQ\.L #\$1,D0/ || u ~ /SUBQ\.L #1,D0/) has_const4=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/ || n ~ /MOVEQL1D6/ || n ~ /MOVEQLFFD5/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GETPTR_CALL="has_getptr
    print "HAS_PRESENT_GLOBAL="has_present
    print "HAS_COUNT_GLOBAL="has_count
    print "HAS_BTST0="has_btst0
    print "HAS_BTST7="has_btst7
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
