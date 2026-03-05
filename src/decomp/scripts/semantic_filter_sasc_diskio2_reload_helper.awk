BEGIN {
    has_entry = 0
    has_load_cur = 0
    has_load_next = 0
    has_load_oinfo = 0
    has_rebuild = 0
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

    if (line ~ /DISKIO2_LOADCURDAYDATAFILE/) has_load_cur = 1
    if (line ~ /DISKIO2_LOADNXTDAYDATAFILE/) has_load_next = 1
    if (line ~ /DISKIO2_LOADOINFODATAFILE/) has_load_oinfo = 1
    if (line ~ /NEWGRID_REBUILDINDEXCACHE/ || line ~ /NEWGRID_REBUILDI/) has_rebuild = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_CUR=" has_load_cur
    print "HAS_LOAD_NEXT=" has_load_next
    print "HAS_LOAD_OINFO=" has_load_oinfo
    print "HAS_REBUILD=" has_rebuild
}
