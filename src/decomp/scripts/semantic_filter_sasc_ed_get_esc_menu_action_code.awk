BEGIN {
    has_ring = 0
    has_last_input = 0
    has_sub3 = 0
    has_sub10 = 0
    has_sub14 = 0
    has_sub80 = 0
    has_sel_guard = 0
    has_alpha_cmp = 0
    has_ret0 = 0
    has_ret8 = 0
    has_ret9 = 0
    has_ret10 = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /ED_STATERINGINDEX/ || l ~ /ED_STATERINGTABLE/) has_ring = 1
    if (l ~ /ED_LASTMENUINPUTCHAR/) has_last_input = 1
    if (l ~ /SUBI\.[WL] #\$?3,D[07]/ || l ~ /SUBQ\.[WL] #\$?3,D[07]/) has_sub3 = 1
    if (l ~ /SUBI\.[WL] #\$?(A|10),D[07]/ || l ~ /MOVEQ(\.L)? #\$?A,D[0-7]/) has_sub10 = 1
    if (l ~ /SUBI\.[WL] #\$?(E|14),D[07]/ || l ~ /MOVEQ(\.L)? #\$?E,D[0-7]/) has_sub14 = 1
    if (l ~ /SUBI\.[WL] #\$?80,D[07]/ || l ~ /MOVEQ(\.L)? #\$?40,D[0-7]/ || l ~ /^ADD\.L D0,D0$/) has_sub80 = 1
    if (l ~ /CMPI\.L #\$?6,ED_EDITCURSOROFFSET/ || l ~ /CMP\.L .*ED_EDITCURSOROFFSET/ || l ~ /BCC/) has_sel_guard = 1
    if (l ~ /CMP\.B .*ED_LASTMENUINPUTCHAR/ || l ~ /CMPI\.B #\$?41,D0/ || l ~ /CMP\.B #\$?41,D0/ || l ~ /MOVEQ(\.L)? #\$?41,D1/ || l ~ /^CMP\.B D1,D0$/) has_alpha_cmp = 1

    if (l ~ /^MOVEQ #0,D0$/ || l ~ /^MOVEQ\.L #\$?0,D0$/) has_ret0 = 1
    if (l ~ /^MOVEQ #8,D0$/ || l ~ /^MOVEQ\.L #\$?8,D0$/) has_ret8 = 1
    if (l ~ /^MOVEQ #9,D0$/ || l ~ /^MOVEQ\.L #\$?9,D0$/) has_ret9 = 1
    if (l ~ /^MOVEQ #10,D0$/ || l ~ /^MOVEQ\.L #\$?A,D0$/ || l ~ /^MOVEQ\.L #\$?10,D0$/) has_ret10 = 1

    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_RING=" has_ring
    print "HAS_LAST_INPUT=" has_last_input
    print "HAS_SUB3=" has_sub3
    print "HAS_SUB10=" has_sub10
    print "HAS_SUB14=" has_sub14
    print "HAS_SUB80=" has_sub80
    print "HAS_SEL_GUARD=" has_sel_guard
    print "HAS_ALPHA_CMP=" has_alpha_cmp
    print "HAS_RET0=" has_ret0
    print "HAS_RET8=" has_ret8
    print "HAS_RET9=" has_ret9
    print "HAS_RET10=" has_ret10
    print "HAS_RTS=" has_rts
}
