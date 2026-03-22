BEGIN {
    has_entry=0
    has_row0_sat=0
    has_row1_sat=0
    has_row2_sat=0
    has_row3_sat=0
    has_row0_moveflags=0
    has_row1_moveflags=0
    has_row2_moveflags=0
    has_row3_moveflags=0
    has_row0_clear_sat=0
    has_row1_clear_sat=0
    has_row2_clear_sat=0
    has_row3_clear_sat=0
    has_row0_index_start=0
    has_row0_index_end=0
    has_row1_index_start=0
    has_row1_index_end=0
    has_row2_index_start=0
    has_row2_index_end=0
    has_row3_index_start=0
    has_row3_index_end=0
    direction_test_count=0
    move_end_count=0
    move_start_count=0
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
    if (n ~ /ACCUMULATORROW0SATURATEFLAG/) has_row0_sat=1
    if (n ~ /ACCUMULATORROW1SATURATEFLAG/) has_row1_sat=1
    if (n ~ /ACCUMULATORROW2SATURATEFLAG/) has_row2_sat=1
    if (n ~ /ACCUMULATORROW3SATURATEFLAG/) has_row3_sat=1
    if (n ~ /WDISPACCUMULATORROW0MOVEFLAGS/) has_row0_moveflags=1
    if (n ~ /WDISPACCUMULATORROW1MOVEFLAGS/) has_row1_moveflags=1
    if (n ~ /WDISPACCUMULATORROW2MOVEFLAGS/) has_row2_moveflags=1
    if (n ~ /WDISPACCUMULATORROW3MOVEFLAGS/) has_row3_moveflags=1
    if (n ~ /CLRWACCUMULATORROW0SATURATEFLAG/) has_row0_clear_sat=1
    if (n ~ /CLRWACCUMULATORROW1SATURATEFLAG/) has_row1_clear_sat=1
    if (n ~ /CLRWACCUMULATORROW2SATURATEFLAG/) has_row2_clear_sat=1
    if (n ~ /CLRWACCUMULATORROW3SATURATEFLAG/) has_row3_clear_sat=1
    if (n ~ /WDISPACCUMULATORROW0COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE6/) has_row0_index_start=1
    if (n ~ /WDISPACCUMULATORROW0COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE7/) has_row0_index_end=1
    if (n ~ /WDISPACCUMULATORROW1COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLEE/) has_row1_index_start=1
    if (n ~ /WDISPACCUMULATORROW1COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLEF/) has_row1_index_end=1
    if (n ~ /WDISPACCUMULATORROW2COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE16/) has_row2_index_start=1
    if (n ~ /WDISPACCUMULATORROW2COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE17/) has_row2_index_end=1
    if (n ~ /WDISPACCUMULATORROW3COPPERINDEXSTART/ || n ~ /WDISPACCUMULATORROWTABLE1E/) has_row3_index_start=1
    if (n ~ /WDISPACCUMULATORROW3COPPERINDEXEND/ || n ~ /WDISPACCUMULATORROWTABLE1F/) has_row3_index_end=1
    if (u ~ /BTST #1/ || u ~ /BTST #\$1/ || n ~ /ANDIW2/ || n ~ /ANDL2/) direction_test_count++
    if (n ~ /ESQIFFJMPTBLESQMOVECOPPERENTRYTOWARDEND/ || n ~ /ESQMOVECOPPERENTRYTOWARDEND/ || n ~ /ESQIFFJMPTBLESQMOVECOPPERENTR/) move_end_count++
    if (n ~ /ESQIFFJMPTBLESQMOVECOPPERENTRYTOWARDSTART/ || n ~ /ESQMOVECOPPERENTRYTOWARDSTART/ || n ~ /ESQIFFJMPTBLESQMOVECOPPERENTR/) move_start_count++
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ROW0_SATURATE="has_row0_sat
    print "HAS_ROW1_SATURATE="has_row1_sat
    print "HAS_ROW2_SATURATE="has_row2_sat
    print "HAS_ROW3_SATURATE="has_row3_sat
    print "HAS_ROW0_MOVEFLAGS="has_row0_moveflags
    print "HAS_ROW1_MOVEFLAGS="has_row1_moveflags
    print "HAS_ROW2_MOVEFLAGS="has_row2_moveflags
    print "HAS_ROW3_MOVEFLAGS="has_row3_moveflags
    print "HAS_ROW0_CLEAR_SATURATE="has_row0_clear_sat
    print "HAS_ROW1_CLEAR_SATURATE="has_row1_clear_sat
    print "HAS_ROW2_CLEAR_SATURATE="has_row2_clear_sat
    print "HAS_ROW3_CLEAR_SATURATE="has_row3_clear_sat
    print "HAS_ROW0_INDEX_START="has_row0_index_start
    print "HAS_ROW0_INDEX_END="has_row0_index_end
    print "HAS_ROW1_INDEX_START="has_row1_index_start
    print "HAS_ROW1_INDEX_END="has_row1_index_end
    print "HAS_ROW2_INDEX_START="has_row2_index_start
    print "HAS_ROW2_INDEX_END="has_row2_index_end
    print "HAS_ROW3_INDEX_START="has_row3_index_start
    print "HAS_ROW3_INDEX_END="has_row3_index_end
    print "HAS_DIRECTION_TESTS_FOR_ALL_ROWS="(direction_test_count >= 4)
    print "HAS_MOVE_TOWARD_END_FOR_ALL_ROWS="(move_end_count >= 4)
    print "HAS_MOVE_TOWARD_START_FOR_ALL_ROWS="(move_start_count >= 4)
    print "HAS_RTS="has_rts
}
