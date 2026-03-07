BEGIN {
    has_entry=0
    has_ptr48=0
    has_char_n=0
    has_char_p=0
    has_const18=0
    has_const22=0
    has_const0=0
    has_const1=0
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

    if (u ~ /^NEWGRID_TESTPRIMETIMEWINDOW:/ || u ~ /^NEWGRID_TESTPRIMETIMEWINDO[A-Z0-9_]*:/) has_entry=1
    if (u ~ /48\(A3\)/ || u ~ /\$30\(A3\)/ || u ~ /\$30\(A5\)/ || n ~ /48A3/ || n ~ /30A3/ || n ~ /30A5/) has_ptr48=1
    if (u ~ /#'N'/ || u ~ /#\$4E/ || u ~ /#\$6E/ || u ~ /SUBI\.W #\('N'-'P'\),D0/ || u ~ /SUBI\.W #\('N'-'P'\),D[0-7]/) has_char_n=1
    if (u ~ /#'P'/ || u ~ /#\$50/ || u ~ /#\$70/ || u ~ /SUBQ\.W #\('P'-'N'\),D0/ || u ~ /SUBQ\.W #\('P'-'N'\),D[0-7]/ || u ~ /SUBQ\.W #\('p'-'n'\),D0/ || u ~ /SUBQ\.W #\('p'-'n'\),D[0-7]/) has_char_p=1
    if (u ~ /#18([^0-9]|$)/ || u ~ /#\$12/ || u ~ /18\.[Ww]/) has_const18=1
    if (u ~ /#22([^0-9]|$)/ || u ~ /#\$16/ || u ~ /22\.[Ww]/) has_const22=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || u ~ /0\.[Ww]/ || u ~ /\(\$0\)/ || u ~ /CLR\./) has_const0=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PTR48_ACCESS="has_ptr48
    print "HAS_CHAR_N_BRANCH="has_char_n
    print "HAS_CHAR_P_BRANCH="has_char_p
    print "HAS_CONST_18="has_const18
    print "HAS_CONST_22="has_const22
    print "HAS_CONST_0="has_const0
    print "HAS_CONST_1="has_const1
    print "HAS_RTS="has_rts
}
