BEGIN {
    has_entry=0
    has_get_entry_call=0
    has_get_aux_call=0
    has_get_state_call=0
    has_normalize_48=0
    has_mode0_boolize=0
    has_mode1_match=0
    has_mode23_match=0
    has_const1=0
    has_const2=0
    has_const3=0
    has_const48=0
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

    if (u ~ /^NEWGRID_TESTENTRYSTATE:/ || u ~ /^NEWGRID_TESTENTRYSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRYP/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_get_entry_call=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYAUXPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRYA/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/) has_get_aux_call=1
    if (n ~ /NEWGRIDGETENTRYSTATECODE/) has_get_state_call=1
    if (u ~ /SUBI\.W #\$30,D[0-7]/ || u ~ /SUBI\.W #48,D[0-7]/ || u ~ /CMP\.W .*#\$30/ || u ~ /CMP\.W .*#48/) has_normalize_48=1
    if (u ~ /SEQ D0/ || u ~ /NEG\.B D0/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/ || u ~ /MOVEQ #\$FF,D[0-7]/) has_mode0_boolize=1
    if (u ~ /SUBQ\.L #3,D0/ || u ~ /CMP\.L D1,D0/) has_mode1_match=1
    if (u ~ /CMP\.L .*#3/ || u ~ /CMP\.L -16\(A5\),D1/ || u ~ /SUBQ\.L #3,D0/ || u ~ /SUBQ\.L #\$3,D0/) has_mode23_match=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)/) has_const48=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GET_ENTRY_CALL="has_get_entry_call
    print "HAS_GET_AUX_CALL="has_get_aux_call
    print "HAS_GET_STATE_CALL="has_get_state_call
    print "HAS_NORMALIZE_48="has_normalize_48
    print "HAS_MODE0_BOOLIZE="has_mode0_boolize
    print "HAS_MODE1_MATCH_PATH="has_mode1_match
    print "HAS_MODE23_MATCH_PATH="has_mode23_match
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_48="has_const48
    print "HAS_RTS="has_rts
}
