BEGIN {
    has_entry=0
    has_const16=0
    has_const7=0
    has_const6=0
    has_const5=0
    has_const4=0
    has_constm1=0
    has_store55=0
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

    if (u ~ /^NEWGRID_SETROWCOLOR:/) has_entry=1
    if (u ~ /#16([^0-9]|$)/ || u ~ /#\$10/ || u ~ /16\.[Ww]/ || u ~ /\(\$10\)/) has_const16=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7([^0-9A-F]|$)/ || u ~ /7\.[Ww]/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/ || u ~ /ADDQ\.W #1,D0/) has_constm1=1
    if (u ~ /55\(A3/ || u ~ /55\(A5/ || u ~ /\$37\(A5/ || u ~ /\$37\(A3/) has_store55=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_CONST_16="has_const16
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_STORE_55_OFFSET="has_store55
    print "HAS_RTS="has_rts
}
