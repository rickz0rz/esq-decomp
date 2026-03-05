BEGIN {
    has_entry=0
    has_link=0
    has_save=0
    has_textlen=0
    has_skip=0
    has_copy=0
    has_append=0
    has_prefix_logic=0
    has_shrink=0
    has_status_bool=0
    has_return=0
    saw_seq=0
    saw_neg=0
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
    l=t($0)
    if (l=="") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /LINK\.W A5,#-76/ || l ~ /MOVE\.L A7,D0/) has_link = 1
    if (l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /LVOTEXTLENGTH/ || l ~ /_LVOTEXTLENGTH/) has_textlen = 1
    if (l ~ /GROUP_AI_JMPTBL_STR_SKIPCLASS3CHARS/ || l ~ /GROUP_AI_JMPTBL_STR_SKIPCLASS3CHA/ || l ~ /GROUP_AI_JMPTBL_STR_SKIPCLASS3CH/) has_skip = 1
    if (l ~ /GROUP_AI_JMPTBL_STR_COPYUNTILANYDELIMN/ || l ~ /GROUP_AI_JMPTBL_STR_COPYUNTILANYDEL/ || l ~ /GROUP_AI_JMPTBL_STR_COPYUNTILANY/) has_copy = 1
    if (l ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/ || l ~ /GROUP_AI_JMPTBL_STRING_APPENDATN/) has_append = 1
    if (l ~ /DISPTEXT_CONTROLMARKERSENABLEDFLAG/ || l ~ /DISPTEXT_CONTROLMARKERSENABLEDFL/) has_prefix_logic = 1
    if (l ~ /SUBQ\.L #\$?1,D6/ || l ~ /SUBQ\.L #\$?1,D5/ || l ~ /DISPTEXT_BUILDLINEWITHWIDTH_SHRINK_WORD/) has_shrink = 1
    if (l ~ /SEQ D0/) saw_seq = 1
    if (l ~ /NEG\.B D0/) saw_neg = 1
    if (l ~ /ORI\.W #\$?FFFFFFFF,D0/ || l ~ /ORI\.W #\-1,D0/ || l ~ /ORI\.L #\$?FFFFFFFF,D0/) has_status_bool = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    if (saw_seq && saw_neg) has_status_bool = 1

    print "HAS_LABEL="has_entry
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_TEXTLENGTH="has_textlen
    print "HAS_SKIP="has_skip
    print "HAS_COPY="has_copy
    print "HAS_APPEND="has_append
    print "HAS_PREFIX_LOGIC="has_prefix_logic
    print "HAS_SHRINK="has_shrink
    print "HAS_STATUS_BOOL="has_status_bool
    print "HAS_RETURN="has_return
}
