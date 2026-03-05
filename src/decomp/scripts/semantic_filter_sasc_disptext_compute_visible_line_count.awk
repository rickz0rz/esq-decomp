BEGIN {
    has_entry = 0
    has_finalize = 0
    has_target = 0
    has_rowheight = 0
    has_mulu_call = 0
    has_asr2 = 0
    has_linecount_eq1 = 0
    has_markers_flag = 0
    has_textbuffer = 0
    has_find19 = 0
    has_find20 = 0
    has_plus2 = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /DISPTEXT_FINALIZELINETABLE/ || l ~ /DISPTEXT_FINALIZELINETAB/) has_finalize = 1
    if (l ~ /DISPTEXT_TARGETLINEINDEX/) has_target = 1
    if (l ~ /NEWGRID_ROWHEIGHTPX/) has_rowheight = 1
    if (l ~ /MATH_MULU32/ || l ~ /MATH_MULU/ || l ~ /GROUP_AG_JMPTBL_MATH_MU/) has_mulu_call = 1
    if (l ~ /ASR\.L #\$?2,D0/ || l ~ /ASR\.L #\$?2,D4/) has_asr2 = 1
    if (l ~ /CMP\.L .*D6/ || l ~ /CMP\.L .*#\$?1/) has_linecount_eq1 = 1
    if (l ~ /DISPTEXT_CONTROLMARKERSENABLEDFLAG/ || l ~ /DISPTEXT_CONTROLMARKERSENABLEDFL/) has_markers_flag = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTR/) has_textbuffer = 1
    if (l ~ /PEA 19\.W/ || l ~ /PEA \(\$13\)\.W/ || l ~ /#\$?13/) has_find19 = 1
    if (l ~ /PEA 20\.W/ || l ~ /PEA \(\$14\)\.W/ || l ~ /#\$?14/) has_find20 = 1
    if (l ~ /ADDQ\.L #\$?2,D5/ || l ~ /ADDQ\.L #\$?2,D0/) has_plus2 = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FINALIZE=" has_finalize
    print "HAS_TARGET=" has_target
    print "HAS_ROWHEIGHT=" has_rowheight
    print "HAS_MULU_CALL=" has_mulu_call
    print "HAS_ASR2=" has_asr2
    print "HAS_LINECOUNT_EQ1=" has_linecount_eq1
    print "HAS_MARKERS_FLAG=" has_markers_flag
    print "HAS_TEXTBUFFER=" has_textbuffer
    print "HAS_FIND19=" has_find19
    print "HAS_FIND20=" has_find20
    print "HAS_PLUS2=" has_plus2
    print "HAS_RETURN=" has_return
}
