BEGIN {
    has_entry=0
    has_testbit=0
    has_btst7=0
    has_aux56=0
    has_const49=0
    has_const1=0
    has_const2=0
    has_const3=0
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

    if (u ~ /^NEWGRID_GETENTRYSTATECODE:/ || u ~ /^NEWGRID_GETENTRYSTATECOD[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQTESTBIT1BASED/ || n ~ /NEWGRID2JMPTBLESQTESTBIT1B/ ||
        n ~ /ESQTESTBIT1BASED/ || n ~ /ESQTESTBIT1BASE/) has_testbit=1
    if (n ~ /BTST7/) has_btst7=1
    if (n ~ /56\(A2/ || n ~ /56A2/ || u ~ /\$38\(A0\)/ || u ~ /\$38\(A0,[A-Z0-9.]+\)/ || u ~ /LEA \$38\(A0\),A1/) has_aux56=1
    if (u ~ /#49([^0-9]|$)/ || u ~ /#\$31/ || u ~ /49\.[Ww]/ || u ~ /\(\$31\)/) has_const49=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_TESTBIT_CALL="has_testbit
    print "HAS_BTST7="has_btst7
    print "HAS_AUX56_ACCESS="has_aux56
    print "HAS_CONST_49="has_const49
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_3="has_const3
    print "HAS_RTS="has_rts
}
