BEGIN {
    has_entry=0
    has_update_preset=0
    has_testbit=0
    has_present=0
    has_count=0
    has_btst3=0
    has_btst7=0
    has_aux56=0
    has_const4=0
    has_const6=0
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

    if (u ~ /^NEWGRID_FINDNEXTENTRYWITHALTMARKERS:/ || u ~ /^NEWGRID_FINDNEXTENTRYWITHALTMA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDUPDATEPRESETENTRY/ || n ~ /NEWGRIDUPDATEPRESETENTR/) has_update_preset=1
    if (n ~ /NEWGRID2JMPTBLESQTESTBIT1BASED/ || n ~ /NEWGRID2JMPTBLESQTESTBIT1B/) has_testbit=1
    if (n ~ /TEXTDISPPRIMARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPPRIMARYGROUPPRESENTF/) has_present=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCO/) has_count=1
    if (n ~ /BTST3/ ) has_btst3=1
    if (n ~ /BTST7/ ) has_btst7=1
    if (n ~ /56A0/ || n ~ /56\(A0/ || n ~ /LEA38A0/ || n ~ /SELECTORTEXTPTRBASE/) has_aux56=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_UPDATE_PRESET_CALL="has_update_preset
    print "HAS_TESTBIT_CALL="has_testbit
    print "HAS_PRESENT_GLOBAL="has_present
    print "HAS_COUNT_GLOBAL="has_count
    print "HAS_BTST3="has_btst3
    print "HAS_BTST7="has_btst7
    print "HAS_AUX56_ACCESS="has_aux56
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_6="has_const6
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
