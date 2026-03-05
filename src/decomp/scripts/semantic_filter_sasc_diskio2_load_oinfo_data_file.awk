BEGIN {
    has_entry = 0
    has_load = 0
    has_parse_long = 0
    has_group_compare = 0
    consume_calls = 0
    has_replace = 0
    has_free = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /DISKIO_LOADFILETOWORKBUFFER/) has_load = 1
    if (line ~ /DISKIO_PARSELONGFROMWORKBUFFER/ || line ~ /DISKIO_PARSELONGFROMWORKB/) has_parse_long = 1
    if (line ~ /TEXTDISP_PRIMARYGROUPCODE/ || line ~ /^CMP\.[BWL] .*D7/ || line ~ /^CMP\.[BWL] .*D0,D7/) has_group_compare = 1
    if (line ~ /DISKIO_CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /DISKIO_CONSUMECSTRINGFROMW/) consume_calls++
    if (line ~ /ESQPARS_REPLACEOWNEDSTRING/ || line ~ /GROUP_AE_JMPTBL_ESQPARS_REPL/) has_replace = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_free = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_GROUP_COMPARE=" has_group_compare
    print "CONSUME_CALL_COUNT_GE_2=" (consume_calls >= 2)
    print "HAS_REPLACE=" has_replace
    print "HAS_FREE=" has_free
}
