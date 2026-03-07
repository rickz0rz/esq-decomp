BEGIN {
    has_entry=0
    has_row0=0
    has_row1=0
    has_row2=0
    has_row3=0
    has_btst1=0
    has_clear_sat=0
    has_move_end=0
    has_move_start=0
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

    if (u ~ /^ESQIFF_SERVICEPENDINGCOPPERPALETTEMOVES:/ || u ~ /^ESQIFF_SERVICEPENDINGCOPPERPALETTEMOVE[A-Z0-9_]*:/ || u ~ /^ESQIFF_SERVICEPENDINGCOPPERPALET[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ACCUMULATORROW0SATURATEFLAG/) has_row0=1
    if (n ~ /ACCUMULATORROW1SATURATEFLAG/) has_row1=1
    if (n ~ /ACCUMULATORROW2SATURATEFLAG/) has_row2=1
    if (n ~ /ACCUMULATORROW3SATURATEFLAG/) has_row3=1
    if (u ~ /BTST #1/ || u ~ /BTST #\\$1/ || n ~ /ANDIW2/ || n ~ /ANDL2/) has_btst1=1
    if (n ~ /CLRWACCUMULATORROW0SATURATEFLAG/ || n ~ /CLRWACCUMULATORROW1SATURATEFLAG/ || n ~ /CLRWACCUMULATORROW2SATURATEFLAG/ || n ~ /CLRWACCUMULATORROW3SATURATEFLAG/ || n ~ /CLRWA5/) has_clear_sat=1
    if (n ~ /ESQIFFJMPTBLESQMOVECOPPERENTRYTOWARDEND/ || n ~ /ESQIFFJMPTBLESQMOVECOPPERENTR/) has_move_end=1
    if (n ~ /ESQIFFJMPTBLESQMOVECOPPERENTRYTOWARDSTART/ || n ~ /ESQIFFJMPTBLESQMOVECOPPERENTR/) has_move_start=1
    if (n ~ /BSRWSERVICEROW/) { has_btst1=1; has_clear_sat=1 }
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ROW0="has_row0
    print "HAS_ROW1="has_row1
    print "HAS_ROW2="has_row2
    print "HAS_ROW3="has_row3
    print "HAS_DIRECTION_BIT_TEST="has_btst1
    print "HAS_CLEAR_SATURATE="has_clear_sat
    print "HAS_MOVE_TOWARD_END="has_move_end
    print "HAS_MOVE_TOWARD_START="has_move_start
    print "HAS_RTS="has_rts
}
